#contrucción
FROM eclipse-temurin:17-jdk-alpine as builder
WORKDIR /opt/app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency
COPY ./src ./src
RUN chmod +x mvnw
RUN ls
RUN ./mvnw clean install
