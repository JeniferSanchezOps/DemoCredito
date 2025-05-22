FROM maven:3.8.6-openjdk-17-slim AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:17-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
COPY .env .env

ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_NAME=creditodb
ENV DB_USER=root
ENV DB_PASS=root

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java -jar app.jar --spring.datasource.url=jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME} --spring.datasource.username=${DB_USER} --spring.datasource.password=${DB_PASS}"]