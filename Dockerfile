<<<<<<< HEAD
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
=======
FROM eclipse-temurin:17-jdk-jammy as builder
WORKDIR /opt/app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline
COPY ./src ./src
RUN ./mvnw clean install
 
FROM eclipse-temurin:17-jre-jammy
WORKDIR /opt/app
EXPOSE 8080
COPY --from=builder /opt/app/target/*.jar /opt/app/*.jar
ENTRYPOINT ["java", "-jar", "/opt/app/*.jar" ]
>>>>>>> 82942b0643fd3e0206c2fe1c02f82119e5008afc
