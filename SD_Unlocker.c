#include <stdio.h>
#include <stdlib.h>
#include <sys/io.h>

int main() {
    if (ioperm(0x75, 2, 1) != 0) {
        perror("Error granting I/O permission");
        exit(EXIT_FAILURE);
    }

    // Считываем значения из портов
    unsigned char value1 = inb(0x75);
    unsigned char value2 = inb(0x76);

    printf("Initial values: 0x%02X, 0x%02X\n", value1, value2);

    // Изменяем значения на портах
    outb(0xF7, 0x75);
    outb(0x77, 0x76);

    // Повторно считываем измененные значения
    value1 = inb(0x75);
    value2 = inb(0x76);

    printf("Updated values: 0x%02X, 0x%02X\n", value1, value2);

    printf("I/O operations completed successfully.\n");

    return 0;
}
