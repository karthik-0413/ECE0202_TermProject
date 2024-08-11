#include "stm32l476xx.h"
#include "SysClock.h"
#include "UART.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <stdbool.h>


// Declaring the assembly functions that we will be implementing
extern void zest(void);
extern void step1(int direction);
extern void step2(int direction);
extern void zesty(void);
extern void segmentd(int floor);
extern void tera(int number);
extern int keypadd(void);

// Declaring the prototypes for the helper functions we will be using
void EXTI_Init(void);
void EXTI0_IRQHandler(void);
void EXTI1_IRQHandler(void);
void EXTI2_IRQHandler(void);
void EXTI3_IRQHandler(void);
void EXTI4_IRQHandler(void);
void openDoors(int floor);
void moveUp(void);
void moveDown(void);


// Using an external interrupt to light up an LED when a button is pushed and detected
void EXTI_Init(void)
{
    // Enable SYSCFG Clock
    RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;

	// *****************************************
	// ELEVATOR CALLS INTERRUPT INITIALIZATION *
	// *****************************************

	// Selcting PC.0 - PC.3 as the trigger source of EXTI0 - EXTI3 (Elevator Call LEDs)
	SYSCFG->EXTICR[0] &= ~(0xFFFF);
	// PC.Anything = 0010
	SYSCFG->EXTICR[0] |= (0x2222);

	// Enabling interrupts EXTI0 - EXTI3
	// Interrupt mask register: 0 = masked, 1 = unmasked
	// 0 = the processor ignores the corresponding interrupt
	EXTI->IMR1 |= 0xF;

	// Event mask register: 0 = masked, 1 = unmasked
	// 0 = the processor ignores the corresponding interrupt
	EXTI->EMR1 |= 0xF;

	// Enabling rising edge trigger for EXTI0 - EXTI3
	EXTI->RTSR1 |= 0xF;

	// Disabling falling edge trigger for EXTI0 - EXTI3
	EXTI->FTSR1 &= ~0xF;


	// *************************************
	// ADMIN CALL INTERRUPT INITIALIZATION *
	// *************************************

	// Selcting PB.4 as the trigger source of EXTI4 (Admin Call LED)
	SYSCFG->EXTICR[1] &= ~(0x000F);
	// PB.Anything = 0001
	SYSCFG->EXTICR[1] |= (0x0001);
	
	// Enabling interrupts EXTI4
	// Interrupt mask register: 0 = masked, 1 = unmasked
	// 0 = the processor ignores the corresponding interrupt
	EXTI->IMR1 |= 0x10;
	
	// Event mask register: 0 = masked, 1 = unmasked
	// 0 = the processor ignores the corresponding interrupt
	EXTI->EMR1 |= 0x10;
	
	// Enabling rising edge trigger for EXTI0 - EXTI3
	EXTI->RTSR1 |= 0x10;
	
	// Disabling falling edge trigger for EXTI0 - EXTI3
	EXTI->FTSR1 &= ~0x10;

	// ********************
	// Elevator Call LEDs *
	// ********************
	
		// Set EXTI0 priority to 2
    NVIC_SetPriority(EXTI0_IRQn, 2);

    // Enable EXTI0 interrupt
    NVIC_EnableIRQ(EXTI0_IRQn);
	
		// Set EXTI1 priority to 2
    NVIC_SetPriority(EXTI1_IRQn, 2);

    // Enable EXTI1 interrupt
    NVIC_EnableIRQ(EXTI1_IRQn);
		
		// Set EXTI2 priority to 2
    NVIC_SetPriority(EXTI2_IRQn, 2);

    // Enable EXTI2 interrupt
    NVIC_EnableIRQ(EXTI2_IRQn);
		
		// Set EXTI3 priority to 2
    NVIC_SetPriority(EXTI3_IRQn, 2);

    // Enable EXTI3 interrupt
    NVIC_EnableIRQ(EXTI3_IRQn);

	// *****************
	// Admin Call LEDs *
	// *****************
		
		// Set EXTI4 priority to 1 (Lower Priority Number = Higher Urgency)
    NVIC_SetPriority(EXTI4_IRQn, 1);

    // Enable EXTI4 interrupt
    NVIC_EnableIRQ(EXTI4_IRQn);
}

