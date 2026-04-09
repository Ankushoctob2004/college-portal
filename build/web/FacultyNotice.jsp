<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s = request.getSession(false);

if (s == null || !"FACULTY".equals(s.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}

String branch = (String)s.getAttribute("branch");

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root",
"root"
);

/* ================= ADD NOTICE ================= */

if(request.getMethod().equalsIgnoreCase("POST") && request.getParameter("title")!=null){

PreparedStatement ps = con.prepareStatement(
"INSERT INTO notices(title,message,branch,type,seen) VALUES(?,?,?,?,?)");

ps.setString(1,request.getParameter("title"));
ps.setString(2,request.getParameter("message"));
ps.setString(3,branch);
ps.setString(4,"FACULTY"); // ? ADD
ps.setInt(5,1); // ? ADD

ps.executeUpdate();

response.sendRedirect("FacultyNotice.jsp?msg=added");
return;
}

/* ================= DELETE ================= */

if(request.getParameter("delete")!=null){

PreparedStatement ps = con.prepareStatement(
"DELETE FROM notices WHERE id=?");

ps.setInt(1,Integer.parseInt(request.getParameter("delete")));

ps.executeUpdate();

response.sendRedirect("FacultyNotice.jsp?msg=deleted");
return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Faculty Notice Board</title>

<link rel="stylesheet" href="faculty.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
body{background:#dfe3e8;font-family:Segoe UI;}

.container {
    width:80%;
    margin:40px auto;
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

.notice-form {
    background:#2c3e50;
    padding:20px;
    border-radius:10px;
    color:white;
}

.notice-form input, textarea {
    width:100%;
    padding:10px;
    margin:10px 0;
    border-radius:6px;
    border:none;
}

button {
    padding:10px 20px;
    background:#4CAF50;
    border:none;
    color:white;
    border-radius:6px;
    cursor:pointer;
}

.notice-item {
    background:#2c3e50;
    padding:15px;
    margin-top:15px;
    border-radius:8px;
    position:relative;
    color:white;
}

.delete-btn {
    position:absolute;
    right:15px;
    top:15px;
    background:red;
    border:none;
    color:white;
    padding:5px 10px;
    border-radius:5px;
}
/* ? NAVBAR RESPONSIVE */


.nav-links{
display:flex;
gap:12px;
flex-wrap:wrap;
align-items:center;
}



.nav-links a:hover{
background:#334155;
}

/* ? MOBILE */
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

/* NOTICE BOX FULL WIDTH */
#noticeBox{
width:95% !important;
right:2.5% !important;
}

.container{
width:95% !important;
}

}

/* ? FORM FIX */
.notice-form input,
.notice-form textarea{
font-size:14px;
}

/* ? NOTICE CARD */
.notice-item{
transition:0.3s;
}

.notice-item:hover{
transform:translateY(-3px);
}

/* ? SMALL SCREEN */
@media(max-width:400px){

.notice-form{
padding:15px;
}

button{
width:100%;
}

}
</style>
</head>

<body>

<div class="navbar">
<h2 class="logo">Campus<span>Hub</span></h2>
  <div class="nav-links">

  <!-- ? BELL ADDED -->
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
  "></div>

  </div>

     <a href="FacultyDashboard.jsp">Dashboard</a>
     <a href="LogoutServlet">Logout</a>
  </div>
</div>

<!-- POPUPS -->
<%
String msg = request.getParameter("msg");

if("added".equals(msg)){
%>
<script>
Swal.fire({icon:'success',title:'Success',text:'Notice posted successfully'});
</script>
<%
}

if("deleted".equals(msg)){
%>
<script>
Swal.fire({icon:'success',title:'Deleted',text:'Notice deleted successfully'});
</script>
<%
}
%>

<div class="container">

<h1>Faculty Notice Board (Branch : <%=branch%>)</h1>

<form class="notice-form" method="post">

<input type="text" name="title" placeholder="Notice Title" required>
<textarea name="message" placeholder="Notice Message" required></textarea>

<button type="submit">Post Notice</button>

</form>

<div id="noticeList">

<%
PreparedStatement ps = con.prepareStatement(
"SELECT * FROM notices WHERE branch=? AND (type IS NULL OR type='FACULTY') ORDER BY id DESC");

ps.setString(1,branch);

ResultSet rs = ps.executeQuery();

while(rs.next()){
%>

<div class="notice-item">

<h3><%=rs.getString("title")%></h3>
<p><%=rs.getString("message")%></p>
<small><%=rs.getString("date")%></small>

<form method="post">
<button class="delete-btn" name="delete" value="<%=rs.getInt("id")%>">Delete</button>
</form>

</div>

<%
}

rs.close();
ps.close();
con.close();
%>

</div>

</div>

<!-- ? JS FOR ADMIN NOTICE -->
<script>

/* ? TOGGLE BOX */
function toggleBox(){
let box=document.getElementById("noticeBox");

if(box.style.display==="block"){
    box.style.display="none";
}else{
    box.style.display="block";
    loadNotices();
}
}

/* ? LOAD NOTICES */
function loadNotices(){

fetch("getNotice.jsp")
.then(res=>res.json())
.then(data=>{

let box=document.getElementById("noticeBox");
let count=0;

box.innerHTML="";

if(data.length==0){
    box.innerHTML="<p style='padding:10px'>No Notices</p>";
    return;
}

data.forEach(n=>{

if(n.type==="ADMIN"){

if(n.seen==0) count++;

box.innerHTML+=`
<div style="padding:10px;border-bottom:1px solid #ccc">
<b>${n.title}</b><br>
${n.message}
</div>
`;

}

});

document.getElementById("count").innerText=count;

});
}

/* AUTO REFRESH */
setInterval(loadNotices,5000);

/* INIT */
window.onload=loadNotices;

</script></script>

</body>
</html>