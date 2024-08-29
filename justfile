# build project and generate Spring Boot executable fat JAR
build:
  mvn -DskipTests clean package

# Self-extract executable fat JAR
extract: build
  cd target; java -Djarmode=tools -jar cds-demo.jar extract --destination application

# create a CDS archive for Spring Boot application
generate-cds: extract
  cd target; java -XX:ArchiveClassesAtExit=application.jsa -Dspring.context.exit=onRefresh -jar application/cds-demo.jar

# start your application with CDS enabled
start-cds: generate-cds
  cd target; java -XX:SharedArchiveFile=application.jsa -jar application/cds-demo.jar

# Start your application
start: build
  java -jar target/cds-demo.jar

# build docker image with CDS support
build-image:
  mvn -DskipTests spring-boot:build-image
