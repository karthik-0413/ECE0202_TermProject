	  INCLUDE core_cm4_constants.s		; Load Constant Definitions
	  INCLUDE stm32l476xx_constants.s      

	  IMPORT 	System_Clock_Init
	  


      AREA    SevenSeg, CODE, READONLY

      EXPORT      segmentd                        ; make __main visible to linker

      ENTRY            

                       

segmentd      PROC
			   PUSH {r5}
			   PUSH {r7}
			   ; The argument that is being passed inti the function is automatically passed into r0
			   ; Moving the value being passed into the function into r3
			   MOV r3, r0
			   
			   ; Doing arithmetics which shifts the value passed into the function by 8
			   MOV r5, #256
			   MUL r3, r3, r5
				
			   LDR r0, =GPIOC_BASE  ; Configuring r10 to GPIOB Base
			   LDR r7, [r0, #GPIO_ODR]   ; Loading the input data into the r7
			   BIC r7, #0xF00 ; Masking the bits we are interested in
			   ORR r7, r3	; Setting the value of the ODR to the value that was passed into the function
			   STR r7, [r0, #GPIO_ODR]  ; Storing the value of the MODER to r7    
			   
			   ; Popping the value of r5 and r7 from the stack
			   POP {r7}
			   POP {r5}
			   
			   ; Moving the value of the LR to the PC, which will branch back to the main
			   MOV PC, LR

			  ENDP
