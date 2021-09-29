; opens simple shell, pushing '/bin/sh0x00' on stack
; assemble and run: $ nasm -f elf64 -o <name>.asm && ld <name>.o && ./a.out

section .text
    global _start        ; needed for compiler, comparable to "int main()"

_start:
    ; syntax: int execve(const char *pathname, char *const argv[], char *const envp[])
    xor rdx, rdx         ; rdx (arg3) = 0
    push rdx             ; push 0x00 onto stack as null terminator
    mov rdi, rdx         ; zero out rdi
    mov rdi, '/bin//sh'	
    push rdi             ; push '/bin//sh' onto stack
    xor rdi, rdx         ; zero out rdi again 
    mov rdi, rsp         ; rdi (arg1) = ptr to '/bin//sh0x00'
    mov rsi, rdx         ; rsi (arg2) = 0
    mov rax, rdx		
    mov rax, 0x3b        ; rax = 0x3b (execve syscall)
    syscall				

    ; syntax: void exit(int status);
    inc rax              ; rax = 0x3c (exit syscall)
    xor rdi, rdi         ; rdi (arg1) = 0 (exit status: no errors)
    syscall				
