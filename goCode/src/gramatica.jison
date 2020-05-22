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

\"(\\\"|\\n|\\t|\\r|\\\\|[^\"])*\" { yytext = yytext.substr(1, yyleng-2); return 'CADENA';}
\'[^\"]?\' { yytext = yytext.substr(1, yyleng-2); return 'CARACTER';}
[0-9]+("."[0-9]+)?\b return 'DECIMAL';
[0-9]+\b return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]* return 'IDENTIFICADOR';
\s+ {}                                                                             //Ignora los espacios en blanco
"//".*                           // comentario simple línea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] // comentario multiple líneas
"++" return 'INCREMENTO';
"--" return 'DECREMENTO';
"+" return "MAS";
"-" return 'MENOS';
"*" return 'MULTIPLICACION';
"/" return 'DIVISION';
"^" return 'POTENCIA';
"%" return 'MODULO';
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

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); salida.push('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column);  ArrayDeErrores.push({tipo:"léxico", linea:this._$.first_line, columna:this._$.first_column, descripcion: yytext});}
/lex


%{
	const TIPO_OPERACION	= require('./instrucciones').TIPO_OPERACION;
	const TIPO_VALOR 		= require('./instrucciones').TIPO_VALOR;
	const instruccionesAPI	= require('./instrucciones').instruccionesAPI;
	const Clase = require('./Objetos').Clase;
	const Funcion = require('./Objetos').Funcion;
	const Variable = require('./Objetos').Variable;
	const Parametro = require('./Objetos').Parametro;
	const AsignValue = require('./Objetos').AsignValue;
	var salida=[];
	var Clases = [];
	var CurrentClass ="";
	var Funciones = [];
	var CurrentFunction ="";
	var Variables = [];
	var VariableList =[];
	var ParameterList = [];
	var CurrentType="";
	var CurrentVarType="";
	var FunctionID="";
	var isFunction = true;
	var ArrayDeErrores = [];
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
		var sentClass = Clases;
		Clases = [];
		var tempAr = ArrayDeErrores;
		ArrayDeErrores = [];
		return {AST: $1, Errores: temporal, Cuerpo:sentClass, ArrayOfErrors:tempAr };
	}
;
instrucciones
	: instrucciones instruccion { $1.push($2); $$ = $1; }
	| instruccion               { $$ = [$1]; }
;
instruccion
   	: R_IMPORT IDENTIFICADOR PUNTO_COMA { $$ = instruccionesAPI.nuevoImport($2);}
	| R_CLASS IDENTIFICADOR ABRIR_LLAVE classBody  CERRAR_LLAVE {$$=instruccionesAPI.nuevaClase($2, $4); Clases.push(new Clase($2, Funciones)); Funciones=[];}
   	| error  { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);	salida.push('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); ArrayDeErrores.push({tipo:"sintáctico", linea:this._$.first_line, columna:this._$.first_column, descripcion: yytext});}
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
	: R_VOID IDENTIFICADOR ABRIR_PARENTESIS parametros CERRAR_PARENTESIS ABRIR_LLAVE sentenciasVoid CERRAR_LLAVE  {  $$ = instruccionesAPI.nuevoMetodo($2, $4, $7); Funciones.push(new Funcion($1, $2, ParameterList, Variables)); Variables=[]; ParameterList=[];}
	| R_VOID R_MAIN ABRIR_PARENTESIS CERRAR_PARENTESIS ABRIR_LLAVE sentenciasVoid CERRAR_LLAVE {$$ = instruccionesAPI.nuevoMain($6); Funciones.push(new Funcion($1, $2, ParameterList, Variables)); Variables=[]; ParameterList=[];} 
	| R_INTEGER  declaracion_p { $$ = instruccionesAPI.nuevaDeclaracionVariable($1, $2); if(isFunction)Funciones.push(new Funcion($1, FunctionID, ParameterList, Variables)); Variables=[];  ParameterList=[]; }
	| R_DOUBLE  declaracion_p { $$ = instruccionesAPI.nuevaDeclaracionVariable($1, $2); if(isFunction)Funciones.push(new Funcion($1, FunctionID, ParameterList, Variables)); Variables=[];  ParameterList=[];}
	| R_STRING  declaracion_p { $$ = instruccionesAPI.nuevaDeclaracionVariable($1, $2); if(isFunction)Funciones.push(new Funcion($1, FunctionID, ParameterList, Variables)); Variables=[];  ParameterList=[];}
	| R_BOOLEAN  declaracion_p { $$ = instruccionesAPI.nuevaDeclaracionVariable($1, $2); if(isFunction)Funciones.push(new Funcion($1, FunctionID, ParameterList, Variables)); Variables=[];  ParameterList=[];}
	| R_CHAR  declaracion_p { $$ = instruccionesAPI.nuevaDeclaracionVariable($1, $2); if(isFunction)Funciones.push(new Funcion($1, FunctionID, ParameterList, Variables)); Variables=[];  ParameterList=[];}
;
declaracion_p
	: listaID  defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaVariable($1, $2); isFunction=false;  Variables=[]; VariableList=[];}
	| IDENTIFICADOR ABRIR_PARENTESIS parametros CERRAR_PARENTESIS ABRIR_LLAVE sentencias CERRAR_LLAVE  {$$ = instruccionesAPI.nuevaFuncion($1, $3, $6); FunctionID=$1; isFunction=true;}
;
parametros
	: R_INTEGER IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($1, $2, $3); ParameterList.push(new Parametro($1, $2));}
	| R_DOUBLE IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($1, $2, $3); ParameterList.push(new Parametro($1, $2));}
	| R_STRING IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($1, $2, $3); ParameterList.push(new Parametro($1, $2));}
	| R_BOOLEAN IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($1, $2, $3); ParameterList.push(new Parametro($1, $2));}
	| R_CHAR IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($1, $2, $3); ParameterList.push(new Parametro($1, $2));}
	| { $$ = "NA"; }
