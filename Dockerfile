FROM node:13.10.1-alpine3.11

LABEL "maintainer"="Thee Tienboon <thee.tienboon@gmail.com>"

# Set environment variables
ENV APP /home/node/app
ENV NODE_ENV production

RUN mkdir -p $APP && chown -R node:node $APP && apk add curl

USER node

# Installing node_modules from package-lock.json
COPY --chown=node:node package*.json $APP/
RUN cd $APP && npm ci --only=production \
    && npm cache clean --force --loglevel=error

# Load application's code
COPY --chown=node:node . $APP/
WORKDIR $APP

EXPOSE 3000

CMD ["npm","start"]
