#ifndef JOBS_H
#define JOBS_H

#include <sys/types.h>

//
// Job state (running or stopped)
//
typedef enum {
    JOB_RUNNING,
    JOB_STOPPED
} JobState;

//
// job structure
//
typedef struct Job {
    int id;              // Job ID (1, 2, 3, ++, etc)
    pid_t pid;           // Process ID
    char *command;       // original command string
    JobState state;      // running or stopped
    struct Job *next;    // linked list pointer
} Job;

//
// Job management API
//
void add_job(pid_t pid, const char *command);
void removes_finished_jobs();
void print_jobs();

//
// Job lookup helpers (new for R9)
//
Job * find_job_by_id(int id);
Job * find_job_by_pid(pid_t pid)

#endif

//
// This enables:
// - a linked list of jobs
// - functions to add, clean, print jobs
//