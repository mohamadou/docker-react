#BUILD PHASE
FROM node:17-alpine as builder

USER node

RUN mkdir -p /home/node/app
WORKDIR /home/node/app

COPY --chown=node:node ./package.json ./

RUN npm install

COPY --chown=node:node ./ ./

CMD npm run build


#RUN PHASE
FROM nginx
EXPOSE 80
COPY --from=builder /home/node/app/build /usr/share/nginx/html
