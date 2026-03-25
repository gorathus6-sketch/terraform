#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include "executor.h"

int execute_command(char **tokens) {
    if (tokens[0] == NULL) {
        return 0; // nothing to do
    }

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork");
        return -1;
    }

    if (pid == 0) {
        // child process
        execvp(tokens[0], tokens);

        // if execvp returns, it's an error
        perror("execvp");
        exit(1);
    } else {
        // parent process
        int status;
        waitpid(pid, &status, 0);
    }

    return 0;
}