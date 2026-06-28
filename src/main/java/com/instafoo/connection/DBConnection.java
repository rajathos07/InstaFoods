package com.instafoo.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	

		private static final String url = "jdbc:mysql://localhost:3306/instafoods";
		private static final String name = "root";
		private static final String password = "newpassword123";
		static Connection conn=null;
			
		public static Connection getConnection() {
			
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn=DriverManager.getConnection(url,name,password);
				
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return conn;
			
		}

	

}
