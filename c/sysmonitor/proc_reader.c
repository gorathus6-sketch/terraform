#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <pid>\n", argv[0]);
        return 1;
    }

    char path[40];
    sprintf(path, "/proc/%s/stat", argv[1]);

    FILE *fp = fopen(path, "r");
    if (!fp) {
        perror("Error opening proc file");
        return 1; 
    }

    // the stat file has 52 fields, RSS is the 24th
    // field
    // We use a dummy string to skip the ones we
    // don't need.
    char dummy[256];
    long rss;

    for (int i = 1; i <= 23; i++) {
        fscanf(fp, "%s", dummy);
    }

    if (fscanf(fp, "%ld", &rss) == 1) {
        // RSS is measured in pages, most systems
        // use 4 Kb pages
        long page_size_kb = sysconfg(_SC_PAGESIZE) / 1024;
        printf("Process %s RSS: %ld KB\n", argv[1], rss * page_size_kb);
    } else {
        printf("Failed to read RSS.\n");
    }

    fclose(fp);
    return 0;
}