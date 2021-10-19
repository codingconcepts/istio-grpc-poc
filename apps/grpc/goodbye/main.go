package main

import (
	"context"
	"log"
	"net"

	"github.com/codingconcepts/istio-grpc-poc/apps/grpc/pb"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func main() {
	listener, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("error creating listener: %v", err)
	}

	server := &server{}

	svr := grpc.NewServer()
	pb.RegisterGoodbyeServiceServer(svr, server)

	reflection.Register(svr)

	log.Println("ready")

	if err = svr.Serve(listener); err != nil {
		log.Fatalf("error serving: %v", err)
	}
}

type server struct {
	pb.UnimplementedGoodbyeServiceServer
}

func (s *server) Hello(ctx context.Context, _ *pb.GoodbyeRequest) (*pb.GoodbyeResponse, error) {
	return &pb.GoodbyeResponse{
		Message: "Goodbye, Cruel World!",
	}, nil
}
