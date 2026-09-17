# Stage 1: Compilação
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copia os arquivos de código
COPY go.mod ./
COPY main.go ./

# Compila o binário de forma estática removendo tabelas de símbolos e debug (flags -s e -w)
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o rocks main.go

# Stage 2: Imagem Final (Mínima)
FROM scratch

WORKDIR /app

# Copia apenas o binário compilado do Stage 1
COPY --from=builder /app/rocks .

# Executa o binário
CMD ["./rocks"]

