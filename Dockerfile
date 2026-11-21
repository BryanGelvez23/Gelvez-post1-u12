# ── Etapa 1: compilación con Maven ──────────────────────────────────
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Copiar pom.xml primero para aprovechar la caché de capas de Docker
COPY pom.xml .
RUN apk add --no-cache maven && mvn dependency:go-offline -q

COPY src ./src
RUN mvn clean package -DskipTests -q

# ── Etapa 2: imagen de ejecución (solo JRE) ──────────────────────────
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Usuario no root con carpeta de logs propia
RUN addgroup -S spring && adduser -S spring -G spring \
    && mkdir -p /app/logs && chown -R spring:spring /app
USER spring

# Copiar únicamente el JAR compilado desde la etapa de builder
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]