# Etapa 1: build da aplicação
FROM node:20-alpine AS builder

# Diretório de trabalho
WORKDIR /app

# Copia os arquivos de dependência primeiro (melhor para cache)
COPY package.json package-lock.json ./

# Instala as dependências
RUN npm install

# Copia o restante da aplicação
COPY . .

# Gera o build do Next.js
RUN npm run build

# Etapa 2: imagem final para produção
FROM node:20-alpine AS runner

# Diretório de trabalho
WORKDIR /app

# Copia apenas o build e dependências necessárias
COPY --from=builder /app/.next .next
COPY --from=builder /app/public public
COPY --from=builder /app/package.json .
COPY --from=builder /app/node_modules node_modules

# Expõe a porta padrão do Next.js
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["npm", "start"]