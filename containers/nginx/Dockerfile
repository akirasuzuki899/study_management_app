
FROM nginx:1.19.7

RUN rm -f /etc/nginx/conf.d/*

ADD nginx.conf /etc/nginx/conf.d/study_management_app.conf

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf