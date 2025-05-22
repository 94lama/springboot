FROM openjdk:25-jdk as base

FROM base as build
WORKDIR /spring
COPY . .
RUN ./mvnw clean package

FROM base as deploy

RUN groupadd -g 1002 java
RUN adduser -u 1002 spring
USER spring

ARG JAR_FILE=target/*.jar
COPY --chown=spring:java --from=build /spring/${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
