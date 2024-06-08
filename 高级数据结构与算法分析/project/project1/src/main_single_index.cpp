#include "iostream"
#include "string"
#include "map"
#include "vector"
#include "fstream"
#include "filesystem"
#include "cctype"
#include "../lib/porter2_stemmer.h"                                     //External libraries for root word detection
using namespace std;
namespace fs=std::filesystem;
class word_book{                                                        //message of a word in a book
public:
    int times;                                                          
    //record the time the key word apperas
    string title;                                                       
    //the title of the examined article 
    word_book(const string& n):times(1),title(n){;}                     //construct function
};
std::map <string,vector<word_book>> indexs;                             
//use map to store key words, and the book the key wordss in

int examine(ifstream& in, const string& file);                          
//read the files to load the information of books

void update(const string& word,const string& file);                     
//update the "indexs"

void load_index(ofstream& out);                                         
//load the "indexs" to the disk

void low(string& c);                                                    
//the function to transfer big alpha to low alpha

int main(){
    fs::path sample_path("./Books");
    fs::path index_path("./SearchKey");
    ifstream read_file;
    ofstream write_file;
    ofstream cnt_out;
    int words;
    //the number of words in a book
    long long total=0;
    //the number of words of all books
    string full_name;
    if(!fs::is_directory(sample_path))
    {
        cout<<"The database is empty!"<<endl;
        return 0;
    }
    cnt_out.open("./SearchKey/words.txt",ios::out);                 //record the words of every file
    for(auto &i:fs::directory_iterator(sample_path))
    {
        string sub=i.path().filename().string();                    //Iterate through the folder
        cout<<"In directory "<<sub<<":"<<endl;
        for(auto &j:fs::directory_iterator(sample_path/sub))        //Iterate through every sub folder
        {                 
            string file=j.path().filename().string();               //get the name of the file
            cout<<"Examining "<<file<<";"<<endl;
            read_file.open(j.path().string(),ios::in);              //open the file
            if(!read_file.is_open())
            {
                cout<<"Failed open file "<<endl;
                continue;
            }
            else
            {                                                       //successfully open the file, and read words
                full_name=sub+" "+file;
                words=examine(read_file,full_name);             
                cnt_out<<full_name<<endl<<words<<endl;
                total+=words;
                read_file.close();
            }
        }
    }
    cnt_out.close();
    cout<<"Total retrieval "<<total<<" words."<<endl;
    if(!fs::is_directory(index_path))
        fs::create_directory(index_path);
    write_file.open("./SearchKey/index.txt",ios::out);               //load the map to the disk
    load_index(write_file);
    write_file.close();
    return 0;
}

int examine(ifstream& in, const string& file){
    string buf;
    string word;
    bool flag=false;
    //judge wthther is building word
    int cnt=0;
    //count words
    while(getline(in,buf))                                          //Reading files line by line
    {
        for(int i=0;i<buf.length();i++)
        {
            if(isalpha(buf[i]))                                     //get an alpha, start to build words
            {
                if(!flag) flag=true;
                word.push_back(buf[i]);
            }
            else if(buf[i]=='\n')
                continue;
            else {                                                  //Got a non-alphabetic character
                Porter2Stemmer::stem(word);                         //use lib to get the root
                low(word);                                          //turn to low
                cnt++;
                if(word.size()!=0)
                    update(word,file);
                flag=false;
                word.clear();
            }
        }
    }
    cout<<"Total words: "<<cnt<<endl;
    return cnt;
}

void low(string& c){
    for(auto& i:c)
        i=tolower(i);
    return;
}

void update(const string& word,const string& file){
    if(indexs.find(word)!=indexs.end()){                            //successfully find the key word(it has been found)
        if(((indexs.find(word)->second).end()-1)->title==file){     //if in the vector already had the article, then times++
            ((indexs.find(word)->second).end()-1)->times++;
        }
        else                                                        //else create a new element by the new article
            (indexs.find(word)->second).push_back(word_book(file));
    }else{
        indexs[word].push_back(word_book(file));                    //the key word first appear, create a new map element
    }
}

void load_index(ofstream& out){
    for(auto &i:indexs){                                            //iterator the map, load every elemnet
      out<<i.first<<endl<<i.second.size()<<endl;
        for(auto &j:i.second){
            out<<j.title<<endl<<j.times<<endl;
        }
    }
    return ;
}