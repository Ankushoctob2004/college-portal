<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s = request.getSession(false);

if (s == null || !"STUDENT".equals(s.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}

String branch = (String)s.getAttribute("branch");

if(branch == null){
    branch = "";
}
%>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
     <meta name="viewport" content="width=device-width,initial-scale=1.0">
<link rel="stylesheet" href="navbar.css">

<title>Student Notices</title>

<style>
*{box-sizing:border-box;}

body{
background:#0f172a;
color:white;
font-family:Arial;
margin:0;
}

/* ? CONTAINER FIX */
.container{
width:95%;
max-width:900px;
margin:20px auto;
padding:10px;
}

/* ? NOTICE CARD */
.notice-item{
background:#1e293b;
padding:18px;
margin-bottom:15px;
border-radius:10px;
border-left:5px solid #3b82f6;
box-shadow:0 4px 10px rgba(0,0,0,0.5);
transition:0.2s;
}

.notice-item:hover{
transform:translateY(-3px);
}

/* TITLE */
.notice-item h3{
margin-bottom:8px;
color:#60a5fa;
font-size:16px;
}

/* MESSAGE */
.notice-item p{
color:#cbd5f5;
font-size:14px;
line-height:1.4;
word-break:break-word;
}

/* DATE */
.notice-date{
font-size:12px;
color:#94a3b8;
margin-top:8px;
}

/* ? NO DATA */
.no-data{
text-align:center;
margin-top:40px;
background:#1e293b;
padding:30px;
border-radius:10px;
}

.no-data h3{
color:#94a3b8;
margin-bottom:8px;
}

.no-data p{
color:#cbd5f5;
font-size:14px;
}

/* ? MOBILE */
@media(max-width:768px){

.notice-item{
padding:15px;
}

.notice-item h3{
font-size:14px;
}

.notice-item p{
font-size:13px;
}

}

/* ? SMALL MOBILE */
@media(max-width:480px){

.container{
padding:5px;
}

.notice-item{
padding:12px;
}

}
</style>

</head>

<body>

    <%@include file="navbar.jsp"%>

</div>
<div class="container">

<h1>Student Notice Board (Branch : <%=branch%>)</h1>

<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root",
"root");

PreparedStatement ps = con.prepareStatement(
"SELECT * FROM notices WHERE branch=? ORDER BY id DESC");

ps.setString(1,branch);

ResultSet rs = ps.executeQuery();

boolean hasData = false;

while(rs.next()){

hasData = true;
%>

<div class="notice-item">

<h3><%=rs.getString("title")%></h3>

<p><%=rs.getString("message")%></p>

<div class="notice-date">
<%=rs.getString("date")%>
</div>

</div>

<%
}

if(!hasData){
%>

<div class="no-data">
<h3>No Data Available ?</h3>
<p>No notices have been published for your branch.</p>
</div>

<%
}

rs.close();
ps.close();
con.close();
%>

</div>
<script>
function toggleMenu(){
let nav=document.getElementById("navLinks");
nav.classList.toggle("active");
}
</script>
</body>
</html>