;
parametros_p
	: COMA R_INTEGER IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($2, $3, $4); ParameterList.push(new Parametro($2, $3));}
	| COMA R_DOUBLE IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($2, $3, $4); ParameterList.push(new Parametro($2, $3));}
	| COMA R_STRING IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($2, $3, $4); ParameterList.push(new Parametro($2, $3));}
	| COMA R_BOOLEAN IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($2, $3, $4); ParameterList.push(new Parametro($2, $3));}
	| COMA R_CHAR IDENTIFICADOR parametros_p { $$ = instruccionesAPI.nuevoParametro($2, $3, $4); ParameterList.push(new Parametro($2, $3));}
	| { $$ = "NM"; }
;
sentencias
	: sentencias  sentencia { $1.push($2); $$ = $1; }
	| sentencia { $$ = [$1]; }
;
sentencia
	: declaracion_var { $$ = $1; }
	| IDENTIFICADOR IGUAL condicion PUNTO_COMA {$$ = instruccionesAPI.nuevaAsignacion($1, $3);}
	| IDENTIFICADOR ABRIR_PARENTESIS argumentos CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevaLlamada($1, $3);}
	| IDENTIFICADOR INCREMENTO PUNTO_COMA {$$ =  instruccionesAPI.nuevoIncremento($1);}
	| IDENTIFICADOR DECREMENTO PUNTO_COMA {$$ =  instruccionesAPI.nuevoDecremento($1);}
	| R_IF ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentencias CERRAR_LLAVE elseIf { $$ = instruccionesAPI.nuevoIf($3, $6, $8);}
	| R_WHILE ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentenciasBreak CERRAR_LLAVE { $$ = instruccionesAPI.nuevoWhile($3, $6);}
	| R_DO ABRIR_LLAVE sentenciasBreak CERRAR_LLAVE R_WHILE ABRIR_PARENTESIS condicion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoDoWhile($3, $7);}
	| R_SWITCH ABRIR_PARENTESIS expresion CERRAR_PARENTESIS ABRIR_LLAVE casos default CERRAR_LLAVE {$$ = instruccionesAPI.nuevoSwitch($3, $6, $7);}
	| R_FOR ABRIR_PARENTESIS for_init condicion PUNTO_COMA IDENTIFICADOR for_change CERRAR_PARENTESIS ABRIR_LLAVE sentenciasBreak CERRAR_LLAVE { $$ = instruccionesAPI.nuevoFor($3, $4, $7, $10);}
	| R_SYSTEM PUNTO R_OUT PUNTO R_PRINT  ABRIR_PARENTESIS expresion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoImprimir($7);}
	| R_SYSTEM PUNTO R_OUT PUNTO R_PRINTLN  ABRIR_PARENTESIS expresion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoImprimir($7);}
	| R_RETURN condicion PUNTO_COMA{$$=instruccionesAPI.nuevoReturnFuncion($2);}
   	| error { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);	salida.push('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);  ArrayDeErrores.push({tipo:"sintáctico", linea:this._$.first_line, columna:this._$.first_column, descripcion: yytext});}
	
;
elseIf
	: R_ELSE elseIf_P { $$ = $2;}
	| { $$ = "No Else Clause"; }	
;
elseIf_P
	: R_IF ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentencias CERRAR_LLAVE elseIf {$$ = instruccionesAPI.nuevoElseIf($3, $6, $8);}
	| ABRIR_LLAVE sentencias CERRAR_LLAVE {$$ =  instruccionesAPI.nuevoElse($2);}
;
sentenciasBreak
	: sentenciasBreak  sentenciaBreak { $1.push($2); $$ = $1; }
	| sentenciaBreak { $$ = [$1]; }
;
sentenciaBreak
	: declaracion_var { $$ = $1; }
	| IDENTIFICADOR IGUAL condicion PUNTO_COMA {$$ = instruccionesAPI.nuevaAsignacion($1, $3);}
	| IDENTIFICADOR ABRIR_PARENTESIS argumentos CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevaLlamada($1, $3);}
	| IDENTIFICADOR INCREMENTO PUNTO_COMA {$$ =  instruccionesAPI.nuevoIncremento($1);}
	| IDENTIFICADOR DECREMENTO PUNTO_COMA {$$ =  instruccionesAPI.nuevoDecremento($1);}
	| R_IF ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentenciasBreak CERRAR_LLAVE elseIfBreak { $$ = instruccionesAPI.nuevoIf($3, $6, $8);}
	| R_WHILE ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentenciasBreak CERRAR_LLAVE { $$ = instruccionesAPI.nuevoWhile($3, $6);}
	| R_DO ABRIR_LLAVE sentenciasBreak CERRAR_LLAVE R_WHILE ABRIR_PARENTESIS condicion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoDoWhile($3, $7);}
	| R_SWITCH ABRIR_PARENTESIS expresion CERRAR_PARENTESIS ABRIR_LLAVE casos default CERRAR_LLAVE {$$ = instruccionesAPI.nuevoSwitch($3, $6, $7);}
	| R_FOR ABRIR_PARENTESIS for_init condicion PUNTO_COMA IDENTIFICADOR for_change CERRAR_PARENTESIS ABRIR_LLAVE sentenciasBreak CERRAR_LLAVE { $$ = instruccionesAPI.nuevoFor($3, $4, $7, $10);}
	| R_SYSTEM PUNTO R_OUT PUNTO R_PRINT  ABRIR_PARENTESIS expresion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoImprimir($7);}
	| R_SYSTEM PUNTO R_OUT PUNTO R_PRINTLN  ABRIR_PARENTESIS expresion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoImprimir($7);}
	| R_BREAK PUNTO_COMA {$$=$1;}
	| R_CONTINUE PUNTO_COMA {$$=$1;}
	| R_RETURN condicion PUNTO_COMA{$$=instruccionesAPI.nuevoReturnFuncion($2);}
	| error { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);	salida.push('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);  ArrayDeErrores.push({tipo:"sintáctico", linea:this._$.first_line, columna:this._$.first_column, descripcion: yytext});}

;
elseIfBreak
	: R_ELSE elseIf_PBreak { $$ = $2;}
	| { $$ = "No Else Clause"; }	
;
elseIf_PBreak
	: R_IF ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentenciasBreak CERRAR_LLAVE elseIfBreak {$$ = instruccionesAPI.nuevoElseIf($3, $6, $8);}
	| ABRIR_LLAVE sentenciasBreak CERRAR_LLAVE {$$ =  instruccionesAPI.nuevoElse($2);}
;
casos
	: casos caso { $1.push($2); $$ = $1; }
	| caso	 { $$ = [$1]; }
;
caso
	: R_CASE expresion DOS_PUNTOS sentenciasBreak {$$ = instruccionesAPI.nuevoCase($2, $4);}
;
default
	: R_DEFAULT DOS_PUNTOS sentenciasBreak {$$ = instruccionesAPI.nuevoDefault($3);}
	| {$$ ="NO DEFAULT CLAUSE"}
;
sentenciasVoid
	: sentenciasVoid  sentenciaVoid { $1.push($2); $$ = $1; }
	| sentenciaVoid { $$ = [$1]; }
;
sentenciaVoid
	: declaracion_var { $$ = $1; }
	| IDENTIFICADOR IGUAL condicion PUNTO_COMA {$$ = instruccionesAPI.nuevaAsignacion($1, $3);}
	| IDENTIFICADOR ABRIR_PARENTESIS argumentos CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevaLlamada($1, $3);}
	| IDENTIFICADOR INCREMENTO PUNTO_COMA {$$ =  instruccionesAPI.nuevoIncremento($1);}
	| IDENTIFICADOR DECREMENTO PUNTO_COMA {$$ =  instruccionesAPI.nuevoDecremento($1);}
	| R_IF ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentenciasVoid CERRAR_LLAVE elseIfVoid { $$ = instruccionesAPI.nuevoIf($3, $6, $8);}
	| R_WHILE ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentenciasVoidBreak CERRAR_LLAVE { $$ = instruccionesAPI.nuevoWhile($3, $6);}
	| R_DO ABRIR_LLAVE sentenciasVoidBreak CERRAR_LLAVE R_WHILE ABRIR_PARENTESIS condicion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoDoWhile($3, $7);}
	| R_SWITCH ABRIR_PARENTESIS expresion CERRAR_PARENTESIS ABRIR_LLAVE casosVoid defaultVoid CERRAR_LLAVE {$$ = instruccionesAPI.nuevoSwitch($3, $6, $7);}
	| R_FOR ABRIR_PARENTESIS for_init condicion PUNTO_COMA IDENTIFICADOR for_change CERRAR_PARENTESIS ABRIR_LLAVE sentenciasVoidBreak CERRAR_LLAVE { $$ = instruccionesAPI.nuevoFor($3, $4, $7, $10);}
	| R_SYSTEM PUNTO R_OUT PUNTO R_PRINT  ABRIR_PARENTESIS expresion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoImprimir($7);}
	| R_SYSTEM PUNTO R_OUT PUNTO R_PRINTLN  ABRIR_PARENTESIS expresion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoImprimir($7);}
	| R_RETURN PUNTO_COMA {$$=$1;}  
	| error { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);	salida.push('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);  ArrayDeErrores.push({tipo:"sintáctico", linea:this._$.first_line, columna:this._$.first_column, descripcion: yytext});} 
;
elseIfVoid
	: R_ELSE elseIf_PVoid { $$ = $2;}
	| { $$ = "No Else Clause"; }	
;
elseIf_PVoid
	: R_IF ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentenciasVoid CERRAR_LLAVE elseIfVoid {$$ = instruccionesAPI.nuevoElseIf($3, $6, $8);}
	| ABRIR_LLAVE sentenciasVoid CERRAR_LLAVE {$$ =  instruccionesAPI.nuevoElse($2);}
;
sentenciasVoidBreak
	: sentenciasVoidBreak  sentenciaVoidBreak { $1.push($2); $$ = $1; }
	| sentenciaVoidBreak { $$ = [$1]; }
;
sentenciaVoidBreak
	: declaracion_var { $$ = $1; }
	| IDENTIFICADOR IGUAL condicion PUNTO_COMA {$$ = instruccionesAPI.nuevaAsignacion($1, $3);}
	| IDENTIFICADOR ABRIR_PARENTESIS argumentos CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevaLlamada($1, $3);}
	| IDENTIFICADOR INCREMENTO PUNTO_COMA {$$ =  instruccionesAPI.nuevoIncremento($1);}
	| IDENTIFICADOR DECREMENTO PUNTO_COMA {$$ =  instruccionesAPI.nuevoDecremento($1);}
	| R_IF ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentenciasVoidBreak CERRAR_LLAVE elseIfVoidBreak { $$ = instruccionesAPI.nuevoIf($3, $6, $8);}
	| R_WHILE ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentenciasVoidBreak CERRAR_LLAVE { $$ = instruccionesAPI.nuevoWhile($3, $6);}
	| R_DO ABRIR_LLAVE sentenciasVoidBreak CERRAR_LLAVE R_WHILE ABRIR_PARENTESIS condicion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoDoWhile($3, $7);}
	| R_SWITCH ABRIR_PARENTESIS expresion CERRAR_PARENTESIS ABRIR_LLAVE casosVoid defaultVoid CERRAR_LLAVE {$$ = instruccionesAPI.nuevoSwitch($3, $6, $7);}
	| R_FOR ABRIR_PARENTESIS for_init condicion PUNTO_COMA IDENTIFICADOR for_change CERRAR_PARENTESIS ABRIR_LLAVE sentenciasVoidBreak CERRAR_LLAVE { $$ = instruccionesAPI.nuevoFor($3, $4, $7, $10);}
	| R_SYSTEM PUNTO R_OUT PUNTO R_PRINT  ABRIR_PARENTESIS expresion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoImprimir($7);}
	| R_SYSTEM PUNTO R_OUT PUNTO R_PRINTLN  ABRIR_PARENTESIS expresion CERRAR_PARENTESIS PUNTO_COMA {$$ = instruccionesAPI.nuevoImprimir($7);}
	| R_BREAK PUNTO_COMA {$$=$1;}
	| R_CONTINUE PUNTO_COMA {$$=$1;}
	| R_RETURN PUNTO_COMA {$$=$1;}
	| error { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);	salida.push('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);  ArrayDeErrores.push({tipo:"sintáctico", linea:this._$.first_line, columna:this._$.first_column, descripcion: yytext});}

;
elseIfVoidBreak
	: R_ELSE elseIf_PVoidBreak { $$ = $2;}
	| { $$ = "No Else Clause"; }	
;
elseIf_PVoidBreak
	: R_IF ABRIR_PARENTESIS condicion CERRAR_PARENTESIS ABRIR_LLAVE sentenciasVoidBreak CERRAR_LLAVE elseIfVoidBreak {$$ = instruccionesAPI.nuevoElseIf($3, $6, $8);}
	| ABRIR_LLAVE sentenciasVoidBreak CERRAR_LLAVE {$$ =  instruccionesAPI.nuevoElse($2);}
;
casosVoid
	: casosVoid casoVoid { $1.push($2); $$ = $1; }
	| casoVoid	 { $$ = [$1]; }
;
casoVoid
	: R_CASE expresion DOS_PUNTOS sentenciasVoidBreak {$$ = instruccionesAPI.nuevoCase($2, $4);}
;
defaultVoid
	: R_DEFAULT DOS_PUNTOS sentenciasVoidBreak {$$ = instruccionesAPI.nuevoDefault($3);}
	| {$$ ="NO DEFAULT CLAUSE"}
;
argumentos
	: expresion argumentos_P {$$ = instruccionesAPI.nuevoArgumento($1, $2);}
	| {$$ = "NA";}
;
argumentos_P
	: COMA expresion argumentos_P {$$ = instruccionesAPI.nuevoArgumento($2, $3);}
	| {$$ =  "NM";}
;
for_init	
	: R_INTEGER IDENTIFICADOR IGUAL expresion PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $4);}
	| R_DOUBLE IDENTIFICADOR IGUAL expresion PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $4);}
	| IDENTIFICADOR IGUAL expresion PUNTO_COMA {$$ = instruccionesAPI.nuevaAsignacion($1, $3);} 
