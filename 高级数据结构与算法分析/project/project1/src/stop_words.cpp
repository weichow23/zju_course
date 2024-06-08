#include "iostream"
#include "string"
#include "map"
#include "vector"
#include "fstream"
#include "filesystem"
using namespace std;
namespace fs=std::filesystem;
class word_book{                                                //message of a word in a book
public:
    int times;
    //record the time the key word apperas
    string title;
    //the title of the examined article 
    word_book(string& n,int t):times(t),title(n){;}             //construct function
};
int load_index();
//load to the map from disk

std::map<string,vector<word_book>> indexs;
//use map to store key words, and the book the key wordss in

int main(){
    std::map<int,string> rank;
    //use map to rank the times the key words appeared in the files
    int cnt;
    //the times
    ifstream read_file;
    fs::path index_path("./SearchKey");
    if(!is_directory(index_path))
    {
        cout<<"The index is not ready, please run main.exe first!"<<endl;
        return 0;
    }
    if(load_index())                                             //if one file open failed the function will return 1, else return 0
    {
        cout<<"Failed"<<endl;
    }
    for(auto& i:indexs)
    {
        cnt=0;
        for(auto& j:i.second)                                    //iterator the map
        {
            cnt+=j.times;
        }
        rank[cnt]=i.first;
    }
    ofstream out;
    out.open("./SearchKey/stop.txt",ios::out);
    std::map<int,string>::iterator it=rank.end();
    for(int i=0;i<100;i++)
    {
        it--;
        cout<<it->second<<": "<<it->first<<endl;
        out<<it->second<<endl;
    }
    return 0;
}

int load_index(){
    string buf;
    string titles;
    string tmp="abcdefghijklmnopqrstuvwxyz";
    string trash;
    //deal the enter
    ifstream in;
    int n_arc;
    int cnt;
    int i,k;
    for(k=0;k<26;k++)
    {
        in.open("./SearchKey/"+tmp.substr(k,1)+".txt",ios::in);    //open different files according to the first alpha appeared in the word
        if(!in.is_open())
            return 1;
        while(getline(in,buf))                                      //the first line is the keyword
        {
            in>>n_arc;                                             //the second line is the number of articles has the keyword
            getline(in,trash);
            for(i=0;i<n_arc;i++)
            {
                getline(in,titles);                                
                in>>cnt;
                getline(in,trash);
                indexs[buf].push_back(word_book(titles,cnt));
            }
        }
        in.close();
    }
    return 0;
}