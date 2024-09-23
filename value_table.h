#ifndef VALUE_TABLE_H
#define VALUE_TABLE_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Tuple struct definition
typedef struct {
    char* id;          // The ID, changed to a char* if using strings 
    int valuetype;    // The type of the value (e.g., int, bool, etc.)
    int value;        // The actual value stored in the tuple
} Tuple;

// Node struct definition for linked list
struct Node {
    Tuple data;           // The tuple stored in this node
    struct Node* next;    // Pointer to the next node
};

// Function declarations for the value table operations
struct Node* insertAtHead(struct Node* head, Tuple data);
struct Node* insertAtTail(struct Node* head, Tuple data);
void printList(struct Node* head);
void freeList(struct Node* head);
void insertToTable(char* newid, int newvaluetype, int newvalue, struct Node* head);
Tuple* searchId(char* ID, struct Node* head);

#endif  // VALUE_TABLE_H