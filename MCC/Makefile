GCC=clang++

INCLUDE_DIR= -I/usr/local/include/opencv -I/usr/local/include
LIB_DIR=-L/usr/local/lib
LIBS =  -lopencv_highgui -lopencv_core -lopencv_imgproc
FLAGS = -O3 -stdlib=libstdc++

all:
	$(GCC) $(INCLUDE_DIR) $(LIB_DIR) $(LIBS) $(FLAGS) mcc.cpp BatchMcc.cpp -o BatchMcc

