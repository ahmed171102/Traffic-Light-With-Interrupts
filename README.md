# Traffic-Light-With-Interrupts
This microcontroller project uses a PIC16F877A programmed in mikroC PRO to run a Green-Yellow-Red traffic light sequence. It features an external interrupt button on RB0 for an Emergency Stop. Using a custom non-blocking "Smart Delay", the system instantly halts the lights (PORTD) and displays "Traffic OFF" on a 16x2 LCD (PORTB) when pressed.
