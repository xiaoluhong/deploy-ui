FROM node:7 as build1

RUN mkdir /root/src
ADD  . /root/src
WORKDIR /root/src

RUN npm install

#RUN npm run dev

RUN npm run build

FROM alpine

WORKDIR /root
RUN apk add curl bash gnupg caddy --no-cache

#ADD dist/ /root/ui
COPY --from=build1  /root/src/dest /root/ui
COPY entrypoint.sh /root
COPY caddy/Caddyfile /root

RUN chmod +x /root/entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/root/entrypoint.sh"]
