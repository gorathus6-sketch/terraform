// given a list of numbers, return a new list
// containing only numbers greater than 50

#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> nums = {10, 55, 80, 23, 99};
    vector<int> result;

    for (int n : numbs) {
        if (n > 50) {
            result.push_back(n);
        }
    }

    for (int r : result) {
        cout << r << " ";
    }
}