//207954975 Daniel Cohen Shor
                .section .rodata #read only data section
char_format:    .string " %c"
int_format:     .string "%d"
format_31:      .string "first pstring length: %d, second pstring length: %d\n"
format_32or33:  .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
format_35and36: .string "length: %d, string: %s\n"
format_37:      .string "compare result: %d\n"
invalid_option: .string "invalid option!\n"

.align 8 # Align address to multiple of 8
.checkIndex:
	.quad .31Index          # Case 31
	.quad .32or33Index      # Case 32
	.quad .32or33Index      # Case 33
	.quad .invalidIndex     # Case 34
	.quad .35Index          # Case 35
	.quad .36Index          # Case 36
	.quad .37Index          # Case 37
	.quad .invalidIndex     # invalid index case
	.quad .done             # done with switch
             ########
            .text #the beginnig of the code
.global run_func #the label "run_func" is used to state the start of the function that check which option the user chose
    .type run_func, @function
run_func: # the run_func function:
    push %rbp                       #save the old frame pointer
    movq %rsp, %rbp                 #create the new frame pointer
    
    xorq %rcx, %rcx                 #reset rcx
    
    #check the index
    leaq -31(%rdx), %rcx            #compute index = index - 31
    cmpq $6, %rcx                   #compare index:6
    ja .invalidIndex                #if >, goto invalid case
    cmpq $0, %rcx                   #compare index:0
    jb .invalidIndex                #if <, goto invalid case
    jmp *.checkIndex(,%rcx,8)       #goto jt[index]
    
.31Index:
    #backup callee-save register
    pushq %r12
    pushq %r13
    
    #reset the registers
    xorq %r12, %r12
    xorq %r13, %r13
    xorq %rax, %rax
    
    call pstrlen                    #call pstrlen function
    movq %rax, %r12                 #save the size returned from the function in r12
    
    xorq %rax, %rax                 #reset rax
    movq %rsi, %rdi                 #move the pointer to the second pstring to rdi
    call pstrlen                    #call pstrlen function
    movq %rax, %r13                 #save the size returned from the function in r13
    
    #call printf
    xorq %rax, %rax                 #reset rax
    movq $format_31, %rdi           #giving printf the format she needs to print
    movq %r12, %rsi                 #sending to printf the size of the first string
    movq %r13, %rdx                 #sending to printf the size of the second string
    call printf                     #call printf function
    
    #restore callee-save register
    popq %r13
    popq %r12
    
    jmp .done                       #go to done
    
.32or33Index:
    #backup callee-save register
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    
    #reset the registers
    xorq %r12, %r12
    xorq %r13, %r13
    xorq %r14, %r14
    xorq %r15, %r15
    xorq %rax, %rax                
    
    movq %rdi, %r12                 #point r12 to the first pstring
    movq %rsi, %r13                 #point r13 to the second pstring
    
    subq $32, %rsp                  #make enough space for 2 inputes in the stack aliged to 16
    
    #first input - old char
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    movq $char_format, %rdi         #giving scanf the input format
    leaq -32(%rbp), %rsi            #making rsi point to the input
    movq %rsi, %r14                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    
    #second input - new char
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    movq $char_format, %rdi         #giving scanf the input format
    leaq -16(%rbp), %rsi            #making rsi point to the input
    movq %rsi, %r15                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    
    #call the function with the first pstring
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    xorq %rax, %rax                 #reset rax
    
    movq %r12, %rdi                 #point rdi to the first pstring
    movq (%r14), %rsi               #save the old char in rsi
    movq (%r15), %rdx               #save the new char in rdx
    call replaceChar                #call replaceChar function
    movq %rax, %r12                 #save the pointer to the pstring returned from the function in r12
    addq $1, %r12                   #make r12 point to the string in the pstring
    
    #call the function with the second pstring
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    xorq %rdx, %rdx                 #reset rdx
    xorq %rax, %rax                 #reset rax
    
    movq %r13, %rdi                 #point rdi to the second pstring
    movq (%r14), %rsi               #save the old char in rsi
    movq (%r15), %rdx               #save the new char in rdx
    call replaceChar                #call replaceChar function
    movq %rax, %r13                 #save the pointer to the pstring returned from the function in r13
    addq $1, %r13                   #make r13 point to the string in the pstring
    
    #reset the registers for printf
    xorq %rdi, %rdi
    xorq %rsi, %rsi
    xorq %rdx, %rdx
    xorq %rcx, %rcx
    xorq %r8, %r8
    xorq %rax, %rax                 
    
    #call printf
    movq $format_32or33, %rdi       #giving printf the format she needs to print
    movq (%r14), %rsi               #save the old char in rsi
    movq (%r15), %rdx               #save the new char in rdx
    movq %r12, %rcx                 #save the pointer to string of the first pstring returned from the function
    movq %r13, %r8                  #save the pointer to string of the second pstring returned from the function
    call printf                     #calling printf
    
    #restore callee-save register
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    
    jmp .done                       #go to done
    
