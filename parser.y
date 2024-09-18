%{
void yyerror (const char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>
char * entity_id;
extern int yylineno; 
extern char *yytext;

bool flag=true;

typedef struct Node{
	char *key;
	char *value;
	struct Node*next;
} Node;
Node *head = NULL;
Node *createNode(const char *key, const char *value);
bool insert(Node **head, const char *key, const char *value);
char *search(Node *head, const char *key);
void freeList(Node *head);
%}

%union {char *  id;}         /* Yacc definitions */
%start file
%token entity
%token architecture
%token signal
%token is
%token begin
%token of
%token assignmentOP
%token end
%token <id> identifier
%token <id> INVALID_IDENTIFIER
%token exit_command

%type <id> signal_identifier

%%

/* descriptions of expected inputs corresponding actions (in C) */

file : entityDec architectureDec ;

entityDec : entity entity_identifier is end ';' 	
		  ;

architectureDec : architecture  identifier of identifier is
				  signalStatements	begin assignmentStatements end ';' {
						if(strcmp(entity_id,$4)){
							flag=false;
							printf("Line %d: \"%s\" doesn't match the declared entity name \"%s\"\n",yylineno,$4,entity_id);
						}
					}
				;

assignmentStatment : identifier assignmentOP  identifier ';' {
						char *temp1=search(head,$1);
						char *temp2=search(head,$3);
						
						if(temp1==NULL){
							flag=false;
							printf("Line %d : Unknown signal \"s_%s\"\n",yylineno,$1);
						}
						else if(temp2==NULL){
							flag=false;
							printf("Line %d: Unknown signal \"s_%s\"\n",yylineno,$3);
						}
						else if(strcmp(temp1,temp2)){
							flag=false;
							printf("Line %d: Signal types don't match in assignment. LHS type \"%s\", RHS type \"%s\".\n",yylineno,temp1,temp2);
						}
					}
				   ;

assignmentStatements : assignmentStatment assignmentStatements | ;

signalStatement : signal signal_identifier ':' signal_identifier ';' {
					if(!insert(&head,$2,$4)){
						flag=false;
						printf("Line %d: %s is already defined\n",yylineno,$2);
					}
				}
				; 

signalStatements :  signalStatement signalStatements |  ;


entity_identifier : identifier {entity_id=$1;}  | 
					INVALID_IDENTIFIER {
										entity_id=$1;
										flag=false;
										yyerror("Invalid identifier");  
										} 
	;
signal_identifier : identifier {$$=$1;} | 
					INVALID_IDENTIFIER {
										$$=$1;
										flag=false;
										yyerror("Invalid identifier");  
										} 
	;

%%                     /* C code */


Node *createNode(const char *key, const char *value) {
    Node *newNode = (Node *)malloc(sizeof(Node));
    newNode->key = strdup(key);      // Duplicate the key
    newNode->value = strdup(value);  // Duplicate the value
    newNode->next = NULL;
    return newNode;
}

bool insert(Node **head, const char *key, const char *value) {
    Node *current = *head;
    
    // Check if key already exists, update its value
    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
			
            return false;
        }
        current = current->next;
    }

    // If the key doesn't exist, create a new node and add it to the front
    Node *newNode = createNode(key, value);
    newNode->next = *head;
    *head = newNode;
	return true;
}

char *search(Node *head, const char *key) {
    Node *current = head;
    
    // Traverse the list to find the key
    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            return current->value;
        }
        current = current->next;
    }
    
    return NULL; // Key not found
}

void freeList(Node *head) {
    Node *current = head;
    Node *nextNode;

    while (current != NULL) {
        nextNode = current->next;
        free(current->key);
        free(current->value);
        free(current);
        current = nextNode;
    }
}

int main (void) {
	yyparse();
	if(flag){
		printf("parsing successful\n");
	}
	freeList(head);
	return 0;
}

//void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
void yyerror(const char *s) {
    printf("Line %d: %s %s\n", yylineno,s,yytext);
}
