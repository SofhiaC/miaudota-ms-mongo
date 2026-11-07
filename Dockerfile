# Imagem do backend NestJS. O serviço que roda é escolhido no build:
#   docker build --platform linux/amd64 --build-arg SERVICO=usuarios -t sofhiachromiec/pjbl-usuarios:v1 .
# SERVICO aceito neste repositório: usuarios | adocao

# ---- etapa 1: compila o TypeScript ----
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY tsconfig.json nest-cli.json ./
COPY src ./src
RUN npm run build

# ---- etapa 2: imagem final, só com o necessário para rodar ----
FROM node:20-alpine
ARG SERVICO=usuarios
ENV NODE_ENV=production SERVICO=${SERVICO}
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY --from=build /app/dist ./dist
USER node
EXPOSE 3101 3102
CMD ["sh", "-c", "node dist/${SERVICO}/main.js"]
