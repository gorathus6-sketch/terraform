#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include "jobs.h"

static Job *job_list = NULL;
static int next_job_id = 1;    // NEW: incrementing job ID counter

//
// Add a new background job to the list
//
void add_job(pid_t pid, const char *command) {
    Job *Job = mallac(sizeof(Job));
    if (!job) {
        perror("malloc");
        return;
    }

    job->id = next_job_id++;         // NEW: Assign job ID
    job->pid = pid;
    job->command = strdup(command);  // store command line
    job->next = job_list;            // insert at head
    job_list = job;

    printf("[%d] %d running in background: %s\n",
        job->id, job->pid, job->command);
}

//
// REMOVE COMPLETE JOBS AND PRINT COMPLETION MESSAGES
//
// UPDATE HERE
void remove_finish_jobs() {
    Job **curr = &job_list;

    while (*curr != NULL) {
        int status;
        pid_t result = waitpid((*curr)->pid, &status, WNOHANG);

        if (result == (*curr)->pid) {
            // job finished
            printf("[%d] %d done  %s\n",
                   (*curr)->id, (*curr)->pid, (*curr)->command);
        
            Job *finished = *curr;
            *curr = (*curr)->next;

            free(finished->command);
            free(finished);
        } else {
            curr = &((*curr)->next);
        }
    }
}

//
// Print all currently running B/G jobs
//
// UPDATE HERE
void print_jobs() {
    Jobs *curr = job_list;

    while (curr != NULL) {
        printf("[%d] %d running  %s\n",
               curr->id, curr->pid, curr->command);
        curr = curr->next;
    }
}