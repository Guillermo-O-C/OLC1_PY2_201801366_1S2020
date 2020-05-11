const TIPO_VALOR = {
    NUMERO: 'NUMERO',
    DECIMAL: 'DECIMAL',
    IDENTIFICADOR: 'IDENTIFICADOR',
    CADENA: 'CADENA',
    CARACTER: 'CARACTER',
    TRUE: 'TRUE',
    TRUE: 'TRUE'
}
const TIPO_OPERACIONES = {
    SUMA:   'OP_SUMA',
    RESTA:  'OP_RESTA',
    MULTIPLICACION: 'OP_MULTIPLICACION',
    DIVISION:   'OP_DIVISION',
    NEGATIVO:   'OP_NEGATIVO',
    MAYOR:      'OP_MAYOR',
    MAYOR_IGUAL:    'OP_MAYOR_IGUAL',
    MENOR:      'OP_MENOR',
    MENOR_IGUAL:    'OP_MENOR_IGUAL',
    CONCATENACION:  'OP_CONCATENACION'
};

const SENTENCIAS = {
    CLASE: 'CLASE',
    ASIGNACION: 'ASIGNACION',
    DECLARACION:    'DECLARACION',
    IMPORT: 'IMPORT',
    IF: 'IF',
    ELSE_IF:    'ELSE_IF',
    SWITCH: 'SWITCH',
    WHILE:  'WHILE',
    DO_WHILE:   'DO_WHILE',
    FOR:    'FOR',
    FUNCION: 'FUNCION',
    MAIN:   'MAIN',
    RETURN: 'RETURN',
    CONTINUE:  'CONTINUE',
    BREAK:  'BREAK',
    IMPRIMIR: 'IMPRIMIR',
    COMENTARIO: 'COMENTARIO',
    PARAMETRO: 'PARAMETRO'
}

function nuevaOperacion(operandoIzq, OperandoDer, tipo){
    return {
        operandoIzq:operandoIzq,
        OperandoDer:OperandoDer,
        tipoo:tipo
    }
}

const instruccionesAPI = {
	nuevaOperacionBinaria: function(Izq, Der, tipo) {
		return nuevaOperacion(Izq, Der, tipo);
    },
    nuevaOperacionUnaria: function(izq, tipo){
        return nuevaOperacion(izq, undefined, tipo);
    },
    nuevoValor: function(valor, tipo){
        return{
            tipo:tipo,
            valor:valor
        };
    },
    nuevoImprimir: function(cadena){
        return{
            tipo:SENTENCIAS.IMPRIMIR,
            cadena:cadena
        };
    },
    nuevoWhile: function(logica,  sentencias){
        return{
           tipo:SENTENCIAS.WHILE,
           logica:logica,
           sentencias:sentencias
        };
    },
    nuevaDeclaracion: function(tipo_dato, id, valor){
        return{
            tipo:SENTENCIAS.DECLARACION,
            tipo_dato: tipo_dato,
            id:id,
            valor:valor
        };
    },
    nuevaAsignacion: function(id, expresion){
        return{
            tipo:SENTENCIAS.ASIGNACION,
            id:id,
            expresion:expresion
        };
    },
    nuevoIf: function(logica, sentencias){
        return{
            tipo:TIPO_OPERACIONES.IF,
            logica:logica,
            sentencias:sentencias
        };
    },
    nuevoIfElse: function(logica, sentenciasSI, sentenciasNO){
        return{
            tipo:SENTENCIAS.ELSE_IF,
            logica:logica,
            TRUE:sentenciasSI,
            FALSE:sentenciasNO
        };
    },
    nuevaClase: function(idenficador, Sentencias){
        return{
            tipo:SENTENCIAS.CLASE,
            id:idenficador,
            sentencias:Sentencias
        };
    },
    nuevoComentario: function(cadena){
        return{
            tipo:SENTENCIAS.COMENTARIO,
            cadena:cadena
        };        
    },
    nuevoImport: function(id){
        return{
            tipo:SENTENCIAS.IMPORT,
            id:id
        };
    },
    nuevoParametro: function(tipo_dato, id){
        return{
            tipo:SENTENCIAS.PARAMETRO,
            tipo_dato:tipo_dato,
            id:id
        };
    }

}
module.exports.TIPO_OPERACION = TIPO_OPERACIONES;
module.exports.SENTENCIAS = SENTENCIAS;
module.exports.TIPO_VALOR = TIPO_VALOR;
module.exports.instruccionesAPI = instruccionesAPI;