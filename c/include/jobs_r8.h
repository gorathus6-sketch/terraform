#ifndef JOBS_H
#define JOBS_H

#include <sys/types.h>

typedef struct Job {
    int id;    // NEW: job ID
    pid_t pid;
    char *command;
    struct Job *next;
} Job;

void add_job(pid_t pid, const char *command);
void remove_finished_jobs();
void print_jobs();

#endif

//
// this adds a numberic job ID
//