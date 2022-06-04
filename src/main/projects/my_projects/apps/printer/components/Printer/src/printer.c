#include <stdio.h>

#include <camkes.h>

void pr_my_print(const char *msg) {
    printf("Component %s saying: %s\n", get_instance_name(), msg);
}
