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

main_func: type MAIN '(' ')' '{' decls sents ret_stmt '}' 
         | VOID MAIN '(' ')' '{' decls sents ret_stmt '}'
         ;

decls: /* vacío */
     | decl decls ;

decl: type ID ';' { printf("Declaración de variable: %s\n", $2); }
    ;

ret_stmt: RET expr ';' { printf("Return: %d\n", $2); }
        | RET ';'     { printf("Return void\n"); }
        ;

sents: /* vacío */
     | sent sents ;

sent: ID '=' expr ';'  { printf("Asignación: %s = %d\n", $1, $3); } 
    | RET expr ';'     { printf("Return: %d\n", $2); }
    ;

main_func: type MAIN '(' ')' '{' decls sents ret_stmt '}' 
         | VOID MAIN '(' ')' '{' decls sents ret_stmt '}'
         ;

type: INT  { $$ = 1; }
    | BOOL { $$ = 0; }
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


