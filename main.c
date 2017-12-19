/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/19/2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16.h>
#include <delay.h>
#include <i2c.h>
#include <ds1307.h>
#include <stdlib.h>
#include <stdio.h>
#include <alcd.h>

#define ON_PIN  PORTD.3
#define RELAY   PORTD.2
#define LOAD    PORTD.4

#define MODE    PINB.0
#define UP      PINB.1
#define DOWN    PINB.3
#define LOSS_PHASE    690

char buzz[4];
unsigned int adcPin;
bit Charge_Flag = 0;
unsigned char hour,minn,sec,day,date,month,year,mode,No_date,index=0;
eeprom unsigned char hour_on,min_on,hour_off,min_off,alarm_flag;
// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

interrupt [EXT_INT2] void ext_int2_isr(void)
{
       LOAD = ~ LOAD;
       delay_ms(100); 
}

void readPin(void);
void display_PIN(unsigned char x, unsigned char y);
unsigned int read_phase(unsigned char n);
void check_phase(void);
void getTime();
void timeDisplay(unsigned char x, unsigned char y);
void dateDisplay(unsigned char x, unsigned char y);
void dayDisplay(unsigned char x, unsigned char y);
void so_ngay(void);
void setting(void);
void button(void);
void alarmOnDisplay(unsigned char x, unsigned char y);
void alarmOffDisplay(unsigned char x, unsigned char y);
void alarm(void);

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=P Bit2=P Bit1=P Bit0=P 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (1<<DDD4) | (0<<DDD3) | (1<<DDD2) | (1<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (1<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: On
// INT2 Mode: Rising Edge
GICR|=(0<<INT1) | (0<<INT0) | (1<<INT2);
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(1<<ISC2);
GIFR=(0<<INTF1) | (0<<INTF0) | (1<<INTF2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTD
// I2C SDA bit: 7
// I2C SCL bit: 6
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 0
rtc_init(0,0,0);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);
lcd_gotoxy(4,0);
lcd_puts("Welcome");
lcd_gotoxy(3,1);
lcd_puts("CTA Group");
delay_ms(800);
lcd_clear();
readPin();

// Global enable interrupts
#asm("sei")
while (1)
    {     
      button();   
     /*************************************************/ 
     if(index==0)
     {
          if(mode==0){ 
              getTime();  
              timeDisplay(2,0);
              dateDisplay(0,1); 
              
              display_PIN(12,0); 
              check_phase();   
              if(minn%3==0 && sec<10) readPin(); 
              else{ 
                if(Charge_Flag==0) DDRD.3=0; 
              } 
              if(alarm_flag==1){
                lcd_gotoxy(0,0);
                lcd_putchar(255);
              }else{
                lcd_gotoxy(0,0);
                lcd_putchar(0);
              }
              
          }else{ 
            setting();
            if(mode==1){
              lcd_gotoxy(4,0);
              lcd_puts("CAI PHUT");
              timeDisplay(4,1);
            } 
            else if(mode==2){
              lcd_gotoxy(5,0);
              lcd_puts("CAI GIO");
              timeDisplay(4,1);
            }
            else if(mode==3) {
              lcd_gotoxy(4,0);
              lcd_puts("CAI NGAY");
              dateDisplay(3,1);
            }
            else if(mode==4) {
              lcd_gotoxy(4,0);
              lcd_puts("CAI THANG");
              dateDisplay(3,1);
            } 
            else if(mode==5) {
              lcd_gotoxy(4,0);
              lcd_puts("CAI NAM");
              dateDisplay(3,1);
            }
          }
          
     }else{
        alarm();
        if(index==1)
        {
           lcd_gotoxy(2,0);
           lcd_puts("CAI PHUT BAT");
           alarmOnDisplay(5,1); 
        }
        else if(index==2)
        {
           lcd_gotoxy(2,0);
           lcd_puts("CAI GIO BAT");
           alarmOnDisplay(5,1);
        } 
        else if(index==3)
        {
           lcd_gotoxy(2,0);
           lcd_puts("CAI PHUT TAT");
           alarmOffDisplay(5,1);
        }
        else if(index==4)
        {
           lcd_gotoxy(2,0);
           lcd_puts("CAI GIO TAT");
           alarmOffDisplay(5,1);
        }
        else if(index==5)
        {
           lcd_gotoxy(2,0);
           lcd_puts("CHE DO HEN GIO");
           if(alarm_flag==1){
                lcd_gotoxy(7,1);
                lcd_puts("BAT");
           }  
           else{
                lcd_gotoxy(7,1);
                lcd_puts("TAT");
           }
        }
     }
      /****************************************************/
       
    }
}

/**************************************************************************/
void button(void)
{
  if(index==0){ 
    if(MODE==0)
    {
        lcd_clear();
        mode++;
        if(mode>5) mode=0;
        while(!MODE);
    }
    if(UP==0) 
    { 
        lcd_clear();  
        index=1;
        while(!UP);
    } 
    if(DOWN==0)
    {
        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_puts("T_ON: ");
        alarmOnDisplay(8,0); 
         
        lcd_gotoxy(1,1);
        lcd_puts("T_OFF:");
        alarmOffDisplay(8,1);  
        
        while(!DOWN);
        lcd_clear();
    }
  }else{
    if(MODE==0)
    {
        lcd_clear();
        index++;
        if(index>5) index=0;
        while(!MODE); 
    }
  } 

}

void readPin(void)
{
    char i;
    unsigned long ad=0;
    DDRD.3=1;
    for(i=0;i<100;i++)
    {
      ad+=read_adc(3);
      delay_ms(2);
    }  
    adcPin=ad/100; 
}
unsigned int read_phase(unsigned char n)
{
  unsigned int ad=0;
  unsigned char i;
  for(i=0;i<30;i++)
  {
    ad+=read_adc(n);
    delay_ms(4);
  } 
  return (ad/30);
}
void check_phase(void)
{
  if(read_phase(0)<LOSS_PHASE || read_phase(1)<LOSS_PHASE || read_phase(2)<LOSS_PHASE)
  { 
    RELAY=0;
    lcd_gotoxy(14,1);
    lcd_putchar(0xff);  
    lcd_putchar(0xff);
  }  
  else{  
    RELAY=1;
    lcd_gotoxy(14,1);
    lcd_putchar(0);  
    lcd_putchar(0);
  }
}

void display_PIN(unsigned char x, unsigned char y)
{
    /* 
        %pin = 100*((ADC - ADCmin)/(ADCmax-ADCmin))
        ADC: adc hien tai
        ADCmax: adc khi pin o muc maximum theo datasheet
        ADCmin: adc khi pin o muc pin can theo datasheet
    */
    float percent;  
    char pinBuffer[2];
    //percent=100*((878-767)/(920-767)); 
    if(adcPin<767) percent=0;
    else{ 
        percent=((adcPin-767)*100)/153;  
        if(percent>100) percent=100;
    }  
    lcd_gotoxy(x,y); 
    sprintf(pinBuffer,"%2.0f",percent);
    lcd_puts(pinBuffer); 
    lcd_puts("%");
    
    if(percent<30 && Charge_Flag==0){
       DDRD.5=1; // output  
       Charge_Flag=1;  
    } 
    if(percent>=100){
       DDRD.5=0; // input  
       Charge_Flag=0;
    }   
    if(Charge_Flag){
        readPin();
        lcd_gotoxy(11,0);
        lcd_putchar(0xB7);
    }else{
        lcd_gotoxy(11,0);
        lcd_putchar(0);
    }
}

/*******************************************************
  ----------------TIME & DATE-----------------------
*********************************************************/
void getTime()
{
    rtc_get_time(&hour,&minn,&sec);
    rtc_get_date(&day,&date,&month,&year);
}
void timeDisplay(unsigned char x, unsigned char y)
{
  lcd_gotoxy(x,y);
  lcd_putchar(48+(hour/10)); 
  lcd_putchar(48+(hour%10)); 
  lcd_puts(":");
  lcd_putchar(48+(minn/10)); 
  lcd_putchar(48+(minn%10));  
  lcd_puts(":");
  lcd_putchar(48+(sec/10)); 
  lcd_putchar(48+(sec%10));   
}
void dateDisplay(unsigned char x, unsigned char y)
{
  //lcd_gotoxy(x,y); 
  dayDisplay(x,y);
  lcd_putchar(48+(date/10)); 
  lcd_putchar(48+(date%10)); 
  lcd_puts("/");
  lcd_putchar(48+(month/10)); 
  lcd_putchar(48+(month%10)); 
  lcd_puts("/");
  lcd_putchar(48+(year/10)); 
  lcd_putchar(48+(year%10));
}
void dayDisplay(unsigned char x, unsigned char y)
{ int C;
switch (month)
             {
             case 1: C=date;
                     break;
             case 2: C=31+date;
                     break;
             case 3: if(year%4==0) C=60+date;
                     else C=59+date;
                     break;
             case 4: if((year%4)==0) C=91+date;
                     else C=90+date;
                     break;
             case 5: if((year%4)==0) C=121+date;
                     else C=120+date;
                     break;
             case 6: if((year%4)==0) C=152+date;
                     else C=151+date;
                     break;
             case 7: if((year%4)==0) C=182+date;
                     else C=181+date;
                     break;
             case 8: if((year%4)==0) C=213+date;
                     else C=212+date;
                     break;
             case 9: if((year%4)==0) C=244+date;
                     else C=243+date;
                     break;
             case 10:if((year%4)==0) C=274+date;
                     else C=273+date;
                     break;
             case 11:if((year%4)==0) C=305+date;
                     else C=304+date;
                     break;
             case 12:if((year%4)==0) C=335+date;
                     else C=334+date;
                     break;
             default:
             }
             lcd_gotoxy(x,y);
             //cong thuc tinh thu:
            // n=((years-1)+((years-1)/4)-((years-1)/100)+((years-1)/400)+C)%7
            // n: thu trong tuan (0=CN;1=T2.....6=t7)
            // C: ngay thu bao nhieu tu dau nam den hien tai
 switch(((2000+year-1)+((2000+year-1)/4)-((2000+year-1)/100)+((2000+year-1)/400)+C)%7)
            {
                case 0: lcd_puts("CN-"); break;
                case 1: lcd_puts("T2-"); break;
                case 2: lcd_puts("T3-"); break;
                case 3: lcd_puts("T4-"); break;
                case 4: lcd_puts("T5-"); break;
                case 5: lcd_puts("T6-"); break;
                case 6: lcd_puts("T7-"); break;
                default:
            }
}
void alarmOnDisplay(unsigned char x, unsigned char y)
{
    lcd_gotoxy(x,y);
    lcd_putchar(48+(hour_on/10)); 
    lcd_putchar(48+(hour_on%10)); 
    lcd_puts(":");
    lcd_putchar(48+(min_on/10)); 
    lcd_putchar(48+(min_on%10));  
}
void alarmOffDisplay(unsigned char x, unsigned char y)
{
    lcd_gotoxy(x,y);
    lcd_putchar(48+(hour_off/10)); 
    lcd_putchar(48+(hour_off%10)); 
    lcd_puts(":");
    lcd_putchar(48+(min_off/10)); 
    lcd_putchar(48+(min_off%10));  
}
void so_ngay(void)
{
  if(month==2)     // thang 2 nam nhuan co 29 ngay, nam thuong co 28 ngay
  {
   if(year%4==0)   //&&year%100!=0||year%400==0)
   {
    No_date=29;
   }
   else
   {
    No_date=28;
   };
  }

  else
  {
   if(month==4||month==6||month==9||month==11)
   {
    No_date=30;
   }

   else
   {
    if(month==1||month==3||month==5||month==7||month==8||month==10||month==12)
    {
     No_date=31;
    }
   };
  };

}
void setting(void)
{
//================================================
 if(mode==1)   //chinh phut
 {
   if(UP==0)  // phim "UP" nhan
        {
        if(minn==59)
            {
            minn=0;
            }
        else
            {
            minn++;
            };
        rtc_set_time(hour,minn,sec); 
        while(!UP); // doi nha phim 
        }
   //==============
   if(DOWN==0)        // phim "DOWN" nhan
        {
        if(minn==0)
            {
            minn=59;
            }
        else
            {
            minn--;
            }; 
        rtc_set_time(hour,minn,sec);
        while(!DOWN);
        }
 }
 //===============================
  if(mode==2)   //chinh gio
    {
   if(UP==0)  // phim "UP" nhan
        {
        if(hour==23)
            {
            hour=0;
            }
        else
            {
            hour++;
            };
        rtc_set_time(hour,minn,sec);
        while(!UP); // doi nha phim
        }
   //==============
   if(DOWN==0)        // phim "DOWN" nhan
        {
        if(hour==0)
            {
            hour=23;
            }
        else
            {
            hour--;
            }; 
        rtc_set_time(hour,minn,sec);
        while(!DOWN);
        }
    }
 //===============================
 if(mode==3) //chinh ngay
    {
    so_ngay();
    //================================
    if(UP==0) // phim "UP" nhan
        {
        if(date==No_date)
            {
            date=1;
            }
        else
            {
            date++;
            };
        rtc_set_date(day,date,month,year);
        while(!UP); 
        }
    //=========================================
    if(DOWN==0)        // phim "DOWN" nhan
        {

        if(date==1)
            {
            date=No_date;
            }
        else
            {
            date--;
            };
        rtc_set_date(day,date,month,year);
        while(!DOWN);
        }
    }
 //================================================
    if(mode==4)  //chinh thang
    {
        //==================================
    if(UP==0)
        {
        if(month==12)
            {
            month=1;
            }
        else
            {
            month++;
            }; 
        rtc_set_date(day,date,month,year);
        while(!UP);                                       // bao co phim nhan
        }
/////////////////////////////////////////////////////////////
    if(DOWN==0)
        {
        if(month==1)
            {
            month=12;
            }
        else
            {
            month--;
            }; 
        rtc_set_date(day,date,month,year);
        while(!DOWN);
        }
    }
    //=================================
    if(mode==5) //chinh nam
    {
    if(UP==0)
        {
        if(year==99)
            {
            year=0;
            }
        else
            {
            year++;
            };
        rtc_set_date(day,date,month,year);
        while(!UP);
        }
///////////////////////////////////////////////////////////////
    if(DOWN==0)
        {
        if(year==00)
            {
            year=99;
            }
        else
            {
            year--;
            }; 
        rtc_set_date(day,date,month,year);
        while(!DOWN);
        }
    }
}

void alarm(void)
{
   switch(index)
   {
    case 1:
        if(UP==0)
        {
            if(min_on==59)
                {
                min_on=0;
                }
            else
                {
                min_on++;
                }; 
            while(!UP); // doi nha phim 
        }   
        else if(DOWN==0)
        {
            if(min_on==0)
                {
                min_on=59;
                }
            else
                {
                min_on--;
                }; 
            while(!DOWN); // doi nha phim 
        }
        break; 
    case 2:
        if(UP==0)
        {
            if(hour_on==23)
                {
                hour_on=0;
                }
            else
                {
                hour_on++;
                }; 
            while(!UP); // doi nha phim 
        }   
        else if(DOWN==0)
        {
            if(hour_on==0)
                {
                hour_on=23;
                }
            else
                {
                hour_on--;
                }; 
            while(!DOWN); // doi nha phim 
        }
        break;
    case 3:
        if(UP==0)
        {
            if(min_off==59)
                {
                min_off=0;
                }
            else
                {
                min_off++;
                }; 
            while(!UP); // doi nha phim 
        }   
        else if(DOWN==0)
        {
            if(min_off==0)
                {
                min_off=59;
                }
            else
                {
                min_off--;
                }; 
            while(!DOWN); // doi nha phim 
        }
        break; 
    case 4:
        if(UP==0)
        {
            if(hour_off==23)
                {
                hour_off=0;
                }
            else
                {
                hour_off++;
                }; 
            while(!UP); // doi nha phim 
        }   
        else if(DOWN==0)
        {
            if(hour_off==0)
                {
                hour_off=23;
                }
            else
                {
                hour_off--;
                }; 
            while(!DOWN); // doi nha phim 
        }
        break;   
    case 5:
        if(UP==0)
        {
            alarm_flag++;
            if(alarm_flag>1) alarm_flag=0;
            while(!UP); // doi nha phim 
        }   
        else if(DOWN==0)
        {
            alarm_flag--;
            if(alarm_flag<0) alarm_flag=1;
            while(!DOWN); // doi nha phim 
        }
        break;
         
   }
}