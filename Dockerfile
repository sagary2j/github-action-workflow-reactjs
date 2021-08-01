# Stage 1
FROM node:14.2.0-alpine3.11 as react-build
WORKDIR /app
COPY . ./
RUN yarn, yarn build

# Stage 2 - the production environment
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=react-build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
