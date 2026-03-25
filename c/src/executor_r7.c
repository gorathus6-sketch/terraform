#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <fcntl.h>
#include "executor.h"
#include "jobs.h"

//
// DETECT A PIPE OPERATIOR '|'
//
int find_pipe(char **tokens) {
    for (int i = 0; tokens[i] != NULL; i++) {
        if (strcmp(tokens[i], "|") == 0) {
            return i;
        }
    }
    return -1;
}

//
// DETECT BACKGROUND OPERATOR '&'
//
// Add this helper:
int is_background(char **tokens) {
    for (int i = 0; tokens [i] != NULL; i++) {
        if (strcmp(tokens[i], "&") == 0) {
            tokens[i] = NULL;    // remove '&' from argv
            return 1;
        }
    }
    return 0;
}

//
// HANDLE I-O REDIRECTION (< and >)
//
int handle_redirection(char **tokens) {
    for (int i = 0; tokens[i] != NULL; i++) {

        // OUTPUT REDIRECTION: >
        if (strcmp(tokens[i], ">") == 0) {
            if (tokens[i + 1] == NULL) {
                fprintf(stderr, "syntax error: expected filename after '>'\n");
                return -1;
            }

            int fd = open(tokens[i + 1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
            if (fd < 0) {
                perror("open");
                return -1;
            }

            dup(fd, STDOUT_FILENO);
            close(fd);

            tokens[i] = NULL;
            return i;
        }

        // input redirection: <
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
// EXECUTE A SINGLE PIPE: cmd1 | cmd2
//
int execute_pipe(char **tokens, int pipe_index) {
    tokens[pipe_index] = NULL;

    char **left_cmd = tokens;
    char **right_cmd = &tokens[pipe_index + 1];

    int pipefd[2];
    if (pipe(pipefd) < 0) {
        perror("pipe");
        return -1;
    }

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

    close(pipefd[0]);
    close(pipefd[1]);

    waitpid(left_pid, NULL, 0);
    waitpid(right_pid, NULL, 0);

    return 0;
}

//
// EXECUTE A NORMAL (non-pipe) COMMAND
//
// Update execute_command():
int execute_command(char **tokens) {
    if (tokens[0] == NULL) {
        return 0;
    }

    // Check for pipe
    int pipe_index = find_pipe(tokens);
    if (pipe_index != -1) {
        return execute_pipe(tokens, pipe_index);
    }

    // check for background exectuion
    int background = is_background(tokens);

    pid_t pid = fork();

    if (pid < 0>) {
        perror("fork");
        return -1
    }

    if (pid == 0) {
        // CHILD
        handle_redirection(tokens);
        execvp(tokens[0], tokens);
        perror("execvp");
        exit(1);
    }

    // PARENT
    if (background) {
        add_job(pid, tokens[0]);
        return 0;
    }

    int status;
    waitpid(pid, &status, 0);

    return 0;
}

