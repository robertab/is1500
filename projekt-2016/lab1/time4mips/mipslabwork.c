/* mipslabwork.c

   This file written 2015 by F Lundevall

   This file should be changed by YOU! So add something here:

   This file modified 2015-12-24 by Ture Teknolog 

   Latest update 2015-08-28 by F Lundevall

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declarations for these labs */

int question_counter  = 0;
char answerA[] = "A: TEXT EDITOR";
char answerB[] = "B: CAR";
char answerC[] = "C: ROBOT";
char answerD[] = "D: DOESN'T EXIST";

char question[]	      = "WHAT IS EMACS?";

char yesno[]	      = "Y:SW4, N:SW3";
char correct_answer[] = "YOU ARE CORRECT!";
char wrong_answer[]   = "BETTER LUCK NEXT TIME!";
char error_message[]  = "PULL DOWN SW";
char continue_play[]  = "PRESS ANY BUTTON";
char final_message[] = "CONGRATULATIONS, YOU WON";

char* questions[10]    = {"WHAT IS EMACS?", "WHICH ONE IS FLOAT?"};
char* points[10]      = {"1000 P", "2000 P"};

void answers(void);
void exit(void);

/* INTERRUPT Service Routine */
void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  volatile int* trise = (volatile int*) 0xbf886100; // 8 sista satta till 0 (Output)
  TRISD = 0xfe0; // [11:5] Som input. Resten output
  return;
}



void print_questions(void) {
  if (question_counter == 1) display_string(2, yesno);
  while (1) {
    if (getsw() == 4) answers();
    //    else if (getsw() == 3) display_string(0, wrong_answer);
    if (getsw() == 3) exit();
    else {
      display_update();      
      display_string( 0, points[question_counter] );
      display_string( 1, question_counter] );
      display_string( 3, yesno );

    }
  }
}

void user_choice(void) {
  int a,i = 0;
  for (i=0; i<3000000; i++) {
    a++;
  }

  while(1){
    if (getbtns() == 4) print_questions();
    else{
      display_string(0, correct_answer);
      display_string(3, continue_play);
      display_update();
    }
  }
}

void answers(void) {
  while(1){
    if (getsw() > 0) {
      display_string(0, error_message);
      display_update();
    }
    else if (getsw() == 0 && getbtns() == 4){
      question_counter++;        
      user_choice();
    }
    else {
      display_string( 0, answerA);
      display_string( 1, answerB); 
      display_string( 2, answerC);
      display_string( 3, answerD);
      display_update();
    }
  }
}

void exit(void) {
  while(1){
    display_string(0, final_message);
    display_update();
  }

}


void labwork( void )
{
  print_questions();
  display_update();
}
