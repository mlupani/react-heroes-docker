
FROM node:alpine3.21 as dev
WORKDIR /app
COPY package.json ./
RUN yarn install
#CMD [ "yarn","start:dev" ]

FROM node:alpine3.21 as dev-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --frozen-lockfile


FROM node:alpine3.21 as builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
# RUN yarn test
RUN yarn build

FROM nginx:1.27.4 as prod
EXPOSE 80
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY assets/ /usr/share/nginx/html/assets/

CMD [ "nginx", "-g", "daemon off;" ]
















