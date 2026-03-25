#ifndef BUILTINS_H
#define BUILTINS_H

int is_bultin(const char *cmd);
int run_builtin(char **tokens);

#endif

// this gives two clean entry points
// is_builtin() > checks if command is built-in
// run_builtin() > executes
//