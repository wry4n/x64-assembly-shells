; opens simple shell, '/bin/sh' in variable
; assemble and run: $ nasm -f elf64 -o <name>.asm && ld <name>.o && ./a.out

section .data 
    msg db "/bin/sh"    ; msg = "/bin/sh" ("db" stands for "define byte")

section .text
    global _start 		

_start:
    ; syntax: int execve(const char *pathname, char *const argv[], char *const envp[])
    xor rdx, rdx        ; rsi (arg3) = 0 (no arg)
    mov rax, rdx        ; zero out rax
    mov rax, 0x3b       ; rax = 0x3b (execve syscall)
    mov rdi, rdx        ; zero out rdi
    mov rdi, msg        ; rdi (arg1) = msg = "/bin/sh" 
    mov rsi, rdx        ; rsi (arg2) = 0 
    syscall				

    ; syntax: void exit(int status);
    inc rax             ; rax = 0x3c (exit syscall)
    mov rdi, rsi        ; rdi (arg1) = 0 (exit status: no errors)
    syscall				
