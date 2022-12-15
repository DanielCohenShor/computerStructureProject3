//207954975 Daniel Cohen Shor
                .section .rodata #read only data section
invalid_input: .string "invalid input!\n"
             ########
            .text #the beginnig of the code
.global pstrlen #the label "pstrlen" is used to state the the start of the function that returns the length of the string.
    .type pstrlen, @function
pstrlen:    # the pstrlen function:
    push %rbp                       #save the old frame pointer
    movq %rsp, %rbp                 #create the new frame pointer
    
    xorq %rax, %rax                 #reset rax register
    movb (%rdi), %al                #insert the length on the string to rax
    
    jmp .done                       #go to done
    
.global replaceChar #the label "replaceChar" is used to state the the start of the function that replace every old char with new char.
    .type replaceChar, @function
replaceChar:    # the replaceChar function:
    push %rbp                       #save the old frame pointer
    movq %rsp, %rbp                 #create the new frame pointer
    
    #reset the registers
    xorq %rax, %rax
    xorq %r8, %r8
    xorq %rcx, %rcx
    
    movq %rdi, %rax                 #save pointer to the pstring in rax
    movb (%rdi), %cl                #save the size of the string in cl register
    
    jmp .checkReplaceChar           #start the while loop that replace all the old chars in the string to the new char
    
.checkReplaceChar:
    addq $1, %rdi                   #look at the current char
    addq $1, %r8                    #make r8 the index in the for loop, stop when index = size of string
    cmpb %r8b, %cl                  #compare size of string:index of the for loop
    jb .done                        #if <, goto done
    jne .continue                   #if !=, go to continue
    
.continue:
    cmpb %sil, (%rdi)               #compare current char in the pstring:old char
    je .replace                     #if =, goto replace
    jne .checkReplaceChar           #if !=, go to checkReplaceChar
    
.replace:
    movb %dl, (%rdi)                #store new char at the desired position in the string
    jmp .checkReplaceChar           #go to checkReplaceChar
    
.global pstrijcpy #the label "pstrijcpy" is used to state the the start of the function that copies the sub string of src to dest.
    .type pstrijcpy, @function
pstrijcpy:    # the pstrijcpy function:
    push %rbp                       #save the old frame pointer
    movq %rsp, %rbp                 #create the new frame pointer
    
    movq %rdi, %rax                 #save pointer to the dst pstring in rax
    
    #check validation of i,j
    cmpb $0, %dl                    #compare start index:0
    jl .invalid                     #if <, go to invalid
    cmpb (%rdi), %dl                #compare start index:length of the first string
    jge .invalid                    #if >=, go to invalid
    cmpb (%rsi), %dl                #compare start index:length of the second string
    jge .invalid                    #if >=, go to invalid
    
    cmpb %cl, %dl                   #compare start index:end index
    jg .invalid                     #if >, go to invalid
    
    cmpb (%rdi), %cl                #compare end index:length of the first string
    jge .invalid                    #if >=, go to invalid
    cmpb (%rsi), %cl                #compare end index:length of the second string
    jge .invalid                    #if >=, go to invalid
    
    #copy sub string
    xorq %r8, %r8                   #reset r8
    xorq %r9, %r9                   #reset r9
    movq %rdx, %r8                  #save start index in r8
    addq $1, %rdi                   #point rdi to the start of the string in the dst pstring
    addq $1, %rsi                   #point rsi to the start of the string in the src pstring
    addq %rdx, %rdi                 #look at the char of the dst pstring in at the given index i
    addq %rdx, %rsi                 #look at the char of the src pstring in at the given index i
    jmp .checkPstrijcpy             #start the foor loop of replace the chars until i > j
    
.checkPstrijcpy:
    cmpq %r8, %rcx                  #compare end index:current index   
    jb .done                        #if <, go to done
    jmp .copySubString              #go to copySubString
    
.copySubString:
    movb (%rsi), %r9b               #insert the char in current location at src to r9
    movb %r9b, (%rdi)               #insert the char in current location at src to dest
    addq $1, %r8                    #increment the current index
    addq $1, %rdi                   #look at the char of the dst pstring in at the current index
    addq $1, %rsi                   #look at the char of the src pstring in at the current index
    jmp .checkPstrijcpy
    
.invalid:
    xorq %r12, %r12                 #reset r12
    movq %rax, %r12                 #save return value in r12
    
    #reset the registers
    xorq %rdi, %rdi
    xorq %rax, %rax
    
    movq $invalid_input, %rdi       #giving printf the format she needs to print
    call printf                     #calling printf
    movq %r12, %rax                 #save the return value in rax
    jmp .done                       #go to done
    
.global swapCase #the label "swapCase" is used to state the the start of the function that swap the case of the chars in the string.
    .type swapCase, @function
swapCase:    # the swapCase function:
    push %rbp                       #save the old frame pointer
    movq %rsp, %rbp                 #create the new frame pointer
    
    #reset the registers
    xorq %r8, %r8
    xorq %r9, %r9
    
    movb (%rdi), %r8b               #save the size of the string in r8 register
    movq %rdi, %rax                 #save pointer to the pstring in rax
    addq $1, %rdi                   #point rdi to the start of the string in the pstring

    jmp .checkCase                  #start the foor loop until the end of the string that replaces the cases of the letters
    
.checkCase:
    cmpq %r9, %r8                   #compare size of string:current index
    jb .done                        #if <, go to done
    jmp .replaceCase                #else go to replaceCase
    
.replaceCase:
    cmpb $'A', (%rdi)               #compare current char:letter A
    jb .moveToAnotherLetter         #if <, go to moveToAnotherLetter
    cmpb $'z', (%rdi)               #compare current char:letter z
    ja .moveToAnotherLetter         #if >, go to moveToAnotherLetter
    cmpb $'Z', (%rdi)               #compare current char:letter Z
    jle .switchToLower              #if <=, go to switchToLower
    cmpb $'a', (%rdi)               #compare current char:letter a
    jge .switchToUpper              #if >=, go to switchToUpper
    jmp .moveToAnotherLetter        #if between Z to a - not a letter so go to moveToAnotherLetter
    
.switchToLower:
    addb $32, (%rdi)                #add 32 to the char - make it lower case
    jmp .moveToAnotherLetter        #continue to another letter

.switchToUpper:
    subq $32, (%rdi)                #subtract 32 from the char - make it upper case
    jmp .moveToAnotherLetter        #continue to another letter
    
.moveToAnotherLetter:
    addq $1, %r9                    #increment the index
    addq $1, %rdi                   #look at the char of the pstring in at the current index
    jmp .checkCase                  #start the for loop with the new index
    
.global pstrijcmp #the label "pstrijcmp" is used to state the the start of the function that compare the substrings in dest and src.
    .type pstrijcmp, @function
pstrijcmp:    # the pstrijcmp function:
    push %rbp                       #save the old frame pointer
    movq %rsp, %rbp                 #create the new frame pointer
    
    xorq %rax, %rax                 #reset rax
    xorq %r8, %r8                   #reset r8
    xorq %r9, %r9                   #reset r9
    movq %rdx, %r8                  #set r8 to be the start index
      
    movl $-2, %eax                  #set to -2 - when i or j are not valid
    
    #check validation of i,j
    cmpb $0, %dl                    #compare start index:0
    jl .invalid                     #if <, go to invalid
    cmpb (%rdi), %dl                #compare start index:length of the first string
    jge .invalid                    #if >=, go to invalid
    cmpb (%rsi), %dl                #compare start index:length of the second string
    jge .invalid                    #if >=, go to invalid
    
    cmpb %cl, %dl                   #compare start index:end index
    jg .invalid                     #if >, go to invalid
    
    cmpb (%rdi), %cl                #compare end index:length of the first string
    jge .invalid                    #if >=, go to invalid
    cmpb (%rsi), %cl                #compare end index:length of the second string
    jge .invalid                    #if >=, go to invalid
    
    xorq %rax, %rax                 #set to 0 - when the sub strings are equal
    addq $1, %rdi                   #point rdi to the start of the string in the first pstring
    addq $1, %rsi                   #point rsi to the start of the string in the second pstring
    addq %rdx, %rdi                 #look at the char of the first pstring in at the given index i
    addq %rdx, %rsi                 #look at the char of the second pstring in at the given index i
    movl %edx, %r8d                 #save the start index in r8
    jmp .compareSubStrings          #start the for loop to compare the sub strings 
    
.compareSubStrings:
    cmpq %rcx, %r8                  #compare current index:end index
    ja .done                        #if >, go to done
    jmp .compareLexicographic       #else, start to compare the chars
    
.compareLexicographic:
    movb (%rsi), %r9b               #save the char in current index in second pstring in r9
    cmpb %r9b, (%rdi)               #compare current char at first string:current char at second string
    je .moveToNextChar              #if =, go to moveToNextChar
    ja .firstIsBigger               #if >, go to firstIsBigger
    jb .secondIsBigger              #if <, go to secondIsBigger
    
.moveToNextChar:
    addl $1, %r8d                   #increment the index
    addq $1, %rdi                   #look at the char of the first pstring in at the current index
    addq $1, %rsi                   #look at the char of the second pstring in at the current index
    jmp .compareSubStrings          #go to the label that compare the next char
    
.firstIsBigger:
    movl $1, %eax                   #set to 1 - when the the sub string of the first string is bigger than the sub string in the second string
    jmp .done                       #go to done
    
.secondIsBigger:
    movl $-1, %eax                  #set to -1 - when the the sub string of the second string is bigger than the sub string in the first string
    jmp .done                       #go to done
    
.done:
    movq %rbp, %rsp                 #restore the old stack pointer - release all used memory.
    popq %rbp                       #restore old frame pointer (the caller function frame)
    ret
