%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
(?i:entity)				   {return entity;}
(?i:architecture)		   {return architecture;}
(?i:signal)				   {return signal;}
(?i:is)				       {return is;}
(?i:of)				       {return of;}
(?i:begin)				   {return begin;}
(?i:end)				   {return end;}
"<="                       {return assignmentOP;}
"exit"				   {return exit_command;}

[a-zA-Z_][a-zA-Z0-9]+			   {yylval.id = strdup(yytext); return identifier;}

"\n"                            {yylineno += 1;}
[\t\r ]+                        {;}
[:=;]           	   {return yytext[0];}
[^a-zA-Z_ \t\n][a-zA-Z0-9]*  { yylval.id = strdup(yytext); return INVALID_IDENTIFIER;}


%%
int yywrap (void) {return 1;}

