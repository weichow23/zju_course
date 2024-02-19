#include <iomanip>
#include "LZWCoder.h"

using namespace std;

void LZWCoder::initial(){
	dictionary_.clear();
	current_size_=0x101;
	limit_size_=0xFFF;
	strparser_<<hex;
}

unsigned int LZWCoder::getHeader(){
	return 0x100;
}

unsigned int LZWCoder::getTailer(){
	return 0x101;
}

unsigned int LZWCoder::getCode(string str){
	unsigned int code;
	if(str.length()<=2){
		strparser_<<str;
		strparser_>>code;
		return code;
	}
	else{
		map<string,unsigned int>::iterator ite;
		if((ite=dictionary_.find(str))!=dictionary_.end()){
			return ite->second; 
		}
		else{
			dictionary_.insert(pair<string,unsigned int>(str,++current_size_));
			if(current_size_>limit_size_){
				dictionary_.clear();
				current_size_=0x101;
				return 0x100;
			}
			else{
				return 0xFFFFFFFF;
			}
		}
	}
}