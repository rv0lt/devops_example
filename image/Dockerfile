FROM nginx:1.25.1-alpine

COPY ./image/cv/resume.pdf /usr/share/nginx
COPY ./image/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx","-g", "daemon off;"]