// Red LED
void EXTI0_IRQHandler(void)
{
	// If the Admin LED is on, then immeidately end interrupt
	if(((GPIOB->ODR >> 7) & 0x1) == 1)
	{
		EXTI->PR1 |= EXTI_PR1_PIF0;
	}
	
	// Check for EXTI0 interrupt flag
  if ((EXTI->PR1 & EXTI_PR1_PIF0) == EXTI_PR1_PIF0)
	{
		// Set ODR pin A0 to high and connect it to external LED to turn it on
		GPIOA->ODR &= ~(1UL << 0);
		GPIOA->ODR |= (1UL << 0);

		// Clear EXTI0 pending flag
		EXTI->PR1 |= EXTI_PR1_PIF0;
    }
}

// Yellow LED
void EXTI1_IRQHandler(void)
{
	// If the Admin LED is on, then immeidately end interrupt
	if(((GPIOB->ODR >> 7) & 0x1) == 1)
	{
		EXTI->PR1 |= EXTI_PR1_PIF1;
	}
	
	// Check for EXTI0 interrupt flag
	if((EXTI->PR1 & EXTI_PR1_PIF1) == EXTI_PR1_PIF1)
	{
		// Set ODR pin A1 to high and connect it to external LED to turn it on
		GPIOA->ODR &= ~(1UL << 1);
		GPIOA->ODR |= (1UL << 1);

		// Clear EXTI1 pending flag
		EXTI->PR1 |= EXTI_PR1_PIF1;
	}
}

// Green LED
void EXTI2_IRQHandler(void)
{
	// If the Admin LED is on, then immeidately end interrupt
	if(((GPIOB->ODR >> 7) & 0x1) == 1)
	{
		EXTI->PR1 |= EXTI_PR1_PIF2;
	}
	
	// Check for EXTI2 interrupt flag
	if((EXTI->PR1 & EXTI_PR1_PIF2) == EXTI_PR1_PIF2)
	{
		// Set ODR pin A4 to high and connect it to external LED to turn it on
		GPIOA->ODR &= ~(1UL << 4);
		GPIOA->ODR |= (1UL << 4);

		// Clear EXTI2 pending flag
		EXTI->PR1 |= EXTI_PR1_PIF2;
	}
}

// Blue LED
void EXTI3_IRQHandler(void)
{
	// If the Admin LED is on, then immeidately end interrupt
	if(((GPIOB->ODR >> 7) & 0x1) == 1)
	{
		EXTI->PR1 |= EXTI_PR1_PIF3;
	}
	
	if((EXTI->PR1 & EXTI_PR1_PIF3) == EXTI_PR1_PIF3)
	{
		// Set ODR pin A5 to high and connect it to external LED to turn it on
		GPIOA->ODR &= ~(1UL << 5);
		GPIOA->ODR |= (1UL << 5);

		// Clear EXTI3 pending flag
		EXTI->PR1 |= EXTI_PR1_PIF3;
	}
}

// Admin LED
void EXTI4_IRQHandler(void)
{
	// Check for EXTI4 interrupt flag
	if((EXTI->PR1 & EXTI_PR1_PIF4) == EXTI_PR1_PIF4)
	{
		// Set ODR pin B7 to high and connect it to external LED to turn it on
		GPIOB->ODR &= ~(1UL << 7);
		GPIOB->ODR |= (1UL << 7);
		
		// Turning off all of the elevator call LEDs
		GPIOA->ODR &= ~(1UL << 0);
		GPIOA->ODR &= ~(1UL << 1);
		GPIOA->ODR &= ~(1UL << 4);
		GPIOA->ODR &= ~(1UL << 5);
	
		// Clear EXTI4 pending flag
		EXTI->PR1 |= EXTI_PR1_PIF4;
		
	 }
}

