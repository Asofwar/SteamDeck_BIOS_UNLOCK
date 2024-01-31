#include <stdio.h>
#include <stdlib.h>
#include <sys/io.h>
#include <errno.h>

int main() {
    // Предоставляем разрешение на доступ к портам ввода/вывода
    if (ioperm(0x75, 2, 1) != 0) {
        perror("Error granting I/O permission");
        exit(EXIT_FAILURE);
    }

    // Считываем начальные значения из портов
    unsigned char initial_value1 = inb(0x75);
    unsigned char initial_value2 = inb(0x76);

    printf("Initial values: 0x%02X, 0x%02X\n", initial_value1, initial_value2);

    // Изменяем значения на портах
    outb(0xF7, 0x75);
    if (errno) {
        perror("Error writing to port 0x75");
        exit(EXIT_FAILURE);
    }

    outb(0x77, 0x76);
    if (errno) {
        perror("Error writing to port 0x76");
        exit(EXIT_FAILURE);
    }

    // Повторно считываем измененные значения
    unsigned char updated_value1 = inb(0x75);
    unsigned char updated_value2 = inb(0x76);

    printf("Updated values: 0x%02X, 0x%02X\n", updated_value1, updated_value2);

    // Завершаем работу, освобождаем разрешения
    if (ioperm(0x75, 2, 0) != 0) {
        perror("Error revoking I/O permission");
        exit(EXIT_FAILURE);
    }

    printf("I/O operations completed successfully.\n");

    return 0;
}
