FROM node:18-alpine

WORKDIR /app

COPY DevPulse/package*.json ./
RUN npm install --legacy-peer-deps

COPY DevPulse/ .

EXPOSE 7777
CMD ["npm", "start"]
