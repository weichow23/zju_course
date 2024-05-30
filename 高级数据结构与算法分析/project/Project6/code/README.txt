=================================================
# Usage of files:
    
    1. TexturePacking.cpp && StripPack.h && StripPack.cpp
        These are the main programs that we should implement. TexturePacking.cpp call different algorithm implemented in StripPack
     to solve the problem, result heights will be printed in the command line.
    
    2. Gen.cpp
        Generate different size of test cases for performance testing. The generated cases are in PerformanceCases/.
    
    3. Correct_Test.cpp
        Test manually generated input and print out which results are not consistent with expected output. Test cases are in CorrectnessCases/.
    
    4. Perf_Test.cpp
        Test time and result performance of cases in PerformanceCases/ and record testing results in the files.
    Different algorithm performances are recorded in different files.
    
    5. plot.py
        According to the files, draw plots. There is no necessity to test it, though.
=================================================
# For compile:

    In fact, what you have to test are only TexturePacking.cpp and Correct_Test.cpp. But if you'd like to, 
you can test other programs. The running prompts of all the programs re given below.

    Use g++ to compile *.cpp files.

        For TexturePacking.cpp:
            g++ TexturePacking.cpp StripPack.cpp -o TexturePacking.exe -O2 -m64 -static-libgcc -std=c++14 -fexec-charset=GBK
        
        For Gen.cpp:
            g++ Gen.cpp -o Gen.exe -O2 -m64 -static-libgcc -std=c++14 -fexec-charset=GBK

        For Correct_Test.cpp:
            g++ Correct_Test.cpp StripPack.cpp -o Correct_Test.exe -O2 -m64 -static-libgcc -std=c++14 -fexec-charset=GBK
        
        For Perf_Test.cpp:
            g++ Perf_Test.cpp StripPack.cpp -o Perf_Test.exe -O2 -m64 -static-libgcc -std=c++14 -fexec-charset=GBK
    
    Use devc++:
        For TexturePacking.cpp:
            Create a project, add TexturePacking.cpp and StripPack.h and StripPack.cpp to the project. After that, compile it.
        
        For Gen.cpp:
            Open it with devc++ and compile it.
        
        For Correct_Test.cpp:
            Create a project, add Correct_Test.cpp and StripPack.h and StripPack.cpp to the project. After that, compile it.
        
        For Perf_Test.cpp:
            Create a project, add Correct_Test.cpp and StripPack.h and StripPack.cpp to the project. After that, compile it.
=================================================
# For running program:

    For TexturePacking.exe:
        Run it directly. First input width, then input n. After that, n texture with width first, height second should be given.
    
    For Gen.exe:
        Run it directly.
    
    For Correct_Test.exe:
        Before your run it, make sure you have copied CorrectnessCases file to the same directory. Then you can run it directly.
    
    For Perf_Test:
        Before your run it, make sure you have run Gen.exe and copied PerformanceCases file to the same directory. Then you can run it directly.

    For plot.py:
        No necessity to run this, actually. As this only draws picture in our report.
        Make sure that your computer has installed python3 and you have matplotlib and numpy.
        If you have not install matplotlib and numpy, use command below:
            pip3 install matplotlib
            pip3 install numpy