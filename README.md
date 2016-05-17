# kubernetes-jenkins-lab
In order to be successful with this lab it is recommended that you follow the following tutorial on Kubernetes's site.  http://kubernetes.io/docs/hellonode/ .  Following this guide will ensure that you will be able to follow along during the code lab.

## Setup
We will need a couple of docker containers in order to get our lab working.  In this repo you will find a script that will take care of that for you.  In order for this to work you need to have your docker environment working and provide one environment variable.  You can do that by doing the following.
```
export PROJECT_ID='google project id'
sh buildImages.sh
```

### Creating Cluster
Once you have your project setup we will need to create a cluster and a data disk.

```
gcloud container clusters create jenkins-lab
gcloud compute disks create --size=20GB --zone=us-central1-b jenkins-data-jenkins-lab
```

### Creating Jenkins Master
With the cluster created we will start up our master jenkins server.  We will be using a replication controller in order to do this.  It's worth noting that because we have to use a volume mounted unto our node currently we can only have a replication factor of 1. The only feature we will be using from the replication controller is keeping the pod alive.

#### Jenkins Master Replication Controller
```kubectl create -f jenkins-master-replication.yaml```

The first time that we start the replication controller the pod will not come up.  The reason for this is that our container doesn't have permissions to the underlying filesystem so we have to change the permissions to the mount on the host machine.  SSH to host machine `chmod 777 “jenkins_home”`

Once you have changed permissions on the host, delete the replication controller.

```kubectl delete rc jenkins-master```

Now that we have deleted the replication controller and fixed permissions we will have to recreate the controller again.

`kubectl create -f jenkins-master-replication.yaml`

#### Create Jenkins Master Service
Currently we will not be able to interact with the Jenkins server from outside the container cluster.  In order to be able to do this we will have to create a service which will map an IP to our Jenkins environment.  This ip will be internet routable and we will use it in order to interact with Jenkins.  We will tell the service to load balance two ports for us.  Port 8080 and port 50000.

```kubectl create -f jenkins-master-service.yaml```

In order to find the ip that we will use to interact with Jenkins we will query the services until our service named 'jenkins-master' gets an external IP address.

```kubectl get services```

At this point we have a jenkins instance that we can interact with, all you have to do is open your browser and type in the external ip along with port 8080.  `http://external_ip:8080`
One thing to note that since the jenkins home directory is stored in a volume if you destroy the jenkins instance that configuration information is still stored on the volume.

For this to work you will have to install one jenkins plugin that doesn't come stock and that is the Kubernetes plugin.  https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin
