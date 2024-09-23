#include <string.h>
#include "tree_builder.h"
#include <stdio.h>
#include <stdlib.h>

ASTNode* createNode( NodeType type){
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = type;
    node->next = NULL;
    switch(type){
        case NODE_FUNCTION:
            node->data.function.decls = NULL;
            node->data.function.sents = NULL;
            break;
        case NODE_DECLARATION:
            node->data.declaration.identifier= NULL;
            node->data.declaration.value= 0;
            break;
        case NODE_ASSIGNMENT:
            node->data.assignment.receiver= NULL;
            node->data.assignment.value= 0;
            break;       
        case NODE_BINARY_OPERATION:
            node->data.binaryOperation.left= NULL;
            node->data.binaryOperation.right=NULL;
            break;    
        case NODE_LITERAL:
            node->data.literal.value= 0;
            break;    
    }
    return node;
}


// Function to print the AST (for debugging purposes) without indentation
void printAST(ASTNode* node) {
    if (!node) return;

    switch (node->type) {
        case NODE_PROGRAM:
            printf("Program:\n");
            printAST(node->data.function.decls);  // Print declarations
            printAST(node->data.function.sents);  // Print statements
            break;

        case NODE_FUNCTION:
            printf("Function:\n");
            printAST(node->data.function.decls);  // Print declarations inside the function
            printAST(node->data.function.sents);  // Print function body statements
            break;

        case NODE_DECLARATION:
            printf("Declaration: %s\n", node->data.declaration.identifier);  // Print identifier
            break;

         case NODE_ASSIGNMENT:
            printf("Assignment: %s = \n", node->data.assignment.receiver);  // Print variable being assigned
            printAST(node->data.assignment.value);
            //printf("ValueType: %d\n", node->data.assignment.valuetype);  // Print the value type (not an AST node)
            break;

        case NODE_RETURN:
            printf("Return:\n");
            printAST(node->data.returnnode.returnvalue);  // Print return value (an AST node)
            break;

        case NODE_BINARY_OPERATION:
            printf("Binary Operation: %c\n", node->data.binaryOperation.operator);  // Print operator
            printAST(node->data.binaryOperation.left);  // Print left operand
            printAST(node->data.binaryOperation.right);  // Print right operand
            break;

        case NODE_LITERAL:
            printf("Literal: %d\n", node->data.literal.value);  // Print literal value
            break;

        case NODE_IDENTIFIER:
            printf("Identifier: %s\n", node->data.declaration.identifier);  // Print identifier name
            break;

        default:
            printf("Unknown node type!\n");  // Handle any unknown node types
            break;
    }

    // Move to the next node in the list (if any)
    printAST(node->next);
}