;
for_change
	: INCREMENTO {$$=$1;}
	| DECREMENTO {$$=$1;}
	| IGUAL expresion {$$=$2;}
;
declaracion_var
	: R_INTEGER listaID defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3); AsignValue.asignarVariables($1, VariableList, Variables); VariableList=[]; }
	| R_DOUBLE listaID defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3); AsignValue.asignarVariables($1, VariableList, Variables); VariableList=[];}
	| R_STRING listaID defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3); AsignValue.asignarVariables($1, VariableList, Variables); VariableList=[];}
	| R_BOOLEAN listaID defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3); AsignValue.asignarVariables($1, VariableList, Variables); VariableList=[];}
	| R_CHAR listaID defincion_var PUNTO_COMA { $$ = instruccionesAPI.nuevaDeclaracion($1, $2, $3); AsignValue.asignarVariables($1, VariableList, Variables); VariableList=[];}
;
listaID
	:	IDENTIFICADOR listaID_P { $$ = instruccionesAPI.nuevaListaid($1, $2); VariableList.push(new Variable("", $1));}
;
listaID_P
	: COMA IDENTIFICADOR listaID_P {$$ = instruccionesAPI.nuevaListaid($2, $3); VariableList.push(new Variable("", $2));}
	| {$$="NM";}
