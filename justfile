# build project and generate Spring Boot executable fat JAR
build:
    mvn -DskipTests clean package

# Self-extract executable fat JAR
extract: build
    java -Djarmode=tools -jar target/cds-demo.jar extract --destination target/application

# create a CDS archive for Spring Boot application
generate-cds: extract
    java -XX:ArchiveClassesAtExit=target/application.jsa -Dspring.context.exit=onRefresh -jar target/application/cds-demo.jar

# start your application with CDS enabled
start-cds: generate-cds
    java -XX:SharedArchiveFile=target/application.jsa -jar target/application/cds-demo.jar

aot-record:
    java -XX:AOTMode=record -XX:AOTConfiguration=target/app.aotconf -cp target/application/cds-demo.jar org.mvnsearch.HelloWorldApp

aot-generate:
    curl 'http://localhost:8080/'
    curl 'http://localhost:8888/actuator/shutdown' -i -X POST
    sleep 5
    java -XX:AOTMode=create -XX:AOTConfiguration=target/app.aotconf -XX:AOTCache=target/app.aot -XX:+AOTClassLinking -cp target/application/cds-demo.jar

aot-run:
    java -XX:AOTCache=target/app.aot -cp target/application/cds-demo.jar org.mvnsearch.HelloWorldApp

# Start your application
start: extract
    java -jar target/application/cds-demo.jar

# build docker image with CDS support
build-image:
    mvn -DskipTests spring-boot:build-image
