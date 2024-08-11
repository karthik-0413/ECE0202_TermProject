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
	
	AREA    testLED, CODE, READONLY
	EXPORT	zesty				; make __main visible to linker
	ENTRY			
				
zesty	PROC
	
	;	Enable clocks for GPIOC, GPIOB//;	Enable clocks for GPIOA, GPIOB
		
	; Set GPIOC pin 13 (blue button) as an input pin//; Set GPIOA pin 0 (center joystick button) as an input pin
	
	; Set GPIOB pins 2, 3, 6, 7 as output pins
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;; YOUR CODE GOES HERE ;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	
	LDR   r0, =RCC_BASE ; Configuring the reset and clock of the microcontroller
	LDR   r1, [r0, #RCC_AHB2ENR] ; Loading the value of the clock onto r1
	BIC   r1, r1, #0x00000003 ; Setting the desired GPIOs (GPIOB and GPIOC)
	ORR   r1, r1, #0x00000003 ; Masking the GPIOB and GPIOC to enable the clock
	STR   r1, [r0, #RCC_AHB2ENR] ; Storing the value of the clock to r1
	
	LDR   r0, =GPIOB_BASE ; Configuring the MODER resgisters in GPIOC for OUTPUTS
	LDR   r1, [r0, #GPIO_MODER] ; Loading the value of the MODER onto r1
	BIC   r1, r1, #0x0000000C ; Masking the registers that we are interested in
	ORR   r1, r1, #0x00000004
	STR   r1, [r0, #GPIO_MODER] ; Storing the value of the MODER to r1


	;Light no 1
	 LDR r0, =GPIOB_BASE ; Configuring the ODR resgister in GPIOC for OUTPUTS
	 LDR r1, [r0, #GPIO_ODR] ; Loading the value of the ODR onto r1
	 BIC r1, #0xFFFFFFF0 ; Masking the registers that we are interested in
	 ORR r1, #0x00000002 ; Setting the desired bits
	 STR r1, [r0, #GPIO_ODR] ; Storing the value of the ODR to r1
	 

	ENDP
	END