<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html>
<head>
	<title>현재 프로젝트 투입 인원 수</title>
</head>
<body>
        <h1>직원들이 현재 어느 프로젝트에 몇 명이나 투입되어 있나?</h1>
        <% Date date = new Date(); %>
        <h3>현재 날짜: <%= date.toLocaleString() %> </h3>      
	<table width="500" border="1">
		<tr>
			<td width="100">현재 진행중인 프로젝트명</td>
			<td width="100">현재 투입된 인원 수</td>
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
		
		String sql = "SELECT 프로젝트명, COUNT(직원번호) 투입인원수 FROM 투입, 프로젝트 WHERE 프로젝트_착수일자 <= SYSDATE AND (SYSDATE <= 프로젝트_종료일자 OR 프로젝트_종료일자 IS NULL) AND 프로젝트.프로젝트_번호 = 투입.프로젝트_번호 AND 투입_시작일자 <= SYSDATE AND (SYSDATE <= 투입_종료일자 OR 투입_종료일자 IS NULL) GROUP BY 투입.프로젝트_번호, 프로젝트명 ORDER BY 프로젝트명";

		pstmt = conn.prepareStatement(sql);

		rs = pstmt.executeQuery();
		while( rs.next() ) {
			String pname = rs.getString("프로젝트명");
			int count = rs.getInt("투입인원수");
		
%>
			<tr>
				<td width="100"><%= pname %></td>
				<td width="100"><%= count %></td>
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