TITLE Program 6A

; Author: Tyler Cope
; Course / Project ID: CS271/Program 6A
; Date: 3/17/2017
; Description: This program gets 10 integers from the user as strings,
; converts them to integers, and displays them as well as their sum
; and average. It uses macros to do this.

INCLUDE Irvine32.inc

.data
;Constants to compare user input
MAX = 10
LO = 30h       ;Since we're converting to ASCII later on, 0 starts at 30h and goes to 9 at 39h on the ASCII chart
HI = 39h       ;The users are entering digits so this is how we'll check for input validation



nameTitle           BYTE      "Programmed by Tyler Cope",0
programTitle        BYTE      "Designing low-level I/O procedures.     ",0
firstNumPrompt      BYTE      "Enter an unsigned number: ",0
errorMessage        BYTE      "Number out of range or not unsigned",0
programDescript1    BYTE      "This program reads integers from the user,",0
programDescript2    BYTE      "displays them, and shows their sum and average.",0
sumMessage          BYTE      "The sum is: ",0
averageMessage      BYTE      "The average is: ",0
numsEntered         BYTE      "You entered the following numbers: ",0
byeMessage          BYTE      "Goodbye!",0
loopNum             DWORD     10 DUP(0)
userArray           DWORD     MAX DUP(0)
userNum             DWORD     ?
bufferResult        DB        16 DUP(0)           ;This will be used to convert the strings

getString MACRO	numPrompt, loopNum, userNum	
	push	eax
	push	ecx
	push	edx	

	mov		edx,OFFSET firstNumPrompt
	call	WriteString

	mov		edx,OFFSET loopNum       ;This is taken from lecture except we don't subtract 1 from SIZEOF since we don't need to make
	mov		ecx,SIZEOF loopNum       ;Room for the 0 byte at the end of a string
	call	ReadString                    ;Get input from user keyboard

	mov		userNum,00000000         ;Clear for each number
	mov		userNum,eax	          ;Move the value from register into userNum

	pop		eax
	pop		ecx
	pop		edx

ENDM

displayString MACRO bufferResult

	push	     edx
	mov		edx,bufferResult
	call	WriteString
	pop		edx

ENDM

shortHand MACRO buffer             ;Macro from lecture to quickly write strings when we need them
     push      edx
     mov       edx,OFFSET buffer
     call WriteString
     pop       edx

ENDM


.code
main PROC
     shortHand programTitle             ;Making use of the macro we created to quickly write strings
     shortHand nameTitle
     call crlf

     shortHand programDescript1
     call crlf
     shortHand programDescript2
     call crlf
     
     push      OFFSET userArray         ;Push parameters to procedure. Similar to former programs
     push      OFFSET loopNum
     push      OFFSET userNum
     call readVal

     shortHand numsEntered
     call crlf
     push      OFFSET bufferResult
     push      OFFSET userArray
     call writeVal
     call crlf

     push      OFFSET sumMessage
     push      OFFSET averageMessage
     push      OFFSET userArray
     call mathDisplay
     call crlf

     shortHand byeMessage
     call crlf    
     
exit
main        ENDP

readVal PROC
     push      ebp                 ;normal setup
	mov	     ebp,esp
	mov	     ecx,10			;set up counter					
	mov	     edi,[ebp + 16]		;access the array

	setUp: 					
          getString firstNumPrompt, loopNum, userNum    ;now we make a call to our macro 

		push      ecx
		mov		esi,[ebp + 12]			
		mov		ecx,[ebp + 8]			
		mov		ecx,[ecx]				
		cld							;Clear directional flag to move forward	
		xor		eax,eax			     ;Clear the registers so we can store things in them
		xor		ebx,ebx		
					
		converter:
		     lodsb				     ;Must use this per assignment specifications. Loads the number entered by each byte
			cmp		eax,HI			;Required input validation (reference comments in .data section for comments about LO and HI)
			jg		error		
			cmp		eax,LO			
			jl		error	
							
			sub		eax,LO			
			push      eax                 ;Push register for use
			mov		eax,ebx
			mov		ebx,MAX             ;Make use of ebx that we setup to accumulate
			mul		ebx
			mov		ebx,eax
			pop		eax                 ;Fix where we pushed
			add		ebx,eax             
			mov		eax,ebx
			xor		eax,eax             ;Clear register
			loop	     converter           ;Loop until it drops

     mov       eax,ebx 
	stosd							
	add		esi,4	                    ;Go to next place				
	pop		ecx						;Fix push ecx
	loop      setUp                         ;Start over for new entry
	jmp		finish
		
	error:                                  ;Displays error if user enters something incorrect
          pop		ecx
          mov		edx,OFFSET  errorMessage
          call	WriteString
          call	crlf
          jmp		setUp

	finish:
          call crlf

	pop ebp	
          		
	ret 12		     ;Clean up stack. Passed three parameters that were DWORDS																	
readVal        ENDP

writeVal PROC
     push      ebp                 ;Same setup and access to array like before
     mov       ebp,esp
     mov       edi,[ebp + 8]       
     mov       ecx,10              

     display:
          push      ecx
          mov       eax,[edi]
          mov       ecx,10
          xor       bx,bx               ;Clear register so we can use it to see each individual digit

          checkDigits:
               xor       edx,edx        ;Needed for division
               div       ecx            ;Already loaded 10 into ecx
               push      dx             
               inc       bx             ;See how many digits user entered
               test      eax,eax        ;If the result of the division was 0, we know it's safe to convert
               jz        next
               jmp       checkDigits    ;Otherwise we keep going and storing each digit
          
          next:
               mov       cx,bx               ;We've kept track of the digits and now we can use this information
               lea       esi,bufferResult    ;Store calculated memory result
         
         continue:                           ;Now we convert each digit to ASCII and move it into each spot at the current place in the array
               pop       ax                  ;It will keep going until all digits are converted and placed (since we kept track of the number of digits)
               add       ax,'0'
               mov       [esi],ax
               
               displayString OFFSET bufferResult
               loop continue
               
     pop       ecx            ;Fix so we can use it to loop again
     mov       al,TAB         ;Align the numbers
     call WriteChar
     xor       ebx,ebx        ;Clear the registers to use again  
     xor       edx,edx
     add       edi,4          ;Next place in array
     loop      display
     
     pop ebp

     ret 12
writeVal       ENDP

mathDisplay PROC
     push      ebp                 ;Set-up like normal
	mov       ebp,esp
	mov       edi,[ebp + 8]       ;Get access to the array
	mov	     eax,10		     ;We know there are 10 numbers		
	mov       edx,0               ;Clear registers and setup loop counter (ecx)
	mov	     ebx,0
	mov	     ecx,eax             

	getSum:
		mov       eax,[edi]      ;Get the current number we are at in the array
		add		ebx,eax        ;Add that number to ebx to keep a running total
          add		edi,4          ;Advance to the next number in the array
          dec       ecx
          cmp       ecx,0          ;We'll move on once this executes 10 times
          je        writeSum
          jmp       getSum

	writeSum:
	     mov       edx,0
	     mov		eax,ebx
	     mov		edx,[ebp + 16]      ;Get the string parameter
	     call	WriteString
	     call	WriteDec                 ;Write the sum
	     call	crlf

     getAverage:
	     xor       edx,edx             ;set up register for division
	     mov		ebx,10              ;Divide by 10 to get the average
	     div		ebx
	     mov		edx,[ebp + 12]      ;Get the string parameter
	     call	WriteString
	     call	WriteDec                 ;Write the average
	     call	crlf

	pop		ebp

	ret		12
mathDisplay         ENDP

End     main