.35Index:
    #backup callee-save register
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    
    #reset the registers
    xorq %r12, %r12
    xorq %r13, %r13
    xorq %rdx, %rdx
    xorq %rcx, %rcx
    xorq %r14, %r14
    xorq %r15, %r15
    
    subq $32, %rsp                  #make enough space for 2 inputes in the stack aliged to 16

    movq %rdi, %r12                 #point r12 to the first pstring
    movq %rsi, %r13                 #point r13 to the second pstring
    
    #first input - start index
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    movq $int_format, %rdi          #giving scanf the input format
    leaq -32(%rbp), %rsi            #making rsi point to the input
    movq %rsi, %r14                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    
    #second input - end index
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    movq $int_format, %rdi          #giving scanf the input format
    leaq -16(%rbp), %rsi            #making rsi point to the input
    movq %rsi, %r15                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    
    #call the function with first pstring as dst, second pstring as src, start index as i and end index as j
    #reset the registers
    xorq %rdi, %rdi                 
    xorq %rsi, %rsi                 
    xorq %rax, %rax                 
    xorq %rdx, %rdx
    xorq %rcx, %rcx
    
    movq %r12, %rdi                 #point rdi to the first pstring
    movq %r13, %rsi                 #point rsi to the second pstring
    movb (%r14), %dl                #save the start index in rdx
    movb (%r15), %cl                #save the end index in rcx
    call pstrijcpy                  #call pstrijcpy function
    movq %rax, %r14                 #save the pointer to the pstring returned from the function in r14
    
    #call printf on dest
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    xorq %rdx, %rdx                 #reset rdx
    xorq %rax, %rax                 #reset rax
    
    movq $format_35and36, %rdi      #giving printf the format she needs to print
    movb (%r14), %sil               #save the length of dest string in rsi
    addq $1, %r14                   #make r14 point to the string in the pstring
    movq %r14, %rdx                 #save the string of dest in rdx
    call printf                     #calling printf function
    
    #call printf on src
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    xorq %rdx, %rdx                 #reset rdx
    xorq %rax, %rax                 #reset rax
    
    movq $format_35and36, %rdi      #giving printf the format she needs to print
    movb (%r13), %sil               #save the length of src string in rsi
    addq $1, %r13                   #make r13 point to the string in the pstring
    movq %r13, %rdx                 #save the string of src in rdx
    call printf                     #calling printf function
    
    #restore callee-save register
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    
    jmp .done                       #go to done
    
