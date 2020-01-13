FROM node:alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
 
FROM node:alpine
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY src/ .
CMD ["node", "src/main.js"]
