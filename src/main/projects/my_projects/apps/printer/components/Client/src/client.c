#include <stdio.h>
#include <inttypes.h>

#include <camkes.h>

#define WAIT 2000000000

int run(void) {
    char *msg = "My message.";
    int i = 0;
    while(i < 5) {
        pr_my_print(msg);
        timeServerWrapperInterface_sleep(WAIT);
        i++;
    }
}
