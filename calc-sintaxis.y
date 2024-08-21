%{

#include <stdlib.h>
#include <stdio.h>

%}
 
%token INT
%token TRUE FALSE
%token ID
%token TMENOS
%token BOOL
%token RET

%type expr
%type VALOR
%type boolean

%left '+' '-'
%left '*'
%left AND OR
%%
 
prog: sents
; 
sents : sent
| sent sents
;

sent: ID '=' expr ';'  { printf("No hay errores \n"); } 
    | RET expr ';'     { printf("return");}
    ;


expr: VALOR               
 
    | expr '+' expr    { $$ = $1 + $3;}
    
    | expr '*' expr    { $$ = $1 * $3;}  

    | expr '-' expr    { $$ = $1 - $3;} 

    | '(' expr ')'     { $$ = $2;} 

    | expr AND expr    { $$ = $1 && $3; }

    | expr OR expr     { $$ = $1 || $3; }

    | ID  {printf("variable");}

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


