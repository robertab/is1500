/*
Assignment 3.
print_sieves()
By Robert Åberg
Labpartner: Sara Ervik
*/





#include <stdio.h>
#include <stdlib.h>


#define COLUMNS 6
int counter = 0;


void print_number(int n){
  printf("%10d\t", n);
  if (counter == COLUMNS){
    counter = 0;
    printf("\n");
  }
}
  
void print_sieves(int n){
  int i, j, k, s;
  int primeList[n];
  for (i = 2; i <= n; i++) {
    primeList[i] = 1;
  }
  for (j = 2; j*j <= n ; j++) {
    if (primeList[j]){
      for (k = j*j ; k <= n ; k += j) {
	primeList[k] = 0;
      }
    }
  }
  int y = 2;
  int distCounter = 0;
  // For loop for printing the values.
  for (s = 2; s <= n; s++) {
    if (primeList[s]){
      int x = s;
      if ((x - y) == 4)
	distCounter += 1;
      counter++;
      print_number(s);
      y = x;    
    }
  }
  printf("\n\n%s%d\n","The number of times the distance is 4 is: ", distCounter);
  
}



int main(int argc, char *argv[]){
  if(argc == 2)
    print_sieves(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}