;
defincion_var
	: IGUAL condicion { $$ = $2; }
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
	| DECIMAL											{ $$ = instruccionesAPI.nuevoValor(Number($1), TIPO_VALOR.DECIMAL); }
	| IDENTIFICADOR										{ $$ = instruccionesAPI.nuevoValor($1, TIPO_VALOR.IDENTIFICADOR); }
	| IDENTIFICADOR	ABRIR_PARENTESIS argumentos CERRAR_PARENTESIS { $$ = instruccionesAPI.nuevaLlamada($1, $3); }
	| CARACTER											{ $$ = instruccionesAPI.nuevoValor($1, TIPO_VALOR.CARACTER); }
	| R_TRUE											{ $$ = instruccionesAPI.nuevoValor($1, TIPO_VALOR.TRUE); }
	| R_FALSE											{ $$ = instruccionesAPI.nuevoValor($1, TIPO_VALOR.FALSE); }
	| CADENA											{ $$ = instruccionesAPI.nuevoValor($1, TIPO_VALOR.CADENA); }
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
	| NOT condicion							{ $$ = instruccionesAPI.nuevaOperacionBinaria($2, TIPO_OPERACION.NOT); }
	| expresion_relacional								{ $$ = instruccionesAPI.nuevaCondicion($1); }
;
