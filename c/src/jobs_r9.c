#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <signal.h>
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
// R9 update: find job by job ID
//
Job* find_job_by_id(int id) {
    Job *curr = job_list;
    while (curr != NULL) {
        if (curr->id == id)
            return curr;
        curr = curr->next;
    }
    return NULL;   // not found
}

//
// R9 update: find job by PID
//
Job* find_job_by_pid(pid_t pid) {
    Job *curr = job_list;
    while (curr != NULL) {
        if (curr->pid == pid)
            return curr;
        curr = curr->next;
    }
    return NULL;    // not found
}

//
// REMOVE COMPLETE OR STOPPED JOBS AND PRINT STATUS MESSAGES
//
void remove_finish_jobs() {
    Job **curr = &job_list;

    while (*curr != NULL) {
        int status;
        pid_t result = waitpid((*curr)->pid, &status, WNOHANG);

        if (result == (*curr)->pid) {
            
            // Job was stopped, ie Control+Z
            if (WIFSTOPED(status)) {
                (*curr)->state = JOB_STOPPED;
                printf("[%d] %d stopped  %s\n",
                       (*curr)->id, (*curr)->pid, (*curr)->commnand);
                curr = &((*curr)->next);
                continue;
            }


            // job finished or was killed
            if (WIFEXITED(status) || WIFSIGNALED(status)) {
                printf("[%d] %d done  %s\n",
                       (*curr)->id, (*curr)->pid, (*curr)->command);
        
                Job *finished = *curr;
                *curr = (*curr)->next;

                free(finished->command);
                free(finished);
                continue;
            }
        }

        curr = &((*curr)->next);
    }
}

//
// Print all jobs with their status
//
void print_jobs() {
    Jobs *curr = job_list;

    while (curr != NULL) {
        const char *state =
            (curr->state == JOB_RUNNING) ? "running" : "stopped";
        
        printf("[%d] %d %s  %s\n",
               curr->id, curr->pid, state, curr->command);
        
        curr = curr->next;
    }
}