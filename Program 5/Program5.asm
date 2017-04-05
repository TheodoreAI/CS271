TITLE Program 5

; Author: Tyler Cope
; Course / Project ID: CS271/Program 5
; Date: 3/3/2017
; Description: This program asks users how many random numbers they want to
; see between 10-200. It generates a list of random numbers, displays it,
; sorts it, displays the median, then displays the sorted list. Parameters
; for the functions are passed on the stack.


INCLUDE Irvine32.inc
.data
;Constants to compare user input
MIN = 10
MAX = 200
LO = 100
HI = 999


nameTitle           BYTE      "Programmed by Tyler Cope",0
programTitle        BYTE      "Sorting Random Integers.     ",0
firstNumPrompt      BYTE      "Please enter the amount of random numbers you want to see between 10-200.",0
secondNumPrompt     BYTE      "Enter a number: ",0
programDescript1    BYTE      "This program generates random numbers between 100-999,",0
programDescript2    BYTE      "displays the original list, calculates the median, then",0
programDescript3    BYTE      "sorts and displays the list.",0
firstDisplay        BYTE      "The unsorted list is:",0
secondDisplay       BYTE      "The sorted list is:",0
errorMessage        BYTE      "That number is out of range. Try again.",0
medianMessage       BYTE      "The median is: ",0
userNum             DWORD     ?
userArray           DWORD     MAX DUP(?)


.code
main PROC
     call Randomize                ;Irvine32 procedure for generating random numbers
     call introduction

     push      OFFSET userNum      ;From lecture example, we're passing the number the user enters by reference as a parameter to get the data
     call getData

     push      OFFSET userArray    ;Assignment specifications say that fillArray must pass the array as reference
     push      userNum             ;fillArray needs the actual value the user passed so we know how many times we need to loop
     call fillArray                ;Now we're ready to fill the array because we passed the right parameters by pushing them onto the system stack

     mov       edx,OFFSET firstDisplay
     call WriteString
     call crlf
     push      OFFSET userArray
     push      userNum
     call displayList

     push      OFFSET userArray
     push      userNum
     call sortList
     call crlf

     push      OFFSET userArray
     push      userNum
     call displayMedian

     mov       edx,OFFSET secondDisplay
     call WriteString
     call crlf
     push      OFFSET userArray
     push      userNum
     call displayList

exit
main      ENDP

introduction PROC
     mov       edx,OFFSET programTitle
     call WriteString
     
     mov       edx,OFFSET nameTitle
     call WriteString
     call crlf

     mov       edx,OFFSET programDescript1
     call WriteString
     call crlf

     mov       edx,OFFSET programDescript2
     call WriteString
     call crlf

     mov       edx,OFFSET programDescript3
     call WriteString
     call crlf
     call crlf
ret

introduction        ENDP

getData PROC
     push      ebp            ;Set up stack frame (from lecture)
     mov       ebp,esp
     mov       ebx,[ebp + 8]  ;Allows us to get the address of the userNum into ebx so we can store it

     mov       edx,OFFSET firstNumPrompt
     call WriteString
     call crlf

     numPrompt:
          mov       edx,OFFSET secondNumPrompt
          call WriteString
          call crlf
          call ReadInt
          mov       [ebx],eax      ;Since we set up the parameters properly, we can now save the user's number
          cmp       eax,MAX
          jg        error
          cmp       eax,MIN
          jl        error
          jmp       finish

     error:
          mov       edx,OFFSET errorMessage
          call WriteString
          call crlf
          jmp numPrompt

     finish:
          pop       ebp             ;From lecture

     ret 4                         ;We only pushed one DWORD onto the stack so just need to ret 4 to reset the stack
getData        ENDP


fillArray PROC                     ;Fills array with random integers
     push      ebp
     mov       ebp,esp             ;Again, we're setting up the stack frame
     mov       edi,[ebp + 12]      ;This is how we're getting to the array to fill. From lecture, edi is the standard register to use for "destination"
     mov       ecx,[ebp + 8]       ;Allows us to get the number the user entered into ecx so we can use it as a loop

     arrayLoop:
          mov       eax,HI              ;This allows us to get the proper range of integers to fill the array
          sub       eax,LO
          inc       eax
          call RandomRange
          add       eax,LO              ;This ensures that the number will be in the proper range
          mov       [edi],eax           ;Store the number in the arary
          add       edi,4               ;Get the next slot in the array
          dec       ecx
          cmp       ecx,0
          je        ending
          jmp       arrayLoop

     ending:
          call crlf

          pop ebp
 ret 8
fillArray      ENDP

