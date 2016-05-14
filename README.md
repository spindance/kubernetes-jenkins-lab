# kubernetes-jenkins-lab
In order to be successful with this lab it is recommended that you follow the following tutorial on Kubernetes's site.  http://kubernetes.io/docs/hellonode/ .  Following this guide will ensure that you will be able to follow along during the code lab. 

Once you have your project setup we will need to create a cluster and a data disk.
```gcloud container clusters create jenkins-lab
gcloud compute disks create --size=20GB --zone=us-central1-b jenkins-data-jenkins-lab```

Once we have our cluster created we will start up our master jenkins server.  We will be using a replication controller.
```kubectl create -f jenkins-master-replication.yaml```
Container will die.  You have to change the permissions to the mount on the host machine.  SSH to host machine chmod 777 “jenkins_home” 
Delete replication service
kubectl delete rc jenkins-master
Recreate
kubectl create -f jenkins-master-replication.yaml
Create Service

