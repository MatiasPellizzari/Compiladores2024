#include "value_table.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


struct Node* insertAtHead(struct Node* head, Tuple data) {
    struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
    newNode->data = data;
    newNode->next = head;
    return newNode;
}

struct Node* insertAtTail(struct Node* head, Tuple data) {
    struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
    newNode->data = data;
    newNode->next = NULL;

    if (head == NULL) {
        return newNode;
    }

    struct Node* temp = head;
    while (temp->next != NULL) {
        temp = temp->next;
    }

    temp->next = newNode;

    return head;
}

void printList(struct Node* head) {
    struct Node* temp = head;
    while (temp != NULL) {
        printf("ID: %s, ValueType: %d, Value: %d\n", temp->data.id, temp->data.valuetype, temp->data.value);  // Use %s for string
        temp = temp->next;
    }
}

void freeList(struct Node* head) {
    struct Node* temp;
    while (head != NULL) {
        temp = head;
        head = head->next;
        free(temp->data.id);  // Free the duplicated string
        free(temp);            // Free the node
    }
}

void insertToTable(char* newid, int newvaluetype, int newvalue, struct Node* head) {
    Tuple newTuple;
    newTuple.id = strdup(newid);
    newTuple.valuetype = newvaluetype;
    newTuple.value = newvalue;

    head = insertAtTail(head, newTuple);  // Just pass head, no need for ** if not modifying it
}

Tuple* searchId(char* ID, struct Node* head) {
    if (head != NULL) {  
        if (strcmp(head->data.id, ID) == 0) { // Compare only the first character
            return &head->data;  
        } else {
            return searchId(ID, head->next);  
        }
    } else {
        printf("Error: ID not found.\n");
        return NULL; 
    }
}