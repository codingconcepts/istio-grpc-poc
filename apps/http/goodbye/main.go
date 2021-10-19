package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", goodbye)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func goodbye(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Goodbye, Cruel World!")
}
