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

/* ADD FACULTY */
if(request.getParameter("username") != null){

PreparedStatement loginPs = con.prepareStatement(
"INSERT INTO login(username,password,role) VALUES(?,?,?)");

loginPs.setString(1,request.getParameter("username"));
loginPs.setString(2,request.getParameter("password"));
loginPs.setString(3,"FACULTY");
loginPs.executeUpdate();

PreparedStatement ps = con.prepareStatement(
"INSERT INTO faculty(username,name,branch) VALUES(?,?,?)");

ps.setString(1,request.getParameter("username"));
ps.setString(2,request.getParameter("name"));
ps.setString(3,request.getParameter("branch"));
ps.executeUpdate();
}

/* DELETE */
if(request.getParameter("delete") != null){

PreparedStatement dps = con.prepareStatement(
"DELETE FROM faculty WHERE id=?");

dps.setInt(1,Integer.parseInt(request.getParameter("delete")));
dps.executeUpdate();

PreparedStatement dps2 = con.prepareStatement(
"DELETE FROM login WHERE username=?");

dps2.setString(1,request.getParameter("user"));
dps2.executeUpdate();

response.sendRedirect("AdminFaculty.jsp");
return;
}

/* SEND MESSAGE */
if(request.getParameter("sendMsg") != null){

PreparedStatement mps = con.prepareStatement(
"INSERT INTO faculty_messages(username,message) VALUES(?,?)");

mps.setString(1,request.getParameter("user"));
mps.setString(2,request.getParameter("text"));
mps.executeUpdate();
}

/* NOTIFICATION COUNT */
PreparedStatement notifPs = con.prepareStatement(
"SELECT COUNT(*) FROM faculty_queries WHERE status='unread'");
ResultSet nrs = notifPs.executeQuery();

int notifCount = 0;
if(nrs.next()){
notifCount = nrs.getInt(1);
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Manage Faculty</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<link rel="stylesheet" href="admin.css">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>

/* BODY */
body{
margin:0;
font-family:'Segoe UI';
background:#f1f5f9;
}

/* CONTAINER FULL WIDTH */
.container{
width:100%;
margin:100px auto 20px;
padding:20px;
}

/* TITLE */
h2{
text-align:center;
font-size:30px;
margin-bottom:25px;
}

/* FORM */
.form-box{
background:white;
padding:25px;
border-radius:12px;
box-shadow:0 4px 15px rgba(0,0,0,0.1);
text-align:center;
margin-bottom:24px;
}

/* INPUT */
input,select{
padding:10px;
margin:8px;
border-radius:6px;
border:1px solid #ccc;
min-width: 160px;
}

/* BUTTON */
button{
padding:10px 15px;
background:#2563eb;
color:white;
border:none;
border-radius:6px;
cursor:pointer;
transition:0.3s;
}

/* TABLE WRAPPER (IMPORTANT ?) */
.table-box{
overflow-x:auto;
}

/* TABLE */
table{
width:124%;
border-collapse:collapse;
background:white;
border-radius:-6px;
overflow:hidden;
box-shadow:0 4px 10px rgba(0,0,0,0.1);
min-width:600px;
}

th{
background:#1e293b;
color:white;
padding:12px;
text-align:left;
}

td{
padding:12px;
border-bottom:1px solid #ddd;
}

/* BUTTONS */
.delete-btn{
background:red;
margin-left:5px;
}

.msg-btn{
background:#16a34a;
}

/* MODAL */
#overlay{
display:none;
position:fixed;
top:0;
left:0;
width:100%;
height:100%;
background:rgba(0,0,0,0.5);
z-index:998;
}

#chatModal{
display:none;
position:fixed;
top:50%;
left:50%;
transform:translate(-50%,-50%);
background:white;
padding:25px;
border-radius:14px;
width:400px;
z-index:999;
}

#chatModal textarea{
width:100%;
height:100px;
padding:10px;
margin-top:10px;
}

.close-btn{
position:absolute;
top:10px;
right:10px;
background:red;
color:white;
border:none;
border-radius:50%;
width:28px;
height:28px;
}

/* NOTIFICATION */
.notify{
position:fixed;
top:80px;
right:20px;
background:#2563eb;
color:white;
padding:8px 12px;
border-radius:50px;
cursor:pointer;
font-size: 18px;
z-index: 1000;
}
#notifyBox{
display:none;
position:absolute;   /* FIXED */
top:70px;
right:20px;
width:280px;
background:white;
border-radius:10px;
box-shadow:0 6px 20px rgba(0,0,0,0.2);
padding:10px;
z-index:999;
max-height:300px;
overflow-y:auto;
}

