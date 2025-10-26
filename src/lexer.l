%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *tipo;
    char *lexema;
    int linea;
    int columna;
} Token;

Token tokens[1000];
int token_count = 0;
int linea_actual = 1;
int columna_actual = 1;

void agregar_token(const char *tipo, const char *lexema) {
    tokens[token_count].tipo = strdup(tipo);
    tokens[token_count].lexema = strdup(lexema);
    tokens[token_count].linea = linea_actual;
    tokens[token_count].columna = columna_actual;
    token_count++;
    columna_actual += strlen(lexema);
}

void imprimir_tokens() {
    printf("[\n");
    for (int i = 0; i < token_count; i++) {
        printf("  {\"tipo\": \"%s\", \"lexema\": \"", tokens[i].tipo);
        
        // Escapar caracteres especiales en el lexema
        for (int j = 0; tokens[i].lexema[j] != '\0'; j++) {
            char c = tokens[i].lexema[j];
            if (c == '"') {
                printf("\\\"");
            } else if (c == '\\') {
                printf("\\\\");
            } else if (c == '\n') {
                printf("\\n");
            } else if (c == '\t') {
                printf("\\t");
            } else {
                putchar(c);
            }
        }
        
        printf("\", \"linea\": %d, \"columna\": %d}%s\n",
               tokens[i].linea, tokens[i].columna,
               (i < token_count - 1) ? "," : "");
    }
    printf("]\n");
}

void limpiar_tokens() {
    for (int i = 0; i < token_count; i++) {
        free(tokens[i].tipo);
        free(tokens[i].lexema);
    }
    token_count = 0;
    linea_actual = 1;
    columna_actual = 1;
}
%}

%option noyywrap

DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          {LETRA}({LETRA}|{DIGITO}|_)*
ENTERO      {DIGITO}+
REAL        {DIGITO}+\.{DIGITO}+
ESPACIO     [ \t]+
NEWLINE     \n

%%

"if"        { agregar_token("PALABRA_RESERVADA", yytext); }
"else"      { agregar_token("PALABRA_RESERVADA", yytext); }
"while"     { agregar_token("PALABRA_RESERVADA", yytext); }
"for"       { agregar_token("PALABRA_RESERVADA", yytext); }
"int"       { agregar_token("TIPO_DATO", yytext); }
"float"     { agregar_token("TIPO_DATO", yytext); }
"char"      { agregar_token("TIPO_DATO", yytext); }
"string"    { agregar_token("TIPO_DATO", yytext); }
"bool"      { agregar_token("TIPO_DATO", yytext); }
"void"      { agregar_token("TIPO_DATO", yytext); }
"return"    { agregar_token("PALABRA_RESERVADA", yytext); }
"break"     { agregar_token("PALABRA_RESERVADA", yytext); }
"continue"  { agregar_token("PALABRA_RESERVADA", yytext); }
"true"      { agregar_token("BOOLEANO", yytext); }
"false"     { agregar_token("BOOLEANO", yytext); }
"print"     { agregar_token("PALABRA_RESERVADA", yytext); }
"input"     { agregar_token("PALABRA_RESERVADA", yytext); }

"+"         { agregar_token("OPERADOR_ARITMETICO", yytext); }
"-"         { agregar_token("OPERADOR_ARITMETICO", yytext); }
"*"         { agregar_token("OPERADOR_ARITMETICO", yytext); }
"/"         { agregar_token("OPERADOR_ARITMETICO", yytext); }
"%"         { agregar_token("OPERADOR_ARITMETICO", yytext); }

"=="        { agregar_token("OPERADOR_RELACIONAL", yytext); }
"!="        { agregar_token("OPERADOR_RELACIONAL", yytext); }
"<"         { agregar_token("OPERADOR_RELACIONAL", yytext); }
">"         { agregar_token("OPERADOR_RELACIONAL", yytext); }
"<="        { agregar_token("OPERADOR_RELACIONAL", yytext); }
">="        { agregar_token("OPERADOR_RELACIONAL", yytext); }

"&&"        { agregar_token("OPERADOR_LOGICO", yytext); }
"||"        { agregar_token("OPERADOR_LOGICO", yytext); }
"!"         { agregar_token("OPERADOR_LOGICO", yytext); }

"="         { agregar_token("ASIGNACION", yytext); }

"("         { agregar_token("PARENTESIS_IZQ", yytext); }
")"         { agregar_token("PARENTESIS_DER", yytext); }
"{"         { agregar_token("LLAVE_IZQ", yytext); }
"}"         { agregar_token("LLAVE_DER", yytext); }
"["         { agregar_token("CORCHETE_IZQ", yytext); }
"]"         { agregar_token("CORCHETE_DER", yytext); }

";"         { agregar_token("PUNTO_COMA", yytext); }
","         { agregar_token("COMA", yytext); }

{REAL}      { agregar_token("NUMERO_REAL", yytext); }
{ENTERO}    { agregar_token("NUMERO_ENTERO", yytext); }
{ID}        { agregar_token("IDENTIFICADOR", yytext); }

\"([^\"\n]|\\.)*\"  { agregar_token("CADENA", yytext); }

"//".* { agregar_token("COMENTARIO", yytext); }

{ESPACIO}   { columna_actual += yyleng; }
{NEWLINE}   { linea_actual++; columna_actual = 1; }

.           { agregar_token("ERROR", yytext); }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Error: No se puede abrir el archivo %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    yylex();
    imprimir_tokens();
    limpiar_tokens();
    
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}
