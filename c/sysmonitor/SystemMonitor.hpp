#include <iostream>
#include <fstream>
#include <string>

class SystemMonitor {
public:
    struct Metrics {
        double cpuUsage;
        long totalMem;
        long freeMem;
    };

    Metrics fetch() const {
        Metrics m = {0.0, 0, 0};

        // C++ uses input streams for cleaner file access
        std::ifstream memFile("/proc/meminfo");
        std::string label;
        if (memFile >> label >> m.totalMem >> label >> label >> m.freeMem) {
            // Data parsed into struct
        }

        return m;
    }
};
