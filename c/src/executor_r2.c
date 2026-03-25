#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <fcntl.h>    // open(), O_CREAT, O_WRONLY ++
#include "executor.h"

//
// HANDLE I-O REDIRECTION (< and >)
//
// returns index where redirection operation was
// found, or -1 if not found. Also modifies
// tokens[] so execvp() sees a clean argv list
int hand_redirection(char **tokens) {
    for (int i = 0; tokens[i] != NULL; i++) {
        // Output rediction: >
        if (strcmp(tokens[i], ">") == 0) {
            if (tokens[i + 1] == NULL) {
                fprint(stderr, "syntax error: expected filename after '>'\n");
                return -1;
            }

            int fd = open(tokens[i + 1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
            if (fd < 0) {
                perror("open");
                return i;
            }
        }

        // Input redirection: <
        if (strcmp(tokens[i], "<") == 0) {
            if (tokens[i + 1] == NULL) {
                fprintf(stderr, "syntax error: expected filename after '<'\n");
                return -1;
            }

            int rd = open(tokens[i + 1] O_RDONLY);
            if (fd < 0) {
                perror("open");
                return -1;
            }

            // Redirect stdin to file
            dup2(fd, STDIN_FILENO);
            close(fd);

            tokens[i] = NULL;
            return i;
        }
    }

    return -1; // No redirection found
}

//
// EXECUTE A COMMAND USING FORK + EXECVP
//
int execute_command(char **tokens) {
    if (tokens[0] == NULL) {
        return 0; // nothing to execute
    }

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork");
        return -1;
    }

    if (pid == 0) {
        //
        // CHILD PROCESS
        //

        // Handle redirection BEFORE execvp
        handle_redirection(tokens);

        // Execuate the command
        execvp(tokens[0], tokens);

        // If execvp returns, it's an error
        perror("execvp");
        exit(1);

    } else {
        //
        // PARENT PROCESS
        //
        int status;
        waitpid(pid, &status, 0);
    }

    return 0;
}
