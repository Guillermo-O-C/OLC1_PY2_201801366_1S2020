const express = require("express");
const app = express();
const parser = require('../goCode/src/gramatica');
const bodyReader = require('body-parser');
let entry;
app.listen(3000, () => {
    console.log("El servidor está inicializado en el puerto 3000");
});
app.use(bodyReader.json());
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "orgin, X-Requested-With, Content-Type, Accept");
    next();
});
app.post('/analizar', function(req, res) {
    entry = req.body.original;
    res.send(analizar());
});

function analizar() {
    let AST;
    try {
        AST = parser.parse(entry);
        console.log(JSON.stringify(AST, null, 2));
        return JSON.stringify(AST, null, 2);
    } catch (error) {
        console.log(error);
        return error;
    }
}

function DataMessenger() {
    var xml = new XMLHttpRequest();
    xml.open("POST", "http://localhost:3000/analizar", true);
    xml.setRequestHeader('Content-Type', 'application/json');
    xml.onreadystatechange = function() {
        if (xml.readyState == XMLHttpRequest.DONE) {
            alert("yasta");
            addAST(cml.responseText);
        }
    }
    xml.sendJSON(JSON.stringify({
        original: document.getElementById('original').getValue()
    }));
}