# Step 1: Builder stage using Maven + JDK 17 (full)
FROM maven:3.9.3-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Step 2: Slim runtime using distroless (very small & secure)
FROM gcr.io/distroless/java17-debian11

WORKDIR /app

COPY --from=builder /app/target/demo-1.0.0.jar app.jar

# No shell access in distroless (for security and size)
ENTRYPOINT ["java", "-jar", "app.jar"]
