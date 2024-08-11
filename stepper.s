;******************** (C) Yifeng ZHU *******************************************
; @file    main.s
; @author  Yifeng Zhu
; @date    May-17-2015
; @note
;           This code is for the book "Embedded Systems with ARM Cortex-M 
;           Microcontrollers in Assembly Language and C, Yifeng Zhu, 
;           ISBN-13: 978-0982692639, ISBN-10: 0982692633
; @attension
;           This code is provided for education purpose. The author shall not be 
;           held liable for any direct, indirect or consequential damages, for any 
;           reason whatever. More information can be found from book website: 
;           http:;www.eece.maine.edu/~zhu/book
;*******************************************************************************


	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s      

	IMPORT 	System_Clock_Init

	
	AREA    stepper, CODE, READONLY
	EXPORT	step1				; make __main visible to linker
	ENTRY			
				
step1	PROC
	;	Enable clocks for GPIOC, GPIOB//;	Enable clocks for GPIOA, GPIOB
		
	; Set GPIOC pin 13 (blue button) as an input pin//; Set GPIOA pin 0 (center joystick button) as an input pin
	
	; Set GPIOB pins 2, 3, 6, 7 as output pins
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;; YOUR CODE GOES HERE ;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	; Pushing the value of the LR, r8, r9 in the stack
	PUSH{LR}
	PUSH{r8,r9}
	
	; Clearing the contents of r3
	AND r3, 0x0
	
	; The argument that is being passed into the function is automatically passed into r0
	; Moving the value being passed into the function into r3
	MOV r3, r0
	
	

	
	LDR   r0, =GPIOB_BASE ; Configuring the MODER resgisters in GPIOC for OUTPUTS
	LDR   r1, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r1
	BIC   r1, r1, #0x000000F0 ; Masking the registers that we are interested in
	BIC   r1, r1, #0x0000000F ; Masking the registers that we are interested in
	ORR   r1, r1, #0x00000050 ; Masking the registers that we are interested in
	ORR   r1, r1, #0x00000005 ; Masking the registers that we are interested in
	STR   r1, [r0, #GPIO_MODER] ; Storing the value of the MODER to r1
	
	  ; Comparing the value being passed into the function to 1
	  CMP r3, #1
	  ; If not 1, then branch to jump function that reverses the stepper motor direction
	  BNE jump
	  
	  ; Moving the value needed to open and close the doors in out elevator model
      MOV r8, #263
	  
delayloop2
    
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  BIC r1, #0x0000000F ; Masking the registers that we are interested in
	  ORR r1, #0x00000008 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  BIC r1, #0x0000000F ; Masking the registers that we are interested in
	  ORR r1, #0x00000004 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  BIC r1, #0x0000000F ; Masking the registers that we are interested in
	  ORR r1, #0x00000002 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  BIC r1, #0x0000000F ; Masking the registers that we are interested in
	  ORR r1, #0x00000001 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  SUBS r8, #1	; Subtracting the value of r8 by 1 each iteration
      BNE delayloop2	; Repeating the subroutine until r8 = 0
		  
	  B endd;
jump	  

	  ; Moving the value needed to open and close the doors in out elevator model
      MOV r8, #263
counter
      
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  BIC r1, #0x0000000F ; Masking the registers that we are interested in
	  ORR r1, #0x00000001 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  BIC r1, #0x0000000F ; Masking the registers that we are interested in
	  ORR r1, #0x00000002 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  BIC r1, #0x0000000F ; Masking the registers that we are interested in
	  ORR r1, #0x00000004 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	  LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	  BIC r1, #0x0000000F ; Masking the registers that we are interested in
	  ORR r1, #0x00000008 ; Setting the desired bits
	  STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	  
	  PUSH{LR}	; Pushing the value of the Linked Register to the stack
	  BL delay	; Adding a delay to the output
	  POP{LR}	; Popping the top value of the stack and assigning it to the Linked Register
	  
	  SUBS r8, #1	; Subtracting the value of r8 by 1 each iteration
      BNE counter	; Repeating the subroutine until r8 = 0
    
	
endd      
    ; Popping the value of r8, r9, and the LR from the stack
	POP{r8,r9}
	POP{LR}
	
	; Branching back to the main function
	BX LR
	  ENDP	; Ending the process
		  
; delay subroutine (no args)
delay PROC
      ; Delay for software debouncing
      LDR r9, =5000
delayloop
      SUBS r9, #1	; Subtracting the value of r9 by 1 each iteration
      BNE delayloop	; Repeating the subroutine until r9 = 0
      BX LR	; Branching to the address in the Linked Register
      ENDP	; Ending the process
		
	ENDP	; Ending the process		
		
	
	ALIGN			

	AREA myData, DATA, READWRITE
	ALIGN
; Replace ECE1770 with your last name
str DCB "ECE1770",0
	END