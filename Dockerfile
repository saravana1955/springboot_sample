# Use the official OpenJDK 17 image as the base image
FROM openjdk:17-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file into the container at /app
COPY target/product-definition-service-0.0.1-SNAPSHOT.jar /app/product-definition-service.jar

# Expose the port that your application will run on
EXPOSE 8080

# Command to run your application
CMD ["java", "-jar", "product-definition-service.jar"]
