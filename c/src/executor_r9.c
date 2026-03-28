#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include "executor.h"
#include "jobs.h"

//
// detect a pipe operator '|'
//
int find_pipe(char **tokens) {
    for (int i = 0; tokens[i] != NULL; i++) {
        if (strcmp(tokens[i], "|") == 0) {
            return i;
        }
    }
    return -1;   // not found
}

//
// detect background operator ('&')
//
int is_background(char **tokens) {
    for (int i = 0; tokens[i] != NULL; i++) {
        if (strcmp(tokens[i], "&") == 0) {
            tokens[1] = NULL;
            return 1;
        }
    }
    returns 0;
}

//
// Handle I/O redirection (< and >)
//
int handle_redirection(char **tokens) {
    for (int i = 0; tokens[i] != NULL; i++) {
        
        // output redirection
        if (strcmp(tokens[i], ">") == 0) {
            if (tokens[i + 1] == NULL) {
                fprintf(stderr, "syntax error: expected filename after '>'\n");
                return -1;
            }

            int fd = open(tokens[i + 1], O_WRONLY | O_CREAT | O_TRUNC, 0664);
            if (fd < 0) {
                perror("open");
                return -1;
            }

            dup2(fd, STDOUT_FILENO);
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

    return -1; // no redirection
}

//
// exec a single pipe: cmd1 | cmd2
//
int execute_pipe(char **tokens, int pipe_index) {
    tokens[pipe_index] = NULL;    // split tokens into 2 commands

    char **left_cmd = tokens;    // cmd1
    char **right_cmd = &tokens[pipe_index + 1];    // cmd2
    
    int pipefd[2];
    if (pipe(pipefd) < 0) {
        perror("pipe");
        return -1;
    }

    // left child: exec cmd1 and write to pipe
    pid_t left_pid = fork();
    if (left_pid < 0) {
        perror("fork");
        return -1;
    }

    if (left_pid == 0) {
        signal(SIGTSTP, SIG_DFL); // reset contrl+z handler in child
        signal(SIGINT, SIG_DFL); // reset control+c handler in child

        dup2(pipefd[1], STDOUT_FILENO); // redirect stdout to pipe
        close(pipefd[0]); // close unused read end
        close(pipefd[1]); // close original write end

        execvp(left_cmd[0], left_cmd);
        perror("execvp");
        exit(1);
    }

    // right child: exec cmd2 and read from pipe
    pid_t right_pid = fork();
    if (right_pid < 0) {
        perror("fork");
        return -1;
    }

    if (right_pid == 0) {
        signal(SIGTSTP, SIG_DFL); // reset control+z handler in child
        signal(SIGINT, SIG_DFL); // reset control+c handler in child

        dup2(pipefd[0], STDIN_FILENO); // redirect stdin from pipe
        close(pipefd[0]); // close original read end
        close(pipefd[1]); // close unused write end

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
// exec a normal non-pipe command
//
int execute_command(char **tokens) {
    if (tokens[0] == NULL) {
        return 0;    // empty command
    }

    // check for pipe
    int pipe_index = find_pipe(tokens);
    if (pipe_index != -1) {
        return execute_pipe(tokens, pipe_index);
    }

    // check for background execution
    int background = is_background(tokens);

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork");
        return -1;
    }

    if (pid == 0) {
        // child process
        signal(SIGTSTP, SIG_DFL); // reset control+z handler in child
        signal(SIGINT, SIG_DFL); // reset control+c handler in child

        handle_redirection(tokens); // handle I/O ridirection

        execvp(tokens[0], tokens);
        perror("execvp");
        exit(1);
    }

    // parent process
    if (background) {
        add_job(pid, tokens[0]); // add to job list
        return 0;
    }

    int status;
    waitpid(pid, &status, 0);

    return 0;
}