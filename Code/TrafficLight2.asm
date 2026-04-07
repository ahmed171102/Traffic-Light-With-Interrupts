
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;TrafficLight2.c,24 :: 		void interrupt(){
;TrafficLight2.c,25 :: 		if(INTF_bit){         // Check if the External Interrupt Flag was triggered
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt0
;TrafficLight2.c,26 :: 		system_off = 1;   // Set the flag to 1 to signal the system to stop
	MOVLW      1
	MOVWF      _system_off+0
;TrafficLight2.c,27 :: 		INTF_bit = 0;     // Clear the interrupt flag so it doesn't get stuck in a loop
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;TrafficLight2.c,28 :: 		}
L_interrupt0:
;TrafficLight2.c,29 :: 		}
L_end_interrupt:
L__interrupt11:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;TrafficLight2.c,32 :: 		void main(){
;TrafficLight2.c,35 :: 		TRISB = 0x01;  // Set RB0 as Input (for the button), and all other PORTB pins as Outputs (for LCD)
	MOVLW      1
	MOVWF      TRISB+0
;TrafficLight2.c,36 :: 		TRISD = 0x00;  // Set all PORTD pins as Outputs (for the LEDs)
	CLRF       TRISD+0
;TrafficLight2.c,37 :: 		PORTD = 0x00;  // Start with all LEDs turned off
	CLRF       PORTD+0
;TrafficLight2.c,40 :: 		OPTION_REG.INTEDG = 0; // Trigger the interrupt on a falling edge (when button is pressed)
	BCF        OPTION_REG+0, 6
;TrafficLight2.c,41 :: 		INTE_bit = 1;          // Enable the External Interrupt on pin RB0
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;TrafficLight2.c,42 :: 		GIE_bit = 1;           // Enable Global Interrupts (the master switch for interrupts)
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;TrafficLight2.c,45 :: 		Delay_ms(100);             // Give the LCD time to power up
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main1:
	DECFSZ     R13+0, 1
	GOTO       L_main1
	DECFSZ     R12+0, 1
	GOTO       L_main1
	DECFSZ     R11+0, 1
	GOTO       L_main1
	NOP
	NOP
;TrafficLight2.c,46 :: 		Lcd_Init();                // Initialize the LCD module
	CALL       _Lcd_Init+0
;TrafficLight2.c,47 :: 		Lcd_Cmd(_LCD_CLEAR);       // Clear any text on the screen
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TrafficLight2.c,48 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);  // Hide the blinking cursor
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TrafficLight2.c,51 :: 		while(1){
L_main2:
;TrafficLight2.c,54 :: 		if(system_off){
	MOVF       _system_off+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main4
;TrafficLight2.c,55 :: 		PORTD = 0x00;               // Turn off all traffic lights
	CLRF       PORTD+0
;TrafficLight2.c,56 :: 		Lcd_Cmd(_LCD_CLEAR);        // Clear the screen
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TrafficLight2.c,57 :: 		Lcd_Out(1,1,"Traffic OFF"); // Print shutdown message
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_TrafficLight2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;TrafficLight2.c,58 :: 		while(1);                   // Trap the program in an infinite loop forever
L_main5:
	GOTO       L_main5
;TrafficLight2.c,59 :: 		}
L_main4:
;TrafficLight2.c,62 :: 		PORTD = 0x01;                   // Turn on RD0 (Green LED)
	MOVLW      1
	MOVWF      PORTD+0
;TrafficLight2.c,63 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TrafficLight2.c,64 :: 		Lcd_Out(1,1,"Traffic Light");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_TrafficLight2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;TrafficLight2.c,65 :: 		Lcd_Out(2,1,"GREEN");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_TrafficLight2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;TrafficLight2.c,66 :: 		Delay_ms(5000);                 // Wait for 5 seconds
	MOVLW      127
	MOVWF      R11+0
	MOVLW      212
	MOVWF      R12+0
	MOVLW      49
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
	NOP
;TrafficLight2.c,69 :: 		PORTD = 0x02;                   // Turn on RD1 (Red LED)
	MOVLW      2
	MOVWF      PORTD+0
;TrafficLight2.c,70 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TrafficLight2.c,71 :: 		Lcd_Out(1,1,"Traffic Light");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_TrafficLight2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;TrafficLight2.c,72 :: 		Lcd_Out(2,1,"RED");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_TrafficLight2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;TrafficLight2.c,73 :: 		Delay_ms(5000);                 // Wait for 5 seconds
	MOVLW      127
	MOVWF      R11+0
	MOVLW      212
	MOVWF      R12+0
	MOVLW      49
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
	NOP
;TrafficLight2.c,76 :: 		PORTD = 0x04;                   // Turn on RD2 (Yellow LED)
	MOVLW      4
	MOVWF      PORTD+0
;TrafficLight2.c,77 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;TrafficLight2.c,78 :: 		Lcd_Out(1,1,"Traffic Light");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_TrafficLight2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;TrafficLight2.c,79 :: 		Lcd_Out(2,1,"YELLOW");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_TrafficLight2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;TrafficLight2.c,80 :: 		Delay_ms(2000);                 // Wait for 2 seconds
	MOVLW      51
	MOVWF      R11+0
	MOVLW      187
	MOVWF      R12+0
	MOVLW      223
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
	NOP
;TrafficLight2.c,81 :: 		}
	GOTO       L_main2
;TrafficLight2.c,82 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
