#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokenizer.h"
#include "executor.h"
#include "builtins.h"

#define MAX_INPUT 1024

void trim_newline(char *str) {
    size_t len = strlen(str);
    if (len > 0 && str[len - 1] == '\n') {
        str[len -1] = '\0';
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

        char **tokens = tokenize(input);

        // check for built-in commands
        if (is_builtin(tokens[0])) {
            run_builtin(tokens);
            free_tokens(tokens);
            continue;
        }

        // Execute external command
        execute_command(tokens);

        free_tokens(tokens);
    }

    return 0;
}

// now the shell handles builtins internally
// executes external commands normally
// behades like an actual interactive env