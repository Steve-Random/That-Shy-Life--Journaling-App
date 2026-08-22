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
    void setUp() {
        dbManager = new DatabaseManager("jdbc:test-url", "test-user", "test-pass");
    }

    private MockedStatic<DriverManager> mockDriverManagerToReturn(Connection conn) throws SQLException {
        MockedStatic<DriverManager> mocked = mockStatic(DriverManager.class);
        mocked.when(() -> DriverManager.getConnection(anyString(), anyString(), anyString())).thenReturn(conn);
        return mocked;
    }

    // connect()

    @Test
    void connect_returnsConnection_whenDriverManagerSucceeds() throws Exception {
        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            assertSame(mockConnection, dbManager.connect());
        }
    }

    @Test
    void connect_returnsNull_whenDriverManagerThrowsSQLException() {
        try (MockedStatic<DriverManager> mocked = mockStatic(DriverManager.class)) {
            mocked.when(() -> DriverManager.getConnection(anyString(), anyString(), anyString()))
                    .thenThrow(new SQLException("connection refused"));
            //connect() promises null on failure not a thrown Exception
            assertSame(mockConnection, dbManager.connect());
        }
    }

    //Create Users Table

    @Test
    void createUsersTable_executesCreateTableStatement() throws Exception {
        when(mockConnection.createStatement()).thenReturn(mockStatement);

        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            dbManager.createUsersTable();
        }

        verify(mockStatement).execute(contains("CREATE TABLE IF NOT EXISTS users"));
    }

    @Test
    void createUsersTable_doesNotThrow_whenExecuteFails() throws Exception {
        when(mockConnection.createStatement()).thenReturn(mockStatement);
        doThrow(new SQLException("boom")).when(mockStatement).execute(anyString());

        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            assertDoesNotThrow(() -> dbManager.createUsersTable());
        }
    }

    //Create New Table (entries table)

    @Test
    void createNewTable_executesCreateTableStatement() throws Exception {
        when(mockConnection.createStatement()).thenReturn(mockStatement);

        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            dbManager.createNewTable();
        }

        verify(mockStatement).execute(contains("CREATE TABLE IF NOT EXISTS entries"));
    }

    //SaveUser

    @Test
    void saveUser_insertsUserWithCorrectFields() throws Exception {
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);

        User user = new User();
        user.setId("user-1");
        user.setEmail("test@example.com");
        user.setPassword("hashed-password");
        user.setCreatedAt(LocalDateTime.of(2026, 1, 1, 9, 0));

        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            dbManager.saveUser(user);

            verify(mockPreparedStatement).setString(1, "user-1");
            verify(mockPreparedStatement).setString(2, "test@example.com");
            verify(mockPreparedStatement).setString(1, "hashed-password");
            verify(mockPreparedStatement).setString(1, "2026-01-01T09:00");
            verify(mockPreparedStatement).executeUpdate();

        }
    }

    @Test
    void saveUser_doesNotThrow_whenExecuteUpdateFails() throws Exception {
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeUpdate()).thenThrow(new SQLException("duplicate email"));

        User user = new User();
        user.setId("user-1");
        user.setEmail("test@example.com");
        user.setPassword("hashed-password");
        user.setCreatedAt(LocalDateTime.now());

        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            assertDoesNotThrow(() -> dbManager.saveUser(user));
        }
    }

    //findUserByEmail
    @Test
    void findUserByEmail_returnsUser_whenFound() throws Exception {
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultset);
        when(mockResultset.next()).thenReturn(true);
        when(mockResultset.getString("id")).thenReturn("user-1");
        when(mockResultset.getString("email")).thenReturn("test@example.com");
        when(mockResultset.getString("createdAt")).thenReturn("2026-01-01T09:00");

        //.........

        User result;
        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            result = dbManager.findUserByEmail("nobody@example.com");
        }

        assertNull(result);
    }

    @Test
    void findUserByEmail_returnsNull_whenNoMatchingRow() throws Exception {
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultset);
        when(mockResultset.next()).thenReturn(false);

        User result;
        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            result = dbManager.findUserByEmail("nobody@example.com");
        }

        assertNull(result);
    }

    @Test
    void findUserByEmail_returnsNull_whenQueryFails() throws Exception {
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenThrow(new SQLException());

        User result;
        try (MockedStatic<DriverManager> ignored = mockDriverManagerToReturn(mockConnection)) {
            result = dbManager.findUserByEmail("test@example.com");
        }

        assertNull(result);
    }

}