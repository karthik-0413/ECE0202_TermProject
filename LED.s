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
	IMPORT 	UART2_Init
	IMPORT	USART2_Write
	
	AREA    LED, CODE, READONLY
	EXPORT	zest				; make __main visible to linker
	ENTRY			
				
zest	PROC
	
	;	Enable clocks for GPIOC, GPIOB//;	Enable clocks for GPIOA, GPIOB
		
	; Set GPIOC pin 13 (blue button) as an input pin//; Set GPIOA pin 0 (center joystick button) as an input pin
	
	; Set GPIOB pins 2, 3, 6, 7 as output pins
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;; YOUR CODE GOES HERE ;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	
	LDR   r0, =RCC_BASE ; Configuring the reset and clock of the microcontroller
	LDR   r1, [r0, #RCC_AHB2ENR] ; Loading the value of the clock onto r1
	BIC   r1, r1, #0x00000005 ; Setting the desired GPIOs (GPIOB and GPIOC)
	ORR   r1, r1, #0x00000005 ; Masking the GPIOB and GPIOC to enable the clock
	STR   r1, [r0, #RCC_AHB2ENR] ; Storing the value of the clock to r1
	
	LDR   r0, =GPIOA_BASE ; Configuring the MODER resgisters in GPIOC for OUTPUTS
	LDR   r1, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r1
	BIC   r1, r1, #0x0000000F ; Masking the registers that we are interested in
	BIC   r1, r1, #0x00000F00 ; Masking the registers that we are interested in
	ORR   r1, r1, #0x00000005 ; Setting the desired resgisters
	ORR   r1, r1, #0x00000500 ; Setting the desired resgisters

	STR   r1, [r0, #GPIO_MODER] ; Storing the value of the MODER to r1
	
	LDR   r0, =GPIOC_BASE ; Configuring the MODER resgisters in GPIOC for INPUTS
	LDR   r1, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r1
	BIC   r1, r1, #0x000000FF ; Masking the registers that we are interested in
	ORR   r1, r1, #0x00000000 ; Setting the desired resgisters
	STR   r1, [r0, #GPIO_MODER] ; Storing the value of the MODER to r1

	
button1

	;Button no 1 
	 LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	 LDR r1, [r0, #GPIO_IDR] ; Loading the value of the ODR onto r1
	 AND r1, #0x1
	 CMP r1, #0x00000001 ; Masking the registers that we are interested in
	 BNE button2
	
	;Light no 1
	 LDR r0, =GPIOA_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	 LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	 BIC r1, #0xFFFFFF00 ; Masking the registers that we are interested in
	 ORR r1, #0x00000001 ; Setting the desired bits
	 STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	 
button2
	
	;Button no 2
	 LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	 LDR r1, [r0, #GPIO_IDR] ; Loading the value of the ODR onto r1
	 AND r1, #0x2
	 CMP r1, #0x0000002 ; Masking the registers that we are interested in
	 BNE button3
	
	;Light no 2
	 LDR r0, =GPIOA_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	 LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	 BIC r1, #0xFFFFFF00 ; Masking the registers that we are interested in
	 ORR r1, #0x00000002 ; Setting the desired bits
	 STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	 
button3
	
	;Button no 3
	  LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	 LDR r1, [r0, #GPIO_IDR] ; Loading the value of the ODR onto r1
	 AND r1, #0x4
	 CMP r1, #0x0000004 ; Masking the registers that we are interested in
	 BNE button4
	 
	;Light no 3
	 LDR r0, =GPIOA_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	 LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	 BIC r1, #0xFFFFFF00 ; Masking the registers that we are interested in
	 ORR r1, #0x00000010 ; Setting the desired bits
	 STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	 
button4
	
	;Button no 4
	 LDR r0, =GPIOC_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	 LDR r1, [r0, #GPIO_IDR] ; Loading the value of the ODR onto r1
	 AND r1, #0x8
	 CMP r1, #0x0000008 ; Masking the registers that we are interested in
	 BNE button1
	
	;Light no 4
	 LDR r0, =GPIOA_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	 LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	 BIC r1, #0xFFFFFF00 ; Masking the registers that we are interested in
	 ORR r1, #0x00000020 ; Setting the desired bits
	 STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	 
	B zest
	ENDP
	END