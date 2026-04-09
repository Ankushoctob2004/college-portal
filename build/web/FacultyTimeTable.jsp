<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s=request.getSession(false);

if(s==null || !"FACULTY".equals(s.getAttribute("role"))){
response.sendRedirect("login.jsp");
return;
}

String branch=(String)s.getAttribute("branch");
%>

<!DOCTYPE html>
<html>
<head>

<title>Faculty Time Table</title>
<meta name="viewport" content="width=device-width,initial-scale=1.0">

<link rel="stylesheet" href="faculty.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>

body{background:#dfe3e8;font-family:Segoe UI;}

.container{
max-width:1100px;
margin:auto;
padding:40px;
text-align:center;
}

.card{
background:white;
padding:25px;
border-radius:10px;
box-shadow:0 5px 15px rgba(0,0,0,0.1);
margin-bottom:30px;
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
.form-grid{
display:grid;
grid-template-columns:repeat(auto-fit,minmax(180px,1fr));
gap:15px;
margin-bottom:20px;
}

input,select{
padding:10px;
border:1px solid #ccc;
border-radius:5px;
}

button{
padding:10px 20px;
background:#2c3e50;
color:white;
border:none;
border-radius:5px;
cursor:pointer;
}

.delete-btn{
background:#e74c3c;
color:white;
padding:6px 10px;
border:none;
border-radius:5px;
cursor:pointer;
}

table{
width:100%;
border-collapse:collapse;
background:white;
}

th,td{
padding:12px;
border:1px solid #ddd;
}

th{
background:#2c3e50;
color:white;
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

<div class="container">

<h1>Faculty Time Table (Branch : <%=branch%>)</h1>

<div class="card">

<form method="post">

<div class="form-grid">

<select name="day">
<option>Monday</option>
<option>Tuesday</option>
<option>Wednesday</option>
<option>Thursday</option>
<option>Friday</option>
<option>Saturday</option>
</select>

<input type="text" name="subject" placeholder="Subject" required>
<input type="text" name="faculty" placeholder="Faculty Name" required>
<input type="text" name="room" placeholder="Room No" required>
<input type="time" name="start" required>
<input type="time" name="end" required>

</div>

<button type="submit">Add Time Table</button>

</form>

</div>

<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root",
"root"
);

/* ================= INSERT WITH DUPLICATE CHECK ================= */

if(request.getMethod().equalsIgnoreCase("POST")){

String day=request.getParameter("day");
String subject=request.getParameter("subject");
String faculty=request.getParameter("faculty");
String room=request.getParameter("room");
String start=request.getParameter("start");
String end=request.getParameter("end");

/* ? CHECK DUPLICATE (same day + time + branch) */

PreparedStatement check=con.prepareStatement(
"SELECT * FROM timetable WHERE branch=? AND day=? AND start_time=? AND end_time=?"
);

check.setString(1,branch);
check.setString(2,day);
check.setString(3,start);
check.setString(4,end);

ResultSet crs=check.executeQuery();

if(crs.next()){
%>

<script>
Swal.fire({
icon:'error',
title:'Duplicate Entry!',
text:'Time slot already exists'
});
</script>

<%
}else{

PreparedStatement ps=con.prepareStatement(
"INSERT INTO timetable(branch,day,subject,faculty,room,start_time,end_time) VALUES(?,?,?,?,?,?,?)"
);

ps.setString(1,branch);
ps.setString(2,day);
ps.setString(3,subject);
ps.setString(4,faculty);
ps.setString(5,room);
ps.setString(6,start);
ps.setString(7,end);

ps.executeUpdate();
%>

<script>
Swal.fire({
icon:'success',
title:'Success',
text:'Time Table Added Successfully'
});
</script>

<%
}
}

/* ================= DELETE ================= */
String deleteId = request.getParameter("deleteId");

if(deleteId != null){

PreparedStatement dps = con.prepareStatement(
"DELETE FROM timetable WHERE id=?"
);

dps.setInt(1,Integer.parseInt(deleteId));
dps.executeUpdate();

/* ? REDIRECT AFTER DELETE */
response.sendRedirect("FacultyTimeTable.jsp?msg=deleted");
return;

}
/* ================= FETCH ================= */

PreparedStatement ps2=con.prepareStatement(
"SELECT * FROM timetable WHERE branch=? ORDER BY day"
);

ps2.setString(1,branch);

ResultSet rs=ps2.executeQuery();
%>

<table>

<tr>
<th>Day</th>
<th>Subject</th>
<th>Faculty</th>
<th>Room</th>
<th>Time</th>
<th>Delete</th>
</tr>

<%

while(rs.next()){
%>

<tr>

<td><%=rs.getString("day")%></td>
<td><%=rs.getString("subject")%></td>
<td><%=rs.getString("faculty")%></td>
<td><%=rs.getString("room")%></td>
<td><%=rs.getString("start_time")%> - <%=rs.getString("end_time")%></td>

<td>
<a href="FacultyTimeTable.jsp?deleteId=<%=rs.getInt("id")%>">
<button class="delete-btn">Delete</button>
</a>
</td>

</tr>

<%
}

con.close();
%>

</table>

</div>

</body>
</html>