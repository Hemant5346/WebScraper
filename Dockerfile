FROM node:18-alpine AS builder

# Set working directory for build context
WORKDIR /app

# Copy package.json and install dependencies (using npm or yarn)
COPY package*.json ./
RUN npm install  # Or: RUN yarn install

# Copy your application code
COPY . .

# Create a non-root user for the application process
RUN adduser --disabled-password --shell /bin/sh appuser

# Switch to the non-root user for the remaining build steps
USER appuser

# Build the application (adjust if you use a different build command)
RUN npm run build  # Or: RUN yarn build

RUN npm install --save-dev webpack 

# Create a new image for serving the application (from a minimal Node.js image)
FROM node:18-alpine AS runner

# Set working directory for the runner image
WORKDIR /app

# Copy the built application from the builder image
COPY --from=builder /app .

# Expose port 8000
EXPOSE 8000

# Start the Node.js application using the non-root user
CMD ["npm", "start"]  
