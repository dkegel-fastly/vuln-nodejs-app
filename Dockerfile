# Use bullseye because otherwise apt-get was failing for me in 2026...?
FROM node:16-bullseye-slim
WORKDIR /usr/code
COPY package*.json ./

# Need a few more bits with the slim base image
RUN apt-get update -y && apt-get install -y build-essential iputils-ping

# Simple solution to no-chromium-bundled-for-arm; see https://github.com/payatu/vuln-nodejs-app/issues/3 for longer one
RUN if [ "$(uname -m)" = "aarch64" ] ; then apt-get install -y chromium; fi

RUN npm install
RUN npm install nodemon -g
COPY . .
RUN npm run build
EXPOSE 9000
CMD ["node", "server.js"]
