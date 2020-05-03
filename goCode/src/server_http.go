package main

import (
	"fmt"
	"log"
	"net/http"
)

const (
	CONN_HOST = "localhost"
	CONN_PORT = "8080"
)
func runServer(w http.ResponseWriter, r *http.Request){
	fmt.Fprintf(w, "¡Servidor Iniciado")
}
func main(){
	http.HandleFunc("/", runServer)
	err := http.ListenAndServe(CONN_HOST+":"+CONN_PORT, nil)
	if err != nil{
		log.Fatal("error al inciar el server: ", err)
		return
	}
}