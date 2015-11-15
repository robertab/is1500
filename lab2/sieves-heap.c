/*
Assignment 3.
print_sieves()
By Robert Åberg
Labpartner: Sara Ervik
*/



#include <stdio.h>
#include <stdlib.h>


#define COLUMNS 6
int counter = 0; //Global counter.


void print_number(int n){
  printf("%10d\t", n);
  if (counter == COLUMNS){
    counter = 0;
    printf("\n");
  }
}
  
void print_sieves(int n){
  int i, j, k, s;
  int *primeList;

  primeList = malloc(n * sizeof(int));

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
  for (s = 0; s < n; s++) {
    if (primeList[s]){
      counter++;
      print_number(s);
    }
  }
  free(primeList);
}

int main(int argc, char *argv[]){
  if(argc == 2)
    print_sieves(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}
