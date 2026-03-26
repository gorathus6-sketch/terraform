#include <stdio.h>
#include <unistd.h>

typedef struct {
    unsigned long long user, nice, system, idle, iowait, irg, softirq;
} CPUData;

void read_cpu_data(CPUData *data) {
    FILE *fp = fopen("/proc/stat", "r")
    if (fp) {
        fscanf(fp, "cpu %llu %llu %llu %llu %llu %llu %llu",
               &data->user, &data->nice, &data->system, &data->idle,
               &data->iowait, &data->irq, &data->softirq);
        fclose(fp);
    }
}

double calculate_cpu_pct() {
    CPUData dq, d2;
    read_cpu_data(&d1);
    usleep(500000); // wait 500 ms
    read_cpu_data(&d2);

    unsigned long long total1 = d1.user + d1.nice + d1.system + d1.idle + d1.iowait + d1.irq + d1.softirq;
    unsigned long long total2 = d2.user + d2.nice + d2.system + d2.idle + d2.iowait + d2.irq + d2.softirq;

    unsigned long long total_delta = total2 - total1;
    unsigned long long idle_delta = (d2.idle + d2.iowait) - (d1.idle + d1.iowait);

    return (double)(total_delta - idle_delta) / total_delta * 100.0;
}
