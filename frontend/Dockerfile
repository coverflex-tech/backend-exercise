FROM node:16.13.2-alpine

WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# start app
ENTRYPOINT ["sh", "/app/entrypoint.sh"]
