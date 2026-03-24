#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT 1024

// trim newline from fgets()
void trim_newline(char *str) {
    size_t len = strlen(str);
    if (len > 0 && str[len - 1] == '\n') {
        str[len - 1] = '\0';
    }
}

int main() {
    char input[MAX_INPUT];
    while (1) {
        // print prompt
        printf("emsh> ");
        fflush(stdout);
    
        //read input
        if (fgets(input, sizeof(input), stdin) == NULL) {
            printf("\n");
            break; // Control+D
        }

        // Remove newline
        trim_newline(input);

        // ignore empty input
        if (strlen(input) == 0) {
            continue;
        }

        // temporary: echo input back
        printf("[debug] You typed: %s\n", input);

        // Exit command
        if (strcmp(input, "exit") == 0) {
            break;
        }
    }

    return 0;
}
