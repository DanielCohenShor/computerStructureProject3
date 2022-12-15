//207954975 Daniel Cohen Shor
                .section .rodata #read only data section
int_format:     .string "%d"
string_foramt:  .string "%s"
             ########
            .text #the beginnig of the code
.global run_main #the label "run_main" is used to state the the start of the function that gets the pstrings and the index from the user.
    .type run_main, @function
run_main: # the run_main function:
    push %rbp                       #save the old frame pointer
    movq %rsp, %rbp
    
    #reset the registers
    xorq %rax, %rax
    xorq %r11, %r11
    xorq %r12, %r12
    xorq %r13, %r13
    xorq %r14, %r14
    xorq %r15, %r15
    
    subq $528, %rsp                 #make enough space for 5 inputes in the stack aliged to 16
    
    #first input - the length on the first pstring
    movq $int_format, %rdi          #giving scanf the input format
    leaq -528(%rbp), %rsi           #making rsi point to the input
    movq %rsi, %r12                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    movb (%r12), %r11b              #cast the number to char
    movb %r11b, -524(%rbp)          #insert the length into pstring struct
    
    #second input - the string of the first pstring
    movq $string_foramt, %rdi       #giving scanf the input format
    leaq -523(%rbp), %rsi           #making rsi point to the input
    movq %rsi, %r13                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    
    #third input - the length on the second pstring
    movq $int_format, %rdi          #giving scanf the input format
    leaq -268(%rbp), %rsi           #making rsi point to the input
    movq %rsi, %r14                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    movb (%r14), %r11b              #cast the number to char
    movb %r11b, -264(%rbp)          #insert the length into pstring struct
    
    #fourth input - the string of the second pstring
    movq $string_foramt, %rdi       #giving scanf the input format
    leaq -263(%rbp), %rsi           #making rsi point to the input
    movq %rsi, %r15                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    
    #fifth input - the index
    movq $int_format, %rdi          #giving scanf the input format
    leaq -8(%rbp), %rsi             #making rsi point to the input
    movq %rsi, %r14                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    
    #reset the registers
    xorq %rdi, %rdi
    xorq %rsi, %rsi
    xorq %rdx, %rdx
    
    #call run_func
    leaq -524(%rbp), %rdi           #save first pstring in rdi 
    leaq -264(%rbp), %rsi           #save second pstring in rsi
    movq (%r14), %rdx               #save the index in rdx
    call run_func                   #call run_func function in func_select
        
    #ends the using in stack
    movq %rbp, %rsp                 #restore the old stack pointer - release all used memory.
    popq %rbp                       #restore old frame pointer (the caller function frame)
    xorq %rax, %rax                 #return to caller function (OS)
    ret
