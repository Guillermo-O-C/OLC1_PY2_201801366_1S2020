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
    METODO: 'METODO',
    CASE: 'CASE',
    DEFAULT: 'DEFAULT',
    LLAMADA: 'LLAMADA',
    INCREMENTO: 'INCREMENTO',
    DECREMENTO: 'DECREMENTO'
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
            listId: id,
            valor: valor
        };
    },
    nuevaListaid: function(id, siguiente) {
        return {
            id: id,
            siguiente: siguiente
        };
    },
    nuevaVariable: function(lisId, valor) {
        return {
            tipo: SENTENCIAS.VARIABLE,
            listaId: lisId,
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
    nuevoIf: function(logica, sentencias, elseT) {
        return {
            tipo: SENTENCIAS.IF,
            logica: logica,
            sentencias: sentencias,
            else: elseT
        };
    },
    nuevoElseIf: function(logica, sentencias, elseT) {
        return {
            tipo: SENTENCIAS.ELSE_IF,
            logica: logica,
            sentencias: sentencias,
            else: elseT
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
    nuevaFuncion: function(id, parametros, sentencias) {
        return {
            tipo: SENTENCIAS.FUNCION,
            id: id,
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
    },
    nuevoSwitch: function(id, cases, defaultT) {
        return {
            tipo: SENTENCIAS.SWITCH,
            id: id,
            cases: cases,
            default: defaultT
        };
    },
    nuevoCase: function(expresion, sentencias) {
        return {
            tipo: SENTENCIAS.CASE,
            expresion: expresion,
            sentencais: sentencias
        };
    },
    nuevoDefault: function(sentencias) {
        return {
            tipo: SENTENCIAS.DEFAULT,
            sentencias: sentencias
        };
    },
    nuevoFor: function(inicial, final, paso, sentencias) {
        return {
            tipo: SENTENCIAS.FOR,
            inicial: inicial,
            final: final,
            paso: paso,
            sentencias: sentencias
        };
    },
    nuevaLlamada: function(id, parametros) {
        return {
            tipo: SENTENCIAS.LLAMADA,
            id: id,
            parametros: parametros
        };
    },
    nuevaDeclaracionVariable: function(tipoDato, declaracion) {
        return {
            tipo: SENTENCIAS.DECLARACION,
            tipo_dato: tipoDato,
            declaracion: declaracion
        };
    },
    nuevoReturnFuncion: function(expresion) {
        return {
            tipo: SENTENCIAS.RETURN,
            valor: expresion
        };
    },
    nuevoDoWhile: function(sentencias, logica) {
        return {
            tipo: SENTENCIAS.DO_WHILE,
            sentencias: sentencias,
            logica: logica
        };
    },
    nuevoArgumento: function(expresion, siguiente) {
        return {
            expresion: expresion,
            siguiente: siguiente
        };
    },
    nuevoIncremento: function(id) {
        return {
            tipo: SENTENCIAS.INCREMENTO,
            id: id
        };
    },
    nuevoDecremento: function(id) {
        return {
            tipo: SENTENCIAS.DECREMENTO,
            id: id
        };
    }
}
module.exports.TIPO_OPERACION = TIPO_OPERACIONES;
module.exports.SENTENCIAS = SENTENCIAS;
module.exports.TIPO_VALOR = TIPO_VALOR;
module.exports.instruccionesAPI = instruccionesAPI;