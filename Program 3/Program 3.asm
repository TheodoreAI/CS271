TITLE Program 3  

; Author: Tyler Cope
; Course / Project ID: CS271/Program 3
; Date: 2/10/2017
; Description: This program asks users their name, greets them,
; then asks them to enter negative numbers between -100 and -1.
; If they write a number that's out of bounds,
; the program jumps to display the sum and the average of the numbers
; or a special message if they entered no negative numbers.



INCLUDE Irvine32.inc
.data
nameTitle           BYTE      "Programmed by Tyler Cope",0
programTitle        BYTE      "Integer Accumulator",0
userQuestion        BYTE      "Please input your name: ",0
userGreet           BYTE      "Hello, ",0
userName            BYTE      30 DUP(0)
userNum             DWORD     ?
counter             DWORD     ?
numCount            DWORD     ?
total               DWORD     0
average             DWORD     0
firstNumPrompt      BYTE      "Please enter negative numbers between -100 and -1",0
secondNumPrompt     BYTE      "Enter a non-negative number when you are finished to see the results.",0
thirdNumPrompt      BYTE      "Enter a number: ",0
numsEntered1        BYTE      "You entered ",0
numsEntered2        BYTE      " valid numbers.",0
sumMessage          BYTE      "The sum of the valid numbers you entered is: ",0
avgMessage          BYTE      "The average of the valid numbers you entered is: ",0
noNegNumbers        BYTE      "You did not enter any negative numbers.",0
byeMessage          BYTE      "Nice to meet you. Bye, ",0


;Constants to compare the user input
UPPER = -1
LOWER = -100


.code

main      PROC
introduction:
     mov       edx,OFFSET programTitle
     call WriteString
     call crlf

     mov       edx,OFFSET nameTitle
     call WriteString
     call crlf

     mov       edx,OFFSET userQuestion
     call WriteString
     call crlf

     mov       edx,OFFSET userName
     mov       ecx,SIZEOF userName     
     call ReadString
     mov       counter, eax

     mov       edx,OFFSET userGreet
     call WriteString
     mov       edx,OFFSET userName
     call WriteString
     call crlf

userInstructions:

     mov       edx,OFFSET firstNumPrompt
     call WriteString
     call crlf

     mov       edx,OFFSET secondNumPrompt
     call WriteString
     call crlf

getData:
     mov       eax,numCount
     add       eax,1               ;keeps track of the numbers entered. If no vaild numbers, will subtract 1 from it and check if the zero flag was set
     mov       numCount,eax
     mov       edx,OFFSET thirdNumPrompt
     call WriteString
     call ReadInt
     mov       userNum,eax

     ;compare that number with the constants
     cmp       eax,UPPER
     jg        numAddition
     cmp       eax,LOWER
     jl        numAddition
     add       eax,total
     mov       total,eax
     loop      getData        ;keeps going until they enter a number that is out of bounds


numAddition:
     mov       eax,numCount
     sub       eax,1
     jz        farewell1           ;jumps to display the special message if no negative numbers are entered
     mov       eax,total

     mov       edx,OFFSET numsEntered1
     call WriteString
     mov       eax,numCount
     sub       eax,1
     call WriteDec
     mov       edx,OFFSET numsEntered2
     call WriteString
     call crlf

     mov       edx,OFFSET sumMessage
     call WriteString
     mov       eax,total
     call WriteInt
     call crlf

     mov       edx,OFFSET avgMessage
     call WriteString
     mov       eax,0
     mov       eax,total
     cdq
     mov       ebx,numCount
     sub       ebx,1
     idiv      ebx            ;Doing integer division
     mov       average,eax
     call WriteInt
     call crlf
     jmp farewell2


farewell1:
     mov       edx,OFFSET noNegNumbers
     call WriteString
     call crlf

farewell2:
     mov       edx,OFFSET byeMessage
     call WriteString
     mov       edx,OFFSET userName
     call WriteString
     call crlf

exit
main      ENDP
End       main