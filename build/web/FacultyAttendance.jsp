<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%

HttpSession s = request.getSession(false);

if (s == null || !"FACULTY".equals(s.getAttribute("role"))) {
response.sendRedirect("login.jsp");
return;
}

String branch=(String)s.getAttribute("branch");
if(branch==null) branch="";

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>

<title>Faculty Attendance</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<link rel="stylesheet" href="faculty.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>

*{box-sizing:border-box;}

body{
background:#dfe3e8;
font-family:Segoe UI;
margin:0;
overflow-x:hidden;
}

.container{
background:#fff;
padding:30px;
border-radius:12px;
max-width:1100px;
margin:auto;
margin-top:50px;
}
.logo span {
color:#1ABC9C;
  
}
.logo {font-size: 40px;
  color:#2F80ED;
 
}
/* LOGO */
.navbar h2 logo{
font-size:50px;
color:#2F80ED;
}
/* DATE */
.date-box{
margin-bottom:15px;
display:flex;
gap:10px;
align-items:center;
flex-wrap:wrap;
}

.date-box input{
padding:8px;
}

/* TABLE WRAP */
.table-container{
width:100%;
overflow-x:auto;
}

/* TABLE */
table{
width:100%;
border-collapse:collapse;
min-width:800px;
}

th{
background:#334155;
color:#fff;
padding:12px;
}

td{
padding:10px;
text-align:center;
border-bottom:1px solid #e2e8f0;
}

/* NAME WRAP */
td:nth-child(2){
white-space:normal;
}

/* RADIO */
input[type="radio"]{
transform:scale(1.2);
cursor:pointer;
}

/* HOVER */
tr:hover{
background:#f1f5f9;
transition:0.2s;
}

/* BUTTON */
.save-btn{
margin-top:20px;
background:#334155;
color:#fff;
padding:10px 20px;
border:none;
border-radius:6px;
cursor:pointer;
transition:0.3s;
}

.save-btn:hover{
background:#1e293b;
transform:scale(1.05);
}

/* MOBILE */
@media(max-width:768px){

.container{
width:95%;
padding:15px;
}

.date-box{
flex-direction:column;
align-items:flex-start;
}

th,td{
font-size:12px;
padding:8px;
white-space:nowrap;
}

.save-btn{
width:100%;
font-size:14px;
padding:12px;
}

}

/* SMALL */
@media(max-width:480px){
h2{
font-size:18px;
text-align:center;
}
}
/* ? NAVBAR RESPONSIVE */


.nav-links{
display:flex;
gap:15px;
}



/* ? MOBILE NAVBAR */
@media(max-width:768px){

.navbar{
flex-direction:column;
align-items:flex-start;
gap:10px;
}

.nav-links{
width:100%;
justify-content:space-around;
}

}

/* ? TABLE BETTER MOBILE */
.table-container{
border-radius:10px;
overflow:auto;
}

/* ? SCROLL IMPROVEMENT */
.table-container::-webkit-scrollbar{
height:6px;
}

.table-container::-webkit-scrollbar-thumb{
background:#94a3b8;
border-radius:10px;
}

/* ? RADIO ALIGN FIX */
td input[type="radio"]{
margin:auto;
display:block;
}

/* ? SMALL SCREEN FIX */
@media(max-width:600px){

h2{
font-size:16px;
}

td:nth-child(2){
min-width:120px;
}

}

/* ? EXTRA SMALL */
@media(max-width:400px){

.save-btn{
font-size:13px;
padding:10px;
}

th,td{
font-size:11px;
}

}
</style>

</head>

<body>

<div class="navbar">
<h2 class="logo">Campus<span>Hub</span></h2>
<div class="nav-links">
<a href="FacultyDashboard.jsp">Dashboard</a>
<a href="LogoutServlet">Logout</a>
</div>
</div>

<!-- SUCCESS -->
<%
String msg=(String)session.getAttribute("msg");
if(msg!=null){
%>

<script>
Swal.fire({
icon:'success',
title:'Success',
text:'<%=msg%>',
confirmButtonColor:'#3085d6'
});
</script>

<%
session.removeAttribute("msg");
}
%>

<div class="container">

<h2 align="center">Mark Attendance (Branch : <%=branch%>)</h2>

<form method="post" action="SaveAttendanceServlet">

<div class="date-box">
<label><b>Date:</b></label>
<input type="date" name="date" id="date" required>
</div>

<div class="table-container">

<table>

<tr>
<th>Username</th>
<th>Name</th>
<th>Present</th>
<th>Absent</th>
<th>Leave</th>
</tr>

<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root",
"root");

PreparedStatement ps=con.prepareStatement(
"SELECT username,name FROM students WHERE branch LIKE ?"
);

ps.setString(1,"%"+branch+"%");
ResultSet rs=ps.executeQuery();

boolean found=false;

while(rs.next()){
found=true;
String u=rs.getString("username");
%>

<tr>

<td><%=u%></td>
<td><%=rs.getString("name")%></td>

<td><input type="radio" name="status_<%=u%>" value="PRESENT" required></td>
<td><input type="radio" name="status_<%=u%>" value="ABSENT"></td>
<td><input type="radio" name="status_<%=u%>" value="LEAVE"></td>

</tr>

<%
}

if(!found){
%>

<tr>
<td colspan="5">No students found</td>
</tr>

<%
}

rs.close();
ps.close();
con.close();
%>

</table>

</div>

<button class="save-btn" type="submit">Save Attendance</button>

</form>

</div>

<!-- AUTO DATE -->
<script>

let today = new Date();

let yyyy = today.getFullYear();
let mm = String(today.getMonth() + 1).padStart(2, '0');
let dd = String(today.getDate()).padStart(2, '0');

document.getElementById("date").value = yyyy + "-" + mm + "-" + dd;

</script>

</body>
</html>