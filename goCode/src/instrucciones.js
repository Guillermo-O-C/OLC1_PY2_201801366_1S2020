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
    IMPRIMIR: 'S_IMMPRIMIR',
    IF: 'S_IF',
    ELSE_IF:    'S_ELSE_IF',
    SWITCH: 'S_SWITCH',
    WHILE:  'S_WHILE',
    DO_WHILE:   'S_DO_WHILE',
    FOR:    'S_FOR',
    RETURN: 'S_RETURN',
    CONTINUE:  'S_CONTINUE',
    BREAK:  'S_BREAK',
    DECLARACION:    'S_DECLARACION',
    ASIGNACION: 'S_ASIGNACION'
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
	nuevoOperacionBinaria: function(Izq, Der, tipo) {
		return nuevaOperacion(Izq, Der, tipo);
	},
}