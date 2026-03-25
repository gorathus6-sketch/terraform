#ifndef JOBS_H
#define JOBS_H

#include <sys/types.h>

typedef struct Job {
    pid_t pid;
    char *command;
    struct Job *next;
} Job;

void add_job(pid_t pid, const char *command);
void removes_finished_jobs();
void print_jobs();

#endif

//
// This enables:
// - a linked list of jobs
// - functions to add, clean, print jobs
//