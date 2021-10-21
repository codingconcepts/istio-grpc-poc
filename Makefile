########################
# Prerequisite targets #
########################

protos:
	protoc \
		-I apps/grpc \
		--go_out=apps/grpc/pb --go-grpc_out=apps/grpc/pb \
		apps/grpc/service.proto

apply_namespace:
	kubectl apply -f manifests/namespace.yaml

delete_namespace:
	kubectl delete -f manifests/namespace.yaml

istio_download:
	wget https://github.com/istio/istio/releases/download/1.11.4/istio-1.11.4-win.zip
	unzip istio-1.11.4-win.zip
	rm istio-1.11.4-win.zip
	mv istio-1.11.4/bin/istioctl.exe istioctl.exe

apply_istio:
	./istioctl.exe install --set profile=default -y -f manifests/istio.yaml
	-kubectl label namespace routing-poc istio-injection=enabled
	-kubectl label namespace routing-poc istio-injection=enabled

delete_istio:
	./istioctl.exe x uninstall --purge

################
# Build targets #
################

build_http_hello:
	GOOS=linux go build -o apps/http/hello/http-hello apps/http/hello/main.go
	docker build -f apps/http/hello/Dockerfile -t codingconcepts/http-hello:latest ./apps
	docker push codingconcepts/http-hello:latest

build_http_goodbye:
	GOOS=linux go build -o apps/http/goodbye/http-goodbye apps/http/goodbye/main.go
	docker build -f apps/http/goodbye/Dockerfile -t codingconcepts/http-goodbye:latest ./apps
	docker push codingconcepts/http-goodbye:latest

build_grpc_hello:
	GOOS=linux go build -o apps/grpc/hello/grpc-hello apps/grpc/hello/main.go
	docker build -f apps/grpc/hello/Dockerfile -t codingconcepts/grpc-hello:latest ./apps
	docker push codingconcepts/grpc-hello:latest

build_grpc_goodbye:
	GOOS=linux go build -o apps/grpc/goodbye/grpc-goodbye apps/grpc/goodbye/main.go
	docker build -f apps/grpc/goodbye/Dockerfile -t codingconcepts/grpc-goodbye:latest ./apps
	docker push codingconcepts/grpc-goodbye:latest

#############################
# Shared Kubernetes targets #
#############################

apply_gateway:
	kubectl apply -f manifests/gateway.yaml -n routing-poc

delete_gateway:
	kubectl delete -f manifests/gateway.yaml -n routing-poc

######################
# Deployment targets #
######################

http_apply_hello:
	kubectl apply -f manifests/http.hello.yaml -n routing-poc

http_delete_hello:
	kubectl delete -f manifests/http.hello.yaml -n routing-poc

http_apply_goodbye:
	kubectl apply -f manifests/http.goodbye.yaml -n routing-poc

http_delete_goodbye:
	kubectl delete -f manifests/http.goodbye.yaml -n routing-poc


grpc_apply_hello:
	kubectl apply -f manifests/grpc.hello.yaml -n routing-poc

grpc_delete_hello:
	kubectl delete -f manifests/grpc.hello.yaml -n routing-poc

grpc_apply_goodbye:
	kubectl apply -f manifests/grpc.goodbye.yaml -n routing-poc

grpc_delete_goodbye:
	kubectl delete -f manifests/grpc.goodbye.yaml -n routing-poc

#################
# Check targets #
#################

check:
	curl hello.http.scratchpad.xyz
	curl goodbye.http.scratchpad.xyz
	grpcurl -plaintext -max-time 3 hello.grpc.scratchpad.xyz:8080 HelloService.Hello
	grpcurl -plaintext -max-time 3 goodbye.grpc.scratchpad.xyz:8080 GoodbyeService.Goodbye