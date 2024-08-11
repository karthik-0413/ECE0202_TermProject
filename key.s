;******************** (C) Yifeng ZHU *******************************************
; @file    main.s
; @author  Yifeng Zhu
; @date    May-17-2015
; @note
;           This code is for the book "Embedded Systems with ARM Cortex-M
;           Microcontrollers in Assembly Language and C, Yifeng Zhu,
;           ISBN-13: 978-0982692639, ISBN-10: 0982692633
; @attention
;           This code is provided for education purpose. The author shall not be
;           held liable for any direct, indirect or consequential damages, for any
;           reason whatever. More information can be found from book website:
;           http:;www.eece.maine.edu/~zhu/book
;*******************************************************************************


      INCLUDE core_cm4_constants.s
      INCLUDE stm32l476xx_constants.s      

      IMPORT      System_Clock_Init

      AREA    key, CODE, READONLY
      EXPORT      keypadd
      ENTRY            
                       
keypadd      PROC

;;;;;;;;;;;; YOUR CODE GOES HERE    ;;;;;;;;;;;;;;;;;;;

	; Pushing the values of r5 and r7 into the stack to preserve their values
	PUSH{r5,r7}

      LDR   r0, =GPIOA_BASE ; Configuring the MODER resgisters in GPIOB for INPUTS
      LDR   r1, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r1
      BIC   r1, #0x00FF0000 ; Moving the desired value into r2
      ORR   r1, #0x00000000  ; Clearing all values and storing it in r1
      STR   r1, [r0, #GPIO_MODER] ; Storing the value of the MODER to r1
     

      LDR   r0, =GPIOC_BASE ; Configuring the MODER resgisters in GPIOC for OUTPUTS
      LDR   r1, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r1
      BIC   r1, r1, #0x0000FF00 ; Masking the registers that we are interested in
      ORR   r1, r1, #0x00005500 ; Masking the registers that we are interested in
      STR   r1, [r0, #GPIO_MODER] ; Storing the value of the MODER to r1


; subrountine that goes through the input values and sees which ODR is pulled down
		ORR r3, #0x50	; Allows the user to press a keypad number inside of the elevator (If not done in a couple of seconds, then the doors close and the keypad cannot be pressed)
machi_cout    
      LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
      LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
      BIC r1, r1, #0x000000F0 ; Masking the registers that we are interested in
      STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1

	  PUSH{LR}
      BL delay  ; Branching to delay function as per the flowchart
      POP {LR}

      LDR r0, =GPIOA_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
      LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
      BIC r2, #0x0000000F ; Masking the registers that we are interested in
      BIC r2, #0x0000F000 ; Masking the registers that we are interested in
	  BIC r2, #0x000000F0 ; Masking the registers that we are interested in
	  SUBS r3, r3, #1	; Making delay 
	  BNE goodbye	; If the counter is not 0, then checking for button press
	  MOV r0, #0	; Returning 0, then no button has been pressed
	  POP{r5,r7} ; Popping values of r5 and r7 from stack
	  BX LR	; Returns to main program
goodbye	  
      CMP r2, #0x00000F00 ; Comparing the value if nothing is pressed
      BEQ machi_cout ; If equal, then go to subrountine that pulls row 1 down
        
      LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
      LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
      BIC r1, #0x000000F0 ; Masking the registers that we are interested in
      ORR r1, #0x000000E0 ; Setting the first bit to 0 to pull first row low
      STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
        
     
      PUSH{LR}
      BL delay  ; Branching to delay function as per the flowchart
      POP {LR}
     

      LDR r0, =GPIOA_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
      LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
      BIC r2, #0x0000000F ; Masking the registers that we are interested in
      BIC r2, #0x0000F000 ; Masking the registers that we are interested in
	  BIC r2, #0x000000F0 ; Masking the registers that we are interested in
      CMP r2, #0x00000F00 ; Comparing the value if nothing is pressed
      BNE mapillai ; If not equal, then branch back to top of this loop
        
      LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
      LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
      BIC r1, #0x000000F0 ; Masking the registers that we are interested in
      ORR r1, #0x000000D0 ; Setting the first bit to 0 to pull second row low
      STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
     
      PUSH{LR}
      BL delay  ; Branching to delay function as per the flowchart
      POP {LR}
     

      LDR r0, =GPIOA_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
      LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
      BIC r2, #0x0000000F ; Masking the registers that we are interested in
      BIC r2, #0x0000F000 ; Masking the registers that we are interested in
	  BIC r2, #0x000000F0 ; Masking the registers that we are interested in
      CMP r2, #0x00000F00 ; Comparing the value if nothing is pressed
      BNE mapillai ; If not equal, then branch back to top of this loop
        
      LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
      LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
      BIC r1, #0x000000F0 ; Masking the registers that we are interested in
      ORR r1, #0x000000B0 ; Setting the first bit to 0 to pull third row low
      STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
     
      PUSH{LR}
      BL delay  ; Branching to delay function as per the flowchart
      POP {LR}
     

      LDR r0, =GPIOA_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
      LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
      BIC r2, #0x0000000F ; Masking the registers that we are interested in
      BIC r2, #0x0000F000 ; Masking the registers that we are interested in
	  BIC r2, #0x000000F0 ; Masking the registers that we are interested in
      CMP r2, #0x00000F00 ; Comparing the value if nothing is pressed
      BNE mapillai ; If not equal, then branch back to top of this loop
        
      LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
      LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
      BIC r1, #0x000000F0 ; Masking the registers that we are interested in
      ORR r1, #0x00000070 ; Setting the first bit to 0 to pull fourth row low
      STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
     
      PUSH{LR}
      BL delay  ; Branching to delay function as per the flowchart
      POP {LR}
     

      LDR r0, =GPIOA_BASE ; Configuring the IDR resgister in GPIOB for INPUTS
      LDR r2, [r0, #GPIO_IDR]  ; Loading the current value of IDR into r2
      BIC r2, #0x0000000F ; Masking the registers that we are interested in
      BIC r2, #0x0000F000 ; Masking the registers that we are interested in
	  BIC r2, #0x000000F0 ; Masking the registers that we are interested in
      CMP r2, #0x00000F00 ; Comparing the value if nothing is pressed
      BEQ machi_cout ; If equal, then go to subrountine that checks to see what exact value has been pressed
        

; subroutine that checks which column makes the row column zero
mapillai
      BIC r5,r5 ; Clearing r5 so that the value register is reset
	  BIC r1, #0x00000F00
      CMP r1, #0x000000E0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xE
      CMPEQ r2, #0x00000E00 ; If so, then nested compare statement that sees if the column one has been pressed
      MOVEQ r7, #1 ; If so, loading the ASCII value of one into r7
      MOVEQ r5, #049 ; If so, moving the ASCII value of one into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000E0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xE
      CMPEQ r2, #0x00000D00 ; If so, then nested compare statement that sees if the column two has been pressed
      MOVEQ r7, #2 ; If so, loading the ASCII value of two into r7
      MOVEQ r5, #050 ; If so, moving the ASCII value of two into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000E0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xE
      CMPEQ r2, #0x00000B00 ; If so, then nested compare statement that sees if the column third has been pressed
      MOVEQ r7, #3 ; If so, loading the ASCII value of three into r7
      MOVEQ r5, #051 ; If so, moving the ASCII value of three into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000E0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xE
      CMPEQ r2, #0x00000700 ; If so, then nested compare statement that sees if the column fourth has been pressed
      LDREQ r7, =LetterA ; If so, loading the ASCII value of A into r7
      MOVEQ r5, #065 ; If so, moving the ASCII value of A into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000D0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xD
      CMPEQ r2, #0x00000E00 ; If so, then nested compare statement that sees if the column one has been pressed
      MOVEQ r7, #4 ; If so, loading the ASCII value of four into r7
      MOVEQ r5, #052 ; If so, moving the ASCII value of four into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000D0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xD
      CMPEQ r2, #0x00000D00 ; If so, then nested compare statement that sees if the column two has been pressed
      MOVEQ r7, #5 ; If so, loading the ASCII value of five into r7
      MOVEQ r5, #053 ; If so, moving the ASCII value of five into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000D0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xD
      CMPEQ r2, #0x00000B00 ; If so, then nested compare statement that sees if the column third has been pressed
      MOVEQ r7, #6 ; If so, loading the ASCII value of six into r7
      MOVEQ r5, #054 ; If so, moving the ASCII value of six into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000D0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xD
      CMPEQ r2, #0x00000700 ; If so, then nested compare statement that sees if the column fourth has been pressed
      LDREQ r7, =LetterB ; If so, loading the ASCII value of B into r7
      MOVEQ r5, #066 ; If so, moving the ASCII value of B into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000B0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xB
      CMPEQ r2, #0x00000E00 ; If so, then nested compare statement that sees if the column one has been pressed
      MOVEQ r7, #7 ; If so, loading the ASCII value of seven into r7
      MOVEQ r5, #055 ; If so, moving the ASCII value of seven into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000B0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xB
      CMPEQ r2, #0x00000D00 ; If so, then nested compare statement that sees if the column two has been pressed
      MOVEQ r7, #8 ; If so, loading the ASCII value of eight into r7
      MOVEQ r5, #056 ; If so, moving the ASCII value of eight into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000B0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xB
      CMPEQ r2, #0x00000B00 ; If so, then nested compare statement that sees if the column third has been pressed
      MOVEQ r7, #9 ; If so, loading the ASCII value of nine into r7
      MOVEQ r5, #057 ; If so, moving the ASCII value of nine into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x000000B0   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0xB
      CMPEQ r2, #0x00000700 ; If so, then nested compare statement that sees if the column fourth has been pressed
      LDREQ r7, =LetterC ; If so, loading the ASCII value of C into r7
      MOVEQ r5, #067 ; If so, moving the ASCII value of C into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x00000070   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0x7
      CMPEQ r2, #0x00000E00 ; If so, then nested compare statement that sees if the column one has been pressed
      LDREQ r7, =astersik ; If so, loading the ASCII value of * into r7
      MOVEQ r5, #042 ; If so, moving the ASCII value of * into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x00000070   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0x7
      CMPEQ r2, #0x00000D00 ; If so, then nested compare statement that sees if the column two has been pressed
      MOVEQ r7, #0 ; If so, loading the ASCII value of zero into r7
      MOVEQ r5, #048 ; If so, moving the ASCII value of zero into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x00000070   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0x7
      CMPEQ r2, #0x00000B00 ; If so, then nested compare statement that sees if the column third has been pressed
      LDREQ r7, =Pound ; If so, loading the ASCII value of # into r7
      MOVEQ r5, #035 ; If so, moving the ASCII value of # into r5
      BEQ displaykey ; If so, branching to displaykey
     
      CMP r1, #0x00000070   ; Comparing the value in r2, which is the GPIOC output bits (0-3) to 0x7
      CMPEQ r2, #0x00000700 ; If so, then nested compare statement that sees if the column fourth has been pressed
      LDREQ r7, =LetterD ; If so, loading the ASCII value of D into r7
      MOVEQ r5, #068 ; If so, moving the ASCII value of D into r5
      BEQ displaykey ; If so, branching to displaykey
        
delay 
      ; Delay for software debouncing
      LDR r9, =0x9999
delayloop
      SUBS r9, #1
      BNE delayloop
      BX LR
	  
; button_press subroutine that waits until button has been pressed to display value in Tera Term
displaykey
      LDR r0, =GPIOA_BASE ; Configuring the resgister in GPIOB for INPUTS         
      LDR r1, =GPIOC_BASE ; Configuring the resgister in GPIOC for OUTPUTS
      LDR r2, [r0, #GPIO_IDR] ; Loading the current value of the IDR into r3
      BIC r2, #0x0000000F ; Masking the registers that we are interested in
	  BIC r2, #0x0000F000 ; Masking the registers that we are interested in
	  BIC r2, #0x000000F0 ; Masking the registers that we are interested in
      CMP r2, #0x00000F00 ; Comparing the value of the IDR to 0x3E, which means that all of the input bits are one (Nothing is pressed)
      BNE displaykey ; Recursively calling the button_press function until the button has been released

      MOV r0, r7	; Moves the updated value of r7 to r0 (This is the return value of the function!!!!!!!!)
	
	  ; Popping the value of r5 and r7 from the stack
	  POP{r5,r7}
	  
	  BX LR ; Returns to the main program
	  ENDP
      
; delay subroutine (no args)

           
      AREA myData, DATA, READWRITE
      ALIGN

; Creating memory space for the corresponding ASCII values of 0-9, A-D, *, and #.
zero DCD 48
one DCD 49
two DCD 50
three DCD 51
four DCD 52
five DCD 53
six DCD 54
seven DCD 55
eight DCD 56
nine DCD 57
LetterA DCD 65
LetterB DCD 66
LetterC DCD 67
LetterD DCD 68
astersik DCD 42
Pound DCD 35