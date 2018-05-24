# Kubernetes cheat sheet

List of commonly used features in Kubernetes.

#### Enable proxy protocol (AWS Loadbalancer only)
```
---
apiVersion: v1
kind: Service
metadata:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
```

#### Enable proxy protocol (nginx-ingress only)
```
---
apiVersion: v1
kind: ConfigMap
data:
  use-proxy-protocol: "true"
```

#### Whitelist access by IP (Ingress level)
```
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/whitelist-source-range: "1.1.1.1/24,2.2.2.2/24"
```

#### Whitelist access by IP (Service/Loadbalancer level)
```
---
apiVersion: v1
kind: Service
spec:
  loadBalancerSourceRanges:
    - 1.1.1.1/24
    - 2.2.2.2/32
```