displayList PROC
     push      ebp
     mov       ebp,esp                  ;Setup as usual
     mov       ebx,0                    ;Using this register to keep track of the numbers entered per line
     mov       edi,[ebp + 12]           ;Get to the list just like last time
     mov       ecx,[ebp + 8]            ;Again using the user's entered number to loop appropriately

     numWrite:
          mov       eax,[edi]           ;This will get the firt number into eax to display
          call WriteDec
          mov       al,TAB              ;Inserting a tab character to align the numbers
          call WriteChar
          dec       ecx                 ;If the loop gets to zero we just go to the end of the procedure
          cmp       ecx,0
          je        ending
          inc       ebx                 ;Add 1 to ebx and compare it to 10. If it's equal we'll jump to add a new line
          cmp       ebx,10
          je        lineInsert
          add       edi,4               ;This gets us to the next number in the list
          jmp       numWrite
          

     lineInsert:
          call crlf
          add       edi,4
          mov       ebx,0               ;Reset the line counter
          jmp      numWrite

     ending:
          call crlf
          call crlf
          
     pop       ebp
ret 8
displayList         ENDP

sortList PROC
	push      ebp                      ;Same as the other procedures. Set up stack frame and move the parameters into registers
	mov       ebp,esp
	mov       edi,[ebp + 12]	     	
	mov	     ecx,[ebp + 8]				
	dec	     ecx                      ;We don't need to test the last number because it will already be sorted
    
	setUp:
		mov		eax,[edi]			;We need access to the elements, so each time we get to a new number, we set it up here
		mov		edx,edi
		push	     ecx				;We pushed the user number to loop and this allows us to continue using it; we reset this each time we
                                        ;get to a new number so we can compare it with every number in the array
        
	swapNums:
			mov		ebx,[edi+4]     ;Get the next number
			mov		eax,[edx]       ;Compare the two numbers and switch them if they are not in the proper order. Go to next number if they are
			cmp		eax,ebx
			jge		continue        ;It's in descending order, so if the number is greater than or equal, no swtiching necessary
			add		edi, 4
			push	     edi            ;We need to setup the call to the helper function so we push these registers before calling it
			push	     edx
			push	     ecx
			call	helpSort            ;Helper function to switch numbers
			sub		edi, 4
            
    continue:
		add		edi,4
		loop	swapNums
			
		pop		ecx                 ;Once the loop ends we need to restore the loop count for the next number 			
		mov		edi,edx            ;We also need to clear esi 
		add		edi,4			;Next number to compare with the rest of the numbers in the array
		loop	setUp                    ;Loop back to the setup to get the next number in the register to compare with the other numbers
        
	
		pop		ebp
        
ret		8
sortList ENDP

helpSort PROC                      ;A helper function called by the sort function to swap the positions of two numbers
	push      ebp
	mov       ebp, esp
	pushad                        ;Lets us use all the registers

	mov		eax,[ebp + 16]	     ;This is a helper function that will be called to sort. So to access the two numbers,
	mov		ebx,[ebp + 12]	     ;we need to manipulate the ebp and store them into registers
	mov		edx,eax
	sub		edx,ebx			;Now we can get the difference into edx

	
	mov		esi,ebx            ;Put the second number into the esi so we can switch the two numbers
	mov		ecx,[ebx]          ;Move the contents of memory at @ebx into ecx
	mov		eax,[eax]          ;We pass these by reference so we can actually switch their location  
	mov		[esi],eax          ;Need to put the value at eax back into the array
	add		esi,edx            ;Fix the subtraction we did
	mov		[esi],ecx          ;Put next value back into array

	popad                        ;restore registers
	pop		ebp                         

ret		12
helpSort     ENDP


displayMedian PROC            ;Procedure that displays the median
	push    ebp
	mov     ebp,esp
	mov     edi,[ebp + 12]  
	mov     ebx,2            ;Set up edx for division
	xor     edx,edx
     mov     eax,[ebp + 8]    ;Move the user number into the eax register so we can divide by 2 to check the array's parity
	div     ebx              ;The remainder stored in edx will tell the program if there is an even or odd number of elements in array
	mov     ecx,eax          ;Now we move the number into ecx so we can use it as a loop. We can use this number to get access the middle of the array

     findMiddle:
          add       edi,4               ;Access next number in array
          loop      findMiddle          ;We want to continue the procedure once we get to the middle of the array

     checkRemainder:
          cmp       edx,0
          je        evenNumberMedian
          jmp       oddNumberMedian

     evenNumberMedian:
          mov       eax,[edi - 4]           ;The array's partiy is even so we add to add the middle two numbers and divide by 2 for the median  
          add       eax,[edi]
          mov       ebx,2
          xor       edx,edx          
          div       ebx
          mov       edx,OFFSET medianMessage
          call WriteString
          call WriteDec                 ;Display the median
          jmp       ending

     oddNumberMedian:                   ;Odd parity so we just need to write the number
          mov       eax,[edi]
          mov       edx,OFFSET medianMessage
          call WriteString
          call WriteDec
          jmp       ending

     ending:
          call crlf

     pop       ebp
 
 ret 8    
displayMedian       ENDP

End       main