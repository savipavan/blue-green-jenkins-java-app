
FROM openjdk:11-jre-slim
COPY target/demo-1.0.0.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/app.jar", "--server.port=8081"]
