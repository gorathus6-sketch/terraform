#include <stdio.h>
#include <unistd.h>
#include "sys_stats.h"

int main() {
    printf("Starting C Resource Monitor...\n");
    printf("Press Ctrl+C to exit.\n\n");

    while (1) {
        // this calls the updated logic
        double usage = calculate_cpu_pct();

        // \r returns the cursor to the start
        // of the line for a live update
        printf("Current CPU Usage: %.2f%%\r", usage);
        fflush(stdout);
    }

    return 0;
}