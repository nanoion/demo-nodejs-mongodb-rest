FROM node:13.10.1-alpine3.11

LABEL "maintainer"="Thee Tienboon <thee.tienboon@gmail.com>"

USER node

# Set environment variables
ENV APP /home/node/app
ENV NODE_ENV production

# Installing node_modules from package-lock.json
RUN mkdir -p $APP
COPY package*.json $APP/
RUN cd $APP && npm ci --only=production \
    && npm cache clean --force --loglevel=error

# Load application's code
COPY . $APP/
WORKDIR $APP

EXPOSE 3000

CMD ["npm","start"]
