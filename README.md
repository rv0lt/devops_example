# Devops_example

[![pipeline](https://github.com/rv0lt/devops_example/actions/workflows/actions.yml/badge.svg)](https://github.com/rv0lt/devops_example/actions/workflows/actions.yml)

This repository is a small project containing an example for a DevOps worflow:

- [Demo project of two web servers developed](#web-servers)
 - [CI pipeline with github actions](#ci-pipeline)
 - [Provisioning of resources with Terraform](#terraform)
 - [Configuration and deployment up of the servers on the instances with ansible](#ansible)

# Web servers

There are two demo web servers applications developed:

 - One of them is a nginx web server
 - The other one was built using the flask framework

Both of them are bundled in docker containers.

The first one (the nginx) serves on **localhost:8000/cv** my resume. Whereas the second one has two endoints: in **locahost:5000/time** displays the time in Unix and **localhost:5000/random** gives 5 random numbers from 1 to 10.

The two directories: [webserver_example_1](https://github.com/rv0lt/devops_example/tree/main/webserver_example_1 "webserver_example_1") and [webserver_example_2](https://github.com/rv0lt/devops_example/tree/main/webserver_example_2 "webserver_example_1") contain the source code of them. As well as explanations on how they were coded and how they work

# CI pipeline

For the CI pipeline, the code is in the [workflows](https://github.com/rv0lt/devops_example/tree/main/.github/workflows) directory.

For the first web server, we need to compile the latex document of the resume, and then build the docker image, as well as pushing it to the docker registry. For the second one, we just need to build and push.

The pipeline will be called anytime there is a push on the mainstream branch, the idea is that anytime there are changes on the code, the images will be built and pushed again, so we can always have the latest version available.

# Terraform

A small terraform code is provided on the deployment folder, it is used to provision the infrastructure where we can deploy our applications. It creates an instance on [Google Cloud](https://cloud.google.com/free/docs/free-cloud-features#compute).

To reproduce the code there are **two** main changes to make:

 - On the *google_compute_instance* resource: 
 
        metadata = { 
	        ssh-keys = "rv0lt:${file("~/.ssh/gcloud_key.pub")}"
        }
 
You would need to provide your own ssh key to connect with the instance, the same format is `"username:${file("username.pub")}"`

 - Also, at the beginning of the terraform file, where the provider is set up:
 
`
	
	provider "google" {
		project =  "global-shard-391615"
		credentials =  "./global-shard-391615-970a65630c3a.json"
		region =  "us-east1"
		zone =  "us-east1-b"
	}

You need to set up a service account and specify the path to the credentials, in the same fashion as it can be seen on the file and it is explained [here](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build).

Once everything is set up, and we apply the terraform file, we can see it outputs the external IP we can use to connect to the instance created.

![enter image description here](https://i.imgur.com/cqq82bi.png)
# Ansible

Finally, we can automatize the deployment of our application on the instance thanks to Ansible, the external IP that was generated on the previous step, needs to be changed on the [inventory file](https://github.com/rv0lt/devops_example/blob/main/deployment/ansible/inventory). In this file, we also need to specify the path to the private key to connect to the host:

    [host] 
    35.138.195.100 ansible_ssh_private_key_file=~/.ssh/gcloud_key

The [playbook](https://github.com/rv0lt/devops_example/blob/main/deployment/ansible/playbook.yaml) file, contains the tasks to install docker and run the images. 

We can run the file with the following command `ansible-playbook -i inventory playbook.yaml`

Once it has finalized the execution we can make a final *sanitary test* to check that everything works as it is supposed:


![enter image description here](https://i.imgur.com/eziPG9y.png)
![enter image description here](https://i.imgur.com/8uirrzQ.png)