// ***************
// MAIN FUNCTION *
// ***************
int main(void)
{
	int dFloor = 1;
	int currentfloor = 1;
	// Enabling all of the clocks we are going to use (A, B, C)
	RCC->AHB2ENR |= 0x00000007;
		
	// Calling the Interrupt Function
	EXTI_Init();

	// Initializing the corresponding registers values to turn the LEDs on
	// GPIOA = Elevator Calls LED Mask and Set Values
		GPIOA->MODER &= ~0x00000F0F;
		GPIOA->MODER |= 0x000000505;

	// GPIOB = Admin LED Mask and Set Values
		GPIOB->MODER &= ~0x0000C300;
		GPIOB->MODER |= 0x000004000;

	// GPIOC = Seven Segment Display Mask and Set Values
		GPIOC->MODER &= ~0x00FF0000;
	  GPIOC->MODER |= 0x00550000;

	// GPIOC = Clearing the Buttons input register
		GPIOC->MODER &= ~0x000000FF;
	

	// Initializing the Seven Segment display to display the current floor as 1, so that it does not start off floating
	segmentd(currentfloor);

	// Infinite While Loop
	while(1)
    {
				// Checks if the Admin LED is on
				if (((GPIOB->ODR >> 7) & 0x1) == 1)
				{
					
					
					// While the elevator is not at floor 1
					for (int i = currentfloor; i > 1; i--)
					{
						// Move down until it gets to floor 1
						moveDown();

						// Display updated floor in seven segment
						currentfloor--;
						segmentd(currentfloor);
					}
					
					// Resetting destination floor to 1
					dFloor = 1;
					
					// Turning off Admin LED
					GPIOB->ODR &= ~(1UL << 7);
				}
				
				// Checks if any floor has been called
				if((((GPIOA->ODR >> 0) & 0x33)) != 0)
				{
					// Determining the destination floor depending on the current floor and which LED calls have been turned on
					switch(currentfloor)
					{
						// If current floor is 1
						case 1: 
								// Check to see if the fourth LED floor was called
								if((((GPIOA->ODR >> 5) & 0x1)) == 1)
								{
									// Setting the destination floor to 4
									dFloor = 4;
								}
								// Check to see if the third LED floor was called
								else if((((GPIOA->ODR >> 4) & 0x1)) == 1)
								{
									// Setting the destination floor to 3
									dFloor = 3;
								}
								// Check to see if the second LED floor was called
								else if((((GPIOA->ODR >> 1) & 0x1)) == 1)
								{
									// Setting the destination floor to 2
									dFloor = 2;
								}
								else
								{
									// Setting the destination floor to 1
									dFloor = 1;
								}
								break;

						// If current floor is 2
						case 2:
								// Check to see if the fourth LED floor was called
								if((((GPIOA->ODR >> 5) & 0x1)) == 1)
								{
									// Setting the destination floor to 4
									dFloor = 4;
								}
								// Check to see if the fourth LED floor was called
								else if((((GPIOA->ODR >> 4) & 0x1)) == 1)
								{
									// Setting the destination floor to 3
									dFloor = 3;
								}
								// Check to see if the first LED floor was called
								else if((((GPIOA->ODR >> 0) & 0x1)) == 1)
								{
									// Setting the destination floor to 1
									dFloor = 1;
								}
								else
								{
									// Setting the destination floor to 2
									dFloor = 2;
								}
								break;

						// If current floor is 3
						case 3:
								// Check to see if the first LED floor was called
								if((((GPIOA->ODR >> 0) & 0x1)) == 1)
								{
									// Setting the destination floor to 1
									dFloor = 1;
								}
								// Check to see if the second LED floor was called
								else if((((GPIOA->ODR >> 1) & 0x1)) == 1)
								{
									// Setting the destination floor to 2
									dFloor = 2;
								}
								// Check to see if the fourth LED floor was called
								else if((((GPIOA->ODR >> 5) & 0x1)) == 1)
								{
									// Setting the destination floor to 4
									dFloor = 4;
								}
								else
								{
									// Setting the destination floor to 3
									dFloor = 3;
								}
								break;

						// If current floor is 4
						case 4:
								// Check to see if the first LED floor was called
								if((((GPIOA->ODR >> 0) & 0x1)) == 1)
								{
									// Setting the destination floor to 1
									dFloor = 1;
								}
								// Check to see if the second LED floor was called
								else if((((GPIOA->ODR >> 1) & 0x1)) == 1)
								{
									// Setting the destination floor to 2
									dFloor = 2;
								}
								// Check to see if the third LED floor was called
								else if((((GPIOA->ODR >> 4) & 0x1)) == 1)
								{
									// Setting the destination floor to 3
									dFloor = 3;
								}
								else
								{
									// Setting the destination floor to 4
									dFloor = 4;
								}
								
								// Break out of switch case
								break;
					}
						
					// If there was a call to any floor
					while(1)
					{
						// If Admin button was pressed, then break out of the while loop
							if (((GPIOB->ODR >> 7) & 0x1) == 1)
							{
								break;
							}
							
							// If the elevator encounters an intermediate floor
							if ((currentfloor == 1 && ((((GPIOA->ODR >> 0) & 0x1)) == 1)) || (currentfloor == 2 && ((((GPIOA->ODR >> 1) & 0x1)) == 1)) || (currentfloor == 3 && ((((GPIOA->ODR >> 4) & 0x1)) == 1)) || (currentfloor == 4 && ((((GPIOA->ODR >> 5) & 0x1)) == 1)))
							{
								// Calling the open doors function and turning off the current floor LED (Passed in parameter)
								openDoors(currentfloor);
							}

							// Checks if the elevator has to go down
							if (currentfloor > dFloor)
							{
								// Call the move down function
								moveDown();

								// Display the updated floors on the seven segment display
								currentfloor--;
								segmentd(currentfloor);
							}
							
							// Checks if the elevator has to go up
							else if (currentfloor < dFloor)
							{	
								// Call the move down function
								moveUp();

								// Display the updated floors on the seven segment display
								currentfloor++;
								segmentd(currentfloor);
							}
							
							// If it has reached the destination floor, then destination floor is 0 in order to get out of this while loop
							if (currentfloor == dFloor)
							{
								break;
							}
					}
				}
			
		}
}	