.36Index:
    #backup callee-save register
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    
    #reset the registers
    xorq %r12, %r12
    xorq %r13, %r13
    xorq %r14, %r14
    xorq %r15, %r15
    
    movq %rdi, %r12                 #point r12 to the first pstring
    movq %rsi, %r13                 #point r13 to the second pstring
    
    #call swapCase for first pstring
    xorq %rax, %rax                 #reset rax
    call swapCase                   #call swapCase function
    movq %rax, %r14                 #save the pointer to the pstring returned from the function in r14
    
    #call printf on first string after swap
    xorq %rax, %rax                 #reset rax
    xorq %rsi, %rsi                 #reset rsi
    movq $format_35and36, %rdi      #giving printf the format she needs to print
    movb (%r14), %sil               #save the length of the first pstring in rsi
    addq $1, %r14                   #make r14 point to the string in the pstring
    movq %r14, %rdx                 #save the string of pstring in rdx
    call printf                     #calling printf fucntion
    
   #call swapCase for second pstring
    xorq %rdi, %rdi                 #reset rdi
    xorq %rax, %rax                 #reset rax
    movq %r13, %rdi                 #save the second pstring in rdi
    call swapCase                   #call swapCase function
    movq %rax, %r15                 #save the pointer to the pstring returned from the function in r15
    
    #call printf on second string after swap
    xorq %rax, %rax                 #reset rax
    xorq %rsi, %rsi                 #reset rsi
    movq $format_35and36, %rdi      #giving printf the format she needs to print
    movb (%r15), %sil               #save the length of the second pstring in rsi
    addq $1, %r15                   #make r15 point to the string in the pstring
    movq %r15, %rdx                 #save the string of pstring in rdx
    call printf                     #calling printf fucntion
    
    #restore callee-save register
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    
    jmp .done                       #go to done
    
.37Index:
    #backup callee-save register
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    
    #reset the registers
    xorq %r12, %r12
    xorq %r13, %r13
    xorq %r14, %r14
    xorq %r15, %r15
    
    movq %rdi, %r12                 #point r12 to the first pstring
    movq %rsi, %r13                 #point r13 to the second pstring
    
    subq $32, %rsp                  #make enough space for 2 inputes in the stack aliged to 16

    #first input - start index
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    movq $int_format, %rdi          #giving scanf the input format
    leaq -32(%rbp), %rsi            #making rsi point to the input
    movq %rsi, %r14                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    
    #second input - end index
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    movq $int_format, %rdi          #giving scanf the input format
    leaq -16(%rbp), %rsi            #making rsi point to the input
    movq %rsi, %r15                 #save the pointer to the input
    xorq %rax, %rax                 #reset rax for scanf
    call scanf                      #call scanf function
    
    #call the function with first pstring as pstr1, second pstring as pstr2, start index as i and end index as j
    #reset the registers
    xorq %rdi, %rdi                 
    xorq %rsi, %rsi                 
    xorq %rax, %rax                 
    xorq %rdx, %rdx
    xorq %rcx, %rcx
    
    movq %r12, %rdi                 #point rdi to the first pstring
    movq %r13, %rsi                 #point rsi to the second pstring
    movb (%r14), %dl                #save the start index in rdx
    movb (%r15), %cl                #save the end index in rcx
    call pstrijcmp                  #call pstrijcpy function
    xorq %r14, %r14                 #reser r14
    movl %eax, %r14d                #save the number returned from the function in r14
    
    #call printf
    xorq %rdi, %rdi                 #reset rdi
    xorq %rsi, %rsi                 #reset rsi
    xorq %rdx, %rdx                 #reset rdx
    xorq %rax, %rax                 #reset rax
    
    movq $format_37, %rdi           #giving printf the format she needs to print
    movl %r14d, %esi                #save the compare result in rsi
    call printf                     #calling printf function
    
    #restore callee-save register
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    
    jmp .done                       #go to done
    
.invalidIndex:
    xorq %rax, %rax                 #reset rax
    movq $invalid_option, %rdi      #giving printf the format she needs to print
    call printf                     #calling printf
    
    jmp .done                       #go to done
    
.done:
    movq %rbp, %rsp                 #restore the old stack pointer - release all used memory.
    popq %rbp                       #restore old frame pointer (the caller function frame)
    ret
