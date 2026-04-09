<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("admin")==null){
response.sendRedirect("AdminLogin.jsp");
return;
}

String id = request.getParameter("id");

Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false",
"root","root");

PreparedStatement ps = con.prepareStatement(
"SELECT * FROM students WHERE id=?");

ps.setInt(1,Integer.parseInt(id));
ResultSet rs = ps.executeQuery();

if(rs.next()){
%>

<!DOCTYPE html>
<html>
<head>
<title>Student Details</title>

<style>
body{
font-family:Arial;
background:#f1f5f9;
text-align:center;
padding-top:100px;
}

.card{
background:white;
padding:30px;
width:400px;
margin:auto;
border-radius:10px;
box-shadow:0 5px 15px rgba(0,0,0,0.2);
}

h2{
margin-bottom:20px;
}
</style>

</head>

<body>

<div class="card">

<h2>Student Profile</h2>

<p><b>ID:</b> <%=rs.getInt("id")%></p>
<p><b>Username:</b> <%=rs.getString("username")%></p>
<p><b>Name:</b> <%=rs.getString("name")%></p>
<p><b>Branch:</b> <%=rs.getString("branch")%></p>

</div>

</body>
</html>

<%
}
rs.close();
ps.close();
con.close();
%>