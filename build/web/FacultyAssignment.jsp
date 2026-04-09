<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s = request.getSession(false);

if(s==null || !"FACULTY".equals(s.getAttribute("role"))){
response.sendRedirect("login.jsp");
return;
}

String branch=(String)s.getAttribute("branch");
%>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1.0">

<title>Faculty - Assignment Management</title>



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
width:85%;
margin:40px auto;
background:#2c3e50;
padding:30px;
border-radius:12px;
box-shadow:0 4px 15px rgba(0,0,0,0.5);
color:white;
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

/* FORM */
.form-section{
display:flex;
align-items:center;
gap:15px;
margin-bottom:25px;
flex-wrap:wrap; /* ? responsive */
}

.form-section select,
.form-section input{
padding:10px;
border-radius:6px;
border:1px solid #444;
background:#2a2a2c;
color:white;
}

.form-section select{
width:300px;
}

.form-section button{
padding:10px 18px;
border:none;
border-radius:6px;
background:#3b82f6;
color:white;
cursor:pointer;
transition:0.3s;
}

.form-section button:hover{
transform:scale(1.05);
background:#2563eb;
}

/* TABLE */
.table-container{
overflow-x:auto; /* ? mobile scroll */
}

table{
width:100%;
border-collapse:collapse;
margin-top:20px;
min-width:600px;
}

th,td{
padding:12px;
border-bottom:1px solid #444;
text-align:center;
}

tr:hover{
background:#34495e;
transition:0.2s;
}

/* BUTTONS */
.view-btn,
.download-btn,
.delete-btn{
padding:6px 12px;
border:none;
border-radius:5px;
cursor:pointer;
transition:0.3s;
}

.view-btn{
background:white;
color:#000;
}

.view-btn:hover{
background:#e5e7eb;
transform:scale(1.05);
}

.download-btn{
background:#27ae60;
color:white;
}

.download-btn:hover{
background:#1e8449;
transform:scale(1.05);
}

.delete-btn{
background:#c0392b;
color:white;
}

.delete-btn:hover{
background:#922b21;
transform:scale(1.05);
}

/* ================= MOBILE ================= */

@media(max-width:768px){

.container{
width:95%;
padding:20px;
}

/* FORM STACK */
.form-section{
flex-direction:column;
align-items:stretch;
}

.form-section select,
.form-section input,
.form-section button{
width:100%;
}

/* TABLE TEXT SMALL */
th,td{
font-size:12px;
padding:8px;
}

}

/* EXTRA SMALL */
@media(max-width:400px){

h2{
font-size:18px;
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

<div class="container">

<h2>Upload Assignment (Branch : <%=branch%>)</h2>

<form method="post" action="UploadAssignmentServlet" enctype="multipart/form-data">

<div class="form-section">

<select name="subject">
<option value="Mathematics">Mathematics</option>
<option value="Physics">Physics</option>
<option value="Computer Science">Computer Science</option>
</select>

<input type="file" name="file" accept="application/pdf" required>

<button type="submit">Upload</button>

</div>

</form>

<h2>Assignment Records</h2>

<div class="table-container">

<table>

<tr>
<th>Subject</th>
<th>File Name</th>
<th>View</th>
<th>Download</th>
<th>Delete</th>
</tr>

<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root",
"root"
);

PreparedStatement ps=con.prepareStatement(
"SELECT * FROM assignments WHERE branch=? ORDER BY id DESC"
);

ps.setString(1,branch);

ResultSet rs=ps.executeQuery();

boolean found=false;

while(rs.next()){
found=true;
%>

<tr>

<td><%=rs.getString("subject")%></td>
<td><%=rs.getString("file_name")%></td>

<td>
<a href="FileServlet?name=<%=rs.getString("file_path")%>" target="_blank">
<button class="view-btn">View</button>
</a>
</td>

<td>
<a href="FileServlet?name=<%=rs.getString("file_path")%>" download>
<button class="download-btn">Download</button>
</a>
</td>

<td>
<a href="DeleteAssignmentServlet?id=<%=rs.getInt("id")%>">
<button class="delete-btn">Delete</button>
</a>
</td>

</tr>

<%
}

if(!found){
%>

<tr>
<td colspan="5">No assignments uploaded</td>
</tr>

<%
}

rs.close();
ps.close();
con.close();
%>

</table>

</div>

</div>

<%
String msg = (String) session.getAttribute("msg");
if(msg != null){
%>

<script>
Swal.fire({
icon: 'success',
title: 'Success',
text: '<%=msg%>'
});
</script>

<%
session.removeAttribute("msg");
}
%>

</body>
</html>