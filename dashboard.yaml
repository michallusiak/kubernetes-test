## ---------
## Dashboard
## ---------

$ minikube dashboard --url

# To use SSM make sure you have the following attached to your EC2 instance:
#
# Role: e.g. SSMRoleForEC2
# Policy: AmazonSSMManagedInstanceCore

# http://127.0.0.1:8080/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/

$ aws ssm start-session \
    --target i-0d28cd28e8fb820fd \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["35481"], "localPortNumber":["8080"]}'