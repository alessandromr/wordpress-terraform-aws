FROM nginx:alpine
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

CMD sleep 30 && echo "Starting NGINX" && nginx -g "daemon off;"