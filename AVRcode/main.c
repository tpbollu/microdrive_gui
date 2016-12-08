#include<avr/io.h>
#include<avr/interrupt.h>

char count_time = 0;
char RX_message = 0;
char start_flag=0;
char pulse_flag=0;

ISR(USART_RX_vect)
{
 //Recieved USART complete
  RX_message = UDR0;
  start_flag = 1;
}

ISR(TIMER0_COMPA_vect)
{
 count_time++;
}

int main()
{
 char pulse_time=0;
 SREG = 0x80; //Global Interrupt Enable
 //DDRB = 0xFF; 

 //USART Initialization
 UCSR0A = 0x00;
 UCSR0B = 0x98; //Enable Transmitter and Reciever
 UCSR0C = 0x06; //Synchronous,8-bit
 UBRR0H = 0x00;
 UBRR0L = 51;
 DDRC = 0xFF;
 PORTC = 0x00;
 DDRB = 0xFF;
 PORTB = 0x00;
 
 //Timer Setup
 TCCR0A = 0x00;
 TCCR0B =0x04;
 TIMSK0 =0x00; 	
 OCR0A = 0xFF;
 
 while(1){
  if(start_flag==1 && pulse_flag==0){
   pulse_time = RX_message;
   
   if(RX_message>128){
	  PORTC = 0x01;
	  PORTB = 0x20;
	  pulse_time = RX_message-128;
	  pulse_flag = 1;
   }
   else{
	  PORTC = 0x03;
	  PORTB = 0x20;
	  pulse_time = RX_message;
	  pulse_flag = 1;
   }
   
   TIMSK0=0x02;
  }

 if(count_time>pulse_time) {
   TIMSK0=0x00;
   PORTC = 0x00;
   PORTB = 0x00;
   count_time=0;
   pulse_flag = 0;
   start_flag=0;
  } 
 }
}
