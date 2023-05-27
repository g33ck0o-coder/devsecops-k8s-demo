FROM adoptopenjdk/openjdk8:alpine-slim
WORKDIR /home/k8s-pipeline
EXPOSE 8080

COPY --from=adoptopenjdk/openjdk8:alpine-slim ${JAR_FILE} /home/k8s-pipeline/app.jar

ARG JAR_FILE=target/*.jar

USER k8s-pipeline

RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline

ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]