%{
#include "tree_builder.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
%}

%union { 
    ASTNode *Node; 
    char *id;
    int value; 
}

%token <ival> INT
%token TRUE FALSE
%token <name> ID
%token TMENOS
%token BOOL
%token MAIN VOID RET

%type <Node> prog main_func decl decls sent sents type expr
%type <int> VALOR boolean

%left '+' '-'
%left '*'
%left AND OR
%%

prog: main_func;

main_func: type MAIN '(' ')' '{' decls sents '}' { $$ = $1; } 
         | VOID MAIN '(' ')' '{' decls sents '}' { $$ = NULL; }
         ;

decl: type ID ';' { 
          $$ = createNode(NODE_DECLARATION); 
          $$->data.declaration.value = $1; 
      }
    ;

decls: decl
     | decl decls;

sent: ID '=' expr ';'  { printf("Asignación: %s = %d\n", $1, $3); } 
    | RET expr ';'     { printf("Return: %d\n", $2); }
    ;

sents: sent
     | sent sents;

type: INT  { $$ = 1; }
    | BOOL { $$ = 0; }
    ;

expr: VALOR { 
          $$ = createNode(NODE_LITERAL); 
          $$->data.declaration.value = $1; 
      }
    | expr '+' expr { 
          $$ = createNode(NODE_BINARY_OPERATION); 
          $$->data.binaryOperation.left = $1;
          $$->data.binaryOperation.right = $3;
          $$->data.binaryOperation.operator = '+'; 
      }
    | expr '*' expr { 
          $$ = createNode(NODE_BINARY_OPERATION); 
          $$->data.binaryOperation.left = $1;
          $$->data.binaryOperation.right = $3;
          $$->data.binaryOperation.operator = '*'; 
      }
    | expr '-' expr { 
          $$ = createNode(NODE_BINARY_OPERATION); 
          $$->data.binaryOperation.left = $1;
          $$->data.binaryOperation.right = $3;
          $$->data.binaryOperation.operator = '-'; 
      }
    | '(' expr ')' { 
          $$ = $2; 
      }
    | expr AND expr { 
          $$ = createNode(NODE_BINARY_OPERATION); 
          $$->data.binaryOperation.left = $1;
          $$->data.binaryOperation.right = $3;
          $$->data.binaryOperation.operator = 'Y'; 
      }
    | expr OR expr { 
          $$ = createNode(NODE_BINARY_OPERATION); 
          $$->data.binaryOperation.left = $1;
          $$->data.binaryOperation.right = $3;
          $$->data.binaryOperation.operator = 'O'; 
      }
    | ID { 
          $$ = createNode(NODE_DECLARATION); 
          $$->data.declaration.identifier = $1; 
      }
    | boolean { 
          $$ = createNode(NODE_DECLARATION); 
          $$->data.declaration.value = $1; 
      }
    ;



VALOR: INT { $$ = $1; }
    ;

boolean: TRUE { $$ = 1; }
       | FALSE { $$ = 0; }
    ;      
%%