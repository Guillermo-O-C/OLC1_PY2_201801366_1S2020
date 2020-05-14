const TIPO_VALOR = {
    NUMERO: 'NUMERO',
    DECIMAL: 'DECIMAL',
    IDENTIFICADOR: 'IDENTIFICADOR',
    CADENA: 'CADENA',
    CARACTER: 'CARACTER',
    TRUE: 'TRUE',
    FALSE: 'FALSE'
}
const TIPO_OPERACIONES = {
    SUMA: 'SUMA',
    RESTA: 'RESTA',
    MULTIPLICACION: 'MULTIPLICACION',
    DIVISION: 'DIVISION',
    NEGATIVO: 'NEGATIVO',
    MAYOR: 'MAYOR',
    MAYOR_IGUAL: 'MAYOR_IGUAL',
    MENOR: 'MENOR',
    MENOR_IGUAL: 'MENOR_IGUAL',
    CONCATENACION: 'CONCATENACION',
    IGUAL_IGUAL: 'IGUAL IGUAL',
    DISTINTO: 'DISTINTO',
    CONDICION: 'CONDICION',
    AND: 'AND',
    OR: 'OR',
    NOT: 'NOT'
};

const SENTENCIAS = {
    CLASE: 'CLASE',
    ASIGNACION: 'ASIGNACION',
    DECLARACION: 'DECLARACION',
    IMPORT: 'IMPORT',
    IF: 'IF',
    ELSE_IF: 'ELSE_IF',
    ELSE: 'ELSE',
    SWITCH: 'SWITCH',
    WHILE: 'WHILE',
    DO_WHILE: 'DO_WHILE',
    FOR: 'FOR',
    FUNCION: 'FUNCION',
    MAIN: 'MAIN',
    RETURN: 'RETURN',
    CONTINUE: 'CONTINUE',
    BREAK: 'BREAK',
    IMPRIMIR: 'IMPRIMIR',
    COMENTARIO: 'COMENTARIO',
    PARAMETRO: 'PARAMETRO',
    VARIABLE: 'VARIABLE',
    METODO: 'METODO'
}

function nuevaOperacion(operandoIzq, OperandoDer, tipo) {
    return {
        operandoIzq: operandoIzq,
        OperandoDer: OperandoDer,
        tipo: tipo
    }
}

const instruccionesAPI = {
    nuevaOperacionBinaria: function(Izq, Der, tipo) {
        return nuevaOperacion(Izq, Der, tipo);
    },
    nuevaOperacionUnaria: function(izq, tipo) {
        return nuevaOperacion(izq, undefined, tipo);
    },
    nuevoValor: function(valor, tipo) {
        return {
            tipo: tipo,
            valor: valor
        };
    },
    nuevaCondicion: function(logica) {
        return {
            tipo: TIPO_OPERACIONES.CONDICION,
            logica: logica
        };
    },
    nuevoImprimir: function(cadena) {
        return {
            tipo: SENTENCIAS.IMPRIMIR,
            cadena: cadena
        };
    },
    nuevoWhile: function(logica, sentencias) {
        return {
            tipo: SENTENCIAS.WHILE,
            logica: logica,
            sentencias: sentencias
        };
    },
    nuevaDeclaracion: function(tipo_dato, id, valor) {
        return {
            tipo: SENTENCIAS.DECLARACION,
            tipo_dato: tipo_dato,
            id: id,
            valor: valor
        };
    },
    nuevaVariable: function(valor) {
        return {
            tipo: SENTENCIAS.VARIABLE,
            valor: valor
        };
    },
    nuevaAsignacion: function(id, expresion) {
        return {
            tipo: SENTENCIAS.ASIGNACION,
            id: id,
            expresion: expresion
        };
    },
    nuevoIf: function(logica, sentencias) {
        return {
            tipo: SENTENCIAS.IF,
            logica: logica,
            sentencias: sentencias
        };
    },
    nuevoElseIf: function(logica, sentencias) {
        return {
            tipo: SENTENCIAS.ELSE_IF,
            logica: logica,
            sentencias: sentencias
        };
    },
    nuevoElse: function(sentencias) {
        return {
            tipo: SENTENCIAS.ELSE,
            sentencias: sentencias
        };
    },
    nuevoWhile: function(logica, sentencias) {
        return {
            tipo: SENTENCIAS.WHILE,
            logica: logica,
            sentencias: sentencias
        };
    },
    nuevaClase: function(idenficador, Sentencias) {
        return {
            tipo: SENTENCIAS.CLASE,
            id: idenficador,
            sentencias: Sentencias
        };
    },
    nuevoComentario: function(cadena) {
        return {
            tipo: SENTENCIAS.COMENTARIO,
            cadena: cadena
        };
    },
    nuevoImport: function(id) {
        return {
            tipo: SENTENCIAS.IMPORT,
            id: id
        };
    },
    nuevoParametro: function(tipo_dato, id, siguiente) {
        return {
            tipo: SENTENCIAS.PARAMETRO,
            tipo_dato: tipo_dato,
            id: id,
            siguiente: siguiente
        };
    },
    nuevaFuncion: function(parametros, sentencias) {
        return {
            tipo: SENTENCIAS.FUNCION,
            parametros: parametros,
            sentencias: sentencias
        };
    },
    nuevoMain: function(sentencias) {
        return {
            tipo: SENTENCIAS.MAIN,
            sentencias: sentencias
        };
    },
    nuevoMetodo: function(id, parametros, sentencias) {
        return {
            tipo: SENTENCIAS.METODO,
            id: id,
            parametros: parametros,
            sentencias: sentencias
        };
    },
    nuevaExpresionLogica: function(expresion) {
        return {
            expresion: expresion
        };
    }

}
module.exports.TIPO_OPERACION = TIPO_OPERACIONES;
module.exports.SENTENCIAS = SENTENCIAS;
module.exports.TIPO_VALOR = TIPO_VALOR;
module.exports.instruccionesAPI = instruccionesAPI;