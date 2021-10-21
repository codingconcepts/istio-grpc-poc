# istio-grpc-poc
Manifests to create an Istio gRPC POC

## Running locally

### Prerequisites

Make sure you're connected to a cloud-based Kubernetes service (I'm using EKS) and have the following binaries installed and accessible via the PATH:

* `kubectl`
* `curl`
* `grpcurl`

Run the following commands to install Istio:
```
$ make istio_download

$ make apply_istio
```

### Manifests

Replace any instances of `scratchpad.xyz` with a domain of your choosing. I own this domain and that's what I'm using for my tests (so you won't have access to point this to your Istio gateway).

Run the following command to create a namespace for the gateway and services:
```
$ make apply_namespace
```

Run the following command to create the Istio gateway:
```
$ make apply_gateway
```

Run the following commands to create the services:
```
$ make http_apply_hello

$ make http_apply_goodbye

$ make grpc_apply_hello
```

### Testing

Run the following command to assert connectivity to your services:
```
$ make check
```