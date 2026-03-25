#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokenizer.h"
#include "executor.h"
#include "builtins.h"
#include "jobs.h"

#define MAX_INPUT 1024

void trim_newline(char *str) {
    size_t len = strlen(str);
    if (len > 0 && str[len - 1] == '\n') {
        str[len - 1] = '\0';
    }
}

int main() {
    char input[MAX_INPUT];

    while (1) {
        // clean up finished BG tasks
        // add 'remove_finished_jobs();' below
        remove_finished_jobs();

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

        // Built-in commands
        if (is_builtin(tokens[0])) {
            run_builtin(tokens);
            free_tokens(tokens);
            continue;
        }

        // external commands
        execute_commands(tokens);

        free_tokens(tokens);
    }

    return 0;
}