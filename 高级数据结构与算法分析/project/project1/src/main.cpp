#include "iostream"
#include "string"
#include "map"
#include "vector"
#include "fstream"
#include "filesystem"
#include "../lib/porter2_stemmer.h"
using namespace std;
namespace fs=std::filesystem;
class word_book{
public:
    int times;//record the time the key word apperas
    string title;//the title of the examined article 
    word_book(string& n):times(1),title(n){;}
};
std::map <string,vector<word_book>> index;
void examine(ifstream& in, string& file);
void update(string word,string file);
void load_index(ofstream& out);
int main(){
    fs::path sample_path("./Books");
    fs::path index_path("./SearchKey");
    ifstream read_file;
    ofstream write_file;
    if(!fs::is_director(sample_path)){
        cout<<"The database is empty!"<<endl;
        return 0;
    }
    for(auto &i:fs::directory_iterator(sample_path)){
        string sub=i.path().filename().string();
        cout<<"In directory "<<sub<<":"<<endl;
        for(auto &j:fs::directory_iterator(sample_path/sub)){
            string file=j.path().filename().string();
            cout<<"Examining "<<file<<";"<<endl;
            read_file.open(j.path().string(),ios::in);
            if(!read_file.is_open()){
                cout<<"Failed open file "<<endl;
                continue;
            }
            else{
                examine(read_file,sub+" "+file);
                read_file.close();
            }
        }
    }
    if(!fs::is_directory(index_path))
        fs::create_directory(index_path);
    write_file.open("./SearchKey/index.txt",ios::out);
    load_index(write_file);
    write_file.close();
    return 0;
}
void examine(ifstream& in, string& file){
    string buf;
    string word;
    bool flag=false;
    while(getline(in,buf)){
        for(int i;i<buf.length();i++){
            if(isalpha(buf[i])){
                if(!flag) flag=true;
                word.push_back(buf[i]);
            }
            else if(buf[i]=='\n'){
                continue;
            }
            else  
            {   
                stem(word.c_str(),0,word.length()-1);
                if(word.size()!=0)
                    update(word,file);
                flag=false;
                word.clear();
            }
        }
    }
}
void update(string word,string file){
    vector<word_book> articles;
    if(index.find(word)!=index.end()){
        articles=index.find(word)->second;
        if((articles.end()-1)->title==file)
            (articles.end()-1)->times++;
        else
            articles.push_back(word_book(file));
    }else{
        index[word].push_back(word_book(file));
    }
}
void load_index(ofstream& out){
    for(auto &i:index){
      cout<<i.first<<endl<<i.second.size()<<endl;
        for(auto &j:i.second){
            cout<<j.name<<endl<<j.times<<endl;
        }
    }
    return ;
}