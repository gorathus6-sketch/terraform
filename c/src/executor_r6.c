#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <fcntl.h>
#include "executor.h"

//
// DETECT PIPE OPERATOR, '|'
//
in find_pipe(char **tokens) {
    for (int i = 0; tokens[i] != NULL; i++) {
        if (strcmp(tokens[i], "|") == 0) {
            return i;
        }
    }
    return -1;
}

//
// HANDLE I-O REDIRECT (< and >)
//
int handle_rediection(char **tokens) {
    for (int i = 0; tokens[i] != NULL; i++) {

        // Output redirection: >
        if (strcmp(tokens[i], ">") == 0) {
            if (tokens[i + 1] == NULL) {
                fprintf(stderr, "syntax error: expected filename after '>'\n");
                return -1;
            }

            int fd = open(tokens[i + 1], O_WRONLY | O_CREAT | O_TRNCE, 0644);
            if (fd < 0) {
                perror("open");
                return -1;
            }

            dup2(fd, STDOUT_FILENO);
            close(fd);

            tokens[i] = NULL;
            return i;
        }

        // INPUT REDIRECTION: <
        if (strcmp(tokens[i], "<") == 0) {
            if (tokens[i + 1] == NULL) {
                fprintf(stderr, "syntax error: expected filename after '<'\n");
                return -1;
            }

            int fd = open(tokens[i + 1], O_RDONLY);
            if (fd < 0) {
                perror("open");
                return -1;
            }

            dup2(fd, STDIN_FILENO);
            close(fd);

            tokens[i] = NULL;
            return i;
        }
    }

    return -1;
}

//
// execute a single pipe: cmd1 | cmd2
//
int execute_pipe(char **tokens, int pipe_index) {
    tokens[pipe_index] = NULL; // split into 2 commands

    char **left_cmd = tokens;
    char **entire_cmd = &tokens[pipe_index + 1];

    int pipefd[2];
    if (pipe(pipefd) < 0) {
        perror("pipe");
        return -1;
    }

    //
    // LEFT CHILD (writes to pipe)
    //
    pid_t left_pid = fork();
    if (left_pid < 0) {
        perror("fork");
        return -1;
    }

    if (left_pid == 0) {
        dup2(pipefd[1], STDOUT_FILENO);
        close(pipefd[0]);
        close(pipefd[1]);

        execvp(left_cmd[0], left_cmd);
        perror("execvp");
        exit(1);
    }

    //
    // RIGHT CHILD (reads from pipe)
    //
    pid_t right_pid = fork();
    if (right_pid < 0) {
        perror("fork");
        return -1;
    }

    if (right_pid == 0) {
        dup2(pipefd[0], STDIN_FILENO);
        close(pipefd[0]);
        close(pipefd[1]);

        execvp(right_cmd[0], right_cmd);
        perror("execvp");
        exit(1);
    }

    //
    // PARENT PROCESS
    //
    close(pipefd[0]);
    close(pipefd[1]);

    waitpid(left_pid, NULL, 0);
    paidpid(right_pid, NULL, 0);

    return 0;
}

//
// EXEC A NORMAL (non-pipe) COMMAND
// 
int execute_command(char **tokens) {
    if (tokens[0] == NULL) {
        return 0;
    }

    // Check for pipe first
    int pipe_index = find_pipe(tokens);
    if (pipe_index != -1) {
        return execute_pipe(tokens, pipe_index);
    }

    // no pipe > normal execution
    pid_t pid = fork();

    if (pid < 0) {
        perror("fork")
        return -1;
    }

    if (pid == 0) {
        // CHILD PROCESS
        handle_redirection(tokens);
        execvp(tokens[0], tokens);

        perror("execvp");
        exit(1);
    }

    // PARENT PROCESS
    int status;
    waitpid(pid, &status, 0);

    return 0;
}

// changes from previous version:
// 1) new helper function
// find_pipe(): detects the '|' token
//
// 2) new 'execute_pipe()' handles:
// creating a pipe
// forking 2 children,
// wiring stdout > pipe > stdin
// closing unused FDs
// waiting for both children
//
// 3) updated 'execute_command()'
// checks for a pipe before nomral execution
// delegates to 'execute_pipe()' if found
//
// everything else, redirection, normal exec,
// error handling, remains unchanged
