#include <iostream>
#include <iomanip>
#include "SystemMonitor.hpp"

int main() {
    SystemMonitor monitor;

    std::cout << "Starting C++ Resource Monitor..." << std::endl;
    std::cout << "Press Ctrl+C to exit." << std::endl << std::endl;

    while (true) {
        double usage = monitor.getUsage(500); // 500 ms sample window

        std::cout << "Current CPU Usage: "
                  << std::fixed << std::setprecision(2)
                  << usage << "%   \r" << std::flush; 
    }

    return 0;
}