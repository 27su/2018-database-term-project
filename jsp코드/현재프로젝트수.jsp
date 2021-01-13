<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
	<title>현재 프로젝트 수행개수</title>
</head>
<body>
	<table width="600" border="1">
		<tr>
			<td width="100">현재 수행 프로젝트 개수</td>
		</tr>
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
	}catch(ClassNotFoundException cnfe){
		cnfe.printStackTrace();
		System.out.println("드라이버 로딩 실패");
	}
	try{
		String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:orcl";
		String userId = "admin";
		String userPass = "admin";

		conn = DriverManager.getConnection(jdbcUrl, userId, userPass);
		
		String sql = "select count (프로젝트_번호) as proj from 프로젝트 where 프로젝트_착수일자 <= SYSDATE AND (SYSDATE <= 프로젝트_종료일자 OR 프로젝트_종료일자 IS NULL) ";

		pstmt = conn.prepareStatement(sql);

		rs = pstmt.executeQuery();
		while( rs.next() ) {
			String PROJ = rs.getString("proj");
		
%>
			<tr>
				<td width="100"><%= PROJ %></td>

			</tr>

<%
		}
	}catch(SQLException e){
		e.printStackTrace();

		if(rs != null) {
			try {
				rs.close();
			}catch(SQLException sqle) {} 
		}
		if(pstmt != null) {
			try {
				pstmt.close();
			}catch(SQLException sqle) {}
		}
		if(conn != null) {
			try {
				conn.close();
			}catch(SQLException sqle) {}
		}
	}
%>

	</table>

</body>
</html>