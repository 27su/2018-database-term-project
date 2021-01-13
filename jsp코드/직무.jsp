<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
	<title>직무</title>
</head>
<body>
	<table width="600" border="1">
		<tr>
			<td width="100">현재진행중인 프로젝트</td>
			<td width="100">투입된 직원이름</td>
			<td width="100">직무</td>
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
		
		String sql = "SELECT 프로젝트명,  직원.직원명 as 직원이름, 직무 FROM 투입, 프로젝트 ,직원 WHERE 프로젝트_착수일자 <= SYSDATE AND (SYSDATE <= 프로젝트_종료일자 OR 프로젝트_종료일자 IS NULL) AND 프로젝트.프로젝트_번호 = 투입.프로젝트_번호 AND 투입_시작일자 <= SYSDATE AND (SYSDATE <= 투입_종료일자 OR 투입_종료일자 IS NULL) AND 직원.직원번호=투입.직원번호 GROUP BY  프로젝트명,투입.직무, 직원.직원명 ORDER BY 프로젝트명";
		pstmt = conn.prepareStatement(sql);

		rs = pstmt.executeQuery();
		while( rs.next() ) {
			String pname = rs.getString("프로젝트명");
			
			String ename = rs.getString("직원이름");
			String role = rs.getString("직무");
		
		
%>
			<tr>
				<td width="100"><%= pname %></td>
				
				<td width="100"><%= ename %></td>
				<td width="100"><%= role %></td>

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