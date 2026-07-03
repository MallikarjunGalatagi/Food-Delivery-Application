package util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static HikariDataSource dataSource;

    static {
        try {
            Properties props = new Properties();
            try (InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (is != null) {
                    props.load(is);
                } else {
                    System.err.println("Warning: db.properties not found in classpath. Using default database settings.");
                    props.setProperty("db.url", "jdbc:mysql://localhost:3306/food_delivery_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
                    props.setProperty("db.username", "root");
                    props.setProperty("db.password", "");
                    props.setProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                    props.setProperty("db.pool.max-size", "10");
                }
            }

            HikariConfig config = new HikariConfig();
            config.setDriverClassName(props.getProperty("db.driver"));
            config.setJdbcUrl(props.getProperty("db.url"));
            config.setUsername(props.getProperty("db.username"));
            config.setPassword(props.getProperty("db.password"));
            
            // Pool configuration
            int maxPoolSize = Integer.parseInt(props.getProperty("db.pool.max-size", "10"));
            config.setMaximumPoolSize(maxPoolSize);
            
            String idleTimeout = props.getProperty("db.pool.idle-timeout", "600000");
            config.setIdleTimeout(Long.parseLong(idleTimeout));
            
            String connTimeout = props.getProperty("db.pool.connection-timeout", "30000");
            config.setConnectionTimeout(Long.parseLong(connTimeout));
            
            // Standard optimizations for MySQL JDBC
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            System.err.println("Fatal Error: Failed to initialize Hikari Connection Pool!");
            e.printStackTrace();
            throw new RuntimeException("Error initializing Hikari Connection Pool: " + e.getMessage(), e);
        }
    }

    /**
     * Obtains a thread-safe connection from the connection pool.
     */
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    /**
     * Closes the connection pool. Should be called when the web app is undeployed/stopped.
     */
    public static void closePool() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            System.out.println("Hikari Connection Pool shut down successfully.");
        }
    }

    private DBConnection() {}
}
