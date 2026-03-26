#include sys_stats.h
#include <stdio.h>
#include <stdlib.h>

SystemMetrics get_system_metrics() {
    SystemMetrics metrics = {0};
    FILE *fp;

    // Memory Info
    fp = fopen("/proc/meminfo", "r");
    if (fp) {
        fscanf(fp, "MemTotal: %ld kB\nMemFree: %ld kB", &metrics.total_mem, &metric.free_mem);
        fclose(fp);
    }

    // CPU Info (simplified snapshot)
    fp = fopen("/proc/stat", "r");
    if (fp) {
        long user, nice, system, idle;
        fscanf(fp, "cpu %ld %ld %ld %ld", &user, &nice, &system, &idle);
        fclose(fp);
        long total = user + nice + system + idle;
        metrics.cpu_usage = (double)(user + system) / total * 100.0;
    }

    return metrics;
}