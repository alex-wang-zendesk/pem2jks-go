FROM golang:1.17-alpine as builder

RUN apk add --no-cache git ca-certificates

WORKDIR /app
COPY . .

RUN go mod init yourModuleName
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o pem-to-jks

FROM scratch
COPY --from=builder /app/pem-to-jks /pem-to-jks
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/pem-to-jks"]
