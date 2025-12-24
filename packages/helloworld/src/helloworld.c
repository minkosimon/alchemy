/**
 * @file helloworld.c
 * @brief Hello World example for Dragonwing QCS6490 board
 *
 * A simple demonstration application for cross-compilation testing
 * on the Qualcomm QCS6490 platform using the Alchemy build system.
 *
 * @author Alchemy Build System Example
 * @date December 2025
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/utsname.h>

/**
 * @brief Print system information
 */
static void print_system_info(void)
{
    struct utsname sys_info;

    if (uname(&sys_info) == 0) {
        printf("System Information:\n");
        printf("  OS:       %s\n", sys_info.sysname);
        printf("  Node:     %s\n", sys_info.nodename);
        printf("  Release:  %s\n", sys_info.release);
        printf("  Version:  %s\n", sys_info.version);
        printf("  Machine:  %s\n", sys_info.machine);
    } else {
        perror("uname");
    }
}

/**
 * @brief Print build information
 */
static void print_build_info(void)
{
    printf("\nBuild Information:\n");
    printf("  Compiled: %s %s\n", __DATE__, __TIME__);

#ifdef TARGET_BOARD_QCS6490
    printf("  Target:   Qualcomm QCS6490\n");
#endif

#ifdef TARGET_BOARD_DRAGONWING
    printf("  Board:    Dragonwing\n");
#endif

#if defined(__aarch64__)
    printf("  Arch:     AArch64 (64-bit ARM)\n");
#elif defined(__arm__)
    printf("  Arch:     ARM (32-bit)\n");
#elif defined(__x86_64__)
    printf("  Arch:     x86_64\n");
#else
    printf("  Arch:     Unknown\n");
#endif

    printf("  Compiler: %s\n", __VERSION__);
}

/**
 * @brief Main entry point
 *
 * @param argc Argument count
 * @param argv Argument vector
 * @return EXIT_SUCCESS on success
 */
int main(int argc, char *argv[])
{
    printf("============================================\n");
    printf("    Hello World from Dragonwing QCS6490!\n");
    printf("============================================\n\n");

    /* Print system information */
    print_system_info();

    /* Print build information */
    print_build_info();

    printf("\n============================================\n");
    printf("    Alchemy Build System Demo Complete!\n");
    printf("============================================\n");

    return EXIT_SUCCESS;
}
