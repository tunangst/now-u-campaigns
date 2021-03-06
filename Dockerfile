# pull official base image
FROM node:13.12.0-alpine as build

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm ci
RUN npm install react-scripts@3.4.1 -g --silent
COPY . ./
RUN npm run build

# LOCAL
## add app
#COPY . ./
#
## start app
#CMD ["npm", "start"]

FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html/
COPY ./deploy/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#
#ENTRYPOINT ["entrypoint.sh"]

