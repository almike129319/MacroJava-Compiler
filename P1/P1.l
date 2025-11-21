%{
    #include <stdio.h>
    #include "P1.tab.h"
    void yyerror(char *);
    int line_counter = 1;
    using namespace std;
%}

%%

"//".*      {}
\/\*([^*]|\*+[^/])*\*+\/ {}


"#"         {return HASH;}
"define"    {return DEFINE;}
"main"      {return MAIN;}
"class"     {return CLASS;}
"extends"   {return EXTENDS;}
"public"    {return PUBLIC;}
"static"    {return STATIC;}
"void"      {return VOID;}
"int"       {return INT;}
"String"    {return STRING;}
"boolean"   {return BOOLEAN;}
"true"      {return TRUE;}
"false"     {return FALSE;}
"if"        {return IF;}
"else"      {return ELSE;}
"do"        {return DO;}
"while"     {return WHILE;}
"return"    {return RETURN;}
"System.out.println" {return PRINT;}
"new"       {return NEW;}
"this"      {return THIS;}
"length"    {return LENGTH;}
"Function"  {return FUNCTION;}
"import java.util.function.Function;" {return IMPORTFUNCTION;} 


")"[ ]*"->" {return LAMBDA_ARROW;}
"="    {return EQ;}
"!="   {return NEQ;}
"!"    {return NOT;}
"<"    {return LT;}
">"    {return GT;}
"<="   {return LEQ;}
"&&"   {return AND;}
"||"   {return OR;}
"+"    {return PLUS;}
"-"    {return MINUS;}
"*"    {return MUL;}
"/"    {return DIV;}


"{"   {return CURLY_OPEN;}
"}"    {return CURLY_CLOSE;}
"("   {return PAREN_OPEN;}
")"   {return PAREN_CLOSE;}
"["   {return SQUARE_OPEN;}
"]"   {return SQUARE_CLOSE;}
"."   {return DOT;}
","   {return COMMA;}
";"   {return SEMICOLON;}

[1-9][0-9]*  { yylval.str = strdup(yytext); return INTEGER_LITERAL; }
"0"          { yylval.str = strdup(yytext); return INTEGER_LITERAL; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); /*printf("identifier :%s\n",yytext);*/ return IDENTIFIER; }

[ \t]   {}
[\n]    {/*printf("%d\n",line_counter);*/line_counter++;}

.       {}
%%

int yywrap(void) {
    return 1;
}


/* int main() {
  yylex();
  return 0;
} */