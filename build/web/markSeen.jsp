<%@ page import="java.sql.*" %>

<%
HttpSession s=request.getSession(false);
String branch=(String)s.getAttribute("branch");

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college","root","root");

PreparedStatement ps=con.prepareStatement(
"UPDATE notices SET seen=1 WHERE branch=?");

ps.setString(1,branch);
ps.executeUpdate();

con.close();
%>