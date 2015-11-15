/* mipslabwork.c

   This file written 2015 by F Lundevall

   This file should be changed by YOU! So add something here:

   This file modified 2015-12-24 by Ture Teknolog 

   Latest update 2015-08-28 by F Lundevall

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int mytime = 0x5957;

char textstring[] = "text, more text, and even more text!";

/* Interrupt Service Routine */
void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  volatile int* trise = (volatile int*) 0xbf886100; // 8 sista satta till 0 (Output)
  *trise = 0x00;
  TRISD = 0xfe0; // [11:5] Som input. Resten output
  return;
}

/* This function is called repetitively from the main program */
void labwork( void )
{
  delay( 1000 );
  time2string( textstring, mytime );
  display_string( 3, textstring );

  display_update();
  getbtns();

  if (getbtns() == 1)
    mytime += (getsw() << 4);
  
  if (getbtns() == 2)
    mytime += (getsw() << 8);

  if (getbtns() == 4)
    mytime += (getsw() << 12);


  volatile int* porte = (volatile int*) 0xbf886110;
  tick( &mytime );
  *porte += 1;
  display_image(96, icon);
}
