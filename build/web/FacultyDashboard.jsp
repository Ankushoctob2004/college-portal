<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s = request.getSession(false);

if (s == null || s.getAttribute("username") == null) {
    response.sendRedirect("AdminLogin.jsp");
    return;
}

String role = (String) s.getAttribute("role");
if (!"FACULTY".equalsIgnoreCase(role)) {
    response.sendRedirect("AdminLogin.jsp");
    return;
}

String username = (String)s.getAttribute("username");
String name = (String)s.getAttribute("name");

if(name == null){
    name = username;
}

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root",
"root"
);

/* AUTO DELETE */
PreparedStatement del = con.prepareStatement(
"DELETE FROM faculty_messages WHERE created_at < NOW() - INTERVAL 1 DAY");
del.executeUpdate();

/* COUNT */
PreparedStatement countPs = con.prepareStatement(
"SELECT COUNT(*) FROM faculty_messages WHERE username=? AND status='unread'");
countPs.setString(1,username);
ResultSet crs = countPs.executeQuery();

int msgCount = 0;
if(crs.next()){
msgCount = crs.getInt(1);
}

/* SEND QUERY */
if(request.getParameter("query") != null){
PreparedStatement qps = con.prepareStatement(
"INSERT INTO faculty_queries(faculty_username,message) VALUES(?,?)");

qps.setString(1,username);
qps.setString(2,request.getParameter("query"));
qps.executeUpdate();
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Faculty Dashboard</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="faculty.css">
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>

/* RESET */
*{box-sizing:border-box;}
body{
background:#dfe3e8;
font-family:Segoe UI;
margin:0;
padding-top:80px;
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


/* MENU ICON */
.menu-icon{
display:none;
font-size:24px;
cursor:pointer;
}

/* NAV LINKS */
.nav-links{
display:flex;
align-items:center;
gap:15px;
}



.nav-links a:hover{
background:#334155;
}
 

/* MOBILE */
@media(max-width:768px){

.menu-icon{
display:block;
}

.nav-links{
display:none;
flex-direction:column;
width:100%;
background:#1e293b;
position:absolute;
top:60px;
left:0;
}

.nav-links.active{
display:flex;
}

.nav-links a{
width:100%;
padding:12px;
border-top:1px solid #334155;
}

.nav-links div{
width:100%;
padding:12px;
border-top:1px solid #334155;
}

body{
padding-top:100px;
}

}

/* MESSAGE ICON */
.bell{position:relative;cursor:pointer;}
.count{
position:absolute;
top:-5px;
right:-10px;
background:red;
color:white;
border-radius:50%;
padding:3px 7px;
font-size:12px;
}

/* MESSAGE BOX */
#msgBox{
display:none;
position:fixed;
right:10px;
top:70px;
width:300px;
background:white;
border-radius:10px;
box-shadow:0 5px 15px rgba(0,0,0,0.3);
padding:10px;
max-height:400px;
overflow-y:auto;
z-index:999;
}

.msg{padding:8px;border-bottom:1px solid #ddd;}

/* FLOAT BUTTON */
.query-btn{
position:fixed;
bottom:20px;
right:20px;
background:#6366f1;
color:white;
border:none;
border-radius:50%;
width:60px;
height:60px;
font-size:22px;
cursor:pointer;
display:flex;
align-items:center;
justify-content:center;
}

/* MODAL */
#overlay{
display:none;
position:fixed;
top:0;left:0;width:100%;height:100%;
background:rgba(0,0,0,0.5);
z-index:998;
}

#queryModal{
display:none;
position:fixed;
top:50%;
left:50%;
transform:translate(-50%,-50%);
background:white;
padding:25px;
border-radius:12px;
width:600px;
z-index:999;
}

#queryModal textarea{
width:100%;
height:100px;
padding:10px;
margin-top:10px;
}

#queryModal button{
margin-top:10px;
padding:10px;
width:100%;
}

/* CARDS */
.welcome{text-align:center;margin:30px 0;}

.cards{
display:grid;
grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
gap:20px;
width:90%;
margin:auto;
}
.cards a{text-decoration: none;}
.card{
background:white;
padding:25px;
border-radius:12px;
text-align:center;
font-weight:bold;
box-shadow:0 5px 15px rgba(0,0,0,0.2);
transition:0.3s;
}

.card:hover{
transform:translateY(-5px);
box-shadow:0 10px 25px rgba(0,0,0,0.3);
}

