FROM nginx:1.25.1-alpine

COPY ./webserver_example_1/cv/resume.pdf /usr/share/nginx
COPY ./webserver_example_1/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

# run as non root user
USER nginx

CMD ["nginx","-g", "daemon off;"]
