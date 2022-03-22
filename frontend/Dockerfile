FROM node:16

WORKDIR /app

# Only copy to the WORKDIR (with .)
COPY package.json .
COPY package-lock.json .

RUN npm install -g npm
RUN npm install --silence

# Same here
COPY . .

EXPOSE 3000

CMD ["npm", "start"]