/* item */
.notif-item{
padding:8px;
border-bottom:1px solid #eee;
font-size:13px;
}

.notif-item:last-child{
border-bottom:none;
}

/* ================= MOBILE ================= */
@media(max-width:768px){

.container{
padding:90px 15px 20px;
}

h2{
font-size:22px;
}

/* FORM FULL WIDTH */
input,select,button{
width:100%;
}

/* MODAL */
#chatModal{
width:90%;
}

}

/* SMALL */
@media(max-width:400px){

h2{
font-size:20px;
}

}

</style>

</head>

<body>

<jsp:include page="adminNavbar.jsp" />

<!-- NOTIFICATION -->
<div class="notify" onclick="toggleNotify()">
<i class="fa-solid fa-bell"></i>

<% if(notifCount>0){ %>
<span class="badge"><%=notifCount%></span>
<% } %>
</div>
<!-- ? NOTIFICATION BOX -->
<div id="notifyBox">

<h4>Notifications</h4>

<%
PreparedStatement qps = con.prepareStatement(
"SELECT * FROM faculty_queries ORDER BY id DESC LIMIT 5");

ResultSet qrs = qps.executeQuery();

boolean hasData=false;

while(qrs.next()){
hasData=true;
%>
<div class="notif-item">

<b><%= (qrs.getString("username") != null ? qrs.getString("username") : "User") %></b><br>

<%= (qrs.getString("message") != null ? qrs.getString("message") : "") %>

</div>

<%
}

if(!hasData){
%>

<div class="notif-item">No new notifications</div>

<%
}
%>

</div>
<div class="container">

<h2>Manage Faculty</h2>

<!-- FORM -->
<div class="form-box">
<form method="post">

<input type="text" name="username" placeholder="Username" required>
<input type="text" name="password" placeholder="Password" required>
<input type="text" name="name" placeholder="Faculty Name" required>

<select name="branch" required>
<option value="">Select Branch</option>
<option>CSE</option>
<option>IT</option>
<option>CE</option>
<option>ME</option>
<option>EE</option>
<option>EC</option>
</select>

<button type="submit">Add Faculty</button>

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
<th>Action</th>
</tr>

<%
PreparedStatement ps = con.prepareStatement(
"SELECT * FROM faculty ORDER BY name ASC");

ResultSet rs = ps.executeQuery();

while(rs.next()){
%>

<tr>

<td><%=rs.getInt("id")%></td>
<td><%=rs.getString("username")%></td>
<td><%=rs.getString("name")%></td>
<td><%=rs.getString("branch")%></td>

<td>

<button class="msg-btn"
onclick="openChat('<%=rs.getString("username")%>')">
Chat
</button>

<button class="delete-btn"
onclick="confirmDelete(<%=rs.getInt("id")%>,'<%=rs.getString("username")%>')">
Delete
</button>

</td>

</tr>

<%
}
%>

</table>
</div>

</div>

<!-- MODAL -->
<div id="overlay"></div>

<div id="chatModal">

<button class="close-btn" onclick="closeChat()">×</button>

<h3>Send Message</h3>

<form method="post">
<input type="hidden" name="user" id="chatUser">
<textarea name="text" required></textarea>
<input type="hidden" name="sendMsg" value="1">
<button type="submit">Send</button>
</form>

</div>

<script>
function toggleNotify(){
let box = document.getElementById("notifyBox");

if(box.style.display=="block"){
box.style.display="none";
}else{
box.style.display="block";
}
}

/* CLICK OUTSIDE CLOSE */
document.addEventListener("click", function(e){
let box = document.getElementById("notifyBox");
let bell = document.querySelector(".notify");

if(!box.contains(e.target) && !bell.contains(e.target)){
box.style.display="none";
}
});

function confirmDelete(id,user){
Swal.fire({
title:'Delete Faculty?',
icon:'warning',
showCancelButton:true,
confirmButtonColor:'#d33'
}).then((result)=>{
if(result.isConfirmed){
window.location="AdminFaculty.jsp?delete="+id+"&user="+user;
}
});
}

function viewQueries(){
window.location="AdminQueries.jsp";
}

</script>

</body>
</html>