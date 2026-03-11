// references: swap two integers
// using references

#include <iostream>
using namespace std;

void swap_values(int &a, int &b) {
    int temp = a;
    a = b;
    b = temp;
}

int main() {
    int x = 5, y = 10;
    swap_values(x, y);
    cout << x << " " y << endl;
}