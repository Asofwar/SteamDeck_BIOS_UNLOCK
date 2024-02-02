section .data
    port1 equ 0x72
    port2 equ 0x73

section .bss
    initial_value1 resb 1
    initial_value2 resb 1
    updated_value1 resb 1
    updated_value2 resb 1

section .text
    global _start

_start:
    ; Предоставляем разрешение на доступ к портам ввода/вывода
    mov rax, 0x101
    mov rdi, port1
    mov rsi, 2
    syscall
    test rax, rax
    jnz error

    ; Считываем начальные значения из портов
    mov eax, 0
    in al, port1
    mov [initial_value1], al
    in al, port2
    mov [initial_value2], al

    movzx rdi, byte [initial_value1]
    movzx rsi, byte [initial_value2]
    mov rdx, rdi
    mov rcx, rsi
    mov r8, format_string
    call print_values

    ; Изменяем значения на портах
    mov al, 0xF7
    out port1, al
    mov al, 0x77
    out port2, al

    ; Повторно считываем измененные значения
    mov eax, 0
    in al, port1
    mov [updated_value1], al
    in al, port2
    mov [updated_value2], al

    movzx rdi, byte [updated_value1]
    movzx rsi, byte [updated_value2]
    mov rdx, rdi
    mov rcx, rsi
    mov r8, format_string
    call print_values

    ; Завершаем работу, освобождаем разрешения
    mov rax, 0x101
    mov rdi, port1
    mov rsi, 2
    syscall
    test rax, rax
    jnz error

    ; Выводим сообщение об успешном завершении
    mov rdi, success_message
    call print_message

    ; Завершаем программу
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; status: 0
    syscall

error:
    ; Выводим сообщение об ошибке
    mov rdi, error_message
    call print_message

    ; Завершаем программу с ошибкой
    mov rax, 60         ; syscall: exit
    xor rdi, 1          ; status: 1
    syscall

print_values:
    ; Выводим значения
    mov rax, 1           ; syscall: write
    mov rdi, 1           ; file descriptor: STDOUT
    mov rdx, 32          ; number of bytes to write
    mov rax, 60          ; syscall: write
    mov rsi, r8          ; pointer to the string
    syscall
    ret

print_message:
    ; Выводим сообщение
    mov rax, 1           ; syscall: write
    mov rdi, 1           ; file descriptor: STDOUT
    mov rdx, 100         ; number of bytes to write
    mov rax, 60          ; syscall: write
    mov rsi, rdi         ; pointer to the string
    syscall
    ret

section .data
    format_string db "Values: 0x%02X, 0x%02X", 0xA
    success_message db "I/O operations completed successfully.", 0xA
    error_message db "Error during I/O operations.", 0xA
