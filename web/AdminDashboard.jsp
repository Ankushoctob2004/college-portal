<%@ page session="true" %>

<%
if(session.getAttribute("admin")==null){
response.sendRedirect("AdminLogin.jsp");
return;
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Admin Dashboard</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<!-- ? ONLY THIS CSS -->
<link rel="stylesheet" href="admin.css">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>

/* ? NAVBAR CSS HATA DIYA (IMPORTANT) */

/* BODY */
body{
margin:0;
font-family:'Segoe UI',Arial;
background:#f1f5f9;
}

/* CONTENT */
.container{
padding-top:120px;
width:100%;
margin:0;
text-align:center;
padding:120px 20px 20px;
}

/* TITLE */
.container h2{
font-size:36px;
margin-bottom:40px;
color:#0f172a;
}

/* CARDS */
.cards{
display:grid;
grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
gap:25px;
}

/* CARD */
.card{
background:white;
padding:25px;
border-radius:12px;
text-align:center;
box-shadow:0 5px 15px rgba(0,0,0,0.1);
transition:0.3s;
cursor:pointer;
}

.card:hover{
transform:translateY(-8px);
box-shadow:0 10px 25px rgba(0,0,0,0.2);
}

.cards a{
text-decoration:none;
color:inherit;
}

/* ================= MOBILE ================= */
@media(max-width:768px){

.container{
padding:100px 15px 20px;
}

.container h2{
font-size:24px;
}

.cards{
grid-template-columns:1fr;
gap:15px;
}

.card{
padding:18px;
font-size:14px;
}

}

/* SMALL */
@media(max-width:400px){

.container h2{
font-size:20px;
}

}

</style>

</head>

<body>

<jsp:include page="adminNavbar.jsp" />

<div class="container">

<h2>Admin Dashboard</h2>

<div class="cards">

<a href="AdminStudents.jsp">
<div class="card">Manage Students</div>
</a>

<a href="AdminFaculty.jsp">
<div class="card">Manage Faculty</div>
</a>

<a href="AdminNotice.jsp">
<div class="card">View Notices</div>
</a>

</div>

</div> 

</body>
</html>