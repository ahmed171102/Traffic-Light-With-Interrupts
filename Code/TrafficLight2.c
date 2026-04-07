// --- LCD MODULE CONNECTIONS ---
// These map the LCD data and control pins to specific pins on the microcontroller's PORTB.
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB1_bit;
sbit LCD_D5 at RB2_bit;
sbit LCD_D6 at RB3_bit;
sbit LCD_D7 at RB6_bit;

// These define the direction (input or output) for those specific LCD pins.
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB1_bit;
sbit LCD_D5_Direction at TRISB2_bit;
sbit LCD_D6_Direction at TRISB3_bit;
sbit LCD_D7_Direction at TRISB6_bit;

// A flag variable to track if the system should shut down.
// 'volatile' is used because this variable is modified inside an interrupt.
volatile short system_off = 0;

// --- INTERRUPT SERVICE ROUTINE ---
// This runs automatically when an external event (like a button press) happens.
void interrupt(){
    if(INTF_bit){         // Check if the External Interrupt Flag was triggered
        system_off = 1;   // Set the flag to 1 to signal the system to stop
        INTF_bit = 0;     // Clear the interrupt flag so it doesn't get stuck in a loop
    }
}

// --- MAIN PROGRAM ---
void main(){

    // --- HARDWARE SETUP ---
    TRISB = 0x01;  // Set RB0 as Input (for the button), and all other PORTB pins as Outputs (for LCD)
    TRISD = 0x00;  // Set all PORTD pins as Outputs (for the LEDs)
    PORTD = 0x00;  // Start with all LEDs turned off

    // --- INTERRUPT SETUP ---
    OPTION_REG.INTEDG = 0; // Trigger the interrupt on a falling edge (when button is pressed)
    INTE_bit = 1;          // Enable the External Interrupt on pin RB0
    GIE_bit = 1;           // Enable Global Interrupts (the master switch for interrupts)

    // --- LCD SETUP ---
    Delay_ms(100);             // Give the LCD time to power up
    Lcd_Init();                // Initialize the LCD module
    Lcd_Cmd(_LCD_CLEAR);       // Clear any text on the screen
    Lcd_Cmd(_LCD_CURSOR_OFF);  // Hide the blinking cursor

    // --- MAIN LOOP ---
    while(1){

        // 1. Check for Emergency Stop
        if(system_off){
            PORTD = 0x00;               // Turn off all traffic lights
            Lcd_Cmd(_LCD_CLEAR);        // Clear the screen
            Lcd_Out(1,1,"Traffic OFF"); // Print shutdown message
            while(1);                   // Trap the program in an infinite loop forever
        }

        // 2. Green Light Sequence
        PORTD = 0x01;                   // Turn on RD0 (Green LED)
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,1,"Traffic Light");
        Lcd_Out(2,1,"GREEN");
        Delay_ms(5000);                 // Wait for 5 seconds

        // 3. Red Light Sequence
        PORTD = 0x02;                   // Turn on RD1 (Red LED)
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,1,"Traffic Light");
        Lcd_Out(2,1,"RED");
        Delay_ms(5000);                 // Wait for 5 seconds

        // 4. Yellow Light Sequence
        PORTD = 0x04;                   // Turn on RD2 (Yellow LED)
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,1,"Traffic Light");
        Lcd_Out(2,1,"YELLOW");
        Delay_ms(2000);                 // Wait for 2 seconds
    }
}