<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s = request.getSession(false);

if(s == null || s.getAttribute("admin")==null){
    response.sendRedirect("AdminLogin.jsp");
    return;
}

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root",
"root"
);

/* ADD NOTICE */
if(request.getMethod().equalsIgnoreCase("POST") && request.getParameter("title")!=null){

String title=request.getParameter("title");
String msg=request.getParameter("message");
String branch=request.getParameter("branch");

PreparedStatement ps = con.prepareStatement(
"INSERT INTO notices(title,message,branch,type,seen) VALUES(?,?,?,?,?)");

ps.setString(1,title);
ps.setString(2,msg);
ps.setString(3,branch);
ps.setString(4,"ADMIN");
ps.setInt(5,0);

ps.executeUpdate();
ps.close();

response.sendRedirect("AdminNotice.jsp?msg=added");
return;
}

/* DELETE */
if(request.getParameter("delete")!=null){

PreparedStatement ps = con.prepareStatement(
"DELETE FROM notices WHERE id=?");

ps.setInt(1,Integer.parseInt(request.getParameter("delete")));

ps.executeUpdate();
ps.close();

response.sendRedirect("AdminNotice.jsp?msg=deleted");
return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Notice Panel</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<link rel="stylesheet" href="admin.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>

/* GLOBAL */
body{
margin:0;
font-family:'Segoe UI', Arial, sans-serif;
background:#f1f5f9;
}

/* CONTAINER */
.container{
width:100%;
padding:100px 15px 20px;
}

/* TITLE */
h2{
text-align:center;
font-size:28px;
margin-bottom:20px;
}

/* FORM */
.notice-form{
background:white;
padding:20px;
border-radius:10px;
box-shadow:0 4px 10px rgba(0,0,0,0.1);
margin-bottom:20px;
}

/* INPUT */
.notice-form input,
.notice-form textarea,
.notice-form select{
width:100%;
padding:10px;
margin:8px 0;
border-radius:6px;
border:1px solid #ccc;
font-family:'Segoe UI', Arial;
}

/* BUTTON */
button{
padding:10px;
background:#2563eb;
color:white;
border:none;
border-radius:6px;
cursor:pointer;
width:15%;
}

/* NOTICE CARD */
.notice-item{
background:white;
padding:15px;
margin-top:15px;
border-radius:10px;
box-shadow:0 4px 10px rgba(0,0,0,0.08);
position:relative;
}

/* TITLE */
.notice-item h3{
margin:0 0 5px;
}

/* MESSAGE */
.notice-item p{
margin:5px 0 10px;
color:#334155;
}

/* DATE */
.notice-item small{
color:#64748b;
}

/* DELETE */
.delete-btn{
position:absolute;
right:15px;
top:15px;
background:red;
border:none;
color:white;
padding:5px 10px;
border-radius:5px;
cursor:pointer;
}

/* MOBILE */
@media(max-width:768px){

h2{
font-size:22px;
}
button{
    width: 26%;
}
.notice-form{
padding:15px;
}

}

</style>

</head>

<body>

<jsp:include page="adminNavbar.jsp" />

<!-- POPUP -->
<%
String msg = request.getParameter("msg");

if("added".equals(msg)){
%>
<script>
Swal.fire({
icon:'success',
title:'Success',
text:'Notice posted successfully'
});
</script>
<%
}

if("deleted".equals(msg)){
%>
<script>
Swal.fire({
icon:'success',
title:'Deleted',
text:'Notice deleted successfully'
});
</script>
<%
}
%>

<div class="container">

<h2>Admin Notice Panel</h2>

<!-- FORM -->
<form class="notice-form" method="post">

<input type="text" name="title" placeholder="Notice Title" required>

<textarea name="message" placeholder="Notice Message" required></textarea>

<select name="branch" required>
<option value="">Select Branch</option>
<option value="CSE">CSE</option>
<option value="IT">IT</option>
<option value="ME">ME</option>
<option value="CE">CE</option>
</select>

<button type="submit">Post Notice</button>

</form>

<!-- LIST -->
<%
PreparedStatement ps = con.prepareStatement(
"SELECT * FROM notices ORDER BY id DESC");

ResultSet rs = ps.executeQuery();

while(rs.next()){
%>

<div class="notice-item">

<h3><%=rs.getString("title")%></h3>

<p><%=rs.getString("message")%></p>

<small>
<%= new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm")
.format(rs.getTimestamp("date")) %>
</small>

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

</body>
</html>