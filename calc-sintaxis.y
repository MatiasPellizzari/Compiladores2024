%{
#include "tree_builder.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
%}

%union { 
    ASTNode* Node; 
    char *id;
    int value; 
}

%token <ival> INT
%token TRUE FALSE
%token <name> ID
%token TMENOS
%token BOOL
%token MAIN VOID RET

%type <Node> prog main_func decl decls sent sents  expr
%type <int> type VALOR boolean

%left '+' '-'
%left '*'
%left AND OR
%%
 
prog: main_func { ASTNode* program = createNode(NODE_PROGRAM);
                  program->function = $1;}
      ; 

main_func: type MAIN '(' ')' '{' decls sents '}' { ASTNode* function = createNode(NODE_PROGRAM);
                                                   function->data.function.returnType = $1;
                                                   function->data.function.decls = $6;
                                                   function->data.function.sents = $7; }
         | VOID MAIN '(' ')' '{' decls sents '}' { ASTNode* function = createNode(NODE_PROGRAM);
                                                   function->data.function.returnType = VOID;
                                                   function->data.function.decls = $6;
                                                   function->data.function.sents = $7; }
         ;

decl: type ID ';' { printf("Declaración de variable \n");
                    ASTNode* declaration = createNode(NODE_DECLARATION);
                    declaration->data.declaration.valuetype = $1;
                    declaration->data.declaration.identifier = $2;
                    }
    ;

decls: decl
     | decl decls;

sent: ID '=' expr ';'  { printf("Asignación \n");
                         ASTNode* assignment = createNode(NODE_ASSIGNMENT);
                         assignment -> data.assignment.valuetype = $1;
                         assignment -> data.assignment.identifier = $3; } 
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



VALOR: INT { $$ =createNode(NODE_LITERAL);
             $$->data.literal.value = $1;
             $$->data.literal.valuetype = INTVALUE; }
    ;

boolean: TRUE { $$ =createNode(NODE_LITERAL);
                $$->data.literal.value = 1;
                $$->data.literal.valuetype = BOOLVALUE; }
       | FALSE { $$ =createNode(NODE_LITERAL);
                 $$->data.literal.value = 0;
                 $$->data.literal.valuetype = BOOLVALUE; }
    ;      
%%