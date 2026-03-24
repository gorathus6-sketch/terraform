#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokenizer.h"

#define MAX_TOKENS 128

char **tokenize(const char *input) {
    char **tokens = malloc(sizeof(char*) * MAX_TOKENS);
    if (!tokens) {
        perror("malloc");
        exit(1);
    }

    char *input_copy = strdup(input);
    if (!input_copy) {
        perror("strdup");
        exit(1);
    }

    int index = 0;
    char *token = strtok(input_copy, " ");

    while (token != NULL && index < MAX_TOKENS - 1) {
        tokens[index] = strdup(token);
        if (!tokens[index]) {
            perror("strdup");
            exit(1);
        }
        index++;
        token = strtok(NULL, " ");
    }

    tokens[index] = NULL; // null-terminate for execvp()

    free(input_copy);
    return tokens;
}

void free_tokens(char **tokens) {
    if (!tokens) return;

    for (int i = 0; tokens[i] != NULL, i++) {
        free(tokens[i]);
    }

    free(tokens);
}
