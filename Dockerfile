FROM node:23 AS base


FROM base AS dependencies
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install


FROM base AS build
WORKDIR /usr/src/app
COPY . .
COPY --from=dependencies /usr/src/app/node_modules ./node_modules
RUN npm run build
RUN npm prune --prod


FROM node:23-alpine3.21 AS deploy
WORKDIR /usr/src/app
RUN npm install -g prisma


COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/prisma ./prisma

RUN apk update && apk add --no-cache openssl && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apk/*

RUN npx prisma generate

EXPOSE 3333
CMD ["npm", "start"]

