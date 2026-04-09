<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s = request.getSession(false);

if (s == null || !"FACULTY".equals(s.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root",
"root"
);

/* ===== ADD EVENT ===== */
if(request.getParameter("title") != null){

PreparedStatement ps = con.prepareStatement(
"INSERT INTO events(title,event_date,image,description) VALUES(?,?,?,?)");

ps.setString(1,request.getParameter("title"));
ps.setString(2,request.getParameter("date"));
ps.setString(3,request.getParameter("image"));
ps.setString(4,request.getParameter("desc"));

ps.executeUpdate();

response.sendRedirect("facultyEvents.jsp?msg=added");
return;
}

/* ===== DELETE EVENT ===== */
if(request.getParameter("delete") != null){

PreparedStatement ps = con.prepareStatement(
"DELETE FROM events WHERE id=?");

ps.setInt(1,Integer.parseInt(request.getParameter("delete")));
ps.executeUpdate();

response.sendRedirect("facultyEvents.jsp?msg=deleted");
return;
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Faculty Events</title>
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<link rel="stylesheet" href="faculty.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>

body{
background:#eef2f7;
font-family:Arial;
}

/* FORM */
.form-container{ 
width:610px;
margin:50px auto;
background:#fff;
padding:25px;
border-radius:12px;
box-shadow:0 5px 15px rgba(0,0,0,0.2);
}

.form-container h2{
text-align:center;
margin-bottom:15px;

}

input, textarea{
width:97%;
padding:10px;
margin:10px 0;
border-radius:6px;
border:1px solid #ccc;
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

button{
padding:10px;
background:#2c3e50;
color:white;
border:none;
border-radius:6px;
cursor:pointer;
width:100%;
}

/* GRID */
.event-grid{
display:grid;
grid-template-columns:repeat(auto-fit,minmax(500px,1fr));
gap:25px;
padding:70px;
}

/* CARD */
.event-card{
background:#fff;
border-radius:12px;
overflow:hidden;
box-shadow:0 8px 20px rgba(0,0,0,0.2);
transition:0.3s;
}

.event-card:hover{
transform:translateY(-5px);
}

/* IMAGE */
.event-card img{
width:100%;
height:180px;
object-fit:cover;
}

/* CONTENT */
.event-content{
padding:15px;
}

.event-content h3{
margin-bottom:5px;
}

.event-content p{
font-size:14px;
color:#555;
}

/* DELETE BUTTON BELOW */
.delete-btn{
margin-top:10px;
background:#e74c3c;
width:100%;
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

<!-- ? SWEET ALERT FIX -->
<script>
const url = new URL(window.location);
const msg = url.searchParams.get("msg");

if(msg === "added"){
    Swal.fire({
        icon:'success',
        title:'Event Created',
        text:'Event posted successfully'
    });
}
if(msg === "deleted"){
    Swal.fire({
        icon:'success',
        title:'Deleted',
        text:'Event deleted successfully'
    });
}

/* ? REMOVE msg AFTER SHOW */
if(msg){
    url.searchParams.delete("msg");
    window.history.replaceState({}, document.title, url.pathname);
}
</script>

<!-- FORM -->
<div class="form-container">

<h2>Create Event</h2>

<form method="post">

<input type="text" name="title" placeholder="Event Title" required>

<input type="date" name="date" required>

<input type="text" name="image" placeholder="Image URL">

<textarea name="desc" placeholder="Description" required></textarea>

<button type="submit">Post Event</button>

</form>

</div>

<!-- EVENTS -->
<div class="event-grid">

<%
PreparedStatement ps = con.prepareStatement(
"SELECT * FROM events ORDER BY id DESC");

ResultSet rs = ps.executeQuery();

while(rs.next()){
%>

<div class="event-card">

<img src="<%=rs.getString("image")%>" onerror="this.src='default.jpg'">

<div class="event-content">

<h3><%=rs.getString("title")%></h3>
<p><b>Date:</b> <%=rs.getString("event_date")%></p>
<p><%=rs.getString("description")%></p>

<form method="post">
<button class="delete-btn" name="delete" value="<%=rs.getInt("id")%>">Delete Event</button>
</form>

</div>

</div>

<%
}

rs.close();
ps.close();
con.close();
%>

</div>

</body>
</html>