// ******************
// HELPER FUNCTIONS *
// ******************

void openDoors(int floor)
{
	// If floor has been reached, then turn the corresponding floor's LED off
	switch(floor)
	{
		case 1:
			// Floor 1 LED off
			GPIOA->ODR &= ~(0x1);
			break;
		case 2:
			// Floor 2 LED off
			GPIOA->ODR &= ~(0x2);
			break;
		case 3:
			// Floor 3 LED off
			GPIOA->ODR &= ~(0x10);
			break;
		case 4:
			// Floor 4 LED off
			GPIOA->ODR &= ~(0x20);
			break;
	}
	
	
	// Display the current floor in the seven segment display
	segmentd(floor);

	//teratermm(3);
	// Argument is 1, so it opens the door (stepper motor function)
	step1(1);
	
	// Calling the keypad function and it returns what number has been pressed down

	// If the Admin button is not on
	if(!(((GPIOB->ODR >> 7) & 0x1) == 1))
	{
		// Initialzizing the variable f
		int f = 1;
			// Infinite while loop that lets the user press multiple keypad floors between the doors opening and closing
			while(1)
			{
				// Getting which value is pressed down
				f = keypadd();
				if(f == 1)
				{
					// Floor 1 LED off
					// ON when a floor if pressed when the keypad (Floor 1)
					GPIOA->ODR &= ~(1UL << 0);
					GPIOA->ODR |= (1UL << 0);
				}
				else if(f == 2)
				{
					// Floor 2 LED off
					// ON when a floor if pressed when the keypad (Floor 2)
					GPIOA->ODR &= ~(1UL << 1);
					GPIOA->ODR |= (1UL << 1);
				}
				else if(f == 3)
				{
					// Floor 3 LED off
					// ON when a floor if pressed when the keypad (Floor 3)
					GPIOA->ODR &= ~(1UL << 4);
					GPIOA->ODR |= (1UL << 4);
				}
				else if(f == 4)
				{
					// Floor 4 LED off
					// ON when a floor if pressed when the keypad (Floor 4)
					GPIOA->ODR &= ~(1UL << 5);
					GPIOA->ODR |= (1UL << 5);
				}
				else
				{
					// Breaks out of the infinte while loop
					break;
				}
			}
	}
	
	//teratermm(4);
	// Argument is 0, so it closes the door (stepper motor function)
	step1(0);
}
						
void moveUp(void)
{
	//teratermm(1);
	// Argument is 1, so the elevator moves up (stepper motor function)
	step2(1);
}

void moveDown(void)
{
	//teratermm(2);
	// Argument is 0, so the elevator moves down (stepper motor function)
	step2(0);
}

