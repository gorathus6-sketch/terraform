#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "builtins.h"
#include "jobs.h"

int is_builtin(const char *cmd) {
    return (
        strcmp(cmd, "cd") == 0 ||
        strcmp(cmd, "exit") == 0 ||
        strcmp(cmd, "help") == 0 ||
        strcmp(cmd, "pwd") == 0 ||
        strcmp(cmd, "jobs") == 0
    );
}

int run_builtin(char **tokens) {
    if (strcmp(tokens[0], "cd") == 0) {
        if (tokens[1]) == NULL {
            fprintf(stderr, "cd: missing argument\n");
            return -1;
        }
        if (chdir(tokens[1]) != 0) {
            perror("cd");
        }
        return 0;
    }

    if (strcmp(tokens[0], "exit") == 0) {
        exit(0);
    }

    if (strcmp(tokens[0], "help") == 0) {
        exit(0);
    }

    if (strcmp(tokens[0], "help") == 0) {
        printf("emsh built-in commands:\n");
        printf("  cd <dir>   Change directory\n");
        printf("  pwd        Print working directory\n");
        printf("  help       Show this help message\n");
        printf("  jobs       List background jobs\n");
        printf("  exit       Exit the shell\n");
        return 0;
    }

    if (strcmp(tokens[0], "pwd") == 0) {
        char cwd[1024];
        if (getcwd(cwd, sizeof(cwd)) != NULL) {
           printf("%s\n", cwd); 
        } else {
            perror("pwd");
        }
        return 0;
    }

    if (strcmp(tokens[0], "jobs") == 0) {
        print_jobs();
        return 0;
    }

    return -1;
}