 #!/bin/bash
 # When you run this you will have to set an environment variable of PROJECT_ID
 # and VERSION. This will than build the docker images you need for the code lab
 # and will also upload them to Google Cloud Registry.

 if [[ ! -z $PROJECT_ID ]] ; then
   echo "Passed in PROJECT_ID:" $PROJECT_ID

   JENKINS_MASTER_TAG="gcr.io/$PROJECT_ID/jenkins-master:1.651.1"
   NODEJS_BUILDER_TAG="gcr.io/$PROJECT_ID/nodejs-slave:4.4.4"
   RUBY_BUILDER_TAG="gcr.io/$PROJECT_ID/ruby-slave:2.2.5"

   set -x
   #BUILD DOCKER JENKINS MASTER CONTAINER
   docker build -t $JENKINS_MASTER_TAG -f Dockerfile_jenkins_master .
   if [[ ! $? -eq 0 ]]; then
     echo "Jenkins Master didn't build."
     exit
   fi
   #PUSH CONTAINTER TO GOOGLE CLOUD REGISTRY
   gcloud docker push $JENKINS_MASTER_TAG

   if [[ ! $? -eq 0 ]]; then
     echo "Jenkins Master wasn't added to Google Container Registry."
     exit
   fi
   #BUILD DOCKER NODEJS SLAVE CONTAINER
   docker build -t $NODEJS_BUILDER_TAG -f Dockerfile_nodejs_slave .

   if [[ ! $? -eq 0 ]]; then
     echo "NODEJS slave didn't build."
     exit
   fi
   #PUSH CONTAINTER TO GOOGLE CLOUD REGISTRY
   gcloud docker push $NODEJS_BUILDER_TAG

   if [[ ! $? -eq 0 ]]; then
     echo "NODEJS Builder wasn't added to Google Container Registry."
     exit
   fi

   #BUILD DOCKER RUBY SLAVE CONTAINER
   docker build -t $RUBY_BUILDER_TAG -f Dockerfile_ruby_slave .

   if [[ ! $? -eq 0 ]]; then
     echo "RUBY slave didn't build."
     exit
   fi
   #PUSH CONTAINTER TO GOOGLE CLOUD REGISTRY
   gcloud docker push $RUBY_BUILDER_TAG

   if [[ ! $? -eq 0 ]]; then
     echo "NODEJS Builder wasn't added to Google Container Registry."
     exit
   else
     echo "ALL IMAGES BUILT READY TO ROLL"
   fi
else
  echo "You must set a PROJECT_ID environment variable. Like so export PROJECT_ID=LAB"
fi
