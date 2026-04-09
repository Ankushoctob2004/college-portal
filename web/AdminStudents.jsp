<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
if(session.getAttribute("admin")==null){
response.sendRedirect("AdminLogin.jsp");
return;
}

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false",
"root","root");

/* ADD STUDENT */
if(request.getParameter("username") != null){

PreparedStatement check = con.prepareStatement(
"SELECT * FROM login WHERE username=?");
check.setString(1,request.getParameter("username"));
ResultSet checkRs = check.executeQuery();

if(checkRs.next()){
response.sendRedirect("AdminStudents.jsp?msg=exists");
return;
}

PreparedStatement loginPs = con.prepareStatement(
"INSERT INTO login(username,password,role) VALUES(?,?,?)");

loginPs.setString(1,request.getParameter("username"));
loginPs.setString(2,request.getParameter("password"));
loginPs.setString(3,"STUDENT");
loginPs.executeUpdate();

PreparedStatement ps = con.prepareStatement(
"INSERT INTO students(username,name,branch,semester,status) VALUES(?,?,?,?,?)");

ps.setString(1,request.getParameter("username"));
ps.setString(2,request.getParameter("name"));
ps.setString(3,request.getParameter("branch"));
ps.setString(4,request.getParameter("semester"));
ps.setString(5,"Regular");

ps.executeUpdate();

response.sendRedirect("AdminStudents.jsp?msg=added");
return;
}

/* UPDATE STATUS */
if(request.getParameter("updateStatus") != null){
int id = Integer.parseInt(request.getParameter("id"));
String status = request.getParameter("status");

PreparedStatement ps = con.prepareStatement(
"UPDATE students SET status=? WHERE id=?");

ps.setString(1,status);
ps.setInt(2,id);
ps.executeUpdate();

response.sendRedirect("AdminStudents.jsp?msg=updated");
return;
}

