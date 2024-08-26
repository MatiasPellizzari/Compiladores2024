%{

#include <stdlib.h>
#include <stdio.h>

%}
 
%token INT
%token TRUE FALSE
%token ID
%token TMENOS
%token BOOL
%token MAIN VOID RET

%type expr
%type VALOR
%type boolean

%left '+' '-'
%left '*'
%left AND OR
%%
 
prog: main_func; 

main_func: type MAIN '(' ')' '{' decls sents '}' 
         | VOID MAIN '(' ')' '{' decls sents '}'
         ;

decl: type ID ';' { printf("Declaración de variable: %s\n", $2);}
    ;

decls: decl
     | decl decls ;

sent: ID '=' expr ';'  { printf("Asignación: %s = %d\n", $1, $3); } 
    | RET expr ';'     { printf("Return: %d\n", $2); }
    ;

sents: sent
     | sent sents ;


type: INT  { $$ = 1; }
    | BOOL { $$ = 0; }
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
 
%%


