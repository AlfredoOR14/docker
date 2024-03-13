# Fase de construcción
FROM eclipse-temurin:17-jdk-alpine as builder

WORKDIR /opt/app

# Copia los archivos de configuración y el archivo de construcción de Maven
COPY .mvn/ mvnw pom.xml ./

# Descarga las dependencias de Maven (sin ejecutar el build)
RUN ./mvnw dependency:go-offline

# Copia el código fuente
COPY ./src ./src

# Cambia los permisos y muestra el contenido del directorio
RUN chmod +x mvnw
RUN echo 'LS'
RUN ls

# Ejecuta la construcción
RUN ./mvnw install

# Segunda fase para la imagen final
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /opt/app

# Copia solo los artefactos necesarios de la fase de construcción
COPY --from=builder /opt/app/target/demo.jar ./demo.jar

# Define el comando de inicio
CMD ["java", "-jar", "demo.jar"]
