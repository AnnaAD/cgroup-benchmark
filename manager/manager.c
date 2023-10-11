#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sched.h>


#define STACK_SIZE (1024 * 1024) // 1MB stack size for clone

static char child_stack[STACK_SIZE];

void execute_in_cgroup(const char *executable, const char *cgroup_name) {
    // Create a child process with its own namespace and cgroup
    int pid = clone(NULL, child_stack + STACK_SIZE, CLONE_NEWPID | CLONE_NEWNS, NULL);

    if (pid == 0) {
        // Child process
        // Set the cgroup for the child process
        if (cgroup_name != NULL) {
            char cgroup_path[100];
            snprintf(cgroup_path, sizeof(cgroup_path), "/sys/fs/cgroup/cpu/%s", cgroup_name);
            mkdir(cgroup_path, 0755);
            FILE *cgroup_file = fopen(strcat(cgroup_path, "/tasks"), "w");
            fprintf(cgroup_file, "%d", getpid());
            fclose(cgroup_file);
        }

        // Execute the specified executable
        execlp(executable, executable, NULL);
        perror("execlp");
        exit(EXIT_FAILURE);
    } else if (pid < 0) {
        perror("clone");
        exit(EXIT_FAILURE);
    } else {
        // Parent process
        // Wait for the child process to complete
        waitpid(pid, NULL, 0);
    }
}

void execute_with_scheduler(const char *executable, int policy, int priority) {
    // Create a child process
    int pid = clone(NULL, child_stack + STACK_SIZE, CLONE_NEWPID, NULL);

    if (pid == 0) {
        // Child process
        struct sched_param sched_param;
        sched_param.sched_priority = priority;

        // Set the scheduling policy and priority for the child process
        if (sched_setscheduler(0, policy, &sched_param) == -1) {
            perror("sched_setscheduler");
            exit(EXIT_FAILURE);
        }

        // Execute the specified executable
        execlp(executable, executable, NULL);
        perror("execlp");
        exit(EXIT_FAILURE);
    } else if (pid < 0) {
        perror("clone");
        exit(EXIT_FAILURE);
    } else {
        // Parent process
        // Wait for the child process to complete
        waitpid(pid, NULL, 0);
    }
}

int main() {
    // Create and run processes in different cgroups
    execute_in_cgroup("executable1", "cgroup1");
    execute_in_cgroup("executable2", "cgroup2");

    execute_with_scheduler("executable", SCHED_FIFO, 99);


    return 0;
}
