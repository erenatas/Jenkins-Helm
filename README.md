# Jenkins Helm Chart Example
Complete **Jenkins Helm Chart**, with **Ansible playbook** for automated configuration management. Key features:


1. Simple installation
2. Powered with [Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/)
3. Configured with [JCasC](https://jenkins.io/projects/jcasc/)
4. Example pipeline job included.

This Jenkins Helm Chart leverages the [Jenkins Kubernetes Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin) in order to have scaling abilities of Kubernetes to schedule build agents. These build agents are contained in pods.

<details>
  <summary><strong>Table of Contents</strong> (click to expand)</summary>

<!-- toc -->

- [Prerequisites](#prerequisites)
  - [Deployment with Ansible Playbook](#deployment-with-ansible-playbook)
  - [Manual Deployment](#manual-deployment)
  - [Tested Versions](#tested-versions)
- [Tested Environments](#tested-environments)
- [Configuration](#configuration)
  - [Authentication](#authentication)
  - [Jenkins Configuration](#jenkins-configuration)
  - [Job Configuration](#job-configuration)
  - [Plugin Configuration](#plugin-configuration)
  - [Setting Ports](#setting-ports)
  - [Agent Configuration](#slave-configuration)
- [Installation](#installation)
  - [Installation with Ansible Playbook](#installation-with-ansible-playbook)
  - [Manual Installation](#manual-installation)
- [Usage](#usage)
- [Uninstalling Helm Chart](#uninstalling-helm-chart)
- [Final Notes](#final-notes)
- [Credits](#credits)

<!-- tocstop -->

</details>

## Prerequisites
### Deployment with Ansible Playbook
#### Control Node
Currently Ansible can be run from any machine with Python 2 (version 2.7) or Python 3 (versions 3.5 and higher) installed. Windows isn’t supported for the control node. Tested and recommended environment is Ubuntu 18.04.
#### Managed Node
- A Linux distribution that has APT(Advanced Packaging Tool) and supported by Docker. Recommended and tested distribution is Ubuntu 18.04. Fresh installation would be preferred.
- SSH Connection for running Ansible Playbook.

#### Tested Versions
- Minikube: 
```
minikube version: v1.3.1
commit: ca60a424ce69a4d79f502650199ca2b52f29e631
```
- Helm:  
```
Client: &version.Version{SemVer:"v2.14.3", GitCommit:"0e7f3b6637f7af8fcfddb3d2941fcc7cbebb0085", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.14.3", GitCommit:"0e7f3b6637f7af8fcfddb3d2941fcc7cbebb0085", GitTreeState:"clean"}
```
- Ansible:
```
ansible 2.8.5
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/eren/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.15+ (default, Jul  9 2019, 16:51:35) [GCC 7.4.0]
```


### Manual Deployment
For running this helm chart on your own environment, you should make sure to have Minikube and Helm installed in your environment. For detailed instructions on how to install Minikube and Helm, you can check [Installing Kubernetes with Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/) and [Installing Helm
](https://helm.sh/docs/using_helm/#installing-helm). Manual installation for Ubuntu 18.04 will be explained in detail in [Installation Section](#installation).

## Tested Environments
- Control Node:
  - Ubuntu 18.04
- Managed Node:
  - Ubuntu 18.04

## Configuration
### Authentication
In the ```values.yaml```, default username is ```admin``` and password is ```admin```, if you want, you can change it from ```values.yaml```.
<pre>
master:
  image:
    name: jenkins/jenkins
    tag: lts
    pullPolicy: "Always"
  authentication:
  <b>
    username: admin
    password: admin
  </b>
  ...
</pre>

### Jenkins Configuration
Jenkins configuration has been done with [JCasC](https://jenkins.io/projects/jcasc/). All of the configuration can be found in ```templates/jcasc-config.yaml```.
### Job Configuration
Jobs are being held under ```jobs``` directory. You can save your jobs as ```<jobname>.xml``` file, ```post-install-script.sh``` script will put them as ```/var/jenkins_home/jobs/<jobname>/config.xml``` under Jenkins master pod.
### Plugin Configuration
Currently installed plugins can be found in ```templates/install-config.yaml```. You can add the plugins that you would want here. You can also see the current versions of plugins here.
<pre>
  plugins.txt: |-
    kubernetes:1.18.2
    workflow-job:2.33
    workflow-aggregator:2.6
    credentials-binding:1.19
    git:3.11.0
    configuration-as-code:1.27
    nodejs:1.3.3
    docker-workflow:1.19
    <b>Desired Plugin Here!</b>
</pre>
### Agent Configuration
As you may see in ```values.yaml``` file, I had to build and push my own image in order to have proprietary packages for running an example job. You can see the ```Dockerfile```. \
You can change the image and tag names in ```values.yaml```. You can also change the resources of Jenkins resources.
### Setting Ports
This Helm Chart's service type is ```NodePort```. The default Jenkins Master port is ```30005```. If you want, you can change it to desired port in ```values.yaml```. You can also change the Slave listener port which is ```50000``` by default. 
## Installation
### Installation with Ansible playbook
In order to use the installation with Ansible playbooks, you need to install Ansible on your control node. It is quite simple.
**Installing Ansible on Ubuntu 18.04:**
1. Add Ansible project's PPA(personal package archive) to your system
```
# Update Packages

apt update

# Install software-properties-common

apt install software-properties-common

# Add Ansible repository

apt-add-repository ppa:ansible/ansible

# Press ENTER to accept the PPA addition.

# Update Packages

apt update
```

2. Install Ansible
```
apt install ansible
```

Your control node has all the software needed to control your managed nodes now!

3. On control node, make sure to open SSH port. Make sure to check SSH server is running and SSH port is open.

4. Edit Ansible hosts file and put your server ip address such as:
```
# /etc/ansible/hosts
[testserver]
35.165.79.66 ansible_user=ubuntu
```
**Note**: In Ansible Playbook, hosts are ```testserver```. If you need vir use a different hosts, please change it from ```playbook.yaml```.

5. Put the target instance's ssh keys into ```./ssh/authorized_keys```
```
cat ~/.ssh/id_rsa.pub | ssh <user>@<hostname> 'cat >> .ssh/authorized_keys && echo "Key copied"'
```

6. Run the Ansible Playbook by:
```
ansible-playbook playbook.yaml -K
```

Done! Everything should be working correctly.

### Manual Installation
**For installation on Ubuntu 18.04:**
1. Install required packages with the following command:
```
apt-get install curl wget apt-transport-https -y
```
2. Install VirtualBox HyperVisor
```$ helm install . --name jenkins
NAME:   jenkins
LAST DEPLOYED: Thu Sep 19 19:38:52 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME                              DATA  AGE
jenkins-erenjenkins-jasc-config   3     1s
jenkins-erenjenkins-jobs          1     1s
jenkins-erenjenkins-post-install  2     1s

==> v1/Deployment
NAME                 READY  UP-TO-DATE  AVAILABLE  AGE
jenkins-erenjenkins  0/1    1           0          0s

==> v1/Pod(related)
NAME                                  READY  STATUS    RESTARTS  AGE
jenkins-erenjenkins-5bdd965676-mm6gq  0/1    Init:0/1  0         0s

==> v1/Role
NAME                                 AGE
jenkins-erenjenkins-schedule-agents  0s

==> v1/RoleBinding
NAME                                 AGE
jenkins-erenjenkins-schedule-agents  0s

==> v1/Service
NAME                       TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)         AGE
jenkins-erenjenkins        NodePort   10.106.123.163  <none>       8080:30005/TCP  0s
jenkins-erenjenkins-agent  ClusterIP  10.108.7.188    <none>       50000/TCP       0s

==> v1/ServiceAccount
NAME                       SECRETS  AGE
jenkins-erenjenkins        1        0s
jenkins-erenjenkins-agent  1        1s


eren@eren-XPS-15-9570:~/GitRepos/jenkins/jenkins-chart$ kubectl get po -w
NAME                                   READY   STATUS     RESTARTS   AGE
jenkins-erenjenkins-5bdd965676-mm6gq   0/1     Init:0/1   0          10s
jenkins-erenjenkins-5bdd965676-mm6gq   0/1     PodInitializing   0          25s
jenkins-erenjenkins-5bdd965676-mm6gq   1/1     Running           0          28s


apt-get install virtualbox virtualbox-ext-pack
```
3. Install Minikube
```
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
cp minikube-linux-amd64 /usr/local/bin/minikube
chmod 755 /usr/local/bin/minikube
```
4. Check Minikube Version
```
minikube version

# You should see the following output:
# $ minikube version
# minikube version: v1.3.1
# commit: ca60a424ce69a4d79f502650199ca2b52f29e631
```
5. Install Kubectl
```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update -y && apt-get install kubectl -y
```
6. Check Kubectl version
```
kubectl version

# You should see the following output:
# $ kubectl version
# Client Version: version.Info{Major:"1", Minor:"15", GitVersion:"v1.15.3", GitCommit:"2d3c76f9091b6bec110a5e63777c332469e0cba2", GitTreeState:"clean", BuildDate:"2019-08-19T11:13:54Z", GoVersion:"go1.12.9", Compiler:"gc", Platform:"linux/amd64"}
# Server Version: version.Info{Major:"1", Minor:"15", GitVersion:"v1.15.2", GitCommit:"f6278300bebbb750328ac16ee6dd3aa7d3549568", GitTreeState:"clean", BuildDate:"2019-08-05T09:15:22Z", GoVersion:"go1.12.5", Compiler:"gc", Platform:"linux/amd64"}

```
7. Start Minikube
This command will fire up a Virtualbox VM set single node cluster for you. 

**Note:** Instead of using Virtualbox, you can also use KVM or not use any VMs at all. You can use ```--vm-driver``` flag for choosing the option for your installation. Manual deployment guide was prepared for using Minikube with Virtualbox. For more detail, please see [Install Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/).
```
minikube start
# I have used this command with memory and cpus flags due to not having enough memory for Jenkins agent pods.
# minikube start --cpus 4 --memory 8192
```

8. Download and install Helm
```
# Download Helm

wget https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz

# Extract the archive

tar -zxvf helm-v2.14.3-linux-amd64.tar.gz

# Move the “helm” binary to an appropriate location

mv linux-amd64/helm /usr/local/bin/helm
```

9. Install Tiller with Helm
```
helm init --history-max 200
```

9. Clone this repo:
```
git clone <link of this repo>
```

10. Install Jenkins Helm Chart
```
# Change directory to ./jenkins/jenkins-chart

cd ./jenkins/jenkins-chart

# Install helm chart with the name jenkins

helm install . --name jenkins
```

11. Wait for jenkins pod to run
```
# To watch the containers and see Jenkins master running

kubectl get po -w
```

If you are seeing the following output, it means that Helm chart has been installed successfully:
```
$ helm install . --name jenkins
NAME:   jenkins
LAST DEPLOYED: Thu Sep 19 19:38:52 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME                              DATA  AGE
jenkins-erenjenkins-jasc-config   3     1s
jenkins-erenjenkins-jobs          1     1s
jenkins-erenjenkins-post-install  2     1s

==> v1/Deployment
NAME                 READY  UP-TO-DATE  AVAILABLE  AGE
jenkins-erenjenkins  0/1    1           0          0s

==> v1/Pod(related)
NAME                                  READY  STATUS    RESTARTS  AGE
jenkins-erenjenkins-5bdd965676-mm6gq  0/1    Init:0/1  0         0s

==> v1/Role
NAME                                 AGE
jenkins-erenjenkins-schedule-agents  0s

==> v1/RoleBinding
NAME                                 AGE
jenkins-erenjenkins-schedule-agents  0s

==> v1/Service
NAME                       TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)         AGE
jenkins-erenjenkins        NodePort   10.106.123.163  <none>       8080:30005/TCP  0s
jenkins-erenjenkins-agent  ClusterIP  10.108.7.188    <none>       50000/TCP       0s

==> v1/ServiceAccount
NAME                       SECRETS  AGE
jenkins-erenjenkins        1        0s
jenkins-erenjenkins-agent  1        1s


$ kubectl get po -w
NAME                                   READY   STATUS     RESTARTS   AGE
jenkins-erenjenkins-5bdd965676-mm6gq   0/1     Init:0/1   0          10s
jenkins-erenjenkins-5bdd965676-mm6gq   0/1     PodInitializing   0          25s
jenkins-erenjenkins-5bdd965676-mm6gq   1/1     Running           0          28s


```

12. Expose Jenkins' port
```
minikube service jenkins-erenjenkins
```
**Note:** If you did not use ```--name``` flag with ```helm install``` or set up a different name, this ```minikube service``` command may not work for you. In order to make it work, you need to put the ```Service``` name. If you do not know what the service name is, you can learn it with ```kubectl get svc``` and use that name with ```minikube service```.

14. Open Chrome and go to ```http://localhost:30005```. Your Jenkins is ready!

## Usage
All you need to do is open chrome, go to ```http://<hosturl>:30005``` and login. You can trigger the example job.

## Uninstalling Helm Chart
The best way to uninstall Helm chart installation to do the following:
```
# Learn the name of your chart
helm ls

# Delete the chart
helm del --purge <chartname>

#Example:
# helm del --purge jenkins
```

All the Kubernetes objects of the Chart will be terminated and deleted.


## Credits
- https://helm.sh/docs/chart_best_practices/
- https://www.howtoforge.com/how-to-install-kubernetes-with-minikube-on-ubuntu-1804-lts/
- https://kubernetes.io/docs/setup/learning-environment/minikube/
- https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#control-node-requirements
- https://github.com/jenkinsci/jenkins
- https://github.com/jenkinsci/docker-jnlp-slave
- https://github.com/jenkinsci/configuration-as-code-plugin

Eren ATAS, 19.09.2019