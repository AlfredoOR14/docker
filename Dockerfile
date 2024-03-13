# Primera etapa: Construcción
FROM eclipse-temurin:17-jdk-alpine as builder

WORKDIR /opt/app

# Copiar los archivos necesarios
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
COPY ./src ./src

# Asegurarse de que mvnw tiene permisos de ejecución
RUN chmod +x mvnw

# Descargar las dependencias y compilar el proyecto
RUN ./mvnw clean install

# Segunda etapa: Ejecución
FROM eclipse-temurin:17-jre-alpine

WORKDIR /opt/app

EXPOSE 8080

# Copiar el archivo JAR construido desde la etapa de construcción
COPY --from=builder /opt/app/target/*.jar /opt/app/app.jar

# Comando de entrada para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "/opt/app/app.jar"]