</style>

</head>

<body>

<!-- NAVBAR -->
<div class="navbar">
<h2 class="logo">Campus<span>Hub</span></h2>

<div class="menu-icon" onclick="toggleMenu()">
<i class="fa fa-bars"></i>
</div>

<div class="nav-links" id="navLinks">

<a href="FacultyDashboard.jsp">Dashboard</a>
<a href="LogoutServlet">Logout</a>

<div style="position:relative;cursor:pointer;" onclick="toggleBox()">
? <span id="count" style="background:red;color:white;padding:2px 6px;border-radius:50%;font-size:12px;">0</span>

<div id="noticeBox" style="
display:none;
position:absolute;
right:0;
top:30px;
width:300px;
background:white;
border:1px solid #ccc;
max-height:300px;
overflow:auto;
z-index:1000;
">
</div>
</div>

<div class="bell" onclick="toggleMsgBox()">
<i class="fa-solid fa-inbox"></i>

<% if(msgCount > 0){ %>
<span class="count"><%=msgCount%></span>
<% } %>

</div>

</div>
</div>

<!-- MESSAGE BOX -->
<div id="msgBox">
<h3>Messages</h3>

<%
PreparedStatement mps = con.prepareStatement(
"SELECT * FROM faculty_messages WHERE username=? ORDER BY id DESC");

mps.setString(1,username);
ResultSet mrs = mps.executeQuery();

while(mrs.next()){
%>

<div class="msg">
<%=mrs.getString("message")%>
</div>

<%
}

PreparedStatement upd = con.prepareStatement(
"UPDATE faculty_messages SET status='read' WHERE username=?");

upd.setString(1,username);
upd.executeUpdate();
%>

</div>

<!-- MODAL -->
<div id="overlay"></div>

<div id="queryModal">
<h2>Contact Admin</h2>

<form method="post">
<textarea name="query" placeholder="Ask Admin..." required></textarea>
<button type="submit">Send Message</button>
</form>
</div>

<!-- FLOAT -->
<button class="query-btn" onclick="openModal()">
<i class="fa-solid fa-headset"></i>
</button>

<!-- WELCOME -->
<div class="welcome">
<h1>Welcome, <%= name %></h1>
<p>Manage your classes and student progress efficiently.</p>
</div>

<!-- CARDS -->
<div class="cards">

<a href="FacultyAttendance.jsp"><div class="card">Attendance</div></a>
<a href="FacultyAssignment.jsp"><div class="card">Assignments</div></a>
<a href="FacultyTimeTable.jsp"><div class="card">Time Table</div></a>
<a href="FacultyNotice.jsp"><div class="card">Notices</div></a>
<a href="FacultyMST.jsp"><div class="card">MST Marks</div></a>
<a href="FacultySyllabus.jsp"><div class="card">Syllabus</div></a>
<a href="FacultyResult.jsp"><div class="card">Exam Grades</div></a>
<a href="facultyEvents.jsp"><div class="card">Events</div></a>

</div>

<script>

function toggleMenu(){
let nav = document.getElementById("navLinks");
nav.classList.toggle("active");
}

function toggleMsgBox(){
let box = document.getElementById("msgBox");
box.style.display = box.style.display === "block" ? "none" : "block";
}

function openModal(){
document.getElementById("overlay").style.display="block";
document.getElementById("queryModal").style.display="block";
}

function loadNotices(){
fetch("getNotices.jsp")
.then(res=>res.json())
.then(data=>{
let box=document.getElementById("noticeBox");
let count=0;
box.innerHTML="";
data.forEach(n=>{
let div=document.createElement("div");
div.style.borderBottom="1px solid #ddd";
div.style.padding="10px";
if(n.seen==0){
div.style.background="#eaffea";
count++;
}
div.innerHTML=`
<b>${n.title}</b><br>
${n.message}<br>
<small>${n.date}</small>
`;
div.onclick=function(){
markSeen(n.id);
div.style.background="white";
};
box.appendChild(div);
});
document.getElementById("count").innerText=count;
});
}

function toggleBox(){
let box=document.getElementById("noticeBox");
box.style.display = box.style.display=="block" ? "none" : "block";
}

function markSeen(id){
fetch("markSeen.jsp?id="+id)
.then(()=>loadNotices());
}

setInterval(loadNotices,5000);

window.onload=function(){
loadNotices();
};
</script>

</body>
</html>