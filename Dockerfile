#BUILD PHASE
FROM node:17-alpine AS builder

USER node

RUN mkdir -p /home/node/app
RUN chown -R node:node /home/node && chmod -R 770 /home/node
WORKDIR /home/node/app

COPY --chown=node:node ./package.json ./

RUN npm install

COPY --chown=node:node ./ ./

#CMD ["npm", "run", "build"]

RUN npm run build

#RUN PHASE
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
EXPOSE 80
COPY --from=builder /home/node/app/build .
