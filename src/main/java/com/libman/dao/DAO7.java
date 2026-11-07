package com.libman.dao;

import com.libman.db.Database7;
import java.sql.Connection;
import java.sql.SQLException;

public abstract class DAO7 {
    protected Connection con;

    protected Connection getConnection7() throws SQLException {
        if (con == null || con.isClosed()) {
            con = Database7.open();
        }
        return con;
    }

    public void close7() throws SQLException {
        if (con != null && !con.isClosed()) {
            con.close();
        }
    }
}
