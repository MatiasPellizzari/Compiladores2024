#include <string.h>

typedef enum {
    NODE_PROGRAM,
    NODE_FUNCTION,
    NODE_DECLARATION,
    NODE_ASSIGNMENT,
    NODE_RETURN,
    NODE_BINARY_OPERATION,
    NODE_LITERAL,
    NODE_IDENTIFIER
} NodeType;

typedef struct ASTNode {
    NodeType type;
    union {
        struct {
            struct ASTNode* decls;
            struct ASTNode* sents;
        } function;
        struct {
            struct ASTNode* left;
            struct ASTNode* right;
            char operator;
        } binaryOperation;
        struct{
            char* identifier; 
            int value;
        } declaration;
    } data;
    struct ASTNode* next;
} ASTNode;

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
            node->data.declaration.value= NULL;
            break;
        case NODE_BINARY_OPERATION:
            node->data.binaryOperation.left= NULL;
            node->data.binaryOperation.right=NULL;
            break;    
    }
}



// Function to print the AST (for debugging purposes)
void printAST(ASTNode* node, int indent) {
    if (!node) return;
    for (int i = 0; i < indent; i++) printf("  ");
    switch (node->type) {
        case NODE_PROGRAM:
            printf("Program\n");
            printAST(node->data.function.decls, indent + 1);
            printAST(node->data.function.sents, indent + 1);
            break;
        case NODE_FUNCTION:
            printf("Function\n");
            printAST(node->data.function.decls, indent + 1);
            printAST(node->data.function.sents, indent + 1);
            break;
        case NODE_DECLARATION:
            printf("Declaration: %s\n", node->data.declaration.identifier);
            break;
        case NODE_ASSIGNMENT:
            printf("Assignment: %s\n", node->data.declaration.identifier);
            printAST(node->data.binaryOperation.right, indent + 1);
            break;
        case NODE_RETURN:
            printf("Return\n");
            printAST(node->data.binaryOperation.left, indent + 1);
            break;
        case NODE_BINARY_OPERATION:
            printf("Binary Operation: %c\n", node->data.binaryOperation.operator);
            printAST(node->data.binaryOperation.left, indent + 1);
            printAST(node->data.binaryOperation.right, indent + 1);
            break;
        case NODE_LITERAL:
            printf("Literal: %d\n", node->data.declaration.value);
            break;
        case NODE_IDENTIFIER:
            printf("Identifier: %s\n", node->data.declaration.identifier);
            break;
    }
    printAST(node->next, indent);
}

void buildTree(ASTNode father,ASTNode childr,ASTNode childl){


}
