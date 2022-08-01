FROM golang:alpine

WORKDIR /app


COPY . .
RUN go env -w GO111MODULE=auto
RUN go mod init dockerize
RUN go mod tidy



RUN go build -o main .

EXPOSE 8080

CMD [ "./main" ]
