package com.demo.cliente.config;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.sql.Connection;
import java.sql.DriverManager;

@Slf4j
@Component
public class DatabaseHealthChecker {

    @Value("${spring.datasource.url}")
    private String dbUrl;

    @Value("${spring.datasource.username}")
    private String dbUser;

    @Value("${spring.datasource.password}")
    private String dbPass;

    @PostConstruct
    public void checkDatabaseConnection() {
        log.info("🔍 Verificando conexión a la base de datos...");
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass)) {
            if (conn != null && !conn.isClosed()) {
                log.info("✅ Conexión a la base de datos exitosa: " + dbUrl);
            } else {
                throw new RuntimeException("❌ Conexión no establecida.");
            }
        } catch (Exception e) {
            log.error("❌ Error al conectar con la base de datos: {}", e.getMessage());
            throw new RuntimeException("❌ Error crítico de conexión a BD: " + e.getMessage(), e);
        }
    }
}