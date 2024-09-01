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

typedef enum{
    INT,
    BOOL
}   ValueType;

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
            ValueType valuetype;
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


void buildTree(ASTNode father,ASTNODE addition){
    if(father.type == NODE_FUNCTION){
        if(addition.type == NODE_DECLARATION){
            buildTree(father.decls,addition);
        }else{
            buildTree(father.sents,addition);
        }
    }
    switch(addition.type){
        case NODE_DECLARATION:
           if(father.next == NULL){
                father.next = addition;
           }else{
                buildTree(father.next , addition);
           }
        break;
        case NODE_BINARY_OPERATION:
            if(father.next == NULL){
                father.next = addition;
                addition.left = buildSubTree(addition.left);
                addition.right= buildSubTree(addition.right);
            }else{
                buildTree(father.next , addition);
            }
            break;
        default:        
           if(father.next == NULL){
                father.next = addition;
           }else{
                buildTree(father.next , addition);
           }
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
