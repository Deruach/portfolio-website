# Build stage
FROM node:20.14.0 AS builder
WORKDIR /app

# Alleen package files eerst om layer caching optimaal te benutten
COPY package*.json ./
RUN npm ci

# Dan de rest van de source code
COPY . .

# Build Astro
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html

# Zorg dat nginx blijft draaien
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
