// store numbers in a vector and only print odd

#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> nums = {1,2,3,4,5,6,7,8,9,10};

    for (int n : nums) {
        if (n % 2 != 0) {
            cout << n << endl;
        }
    }
}