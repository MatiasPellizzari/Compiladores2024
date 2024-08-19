%{

#include <stdlib.h>
#include <stdio.h>

%}
 
%token INT
%token BOOL
%token ID
%token TMENOS

%type expr
%type VALOR
    
%left '+' '-'
%left '*'
 
%%
 
prog: expr ';'  { printf("No hay errores \n"); } 
    ;
  
expr: VALOR               

    | expr '+' expr    
    
    | expr '*' expr

    | expr '-' expr  

    | '(' expr ')'      
    ;


VALOR : INT              
       ;
 
%%


