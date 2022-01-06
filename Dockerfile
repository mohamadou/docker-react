#BUILD STAGE
FROM node:17-alpine AS builder

USER node

RUN mkdir -p /home/node/app
RUN chown -R node:node /home/node && chmod -R 770 /home/node
WORKDIR /home/node/app

COPY --chown=node:node ./package.json ./

RUN npm install

COPY --chown=node:node ./ ./

RUN npm run build

#RUN STAGE
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
EXPOSE 80
# Copy static assets from builder stage
COPY --from=builder /home/node/app/build .

# Containers run nginx with global directives and daemon off
#ENTRYPOINT ["nginx", "-g", "daemon off;"]