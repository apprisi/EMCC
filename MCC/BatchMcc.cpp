#include <ctime>
#include <time.h>
#include "mcc.h"
//#include "R.h"
using namespace std;

int main(int argc, char* argv[])
{
    if(argc!=4)
    {
        cout << "Usage:" << endl;
        cout << "BatchMcc minu_list_file save_real_dir save_bit_dir"<<endl;
        cout << "-minu_list_file: a text file containing paths to minutia files. \n\t\tThe file format is the same as MCC SDK"<<endl;
        cout << "-save_real_dir: a folder to save the extracted real MCC template files."<<endl;
        cout << "-save_bit_dir: a folder to save the extracted bit MCC template files."<<endl;
        return -1;
    }

	int R = 70;
	int NS = 16;
	int ND = 5;
	BatchMCC(argv[1], argv[2], argv[3], R, NS, ND, true);
    return 0;
}
