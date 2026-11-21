# Post-contenido — Unidad 12: Despliegue y CI/CD

## Descripción
Repositorio del laboratorio de la Unidad 12 de Programación Web — Séptimo Semestre. Contiene la aplicación Spring Boot dockerizada con un Dockerfile multi-stage y perfiles \dev\/\prod\ (Parte 1), que se extenderá con un pipeline de integración continua con GitHub Actions y monitoreo con Spring Boot Actuator (Parte 2).

## Parte 1 — Dockerización con Perfiles y Variables de Entorno
El Dockerfile multi-stage compila el proyecto con Maven en una etapa JDK (\eclipse-temurin:21-jdk-alpine\) y ejecuta el JAR resultante en una etapa JRE Alpine (\eclipse-temurin:21-jre-alpine\) con un usuario no root (\spring\). La configuración sensible se externaliza en \pplication.properties\ con placeholders \\\: sin variables de entorno, la aplicación arranca con el perfil \dev\ (H2 en memoria); con \SPRING_PROFILES_ACTIVE=prod\ y las variables \DATASOURCE_URL\ / \DATASOURCE_USER\ / \DATASOURCE_PASSWORD\, arranca con la configuración de producción.

## Decisiones de diseño
1. **Placeholders con valor por defecto (\\\) en vez de placeholders estrictos:** permite arrancar sin fricción en local y en CI, y deja los valores reales para producción.
2. **\pplication-dev.properties\ y \pplication-prod.properties\ como archivos separados en vez de un único archivo con bloques condicionales:** hace explícito qué configuración corresponde a cada ambiente.
3. **Imagen final \eclipse-temurin:21-jre-alpine\ en vez de distroless:** reduce el tamaño de la imagen (< 300 MB) sin sacrificar la posibilidad de depurar el contenedor con \docker exec\.