alias kubectl='minikube kubectl --'
alias k='minikube kubectl --'
alias dps='docker ps'

minikube start
# minikube stop

eval $(minikube docker-env)
# eval $(minikube docker-env --unset)

# kubectl proxy --address 0.0.0.0 --accept-hosts '.*' --port 8080
# Access to https://xxx.amazonaws.com:8080/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/

kubectl completion bash > ./kubectl_comp.sh
source ./kubectl_comp.sh
rm ./kubectl_comp.sh
