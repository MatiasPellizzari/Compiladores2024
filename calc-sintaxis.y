%{

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tree_builder.c" 

%}
 
%union {*astNode Node; *char name;} 
%token INT
%token TRUE FALSE
%token ID
%token TMENOS
%token BOOL
%token MAIN VOID RET

%type expr
%type VALOR
%type boolean
%type <Node> prog main_func decl decls sent sents type expr VALOR boolean

%left '+' '-'
%left '*'
%left AND OR
%%
 
prog: main_func { astNode* program = tree_builder.createNode(NODE_PROGRAM);
                  program->function = $1}
      ; 

main_func: type MAIN '(' ')' '{' decls sents '}' { astNode* function = tree_builder.createNode(NODE_PROGRAM);
                                                   function->returnType = $1;
                                                   function-> decls = $7;
                                                   function-> sents = $8; }
         | VOID MAIN '(' ')' '{' decls sents '}' { astNode* function = tree_builder.createNode(NODE_PROGRAM);
                                                   function->returnType = $1;
                                                   function-> decls = $7;
                                                   function-> sents = $8; }
         ;

decl: type ID ';' { printf("Declaración de variable \n");
                    astNode* declaration = tree_builder.createNode(NODE_DECLARATION);
                    declaration -> valuetype = $1;
                    declaration -> identifier = $2;}
    ;

decls: decl
     | decl decls ;

sent: ID '=' expr ';'  { printf("Asignación \n");
                         astNode* asignation = tree_builder.createNode(NODE_DECLARATION);
                         declaration -> valuetype = $1;
                         declaration -> identifier = $2; } 
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


