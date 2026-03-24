#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokenizer.h"

#define MAX_INPUT 1024

void trim_newline(char *str) {
    size_t len = strlen(str);
    if (len > 0 && str[len -1] == '\n') {
        str[len - 1] = '\0';
    }
}

int main() {
    char input[MAX_INPUT];

    while (1) {
        printf("emsh> ");
        fflush(stdout);

        if (fgets(input, sizeof(input), stdin) == NULL) {
            printf("\n");
            break;
        }

        trim_newline(input);

        if (strlen(input) == 0) {
            continue;
        }

        // tokenize input
        char **tokens = tokenize(input);

        // debug print tokens
        printf("[debug] Tokens:\n");
        for (int i = 0; tokens[i] != NULL; i++) {
            printf("  [%d] %s\n", i, tokens[i]);
        }

        // exit command
        if (strcmp(tokens[0], "exit") == 0) {
            free_tokens(tokens);
            break;
        }

        free_tokens(tokens);
    }

    return 0;
}