TITLE Program 4  

; Author: Tyler Cope
; Course / Project ID: CS271/Program 4
; Date: 2/14/2017
; Description: This program asks users to enter the number of
; composite numbers they would like to see between 1 and 400. 
; If they write a number that's out of bounds,
; the program loops until they write a number in range.
; The program then displays a parting message.

INCLUDE Irvine32.inc
.data
nameTitle           BYTE      "Programmed by Tyler Cope",0
programTitle        BYTE      "Composite Numbers",0
userNum             DWORD     ?
counter             DWORD     4                   ;We start this at 4 because the first three numbers are prime
numCount            DWORD     ?
lineCount           DWORD     0
firstNumPrompt      BYTE      "Please enter the number of composite numbers you would like to see between 1-400",0
secondNumPrompt     BYTE      "Enter a number: ",0
errorMessage        BYTE      "That number is out of range. Try again.",0
byeMessage          BYTE      "Results certified by Tyler. Goodbye.",0
ecmessage           BYTE      "The numbers are aligned!",0


;Constants to compare the user input
UPPER = 400
LOWER = 1

.code
 main PROC

 call introduction
 call getUserData
 call showComposites
 call farewell


 exit
main      ENDP

introduction PROC                            ;Introduction to display name and program title
     mov       edx,OFFSET programTitle
     call WriteString
     call crlf

     mov       edx,OFFSET nameTitle
     call WriteString
     call crlf

     mov       edx,OFFSET firstNumPrompt     ;Displays directions
     call WriteString
     call crlf
     ret

introduction        ENDP

getUserData PROC
     numPrompt:                                   ;Prompts user to enter the number of composites they want to see
          mov       edx,OFFSET secondNumPrompt
          call WriteString
          call crlf
     
          call ReadInt                            ;Saves that number
          mov       userNum,eax
          call validate                           ;calls validate to make sure the number is between 1-400


          ret
getUserData        ENDP


validate PROC                                     ;Prompts the user to enter a number if it is out of range
     cmp       eax,UPPER
     jg        error
     cmp       eax,LOWER
     jl        error
     call crlf
     ret

error:
     mov       edx,OFFSET errorMessage
     call WriteString
     call crlf
     call getUserData
     ret

validate       ENDP

showComposites PROC
     mov       edx,OFFSET ecMessage               ;Extra credit message
     call WriteString
     call crlf
     call crlf
     call isComposite                             ;Calls procedure to check composite numbers

   
    ret
showComposites      ENDP

isComposite PROC
     mov       ecx,userNum                        ;The number of times we want to loop
     mov       esi,lineCount                      ;Keeps track of numbers on a line and moves to new line once it gets to 10

     testLoop:
          cmp       counter,5                          ;Two special cases 5 and 7. Both are prime but they are divisible by themselves
          je        noWrite                            ;Therefore we just skip them and don't check against any divisors
          cmp       counter,7
          je        noWrite

          mov       ebx,2                              ;If the number is divisible by any of the following divisors, excluding
          xor       edx,edx                            ;5 and 7, it is composite and we want to print it
          mov       eax,counter
          div       ebx     
          cmp       edx,0                              ;If there is no remainder then it is composite, jump to write the number
          je        zeroWrite

          mov       ebx,3
          xor       edx,edx                            ;Clears edx to use for division
          mov       eax,counter
          div       ebx     
          cmp       edx,0
          je        zeroWrite

          mov       ebx,4
          xor       edx,edx
          mov       eax,counter
          div       ebx     
          cmp       edx,0
          je        zeroWrite

          mov       ebx,5
          xor       edx,edx
          mov       eax,counter
          div       ebx     
          cmp       edx,0
          je        zeroWrite

          mov       ebx,6
          xor       edx,edx
          mov       eax,counter
          div       ebx     
          cmp       edx,0
          je        zeroWrite

          mov       ebx,7
          xor       edx,edx
          mov       eax,counter
          div       ebx     
          cmp       edx,0
          je        zeroWrite

          mov       ebx,8
          xor       edx,edx
          mov       eax,counter
          div       ebx     
          cmp       edx,0
          je        zeroWrite

          mov       ebx,9
          xor       edx,edx
          mov       eax,counter
          div       ebx     
          cmp       edx,0
          je        zeroWrite
     
          jmp       noWrite                                 ;If we get here then the number is prime and we don't want to print it

          zeroWrite:
               mov       eax,counter
               call WriteDec
               mov       al,TAB                             ;This sets up a tab character to align the output columns
               call WriteChar
               dec       ecx
               cmp       ecx,0                              ;If the loop gets to zero we just go to the end of the procedure
               je        ending
               inc       esi
               cmp       esi,10                             ;Once the counter gets to 10 it jumps to logic to insert a space and increment the counter
               je        lineInsert
               inc       counter
               jmp       testLoop
          

          noWrite:  
               inc       counter                            ;Don't write the number, just loop instead
               jmp       testLoop

          lineInsert:
               inc       counter                            ;Get extra numbers on a new line
               call crlf
               jmp       testLoop

          ending:
               call crlf
               call crlf
ret
isComposite    ENDP

farewell PROC
     mov       edx,OFFSET byeMessage                   ;Message to say goodbye to the user
     call WriteString
     call crlf

ret
farewell       ENDP


End       main