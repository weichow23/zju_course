#include <map>
#include <sstream>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <cstring>
#include <algorithm>
#include <cctype>
#include <filesystem>
#include <ctime>
#include "../lib/porter2_stemmer.h"
using namespace std;
namespace fs = std::filesystem;
class word_book{
public:
    int times;//record the time the key word apperas
    string title;//the title of the examined article 
    word_book(string& n, int t):times(t),title(n){;}
    bool operator<(word_book& other){
        if(strcmp(title.c_str(), other.title.c_str()) < 0) return 1;
        else return 0;
    }
};

void InsertToMap(map<string, vector<word_book>>& SearchKey, string SingleKey);
int IsNoisyWord(string SingleKey);
void load_index(map<string, vector<word_book>>& SearchKey, ifstream& in, string SingleKey);
bool isStopword(string SingleKey, vector<string> StopWords);
void load_StopWords(vector<string>& StopWords);
map<string, int> Occurtimes;
bool cmp(string a, string b);
int main(){
    string UserSearchLine;
    char UserSearchKey[20];
    bool HaveBeenLoaded[26];
    bool flag = false;
    int cnt = 0;
    long long start;
    long long end;
    double Threshold = 0.5;
    vector<string> StopWords;
    memset(HaveBeenLoaded, 0, 26*sizeof(bool));
    load_StopWords(StopWords);
    cout << "Please input the words that you want to search." << endl;
    getline(cin, UserSearchLine);

    stringstream ss(UserSearchLine);
    string SingleKey;
    map<string, vector<word_book>> SearchKey;
    
    vector<string> SearchWords;
    vector<vector<word_book>> intersection(10);

    while(ss >> SingleKey){
	if(SingleKey=="--threshold"){
            ss >> Threshold;
            continue;
        }
        Porter2Stemmer::stem(SingleKey);
        cout << "After stem: " << SingleKey << endl;
        if(isStopword(SingleKey, StopWords)){
            cout << "This is a stop word." << endl;
            //continue;
        }
        char First = SingleKey[0];
        if(First >= 'A' && First <= 'Z') First = First - 'A' + 'a';
        for(int i = 0; i < SingleKey.length(); i++){
            SingleKey[i] = tolower(SingleKey[i]);
        }
        start = clock();
        if(!HaveBeenLoaded[First - 'a']){
            InsertToMap(SearchKey, SingleKey);
            HaveBeenLoaded[First - 'a'] = true;
        }
        // if(!HaveBeenLoaded[0]){
        //     InsertToMap(SearchKey, SingleKey);
        //     HaveBeenLoaded[0] = true;
        // }
        SearchWords.push_back(SingleKey);
    }
    sort(SearchWords.begin(), SearchWords.end(), cmp);
    for(int i = 0; i < SearchWords.size(); i++){
        cout << SearchWords[i] << endl;
    }
    int Length;
    if(SearchWords.size() > 3) Length = SearchWords.size() * Threshold;
    else Length = SearchWords.size();
    for(int i = 0; i < Length; i++){
        if(flag == false){
            intersection[0] = SearchKey[SearchWords[i]];
            flag = true;
        }
        set_intersection(SearchKey[SearchWords[i]].begin(), SearchKey[SearchWords[i]].end(), intersection[cnt].begin(), intersection[cnt].end(), back_inserter(intersection[cnt+1])); 
        cnt++;  
    }
	end = clock();
    int i;
    for(i = 0; cnt != 0 && i < intersection[cnt-1].size(); i++){
        cout << intersection[cnt-1][i].title << endl;
    }
    cout << "Find " << i << " books" << endl;
    double last = (end - start);
	cout << "Duration: " << last << " tick" << endl;

}
void InsertToMap(map<string, vector<word_book>>& SearchKey, string SingleKey){
    ifstream read_file;
    string filename("./SearchKey/");
    string txt(".txt");
    if(SingleKey[0] >= 'A' && SingleKey[0] <= 'Z') SingleKey[0] = SingleKey[0] - 'A' + 'a';
    filename = filename + SingleKey[0] + txt;
    // filename = filename + "index" + txt;
    fs::path index_path(filename.c_str());
    if(fs::is_directory(filename.c_str())){
        cout<<"The index is not ready, please run main.exe first!"<<endl;
        return ;
    }
    int fileSize = fs::file_size(filename.c_str());
    cout << filename << " " << fileSize << endl;
    read_file.open(filename.c_str(), ios::in);
    if(!read_file.is_open()){
        cout<<"Failed open file"<<endl;
        return;
    }
    load_index(SearchKey, read_file, SingleKey);
    cout << SearchKey.size() << endl;

}
void load_StopWords(vector<string>& StopWords){
    ifstream read_Stopword;
    string StopWord;
    read_Stopword.open("./SearchKey/stop.txt", ios::in);
    if(!read_Stopword.is_open()){
        cout<<"Failed open file"<<endl;
        return;
    }
    while(read_Stopword >> StopWord){
        StopWords.push_back(StopWord);
    }
    // for(int i = 0; i < StopWords.size(); i++){
    //     cout << StopWords[i] << endl;
    // }
    // cout << StopWords.size() << endl;
}
void load_index(map<string, vector<word_book>>& SearchKey, ifstream& in, string SingleWord){
    string buf;
    string titles;
    string trash;
    int n_arc;
    int cnt;
    int i;
    while(getline(in,buf)){
            in>>n_arc;
            if(buf == SingleWord)Occurtimes[buf] = n_arc;
            getline(in,trash);
            for(i=0;i<n_arc;i++){
                getline(in,titles);
                in>>cnt;
                getline(in,trash);
                SearchKey[buf].push_back(word_book(titles,cnt));
            }
        }

}

bool isStopword(string SingleKey, vector<string> StopWords){
    if(find(StopWords.begin(), StopWords.end(), SingleKey) != StopWords.end())
        return true;
    else
        return false;
}
bool cmp(string a, string b){
    return Occurtimes[a] < Occurtimes[b];
}
