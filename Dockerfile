
# Stage 1: Build React application
FROM node:24-alpine AS build
# FROM: Specifies the base Docker image.
# node:24-alpine: Uses Node.js version 24 with Alpine Linux.
# AS build: Gives this stage the name build.

# Set working directory
WORKDIR /app


# Copy package files
COPY package*.json ./
# Why copy these files first?
# Docker uses layer caching. If your application source code changes but your dependencies don't, Docker can reuse the dependency installation layer.


# Install dependencies
RUN npm ci
# Installs all dependencies listed in package-lock.json.
# Difference between npm install and npm ci:
# npm install: Can update the lock file.
# npm ci: Installs dependencies strictly according to the lock file.


# Copy application source code
COPY . .
# React Project
# │
# ├── src/
# ├── public/
# ├── package.json
# ├── package-lock.json
# ├── index.html
# └── vite.config.js
# Copies the entire application source code from your local project into the container's /app directory.


# Build React application
RUN npm run build



# Stage 2: Serve using Nginx
FROM nginx:alpine
# Starts a second build stage using the lightweight Nginx Alpine image.
# What is Nginx?
# Nginx is a web server that can serve static files such as:
# HTML
# CSS
# JavaScript
# Images


# Copy React build files to Nginx
COPY --from=build /app/dist /usr/share/nginx/html
# COPY - Copy files
# --from=build - Copy from the first Docker build stage
# /app/dist - Source directory
# /usr/share/nginx/html - Destination directory inside Nginx
# Nginx uses /usr/share/nginx/html as its default website directory.


# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
# CMD - Default command executed when the container starts
# nginx -  Starts the Nginx server
# -g - Specifies a global Nginx configuration directive
# daemon off; - Runs Nginx in the foreground



# How to build and run the Docker container:
# 1. Build the Docker image:
#    docker build -t react-docker-app .

# docker build: Creates a Docker image.
# -t: Assigns a name/tag to the image.
# react-docker-app: Image name.
# .: Uses the current directory as the build context.
#


# 2. Run the Docker container:
# docker run -d -p 3000:80 --name react-container react-docker-app
   
# docker run: Creates and starts a container.
# -p 3000:80: Maps Mac port 3000 to container port 80.
# react-docker-app: Image used to create the container.


# 3. Stop the docker container:
# docker stop react-container