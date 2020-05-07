package main

import (
	"fmt"
	_ "fmt"
	"html/template"
	"log"
	"net/http"
	"strconv"
	_ "strconv"
)

const (
	CONN_HOST = "localhost"
	CONN_PORT = "8080"
)

var tpl *template.Template

func init() {
	tpl = template.Must(template.ParseGlob("*.gohtml"))
}
func main() {
	http.HandleFunc("/", runServer)
	http.HandleFunc("/analizar", analizar)
	err := http.ListenAndServe(CONN_HOST+":"+CONN_PORT, nil)
	if err != nil {
		log.Fatal("error al inciar el server: ", err)
		return
	}
}
func analizar(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Redirect(w, r, "/", http.StatusSeeOther)
		return
	}
	/*
		fname := r.FormValue("firster")
		lname := r.FormValue("laster")
		fmt.Fprintf(w, fname+lname)*/
	counter := r.FormValue("tabCounter")
	fmt.Fprintf(w, counter)
	counterInt, err := strconv.Atoi(counter)
	print(err)
	AllFiles := make([]Entrada, counterInt, 2*counterInt)
	for i := 0; i < counterInt; i++ {
		AllFiles[i].content = r.FormValue("entrada" + strconv.Itoa(i))
	}
}
func runServer(w http.ResponseWriter, r *http.Request) {
	tpl.ExecuteTemplate(w, "index.gohtml", nil)
	/*fmt.Fprintf(w, "¡Servidor Iniciado")
		w.Header().Set("Content-Type", "application/json")
		switch r.Method {
			case "GET":
	        	w.WriteHeader(http.StatusOK)
	        	w.Write([]byte(`{"message": "get called"}`))
			case "POST":
	        	w.WriteHeader(http.StatusCreated)
	        	w.Write([]byte(`{"message": "post called"}`))
			default:
	       	 	w.WriteHeader(http.StatusNotFound)
	        	w.Write([]byte(`{"message": "not found"}`))
		}*/
}

type Entrada struct {
	content string
}
