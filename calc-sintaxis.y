%{

#include <stdlib.h>
#include <stdio.h>

%}
 
%token INT
%token TRUE FALSE
%token ID
%token TMENOS
%token BOOL

%type expr
%type VALOR
%type boolean

%left '+' '-'
%left '*'
%left AND OR
%left THEN
%%
 
prog: expr ';'  { printf("No hay errores \n"); } 
    ;
  
expr: VALOR               

    | expr '+' expr    { $$ = $1 + $3;}
    
    | expr '*' expr    { $$ = $1 * $3;}  

    | expr '-' expr    { $$ = $1 - $3;} 

    | '(' expr ')'     { $$ = $2;} 

    | expr AND expr    { $$ = $1 && $3; }

    | expr OR expr     { $$ = $1 || $3; }

    | boolean          { $$ = $1; }  
    ;
VALOR : INT              
    ;

boolean:
    | TRUE    { $$ = 1;}
      
    | FALSE   { $$ = 2;}
    ;
boolean : BOOL
    ;      
 
%%


