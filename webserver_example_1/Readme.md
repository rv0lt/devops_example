# Webserver 1

This application is an nginx web server, the configuration file has been modified to serve my resume on **localhost:8000/cv** as well as to redirect on the main page to my blog **rv0lt.github.io/**:

    location / {
         rewrite ^/$ https://rv0lt.github.io/ redirect;
    }

    location /cv {
       alias /usr/share/nginx/resume.pdf;
       default_type application/pdf; 
    }

The CV folder, contains the latex source code to compile the resume, the resume is compile within the GitHub Actions workflow, so the pdf is not on this folder.

The Dockerfile contains the instructions to build the container. The docker image is available on the [DockerHub registry](https://hub.docker.com/repository/docker/rv0lt/resumewebserver/general)

