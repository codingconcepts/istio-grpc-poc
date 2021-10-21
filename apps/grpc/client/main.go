package main

import (
	"context"
	"log"

	"github.com/codingconcepts/istio-grpc-poc/apps/grpc/pb"
	"google.golang.org/grpc"
)

func main() {
	hello()
	goodbye()
}

func hello() {
	conn, err := grpc.Dial("hello.grpc.scratchpad.xyz:80", grpc.WithInsecure())
	if err != nil {
		log.Fatalf("error dialling gRPC endpoint: %v", err)
	}
	defer conn.Close()

	client := pb.NewHelloServiceClient(conn)

	resp, err := client.Hello(context.Background(), &pb.HelloRequest{})
	if err != nil {
		log.Fatalf("error making hello request: %v", err)
	}
	log.Println(resp.Message)
}

func goodbye() {
	conn, err := grpc.Dial("goodbye.grpc.scratchpad.xyz:80", grpc.WithInsecure())
	if err != nil {
		log.Fatalf("error dialling gRPC endpoint: %v", err)
	}
	defer conn.Close()

	client := pb.NewGoodbyeServiceClient(conn)

	resp, err := client.Goodbye(context.Background(), &pb.GoodbyeRequest{})
	if err != nil {
		log.Fatalf("error making goodbye request: %v", err)
	}
	log.Println(resp.Message)
}
