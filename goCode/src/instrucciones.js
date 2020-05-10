const TIPO_VALOR = {
    NUMERO: 'VAL_NUMERO',
    DECIMAL: 'VAL_DECIMAL',
    IDENTIFICADOR: 'VAL_IDENTIFICADOR',
    CADENA: 'VAL_CADENA',
    CARACTER: 'VAL_CARACTER',
    VERDADERO: 'VAL_VERDADEDRO',
    FALSO: 'VAL_FALSO'
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
    CLASE: 'S_CLASE',
    ASIGNACION: 'S_ASIGNACION',
    DECLARACION:    'S_DECLARACION',
    IMPORT: 'S_IMPORT',
    IF: 'S_IF',
    ELSE_IF:    'S_ELSE_IF',
    SWITCH: 'S_SWITCH',
    WHILE:  'S_WHILE',
    DO_WHILE:   'S_DO_WHILE',
    FOR:    'S_FOR',
    FUNCION: 'S_FUNCION',
    MAIN:   'S_MAIN',
    RETURN: 'S_RETURN',
    CONTINUE:  'S_CONTINUE',
    BREAK:  'S_BREAK',
    IMPRIMIR: 'S_IMPRIMIR',
    
}

function nuevaOperacion(operandoIzq, OperandoDer, tipo){
    return {
        operandoIzq:operandoIzq,
        OperandoDer:OperandoDer,
        tipoo:tipo
    }
}

const InstruccionesAPI = {
    /**
	 * Crea un nuevo objeto tipo Operación para las operaciones binarias válidas.
	 * @param {*} Izq 
	 * @param {*} Der 
	 * @param {*} tipo 
	 */
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
            tipo:TIPO_OPERACIONES.IMPRIMIR,
            cadena:cadena
        };
    },
    nuevoWhile: function(logica,  sentencias){
        return{
           tipo:TIPO_OPERACIONES.WHILE,
           logica:logica,
           sentencias:sentencias
        };
    },
    nuevaDeclaracion: function(id){
        return{
            tipo:TIPO_OPERACIONES.DECLARACION,
            id:id
        };
    },
    nuevaAsignacion: function(id, expresion){
        return{
            tipo:TIPO_OPERACIONES.ASIGNACION,
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
            tipo:TIPO_OPERACIONES.ELSE_IF,
            logica:logica,
            TRUE:sentenciasSI,
            FALSE:sentenciasNO
        };
    },
    nuevaClase: function(idenficador, Sentencias){
        return{
            tipo:TIPO_OPERACIONES.CLASE,
            id:idenficador,
            sentencias:Sentencias
        }
    }

}

module.exports.TIPO_OPERACIONES =  TIPO_OPERACIONES;
module.exports.TIPO_VALOR =  TIPO_VALOR;
module.exports.SENTENCIAS =  SENTENCIAS;
module.exports.InstruccionesAPI = InstruccionesAPI;