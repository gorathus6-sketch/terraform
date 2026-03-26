#ifndef SYS_STATS_H
#define SYS_STATS_H

typedef struct {
    double cpu_usage;
    long total_mem;
    long free_mem;
} SystemMetrics;

SystemMetrics get_system_metrics();

#endif