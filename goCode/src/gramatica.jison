/* Definición del lenguaje */

%lex
%options case-sensitive

%%

"int" return 'R_INTEGER';
"double" return 'R_DOUBLE';
"boolean" return 'R_BOOLEAN';
"char" return 'R_CHAR';
"String" return 'R_STRING';
"false" return 'R_FALSE';
"true" return 'R_TRUE';
"class" return 'R_CLASS';
"import" return 'R_IMPORT';
"if" return 'R_IF';
"else" return 'R_ELSE';
"switch" return 'R_SWITCH';
"case" return 'R_CASE';
"default" return 'R_DEFAULT';
"break" return 'R_BREAK';
"continue" return 'R_CONTINUE';
"while" return 'R_WHILE';
"do" return 'R_DO';
"for" return 'R_FOR';
"void" return 'R_VOID';
"return" return 'R_RETURN';
"main" return 'R_MAIN';
"System" return 'R_SYSTEM';
"out" return 'R_OUT';
"print" return 'R_PRINT';
"println" return 'R_PRINTLN';

\"[^\"]*\" { yytext = yytext.substr(1, yyleng-2); return 'CADENA';}
\'[^\"]?\' { yytext = yytext.substr(1, yyleng-2); return 'CARACTER';}
[0-9]+("."[0-9]+)?\b return 'DECIMAL';
[0-9]+\b return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]* return 'IDENTIFICADOR';
\s+ {}                                                                             //Ignora los espacios en blanco
/*
"//".*                                                                         //Comentario de una línea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]                                             //Comentario multilínea\\n "SALTO";*/
\\"n" return 'SALTO';
\\"t" return 'TAB';
\\"r" return 'RETORNO_CARRO';
\\\\ return 'BARRA_INVERTIDA';
\\\" return 'COMILLA_DOBLE';
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
">=" return 'MAYOR_IGUAL';
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
":" return 'DOS_PUNTOS';
"." return 'PUNTO';

<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex


%{
	const TIPO_OPERACION	= require('./instrucciones').TIPO_OPERACION;
	const TIPO_VALOR 		= require('./instrucciones').TIPO_VALOR;
	const instruccionesAPI	= require('./instrucciones').instruccionesAPI;
%}

/* Asociación de operadores y precedencia */

%left 'MAS' 'MENOS'
%left 'MULTIPLICACION' 'DIVISION'
%left UMENOS

%start ini

%% /* Definición de la gramática */

ini
	: instrucciones EOF {
		// cuado se haya reconocido la entrada completa retornamos el AST
		return $1;
	}
;

instrucciones
	: instrucciones instruccion { $1.push($2); $$ = $1; }
	| instruccion               { $$ = [$1]; }
;
instruccion
   : R_SYSTEM PUNTO R_OUT PUNTO R_PRINTLN ABRIR_PARENTESIS CADENA CERRAR_PARENTESIS PUNTO_COMA                        { $$ = instruccionesAPI.nuevoImprimir($3); }
   | error { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
;