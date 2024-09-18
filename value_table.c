#include "tree_builder.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct Tuple{
    char id;           
    ValueType valuetype; 
    int value;        
} Tuple;

struct Node {
    Tuple data;
    struct Node *next;
};

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
        printf("ID: %c, ValueType: %d, Value: %d\n", temp->data.id, temp->data.valuetype, temp->data.value);
        temp = temp->next;
    }
}

void freeList(struct Node* head) {
    struct Node* temp;
    while (head != NULL) {
        temp = head;
        head = head->next;
        free(temp);
    }
}

void insertToTable(char newid,ValueType newvaluetype , int newvalue, struct Node* head){
    struct Tuple newTuple; 
    newTuple.id = newid;
    newTuple.valuetype = newvaluetype;
    newTuple.value = newvalue;
    insertAtTail(head,newTuple);
}

Tuple searchId(char ID , struct Node* head){
    if(head->next != NULL){
        if(head->data.id == ID){
            return head->data;
        }else{
            return searchId(searchId,head->next);
        }
    }else{
        if(head->data.id==ID){
            return head->data;
        }else{
             printf("Error: ID not found.\n");
        }
    }

}