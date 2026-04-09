<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%

/* ===== GET USERNAME FROM URL ===== */
String user = request.getParameter("username");

if(user != null){

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/college?useSSL=false",
    "root","root");

    PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM students WHERE username=?");

    ps.setString(1,user);

    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        session.setAttribute("username", rs.getString("username"));
        session.setAttribute("name", rs.getString("name"));
        session.setAttribute("branch", rs.getString("branch"));
        session.setAttribute("role", "STUDENT");
    }

    rs.close();
    ps.close();
    con.close();
}

/* ===== SESSION CHECK ===== */
HttpSession s = request.getSession(false);

if (s == null) {
    response.sendRedirect("login.jsp");
    return;
}

String role = (String)s.getAttribute("role");

if (role == null || !role.equalsIgnoreCase("STUDENT")) {
    response.sendRedirect("login.jsp");
    return;
}

/* ===== NAME ===== */
String name = (String)s.getAttribute("name");
String branch = (String)s.getAttribute("branch");

if(name == null){
    name = "Student";
}

%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<meta charset="UTF-8">
<title>Student Dashboard</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<link rel="stylesheet" href="navbar.css">

<style>

body{
color:white;
font-family:'Segoe UI',sans-serif;
margin:0;
background:#151516;
}

/* WELCOME */
.welcome{
text-align:center;
margin:25px 10px;
}

.welcome h1{

}

.welcome p{
font-size:14px;
color:#aaa;
}

/* CARDS GRID */
.cards{
width:90%;
max-width:900px;
margin:auto;
display:grid;
grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
gap:15px;
}

/* LINK RESET */
.cards a{
text-decoration:none;
color:inherit;
}

/* CARD */
.card{
background:white;
padding:20px;
border-radius:14px;
text-align:center;
font-size:14px;
font-weight:bold;
color:#444;
box-shadow:0 5px 15px rgba(0,0,0,0.2);
transition:0.3s;
}

/* ICON */
.card i{
font-size:24px;
color:#667eea;
margin-bottom:8px;
}

/* HOVER */
.card:hover{
transform:translateY(-5px);
background:linear-gradient(135deg,#667eea,#764ba2);
color:white;
}

.card:hover i{
color:white;
}

.card:active{
transform:scale(0.97);
}

</style>

</head>

<body>

<!-- ? NAVBAR (IMPORTANT FIX) -->
<%@include file="navbar.jsp"%>

<div class="welcome">
<h1>Welcome, <%= name %></h1>
<p>Branch: <%= branch %></p>
</div>

<div class="cards">

<a href="StudentAttendance.jsp">
<div class="card">
<i class="fa-solid fa-calendar-check"></i><br>
View Attendance
</div>
</a>

<a href="StudentAssignment.jsp">
<div class="card">
<i class="fa-solid fa-book"></i><br>
Assignments
</div>
</a>

<a href="studentResult.jsp">
<div class="card">
<i class="fa-solid fa-chart-line"></i><br>
Results
</div>
</a>

<a href="studentNotice.jsp">
<div class="card">
<i class="fa-solid fa-bullhorn"></i><br>
Notices
</div>
</a>

<a href="StudentDocuments.jsp">
<div class="card">
<i class="fa-solid fa-folder-open"></i><br>
Documents
</div>
</a>

<a href="studentEvents.jsp">
<div class="card">
<i class="fa-solid fa-calendar-days"></i><br>
Events
</div>
</a>

<a href="StudentTimeTable.jsp">
<div class="card">
<i class="fa-solid fa-clock"></i><br>
Class Time Table
</div>
</a>

<a href="StudentSyllabus.jsp">
<div class="card">
<i class="fa-solid fa-file-lines"></i><br>
Syllabus
</div>
</a>

<a href="StudentMidTerm.jsp">
<div class="card">
<i class="fa-solid fa-pen"></i><br>
Mid-Term Marks
</div>
</a>

</div>

<!-- ? SCRIPT -->
<script>
function toggleMenu(){
let nav=document.getElementById("navLinks");
nav.classList.toggle("active");
}
</script>

</body>
</html>