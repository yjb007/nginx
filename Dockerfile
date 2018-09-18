FROM nginx:1.12.1-alpine

VOLUME /var/log/nginx
VOLUME /etc/nginx/conf.d/proxy

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/ /etc/nginx/conf.d/
COPY proxy.conf /etc/nginx/conf.d/proxy/

ENV TZ=Asia/Shanghai
RUN echo "https://mirrors.aliyun.com/alpine/v3.5/main" >/etc/apk/repositories \ 
	&& echo "https://mirrors.aliyun.com/alpine/v3.5/community" >>/etc/apk/repositories \
	&& apk add --update tzdata \
	&& apk add curl \
	&& rm -rf /var/cache/apk/* \
	&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
	&& echo $TZ > /etc/timezone \
	&& rm /etc/nginx/conf.d/default.conf

HEALTHCHECK --interval=5s --timeout=3s CMD curl -f http://localhost/ || exit 1
