TITLE Program 2  

; Author: Tyler Cope
; Course / Project ID: CS271/Program 2
; Date: 1/27/2017
; Description: This program asks users their name, greets them,
; then asks them to enter how many Fibonacci numbers they would like to see.
; They must choose a number between 1-46 (inclusive). If they write a number
; that's out of bounds, the program loops until they write a correct number.
; The program then displays the Fib numbers up to the number they picked. They
; are aligned with a tab character.

INCLUDE Irvine32.inc

.data
nameTitle           BYTE      "Programmed by Tyler Cope",0
programTitle        BYTE      "Fibonacci Numbers",0
userQuestion        BYTE      "Please input your name: ",0
userGreet           BYTE      "Hello, ",0
firstFibPrompt      BYTE      "Please enter the number of Fibonacci terms.",0
secondFibPrompt     BYTE      "It must be in the range of 1-46",0
thirdFibPrompt      BYTE      "How many Fibonacci terms?",0
userName            BYTE      30 DUP(0)
errorMessage        BYTE      "The number must be between 1-46. Please enter it again.",0
byeMessage          BYTE      "Thanks for using my program. Bye!",0
ecMessage           BYTE      "The numbers are all aligned!",0
count               DWORD     ?
userNum             DWORD     ?


;Constants to compare the user input
UPPER = 46
LOWER = 1



.code
main PROC

introduction:
     mov       edx, OFFSET programTitle
     call WriteString
     call crlf

     mov       edx, OFFSET nameTitle
     call WriteString
     call crlf

     mov       edx, OFFSET userQuestion
     call WriteString
     call crlf

     ;used to specify how many characters. Program will not read string without it
     mov       edx, OFFSET userName
     mov       ecx, SIZEOF userName     
     call ReadString
     mov       count, eax

     mov       edx, OFFSET userGreet
     call WriteString
     mov       edx, OFFSET userName
     call WriteString
     call crlf

userInstructions:

     mov       edx, OFFSET firstFibPrompt
     call WriteString
     call crlf

     mov       edx, OFFSET secondFibPrompt
     call WriteString
     call crlf

getData:

     call ReadInt
     mov       userNum, eax

     ;Compare the number to the constants. Jump to userError section if it's out of range
     cmp       eax, LOWER
     jl        userError
     cmp       eax, UPPER
     jg        userError
     jmp       displayFibs

userError:          ;This is where the loop jumps to if the user enters a number that isn't in bounds
     
     mov       edx, OFFSET errorMessage
     call WriteString
     call crlf
     jmp       userInstructions

displayFibs:

     mov       edx, OFFSET ecMEssage
     call WriteString
     call crlf     

     mov     ebx, 1            ;setup for the loop
     mov     edx, 0
     mov     ecx, userNum      ;move the userNum to use the loop

loopChecker:
     mov        eax, ebx        
     add        eax, edx       ;adds the fib numbers
     mov        ebx, edx
     mov        edx, eax
     call  WriteDec        
     mov        al,  TAB        ;sets up a tab character used for alignment
     call       WriteChar       ;actually displays the tab
     loop       loopChecker     ;This continuously subtracts 1 from userNum until it hits 0. Then it exits the loop
     call  crlf
     jmp        farewell  
   



farewell:                     ;The section that the program goes to when the loop finishes

     mov       edx, OFFSET byeMessage
     call WriteString
     call Crlf

     invoke ExitProcess,0
     main endp
end main

