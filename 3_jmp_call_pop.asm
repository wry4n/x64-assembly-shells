; opens simple shell, jump to function, call before string, pop string
; assemble and run: $ nasm -f elf64 -o <name>.asm && ld <name>.o && ./a.out

section .text
    global _start

_start:
    jmp one

two: 
    ; syntax: int execve(const char *filename, char *const argv[], char *const envp[]);
    pop rdi        ; rdi (arg1) = ptr (return address) to '/bin/sh/0x00"
    xor rsi, rsi   ; rsi (arg2) = 0 
    xor rdx, rdx   ; rdx (arg3) = 0
    xor rax, rax		
    mov rax, 0x3b  ; rax = 0x3b (execve syscall)
    syscall

    ; syntax: void exit(int status);
    inc rax        ; rax = 0x3c (exit syscall)
    xor rdi, rdi   ; rdi (arg1) = 0 (exit status: no errors)
    syscall

one: 
    call two       ; call back up to "two"
    db "/bin/sh"   ; when string placed directly after call,
                   ; ptr to string pushed to stack 
