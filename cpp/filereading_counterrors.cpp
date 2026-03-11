// read a file and count lines
// containing string 'ERROR'

#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main() {
    ifstream file("sample.log");
    string line;
    int count = 0;

    while (getline(file, line)) {
        if (line.find("ERROR") != string::npos) {
            count++;
        }
    }

    cout << "Errors: " << count << endl;
}