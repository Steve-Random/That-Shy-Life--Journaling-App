From maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src src
RUN mvn clean package -DskipTests
RUN ls -la target/
RUN unzip -| target/*.jar |head -50
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/target/*.jar"]