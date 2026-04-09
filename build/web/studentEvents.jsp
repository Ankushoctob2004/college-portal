<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s = request.getSession(false);

if (s == null || !"STUDENT".equals(s.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root",
"root");

PreparedStatement ps=con.prepareStatement("SELECT * FROM events ORDER BY event_date DESC");

ResultSet rs=ps.executeQuery();

boolean hasData = false;
%>

<!DOCTYPE html>
<html>
     
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Student Events</title>
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="navbar.css">

<style>
*{box-sizing:border-box;}

body{
background:#0f172a;
font-family:Segoe UI;
color:white;
margin:0;
}

/* ? HEADER */
.header{
text-align:center;
margin-top:25px;
padding:0 10px;
}

.header h2{
font-size:22px;
}

.header p{
color:#94a3b8;
font-size:14px;
}

/* ? EVENTS GRID */
.events{
margin-top:30px;
width:95%;
max-width:1100px;
margin-left:auto;
margin-right:auto;

display:grid;
grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
gap:20px;
}

/* ? EVENT CARD */
.event-card{
border-radius:15px;
overflow:hidden;
background:#1e293b;
box-shadow:0 4px 10px rgba(0,0,0,0.5);
transition:0.3s;
}

.event-card:hover{
transform:translateY(-5px);
}

/* IMAGE */
.event-image{
width:100%;
height:160px;
object-fit:cover;
}

/* CONTENT */
.event-content{
padding:15px;
}

.event-content h3{
color:#60a5fa;
margin-bottom:6px;
font-size:16px;
}

.event-content p{
color:#cbd5f5;
font-size:13px;
margin:4px 0;
word-break:break-word;
}

/* ? NO DATA */
.no-data{
text-align:center;
margin:40px auto;
background:#1e293b;
padding:30px;
border-radius:10px;
width:90%;
max-width:400px;
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

.event-image{
height:140px;
}

.event-content h3{
font-size:14px;
}

.event-content p{
font-size:12px;
}

}

/* ? SMALL MOBILE */
@media(max-width:480px){

.header h2{
font-size:18px;
}

.events{
grid-template-columns:1fr;
}

}
</style>

</head>

<body>


<%@include file="navbar.jsp" %>
<div class="header">

<h2>College Events</h2>
<p>Stay updated with latest events</p>

</div>

<div class="events">

<%

while(rs.next()){
hasData = true;
%>

<div class="event-card">

<img src="<%=rs.getString("image")%>" class="event-image">

<div class="event-content">

<h3><%=rs.getString("title")%></h3>

<p><%=rs.getString("event_date")%></p>

<p><%=rs.getString("description")%></p>

</div>

</div>

<%
}

%>

</div>

<%

if(!hasData){
%>

<div class="no-data">
<h3>No Data Available ?</h3>
<p>No events have been published yet.</p>
</div>

<%
}

rs.close();
ps.close();
con.close();
%>
<script>
function toggleMenu(){
let nav=document.getElementById("navLinks");
nav.classList.toggle("active");
}
</script>
</body>
</html>