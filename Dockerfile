From maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
RUN jar tf app.jar | grep "com/thatshylife/Main"
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]