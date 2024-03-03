FROM golang:alpine as build
ARG COMPONENT
COPY . /readium/.
WORKDIR /readium
RUN go mod download && go mod verify && go build -o $GOPATH/bin ./${COMPONENT}

FROM alpine:latest
RUN apk update && apk add --no-cache gettext
ARG COMPONENT
WORKDIR /
COPY --from=build /go/bin/${COMPONENT} /bin/app
# COPY ./${COMPONENT}_entrypoint.sh /entrypoint.sh
# COPY ./${COMPONENT}_config.yaml /tmp/config.yaml
EXPOSE 8080
CMD ["app"]
# ENTRYPOINT ["/entrypoint.sh", "/tmp/config.yaml"]