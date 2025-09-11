# 1. Build Angular app
FROM node:22-alpine AS build
WORKDIR /app

# kopiujemy package.json i package-lock.json
COPY package*.json ./

# instalujemy zależności
RUN npm install

# kopiujemy cały projekt
COPY . .

# budujemy aplikację Angular (produkcyjną)
RUN npm run build --prod

# 2. Serwowanie aplikacji przez Nginx
FROM nginx:alpine

# usuń domyślne pliki index.html z nginx
RUN rm -rf /usr/share/nginx/html/*

# kopiujemy wyniki buildu Angulara
COPY --from=build /app/dist/nbapredictor /usr/share/nginx/html

# kopiujemy customową konfigurację nginx (opcjonalnie, dla SPA routing)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
