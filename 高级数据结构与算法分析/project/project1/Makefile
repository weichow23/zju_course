# CXX := g++
# CXXFLAG := -std=c++17
# SRC_DIR := ./src
# TARGET_MAIN := BuildDictionary
# TARGET_SEARCH := Search
# TARGET_STOP := StopWord

# SRC := $(SRC_DIR)/main_multi_index.cpp $(SRC_DIR)/main_single_index.cpp $(SRC_DIR)/Search.cpp $(SRC_DIR)/stop_words.cpp ./lib/porter2_stemmer.cpp

# all: single

# single:
# 	$(CXX) $(CXXFLAG) -c $(SRC) -o SRC_DIR
# 	$(CXX) main_single_index.o porter2_stemmer.o -o $(TARGET_MAIN)
# 	$(CXX) stop_words.o -o $(TARGET_STOP)
# 	$(CXX) Search.o porter2_stemmer.o -o $(TARGET_SEARCH)
# multi:
# 	$(CXX) $(CXXFLAG) -c $(SRC)
# 	$(CXX) main_multi_index.o ./lib/porter2_stemmer.o -o $(TARGET_MAIN)
# 	$(CXX) stop_words.o -o $(TARGET_STOP)
# 	$(CXX) Search.o ./lib/porter2_stemmer.o -o $(TARGET_SEARCH)

# clean:
# 	rm $(TARGET_MAIN) $(TARGET_SEARCH) $(TARGET_STOP) *.o 

CXX := g++
CXXFLAG := -std=c++17
SRC_DIR := ./src
LIB_DIR := ./lib
TARGET_MAIN_S := BuildDictionary_single
TARGET_MAIN_M := BuildDictionary_multi
TARGET_SEARCH := Search
TARGET_STOP := StopWord

SRC := $(wildcard $(SRC_DIR)/*.cpp) $(LIB_DIR)/porter2_stemmer.cpp
OBJ := $(SRC:.cpp=.o)

all: single multi

single: $(TARGET_MAIN_S) $(TARGET_STOP) $(TARGET_SEARCH)

multi: $(TARGET_MAIN_M) $(TARGET_STOP) $(TARGET_SEARCH)

$(SRC_DIR)/main_single_index.o: $(SRC_DIR)/main_single_index.cpp
	$(CXX) $(CXXFLAG) -c $< -o $(SRC_DIR)/main_single_index.o

$(SRC_DIR)/main_multi_index.o: $(SRC_DIR)/main_multi_index.cpp
	$(CXX) $(CXXFLAG) -c $< -o $(SRC_DIR)/main_multi_index.o

$(SRC_DIR)/stop_words.o: $(SRC_DIR)/stop_words.cpp
	$(CXX) $(CXXFLAG) -c $< -o $(SRC_DIR)/stop_words.o
	
$(SRC_DIR)/Search.o: $(SRC_DIR)/Search.cpp
	$(CXX) $(CXXFLAG) -c $< -o $(SRC_DIR)/Search.o

$(TARGET_MAIN_S): $(SRC_DIR)/main_single_index.o $(LIB_DIR)/porter2_stemmer.o
	$(CXX) $(CXXFLAG) $^ -o $@

$(TARGET_MAIN_M): $(SRC_DIR)/main_multi_index.o $(LIB_DIR)/porter2_stemmer.o
	$(CXX) $(CXXFLAG) $^ -o $@

$(TARGET_SEARCH): $(SRC_DIR)/Search.o $(LIB_DIR)/porter2_stemmer.o
	$(CXX) $(CXXFLAG) $^ -o $@

$(TARGET_STOP): $(SRC_DIR)/stop_words.o
	$(CXX) $(CXXFLAG) $^ -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAG) -c $< -o $@

clean:
	rm -f $(TARGET_MAIN_M) $(TARGET_MAIN_S) $(TARGET_SEARCH) $(TARGET_STOP) $(OBJ)

cleanall:
	rm -f $(TARGET_MAIN_M) $(TARGET_MAIN_S) $(TARGET_SEARCH) $(TARGET_STOP) $(OBJ) ./SearchKey/*.txt