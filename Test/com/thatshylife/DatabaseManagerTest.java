package com.thatshylife;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DatabaseManagerTest {

    @Mock
    private Connection mockConnection;
    @Mock
    private Statement mockStatement;
    @Mock
    private PreparedStatement mockPreparedStatement;
    @Mock
    private ResultSet mockResultset;

    private DatabaseManager dbManager;

    @BeforeAll
    static void setUpEncryption() {
        new SecurityManager().setSecretKey("sixteenByteKey!!");
    }

    @BeforeEach
    void setUp(){
        dbManager = new DatabaseManager("jdbc:test-url", "test-user","test-pass");
    }

    private MockedStatic<DriverManager> mockDriverManagerToReturn( Connection conn) throws SQLException{
        MockedStatic<DriverManager> mocked = mockStatic(DriverManager.class);
        mocked.when(() -> DriverManager.getConnection(anyString(), anyString(), anyString())).thenReturn(conn);
        return mocked;
    }

    // connect()

    @Test
    void connect_returnsConnection_whenDriverManagerSucceeds() throws Exception {
        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)){
            assertSame(mockConnection, dbManager.connect());
        }
    }

    @Test
    void connect_returnsNull_whenDriverManagerThrowsSQLException() {
        try (MockedStatic<DriverManager> mocked = mockStatic(DriverManager.class)){
            mocked.when(() -> DriverManager.getConnection(anyString(), anyString(), anyString()))
                            .thenThrow(new SQLException("connection refused"));
            //connect() promises null on failure not a thrown Exception
            assertSame(mockConnection, dbManager.connect());
        }
    }

    //Create Users Table

    @Test
    void createUsersTable_executesCreateTableStatement() throws Exception {
        when ( mockConnection.createStatement()).thenReturn(mockStatement);

        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)){
            dbManager.createUsersTable();
        }

        verify(mockStatement).execute(contains("CREATE TABLE IF NOT EXISTS users"));
    }

    @Test
    void createUsersTable_doesNotThrow_whenExecuteFails() throws Exception {
        when( mockConnection.createStatement()).thenReturn(mockStatement);
        doThrow( new SQLException("boom")).when(mockStatement).execute(anyString());

        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            assertDoesNotThrow(() -> dbManager.createUsersTable());
        }
    }

    //Create Newt Table (entries table)

    @Test
    void createNewTable_executesCreateTableStatement() throws Exception {
        when( mockConnection.createStatement()).thenReturn(mockStatement);

        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            dbManager.createNewTable();
        }

        verify(mockStatement).execute(contains("CREATE TABLE IF NOT EXISTS entries"));
    }

    @Test
    void getAllEntries() {
    }
}