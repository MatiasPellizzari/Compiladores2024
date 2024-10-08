%{

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "calc-sintaxis.tab.h"

%}

%option noyywrap
%option yylineno

letra [a-zA-Z]      
digito [0-9]   


%%

"int"           { return INT; }    // Define variables de tipo entero

"bool"          { return BOOL; }   // Define variables de tipo booleano

"void"          { return VOID; }   // Define funciones que no retornan valor

"main"          { return MAIN; }   // Nombre de la función principal

"RET"			{return RET;}  // Retorno

"TRUE"	                  {	//printf("TRUE");
							return TRUE;
											}

"FALSE"                   { //printf("FALSE");
							return FALSE;
											}

"AND"                      { return AND; }

"OR"                       { return OR; }


{digito}+                     { 
                                //printf("INT : %d\n",atoi(yytext)); 
								yylval.value = atoi(yytext);
                                return INT;}

{letra}({letra}|{digito})*    { 
                               // printf("ID : %s\n",yytext);
							   yylval.id = (char *) malloc(yyleng +1);
								strcpy ((char *) yylval.id , yytext);
                                return ID;}

"-"                       {  //printf("%s\n",yytext);
                                  return TMENOS;}    

[+*;(){}=]                   {  //printf("%s\n",yytext);
                                  return *yytext;}

.|\n                          ; /* ignore all the rest */

%%

void yyerror(){
	printf("%s%d\n","-> ERROR Sintactico en la linea: ",yylineno);
}

int main(int argc,char *argv[]){
	++argv,--argc;
	if (argc > 0)
		yyin = fopen(argv[0],"r");
	else
		yyin = stdin;

	yyparse();

}
