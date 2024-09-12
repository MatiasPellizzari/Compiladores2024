#ifndef TREE_BUILDER_H
#define TREE_BUILDER_H

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
    INTVALUE,
    BOOLVALUE,
    JUSTVOID
} ValueType;

typedef struct ASTNode {
    NodeType type;
    union {
        struct {
            ValueType returnType;
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
        struct{
            char* identifier; 
            int value;
            ValueType valuetype;
        } assignment;
         struct{
            int value;
            ValueType valuetype;
        } literal;
    } data;
    struct ASTNode* next;
} ASTNode;

ASTNode* createNode(NodeType type);
void printAST(ASTNode* node, int indent);

#endif
