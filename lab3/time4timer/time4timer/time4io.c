/* time4io.c
   
   Author: Robert Åberg, Sara Ervik
   Lab3 I/O Programming   

 */


#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"


int getsw ( void );
int getbtns ( void );

/*This function returns the value from the input-read
value of switches */
int getsw( void ) { 
  int switches;

  switches = (PORTD >> 8) & 0xf;
  if (switches == 4)
    return switches - 1;

  if (switches == 8)
    return switches - 4;

  else
    return switches;
  
}

/* This function returns the input-read value of the buttons*/
int getbtns( void ) {
  int buttons;

  buttons = (PORTD >> 5) & 0x7;
  return buttons;
}



  
