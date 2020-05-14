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
//"/""/".*\n                                                                        //Comentario de una línea
//[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]                                             //Comentario multilínea\\n "SALTO";*/
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
"==" return 'IGUALDAD';
"!=" return 'DISTINTO';
"=" return 'IGUAL';
">=" return 'MAYOR_IGUAL';
">" return 'MAYOR';
"<=" return 'MENOR_IGUAL';
"<" return 'MENOR';
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
"," return 'COMA';

<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex


%{
	const TIPO_OPERACION	= require('./instrucciones').TIPO_OPERACION;
	const TIPO_VALOR 		= require('./instrucciones').TIPO_VALOR;
	const instruccionesAPI	= require('./instrucciones').instruccionesAPI;
	var salida=[];
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
		var temporal = salida;
		salida=[];
		return {AST: $1, Errores: temporal};
	}
;

instrucciones
	: instrucciones instruccion { $1.push($2); $$ = $1; }
	| instruccion               { $$ = [$1]; }
;
instruccion
   	: R_IMPORT IDENTIFICADOR PUNTO_COMA { $$ = instruccionesAPI.nuevoImport($2);}
	| R_CLASS IDENTIFICADOR ABRIR_LLAVE classBody  CERRAR_LLAVE {$$=instruccionesAPI.nuevaClase($2, $4);}
   	| error { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); 
	   			salida.push('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);}
;
classBody
	: classBody classActions { $1.push($2); $$ = $1; }
	| classActions	 { $$ = [$1]; }
;

classActions
	: declaracion { $$ = $1; } //not sure
	| asignacion { $$ = $1; }	//not sure
;
declaracion
	: R_VOID IDENTIFICADOR ABRIR_PARENTESIS parametros CERRAR_PARENTESIS ABRIR_LLAVE sentencias CERRAR_LLAVE  {$$ = instruccionesAPI.nuevoMetodo($2, $4, $7);}
	| R_VOID R_MAIN ABRIR_PARENTESIS CERRAR_PARENTESIS ABRIR_LLAVE sentencias CERRAR_LLAVE {$$ = instruccionesAPI.nuevoMain($6);} 
	| R_INTEGER IDENTIFICADOR declaracion_p { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3);}
	| R_DOUBLE IDENTIFICADOR declaracion_p { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3);}
	| R_STRING IDENTIFICADOR declaracion_p { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3);}
	| R_BOOLEAN IDENTIFICADOR declaracion_p { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3);}
	| R_CHAR IDENTIFICADOR declaracion_p { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3);}
;

declaracion_p
	: defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaVariable($1);}
	| ABRIR_PARENTESIS parametros CERRAR_PARENTESIS ABRIR_LLAVE sentencias CERRAR_LLAVE  {$$ = instruccionesAPI.nuevaFuncion($2, $5);}
;

parametros
	: R_INTEGER IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($1, $2, $3);}
	| R_DOUBLE IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($1, $2, $3);}
	| R_STRING IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($1, $2, $3);}
	| R_BOOLEAN IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($1, $2, $3);}
	| R_CHAR IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($1, $2, $3);}
	| { $$ = "NA"; }
;
parametros_p
	: COMA R_INTEGER IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($2, $3, $4);}
	| COMA R_DOUBLE IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($2, $3, $4);}
	| COMA R_STRING IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($2, $3, $4);}
	| COMA R_BOOLEAN IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($2, $3, $4);}
	| COMA R_CHAR IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($2, $3, $4);}
	| { $$ = "NM"; }
;
sentencias
	: sentencias  sentencia { $1.push($2); $$ = $1; }
	| sentencia { $$ = [$1]; }
;
sentencia
	: declaracion_var { $$ = $1; }
	| R_IF ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentencias CERRAR_LLAVE elseIf { $$ = instruccionesAPI.nuevoIf($3, $6);}
	| R_WHILE ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentencias CERRAR_LLAVE { $$ = instruccionesAPI.nuevoWhile($3, $6);}
;
elseIf
	: R_ELSE elseIf_P { $$ = $2;}
	| { $$ = "No Else Clause"; }	
;
elseIf_P
	: R_IF ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentencias CERRAR_LLAVE elseIf {$$ = instruccionesAPI.nuevoElseIf($3, $6);}
	| ABRIR_LLAVE sentencias CERRAR_LLAVE {$$ =  instruccionesAPI.nuevoElse($2);}
;
declaracion_var
	: R_INTEGER IDENTIFICADOR defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3);}
	| R_DOUBLE IDENTIFICADOR defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3);}
	| R_STRING IDENTIFICADOR defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3);}
	| R_BOOLEAN IDENTIFICADOR defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3);}
	| R_CHAR IDENTIFICADOR defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3);}
;
defincion_var
	: IGUAL expresion { $$ = $2; }
	| { $$ = "sin inicializar"; }
;
expresion
	: MENOS expresion %prec UMENOS				{ $$ = instruccionesAPI.nuevaOperacionUnaria($2, TIPO_OPERACION.NEGATIVO); }
	| expresion MAS expresion			{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.SUMA); }
	| expresion MENOS expresion		{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.RESTA); }
	| expresion MULTIPLICACION expresion			{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.MULTIPLICACION); }
	| expresion DIVISION expresion	{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.DIVISION); }
	| ABRIR_PARENTESIS expresion CERRAR_PARENTESIS					{ $$ = $2; }
	| ENTERO											{ $$ = instruccionesAPI.nuevoValor(Number($1), TIPO_VALOR.NUMERO); }
	| DECIMAL											{ $$ = instruccionesAPI.nuevoValor(Number($1), TIPO_VALOR.NUMERO); }
	| IDENTIFICADOR										{ $$ = instruccionesAPI.nuevoValor($1, TIPO_VALOR.IDENTIFICADOR); }
	| CARACTER											{ $$ = instruccionesAPI.nuevoValor($1, TIPO_VALOR.CARACTER); }
	| R_TRUE											{ $$ = instruccionesAPI.nuevoValor($1, TIPO_VALOR.TRUE); }
	| R_FALSE											{ $$ = instruccionesAPI.nuevoValor($1, TIPO_VALOR.FALSE); }
;

expresion_relacional
	: expresion MAYOR expresion		{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.MAYOR); }
	| expresion MENOR expresion		{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.MENOR); }
	| expresion MAYOR_IGUAL expresion	{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.MAYOR_IGUAL); }
	| expresion MENOR_IGUAL expresion	{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.MENOR_IGUAL); }
	| expresion IGUALDAD expresion			{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.IGUAL_IGUAL); }
	| expresion DISTINTO expresion			{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.DISTINTO); }
	| expresion {$$ = $1} 
;

condicion
	: expresion_relacional AND expresion_relacional     { $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.AND); }
	| expresion_relacional OR expresion_relacional 		{ $$ = instruccionesAPI.nuevaOperacionBinaria($1, $3, TIPO_OPERACION.OR); }
	| NOT expresion_relacional							{ $$ = instruccionesAPI.nuevaOperacionBinaria($2, TIPO_OPERACION.NOT); }
	| expresion_relacional								{ $$ = instruccionesAPI.nuevaCondicion($1); }
;