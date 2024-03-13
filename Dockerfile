# Construcción
FROM eclipse-temurin:17-jdk-alpine as builder

WORKDIR /opt/app

# Copiar archivos de configuración Maven
COPY .mvn/ .mvn

# Copiar el script Maven Wrapper y el archivo POM
COPY mvnw ./
COPY pom.xml ./

# Asegurarse de que el script tenga permisos de ejecución
RUN chmod +x mvnw

# Descargar dependencias de Maven
RUN ./mvnw dependency:go-offline

# Copiar el código fuente y compilar la aplicación
COPY ./src ./src
RUN ./mvnw clean install

# Producción
FROM eclipse-temurin:17-jre-alpine

WORKDIR /opt/app

EXPOSE 8080

# Copiar el archivo JAR desde la etapa de construcción
COPY --from=builder /opt/app/target/*.jar /opt/app/app.jar

# Puedes eliminar la entrada "ENTRYPOINT" si no necesitas configurar nada adicional
ENTRYPOINT ["java", "-jar", "/opt/app/app.jar"]
