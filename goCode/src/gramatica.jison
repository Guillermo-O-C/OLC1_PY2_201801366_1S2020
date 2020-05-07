/* Definición del lenguaje */

%lex
%options case-sensitive

%%

"int" return 'INTEGER"';
"double" return 'DOUBLE';
"boolean" return 'BOOLEAN';
"char" return 'CHAR';
"String" return 'STRING';
"false" return 'FALSE';
"true" return 'TRUE';
"class" return 'CLASS';
"import" return 'IMPORT';
"if" return 'IF';
"else" return 'ELSE';
"switch" return 'SWITCH';
"case" return 'CASE';
"default" return 'DEFAULT';
"break" return 'BREAK';
"continue" return 'CONTINUE';
"while" return 'WHILE';
"do" return 'DO';
"for" return 'FOR';
"void" return 'VOID';
"return" return 'RETURN';
"main" return 'MAIN';
"System" return 'SYSTEM';
"out" return 'OUT';
"print" return 'PRINT';
"println" return 'PRINTLN';

\"[^\"]*\" { yytext = yytext.substr(1, yyleng-2); return 'CADENA';}
\'[^\"]?\' { yytext = yytext.substr(1, yyleng-2); return 'CARACTER';}
[0-9]+("."[0-9]+)?\b return 'DECIMAL';
[0-9]+\b return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]* return 'IDENTIFICADOR';
\s+                                                                             //Ignora los espacios en blanco
"//".*                                                                          //Comentario de una línea
[/][*][^*]*[*]+(^/*)*[*]+)*[/]                                                  //Comentario multilínea\\n "SALTO";
\\"n" return 'SALTO';
\\"t" return 'TAB';
\\"r" return 'RETORNO_CARRO';
\\\\ return 'BARRA_INVERTIDA';
\\" return 'COMILLA_DOBLE";
"+" return "MAS";
"-" return 'MENOS';
"*" return 'MULTIPLICACION';
"/" return 'DIVISION';
"^" return 'POTENCIA';
"%" return 'MODULO';
"++" return 'INCREMENTO';
"--" return 'DECREMENTO';
"=" return 'IGUAL';
"==" return 'IGUALDAD';
"!=" return 'DISTINTO';
">" return 'MAYOR';
">=" return 'MAYOR_IGUAL";
"<" return 'MENOR';
"<=" return 'MENOR_IGUAL';
"&&" return 'AND';
"||" return 'OR';
"!" return 'NOT';
"{" return 'ABRIR_LLAVE';
"}" return 'CERRAR_LLAVE';
"(" return 'ABRIR_PARENTESIS';
")" return 'CERRAR_PARENTESIS';
"[" return 'ABRIR_CORCHETE';
"]" return 'CERRAR_CORCHETE';
";" return 'PUNTO_COMA';

<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex

/* Asociación de operadores y precedencia */

%left 'MAS' 'MENOS'
%left 'MULTIPLICACION' 'DIVISION'
%left UMENOS

%start ini

%% /* Definición de la gramática */
