#line 1 "M:/mikroC PRO for PIC/Examples/TrafficLight2.c"


sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB1_bit;
sbit LCD_D5 at RB2_bit;
sbit LCD_D6 at RB3_bit;
sbit LCD_D7 at RB6_bit;


sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB1_bit;
sbit LCD_D5_Direction at TRISB2_bit;
sbit LCD_D6_Direction at TRISB3_bit;
sbit LCD_D7_Direction at TRISB6_bit;



volatile short system_off = 0;



void interrupt(){
 if(INTF_bit){
 system_off = 1;
 INTF_bit = 0;
 }
}


void main(){


 TRISB = 0x01;
 TRISD = 0x00;
 PORTD = 0x00;


 OPTION_REG.INTEDG = 0;
 INTE_bit = 1;
 GIE_bit = 1;


 Delay_ms(100);
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);


 while(1){


 if(system_off){
 PORTD = 0x00;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Traffic OFF");
 while(1);
 }


 PORTD = 0x01;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Traffic Light");
 Lcd_Out(2,1,"GREEN");
 Delay_ms(5000);


 PORTD = 0x02;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Traffic Light");
 Lcd_Out(2,1,"RED");
 Delay_ms(5000);


 PORTD = 0x04;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Traffic Light");
 Lcd_Out(2,1,"YELLOW");
 Delay_ms(2000);
 }
}
