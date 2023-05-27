FROM adoptopenjdk/openjdk8:alpine-slim
EXPOSE 8080

ARG JAR_FILE=target/*.jar

RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline

WORKDIR /home/k8s-pipeline

COPY --from=adoptopenjdk/openjdk8:alpine-slim ${JAR_FILE} /home/k8s-pipeline/app.jar

USER k8s-pipeline

ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]