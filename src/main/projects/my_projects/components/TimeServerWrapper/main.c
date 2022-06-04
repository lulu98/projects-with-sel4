/*
 * Implementation of the TimeServerWrapperInterface interface.
 */

#include <autoconf.h>
#include <camkes.h>
#include <stdio.h>

/*
 * Gets the current time from the TimeServer in global-components.
 */
uint64_t timeServerWrapperInterface_getTime() {
    uint64_t timestamp = timeout_time();
    return timestamp;
}

seL4_CPtr timeout_notification(void);
seL4_Word badge;
seL4_CPtr notification;

/*
 * Sleeps for ns nanoseconds.
 */
int timeServerWrapperInterface_sleep(uint64_t ns) {
    int status = timeout_oneshot_relative(0, ns);
    seL4_Wait(notification, &badge);
    return status;
}

void post_init() {
    notification = timeout_notification();
}
