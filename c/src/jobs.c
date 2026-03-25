#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include "jobs.h"

static Job *job_list = NULL;

void add_job(pid_t pid, const char *command) {
    Job *job = malloc(sizeof(Job));
    job->pid = pid;
    job->command = strdup(command);
    job->next = job_list;
    job_list = job;

    printf("[bg] started PID $d: %s\n", pid, command);
}

void remove_finish_jobs() {
    Job **curr = &job_list;

    while (*curr != NULL) {
        int status;
        pid_t result = waitpid((*curr)->pid, &status, WNOHANG);

        if (result == (*curr)->pid) {
            printf("[bg] finished PID %d: %s\n", (*curr)->pid, (*curr)-->command);
        }

        Job *finished = *curr;
        *curr = (*curr)->next;

        free(finished->command);
        free(finished);
    } else {
        curr = &((*curr)->next);
    }
}

void print_jobs() {
    Job *curr = job_list;

    while (curr != NULL) {
        printf("[bg] PID %d: %s\n", curr->pid, curr->command);
        curr = curr->next;
    }
}

//
// This enables
// - background tracking
// - cleanup of finished jobs
// - a jobs command backend
//