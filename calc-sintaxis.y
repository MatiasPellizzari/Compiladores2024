%{
#include "tree_builder.h"
#include "value_table.c"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#define VOIDTYPE JUSTVOID 
int yylex();
void yyerror(const char *s);
struct Tuple* head;
void initializehead() {
    head = (struct Tuple*)malloc(sizeof(struct Tuple));
}
%}

%union { 
    struct ASTNode* Node; ; 
    char *id;
    int value; 
    int valuetype;
}

%token <value> INT
%token TRUE FALSE
%token <id> ID
%token TMENOS
%token BOOL
%token VOID 
%token MAIN RET

%type <Node> prog main_func decl decls sent sents  expr
%type <valuetype> type VALOR boolean

%left '+' '-'
%left '*'
%left AND OR
%%
 
prog: main_func { ASTNode* program = createNode(NODE_PROGRAM);
                  program->data.function.returnType = $1->data.function.returnType;
                  program->data.function.decls = $1->data.function.decls;
                  program->data.function.sents = $1->data.function.sents;
                  printAST(program);}
      ; 

main_func: type MAIN '(' ')' '{' decls sents '}' { ASTNode* function = createNode(NODE_PROGRAM);
                                                   function->data.function.returnType = $1;
                                                   function->data.function.decls = $6;
                                                   function->data.function.sents = $7;
                                                   $$=function; }
         | VOID MAIN '(' ')' '{' decls sents '}' { ASTNode* function = createNode(NODE_PROGRAM);
                                                   function->data.function.returnType = VOIDTYPE;
                                                   function->data.function.decls = $6;
                                                   function->data.function.sents = $7;
                                                   $$=function; }
         ;

decl: type ID ';' { //printf("Declaración de variable \n");
                    ASTNode* declaration = createNode(NODE_DECLARATION);
                    declaration->data.declaration.valuetype = $1;
                    declaration->data.declaration.identifier = $2;
                    insertToTable(declaration->data.declaration.identifier,declaration->data.declaration.valuetype,0,head);
                    $$=declaration;
                    }
    ;

decls: decl { $$ = $1; }
     | decl decls { 
                     $1->next = $2;
                     $$ = $1;  };

sent: ID '=' expr ';'  { //printf("Asignación \n");
                         ASTNode* assignment = createNode(NODE_ASSIGNMENT);
                         assignment -> data.assignment.identifier= $1;
                         assignment -> data.assignment.value = $3;
                         $$= assignment; } 
    | RET expr ';'     { //printf("Return: %d\n", $2); 
                         ASTNode* returnnode = createNode(NODE_RETURN);
                         returnnode -> data.returnnode.returnvalue= $2;
                         $$= returnnode;
                          }
    ;

sents: sent { $$ = $1; }
     | sent sents  { 
                     $1->next = $2;
                     $$ = $1;  };

type: INT  { $$ = INTVALUE; }
    | BOOL { $$ = BOOLVALUE; }
    ;

expr: VALOR { 
           ASTNode* literal = createNode(NODE_LITERAL); 
           literal -> data.literal.value = $1; 
           $$ = literal;
      }
    | expr '+' expr { 
          ASTNode* addition  = createNode(NODE_BINARY_OPERATION); 
          addition -> data.binaryOperation.left = $1;
          addition -> data.binaryOperation.right = $3;
          addition -> data.binaryOperation.operator = '+'; 
          $$ = addition;
      }
    | expr '*' expr { 
          ASTNode* multiplication = createNode(NODE_BINARY_OPERATION); 
          multiplication -> data.binaryOperation.left = $1 ;
          multiplication -> data.binaryOperation.right = $3 ;
          multiplication -> data.binaryOperation.operator = '*'; 
          $$ = multiplication;
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
          ASTNode*  declaration = createNode(NODE_DECLARATION); 
          declaration ->data.declaration.identifier = $1; 
          $$ = declaration;
      }
    | boolean { 
          ASTNode* literal = createNode(NODE_LITERAL); 
          literal -> data.literal.value = $1; 
          $$ = literal; 
      }
    ;

VALOR: INT { 
    ASTNode*  literal = createNode(NODE_LITERAL);
    literal->data.literal.value = $1;
    literal->data.literal.valuetype = INTVALUE; 
    $$ = literal;
}
boolean: TRUE { ASTNode* literal =createNode(NODE_LITERAL);
                literal ->data.literal.value = 1;
                literal ->data.literal.valuetype = BOOLVALUE;
                $$ = literal; }
       | FALSE { ASTNode* literal =createNode(NODE_LITERAL);
                 literal ->data.literal.value = 0;
                 literal ->data.literal.valuetype = BOOLVALUE;
                 $$ = literal; }
    ;      
%%