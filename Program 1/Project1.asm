TITLE Program 1  

; Author: Tyler Cope
; Course / Project ID: CS271/Program 1
; Date: 1/18/2017
; Description: This program takes two integers from a user and
;displays their sum, difference, quotient, product, and remainder.
;It also verifies the second number is smaller than the first.

INCLUDE Irvine32.inc

.data

;Variables used to display messages
myName      BYTE      "Tyler Cope   ",0
myTitle     BYTE      "CS271 Program 1",0
instructions1    BYTE    "Enter two numbers and you'll see", 0
instructions2    BYTE    "their sum, difference, product, quotient, and remainder.", 0
prompt1        BYTE      "First number: ",0 
prompt2        BYTE      "Second number: ",0 
sayBye         BYTE      "That's all. Bye!",0
sumResult      BYTE      "Their sum is ",0
diffResult     BYTE      "Their difference is ",0
proResult      BYTE      "Their product is ",0
quoResult      BYTE      "Their quotient is ",0
remainResult   BYTE      "Their remainder is ",0
ecmessage      BYTE      "EC: Program verifies second number less than first.",0
ecmessage1     BYTE      "The second number must be smaller!",0

;Variables to hold all the values
firstNum       DWORD     ?
secondNum      DWORD     ?
sum            DWORD     ?
difference     DWORD     ?
product        DWORD     ?
quotient       DWORD     ?
remainder      DWORD     ?


.code
main PROC

;Introduction and instructions:

;Display my name and program name
     mov       edx, OFFSET myName ;set up for call to WriteString (comment taken from demo program on course site)
     call      WriteString
     mov       edx, OFFSET myTitle
     call      WriteString
     call      Crlf


;Display instructions line 1 
     mov       edx,OFFSET instructions1 
     call      WriteString
     call      Crlf

;Display instructions line 2
     mov       edx, OFFSET instructions2
     call      WriteString
     call      Crlf
     call      Crlf

;Display extra credit message
     mov       edx, OFFSET ecmessage
     call      WriteString
     call      Crlf

;Get the data:
Instructions:

;get first integer
     mov       edx, OFFSET prompt1
     call      WriteString
     call      ReadInt        ;needed to get the integer from user
     mov       firstNum, eax

;get second integer
     mov       edx, OFFSET prompt2
     call      WriteString
     call      ReadInt
     mov       secondNum, eax

;compare the two values using cmp and jump to verify if second is larger than first
     mov       eax, secondNum
     cmp       eax, firstNum
     jg        Verify
     jle       Calculations

Verify:
     mov       edx, OFFSET ecmessage1
     call      WriteString
     call      Crlf
     call      Crlf
     

;Calculate results
Calculations:
     ;Results for sum. Moves firstNum to eax, adds secondNum, and stores the result in eax
     mov       eax, firstNum
     add       eax, secondNum
     mov       sum, eax

     ;Results for difference
     mov       eax, firstNum
     sub       eax, secondNum
     mov       difference, eax

     ;Results for product. Need two different registers
     mov       eax, firstNum
     mov       ebx, secondNum
     mul       ebx
     mov       product, eax

     ;Results for quotient and remainder. Remainder is stored in edx so it's moved to "remainder""
     mov       edx, 0
	mov       eax, firstNum	
	mov       ebx, secondNum	
	div       ebx
	mov       quotient, eax
	mov       remainder, edx


;Display results and say bye:
     mov       edx, OFFSET sumResult
     call      WriteString
     mov       eax, sum
     call      WriteDec
     call      Crlf

     mov       edx, OFFSET diffResult
     call      WriteString
     mov       eax, difference
     call      WriteDec
     call      Crlf

     mov       edx, OFFSET proResult
     call      WriteString
     mov       eax, product
     call      WriteDec
     call      Crlf

     mov       edx, OFFSET quoResult
     call      WriteString
     mov       eax, quotient
     call      WriteDec
     call      Crlf

     mov       edx, OFFSET remainResult
     call      WriteString
     mov       eax, remainder
     call      WriteDec
     call      Crlf

     mov       edx, OFFSET sayBye
     call      WriteString
     call      Crlf

	exit	
main ENDP


END main
