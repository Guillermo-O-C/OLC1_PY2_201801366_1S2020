class Clase {
    constructor(id, funciones) {
        this.id = id;
        this.funciones = funciones;
    }
}
class Funcion {
    constructor(tipo, id, parametros, variables) {
        this.id = id;
        this.parametros = parametros;
        this.tipo = tipo;
        this.variables = variables;
    }
}
class Parametro {
    constructor(tipo, id) {
        this.tipo = tipo;
        this.id = id;
    }
}
class Variable {
    constructor(tipo, id) {
        this.tipo = tipo;
        this.id = id;
    }
}
const AsignValue = {
    asignarVariables: function(tipo, variableList, Variables) {
        variableList.forEach(element => {
            element.tipo = tipo;
            Variables.push(element);
        });
    }
}
module.exports.Clase = Clase;
module.exports.Funcion = Funcion;
module.exports.Parametro = Parametro;
module.exports.Variable = Variable;
module.exports.AsignValue = AsignValue;