/* DELETE */
if(request.getParameter("delete") != null){

int id = Integer.parseInt(request.getParameter("delete"));

PreparedStatement getUser = con.prepareStatement(
"SELECT username FROM students WHERE id=?");
getUser.setInt(1,id);
ResultSet ur = getUser.executeQuery();

String uname = "";
if(ur.next()){
uname = ur.getString("username");
}

PreparedStatement ps = con.prepareStatement(
"DELETE FROM students WHERE id=?");
ps.setInt(1,id);
ps.executeUpdate();

PreparedStatement ps2 = con.prepareStatement(
"DELETE FROM login WHERE username=?");
ps2.setString(1,uname);
ps2.executeUpdate();

response.sendRedirect("AdminStudents.jsp?msg=deleted");
return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Manage Students</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<link rel="stylesheet" href="admin.css">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- ? MOST IMPORTANT (navbar mobile fix) -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>

/* SAME UI AS DASHBOARD */

body{
margin:0;
font-family:'Segoe UI', Arial, sans-serif;
background:#f1f5f9;
}

/* CONTAINER */
.container{
max-width:1200px;
margin:auto;
padding:110px 15px 20px;
}

/* TITLE */
h2{
text-align:center;
font-size:28px;
margin-bottom:20px;
}

/* FORM */
.form-box{
background:white;
max-width:1100px;
margin:auto;
padding:20px;
border-radius:10px;
box-shadow:0 4px 10px rgba(0,0,0,0.1);
margin-bottom:20px;
}

.form-box form{
display:flex;
flex-wrap:wrap;
gap:10px;
justify-content:center;
}

/* INPUT */
input,select{
padding:10px;
border-radius:6px;
border:1px solid #ccc;
flex:1 1 180px;
font-family:'Segoe UI';
}

/* BUTTON */
button{
padding:10px;
background:#2563eb;
color:white;
border:none;
border-radius:6px;
cursor:pointer;
min-width:140px;
}

/* FILTER */
.filter-box{
text-align:center;
margin-bottom:15px;
}

/* TABLE */
.table-box{
overflow-x:auto;
display:flex;
justify-center:center;
}

table{
width:100%;
min-width:700px;
min-width:700px;
border-collapse:collapse;
background:white;
border-radius:10px;
overflow:hidden;
box-shadow:0 4px 10px rgba(0,0,0,0.1);
}

th{
background:#1e293b;
color:white;
padding:12px;
text-align: center;
}

td{
padding:14px 10px;
border-bottom:1px solid #ddd;
text-align:center;
vertical-align:middle;
}
 td:last-child
 {
     text-align:right;
     padding-right:20px;
 }
.id-link{
color:#2563eb;
font-weight:bold;
text-decoration:none;
}

.delete-btn{
background:red;
padding:6px 12px;
border-radius:5px;
margin-right:10px;
border:none;
color:white;
cursor:pointer;
}
td form
{
    display:inline-block;
}
filter-box form{
    display:flex;
    justify-content:center;
    gap:10px;
}
/* MOBILE FIX */
/* MOBILE FIX */
@media(max-width:768px){

.container{
padding-top:95px;
}

/* FORM COMPACT */
.form-box{
padding:15px;

}

.form-box form{
/*flex-direction:column;*/
gap:8px;
}

/* INPUT SMALL */
input,select{
width:100%;
padding:8px;
font-size:14px;
}

/* BUTTON NORMAL SIZE */
button{
width:100%;
padding:8px;
font-size:14px;
min-width:auto;
}

/* DELETE BUTTON FIX */
.delete-btn{
padding:5px 8px;
font-size:12px;
}

/* STATUS DROPDOWN */
td select{
padding:5px;
font-size:12px;
}

/* TABLE TEXT SMALL */
td,th{
font-size:12px;
padding:8px;
}

/* TITLE */
h2{
font-size:20px;
margin-bottom:15px;
}

}
</style>

</head>

<body>

<jsp:include page="adminNavbar.jsp" />

<div class="container">

<h2>Manage Students</h2>

<%
String msg = request.getParameter("msg");
if(msg != null){
%>
<script>
Swal.fire({
icon:'success',
title:'Success',
text:'<%= msg.equals("added")?"Student Added":
msg.equals("deleted")?"Student Deleted":
msg.equals("updated")?"Status Updated":
"Username Already Exists" %>'
});
window.history.replaceState({}, document.title, "AdminStudents.jsp");
</script>
<% } %>

<!-- FORM -->
<div class="form-box">
<form method="post">

<input type="text" name="username" placeholder="Username" required>
<input type="text" name="password" placeholder="Password" required>
<input type="text" name="name" placeholder="Name" required>

<select name="branch" required>
<option value="">Select Branch</option>
<option>CSE</option><option>IT</option><option>CE</option>
<option>ME</option><option>EE</option><option>EC</option>
</select>

<select name="semester" required>
<option value="">Select Semester</option>
<option>1</option><option>2</option><option>3</option>
<option>4</option><option>5</option><option>6</option>
<option>7</option><option>8</option>
</select>

<button type="submit">Add Student</button>

</form>
</div>

<!-- FILTER -->
<div class="filter-box">

<form method="get">

<select name="branch" onchange="this.form.submit()">
<option value="">All Branch</option>
<option value="CSE">CSE</option>
<option value="IT">IT</option>
<option value="CE">CE</option>
<option value="ME">ME</option>
<option value="EE">EE</option>
<option value="EC">EC</option>
</select>

<select name="semester" onchange="this.form.submit()">
<option value="">All Semester</option>
<% for(int i=1;i<=8;i++){ %>
<option value="<%=i%>">Sem <%=i%></option>
<% } %>
</select>

</form>

</div>

<!-- TABLE -->
<div class="table-box">
<table>

<tr>
<th>ID</th>
<th>Username</th>
<th>Name</th>
<th>Branch</th>
<th>Sem</th>
<th>Action</th>
</tr>

<%
String branch = request.getParameter("branch");
String semester = request.getParameter("semester");

PreparedStatement ps;

if(branch != null && !branch.equals("") && semester != null && !semester.equals("")){
ps = con.prepareStatement("SELECT * FROM students WHERE branch=? AND semester=? ORDER BY name ASC");
ps.setString(1, branch);
ps.setString(2, semester);
}
else if(branch != null && !branch.equals("")){
ps = con.prepareStatement("SELECT * FROM students WHERE branch=? ORDER BY name ASC");
ps.setString(1, branch);
}
else{
ps = con.prepareStatement("SELECT * FROM students ORDER BY name ASC");
}

ResultSet rs = ps.executeQuery();

while(rs.next()){
%>

<tr>

<td>
<a class="id-link" href="studentHome.jsp?username=<%=rs.getString("username")%>">
<%=rs.getInt("id")%>
</a>
</td>

<td><%=rs.getString("username")%></td>
<td><%=rs.getString("name")%></td>
<td><%=rs.getString("branch")%></td>
<td><%=rs.getString("semester")%></td>

<td>

<button class="delete-btn"
onclick="confirmDelete(<%=rs.getInt("id")%>)">
Delete
</button>

<form method="post" style="display:inline;">
<input type="hidden" name="id" value="<%=rs.getInt("id")%>">

<select name="status" onchange="this.form.submit()">
<option value="Regular" <%= "Regular".equals(rs.getString("status"))?"selected":"" %>>Regular</option>
<option value="EX" <%= "EX".equals(rs.getString("status"))?"selected":"" %>>EX</option>
</select>

<input type="hidden" name="updateStatus" value="1">
</form>

</td>

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

<script>
function confirmDelete(id){
Swal.fire({
title:'Are you sure?',
icon:'warning',
showCancelButton:true,
confirmButtonColor:'#d33'
}).then((result)=>{
if(result.isConfirmed){
window.location='AdminStudents.jsp?delete='+id;
}
});
}
</script>

</body>
</html>