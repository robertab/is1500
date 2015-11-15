/* mipslabwork.c

   This file written 2015 by F Lundevall

   This file should be changed by YOU! So add something here:

   This file modified 2015-12-24 by Ture Teknolog 

   Latest update 2015-08-28 by F Lundevall

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

/*Ett macro som kollar om periodregistret blir för stort. Maxgräms på 16 bitar.*/
#define TIMER2PERIOD ((80000000 / 256) / 10) / 8
#if TIMER2PERIOD > 0xffff
#error "Timer period is too big."
#endif

int prime = 1234567;
int timeoutcount = 0; //Global räknare

int mytime = 0x5957;

char textstring[] = "text, more text, and even more text!";

/* Interrupt Service Routine */
void user_isr( void )
{
  IFS(0) = 0 << 8; // Sätter interrupt flag till 0
  timeoutcount += 1; // 

  if (timeoutcount == 10) {

    time2string ( textstring, mytime );
    display_string( 3, textstring );
    display_update();
    tick( &mytime );
    timeoutcount = 0;
 
  }
  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  volatile int* trise = (volatile int*) 0xbf886100; // 8 sista satta till 0 (Output)
  TRISD = 0xfe0; // [11:5] Som input. Resten output
  
  PR2 = TIMER2PERIOD;
  TMR2 = 0;
  T2CON = 0x70; // Sätter prescale till 1:256
  
  IEC(0) = 0x100; // Sätter tmr2 interrupt enable
  IPC(2) = 0x4; // Sätter icke-noll prio till de tre bitarna.
  T2CONSET = 0x8000; // Startar timern
  enable_interrupt();
  return;
}

/* This function is called repetitively from the main program */
void labwork( void )
{
  
  prime = nextprime ( prime );
  display_string ( 0, itoaconv( prime ));
  display_update();
}
