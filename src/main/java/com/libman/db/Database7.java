package com.libman.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public final class Database7 {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=LibMan;"
            + "integratedSecurity=true;encrypt=true;trustServerCertificate=true";

    private Database7() {
    }

    public static Connection open() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException exception) {
            throw new SQLException("Thiếu SQL Server JDBC driver", exception);
        }
        return DriverManager.getConnection(URL);
    }

    public static void initialize() throws SQLException {
        try (Connection connection = open(); Statement statement = connection.createStatement()) {
            createTable(statement, "Supplier7", """
                    CREATE TABLE dbo.Supplier7 (
                        id NVARCHAR(20) NOT NULL PRIMARY KEY, name NVARCHAR(200) NOT NULL,
                        address NVARCHAR(300) NOT NULL, phone NVARCHAR(30) NOT NULL)""");
            createTable(statement, "Librarian7", """
                    CREATE TABLE dbo.Librarian7 (
                        id NVARCHAR(20) NOT NULL PRIMARY KEY, role NVARCHAR(50) NOT NULL,
                        username NVARCHAR(100) NOT NULL UNIQUE, password NVARCHAR(255) NOT NULL,
                        name NVARCHAR(150) NOT NULL, phone NVARCHAR(30) NOT NULL,
                        address NVARCHAR(300) NOT NULL, position NVARCHAR(100) NOT NULL)""");
            createTable(statement, "Document7", """
                    CREATE TABLE dbo.Document7 (
                        id NVARCHAR(30) NOT NULL PRIMARY KEY, general_qr NVARCHAR(100) NOT NULL UNIQUE,
                        document_code NVARCHAR(30) NOT NULL UNIQUE, name NVARCHAR(200) NOT NULL,
                        quantity INT NOT NULL DEFAULT 0, type NVARCHAR(100) NOT NULL, author NVARCHAR(200) NOT NULL,
                        publication_year INT NOT NULL, unit_price DECIMAL(18,2) NOT NULL,
                        supplier_id NVARCHAR(20) NOT NULL REFERENCES dbo.Supplier7(id))""");
            createTable(statement, "DocumentCopy7", """
                    CREATE TABLE dbo.DocumentCopy7 (
                        id NVARCHAR(50) NOT NULL PRIMARY KEY, qr_code NVARCHAR(100) NOT NULL UNIQUE,
                        document_code NVARCHAR(30) NOT NULL REFERENCES dbo.Document7(document_code),
                        status NVARCHAR(30) NOT NULL)""");
            createTable(statement, "DocumentProvide7", """
                    CREATE TABLE dbo.DocumentProvide7 (
                        id NVARCHAR(50) NOT NULL UNIQUE,
                        document_code NVARCHAR(30) NOT NULL REFERENCES dbo.Document7(document_code),
                        supplier_id NVARCHAR(20) NOT NULL REFERENCES dbo.Supplier7(id),
                        supply_price DECIMAL(18,2) NOT NULL,
                        PRIMARY KEY (document_code, supplier_id))""");
            createTable(statement, "ImportInvoice7", """
                    CREATE TABLE dbo.ImportInvoice7 (
                        id NVARCHAR(50) NOT NULL PRIMARY KEY, supplier_id NVARCHAR(20) NOT NULL REFERENCES dbo.Supplier7(id),
                        librarian_id NVARCHAR(20) NOT NULL REFERENCES dbo.Librarian7(id), created_at DATETIME2 NOT NULL,
                        total DECIMAL(18,2) NOT NULL)""");
            createTable(statement, "ImportDocument7", """
                    CREATE TABLE dbo.ImportDocument7 (
                        id NVARCHAR(50) NOT NULL UNIQUE,
                        invoice_id NVARCHAR(50) NOT NULL REFERENCES dbo.ImportInvoice7(id),
                        document_code NVARCHAR(30) NOT NULL REFERENCES dbo.Document7(document_code),
                        quantity INT NOT NULL, unit_price DECIMAL(18,2) NOT NULL,
                        PRIMARY KEY (invoice_id, document_code))""");
        }
    }

    private static void createTable(Statement statement, String tableName, String sql) throws SQLException {
        try (var tables = statement.getConnection().getMetaData()
                .getTables(null, "dbo", tableName, new String[]{"TABLE"})) {
            if (!tables.next()) {
                statement.executeUpdate(sql);
            }
        }
    }
}
