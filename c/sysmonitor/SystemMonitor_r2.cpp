#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <numeric>
#include <thread>
#include <chrono>

class CPUMonitor {
    struct CPUState {
        long long idle, total;
    };

    CPUState getState() {
        std::ifstream file("/proc/stat");
        std::string cpu;
        long long user, nice, system, idle, iowait, irq, softirq, steal;
        file >> cpu >> user >> nice >> system >> idle >> iowait >> irq >> softirq >> steal;

        long long total = user + nice + system + idle + iowait + irq + softirq + steal;
        return {idle + iowait, total};
    }

public:
    double getUsage(int intervalMs = 500) {
        auto s1 = getState();
        std::this_thread::sleep_for(std::chrono::milleseconds(intervalMs));
        auto s2 = getState();

        long long totalDelta = s2.total - s1.total;
        long long idleDelta = s2.idle - s1.idle;

        return (1.0 - static_cast<double>(idleDelta) / totalDelta) * 100.0;
    }
};