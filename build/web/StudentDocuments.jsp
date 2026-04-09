<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s = request.getSession(false);

if(s == null || !"STUDENT".equals(s.getAttribute("role"))){
    response.sendRedirect("login.jsp");
    return;
}

String username = (String)s.getAttribute("name");
%>

<!DOCTYPE html>
<html>
<head>
  
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">


<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Student Documents</title>
<link rel="stylesheet" href="navbar.css">

<style>
*{box-sizing:border-box;}

body{
background:#0f172a;
color:white;
font-family:Arial;
margin:0;
}

/* ? CONTAINER */
.container{
width:95%;
max-width:900px;
margin:20px auto;
padding:10px;
}

/* ? UPLOAD BOX */
.upload-box{
background:#1e293b;
padding:20px;
border-radius:10px;
margin-bottom:25px;
text-align:center;
}

/* INPUT */
input{
padding:10px;
width:70%;
max-width:300px;
border-radius:6px;
border:none;
margin-bottom:10px;
}

/* BUTTON */
button{
padding:8px 14px;
background:#3b82f6;
color:white;
border:none;
border-radius:6px;
cursor:pointer;
font-size:13px;
}

button:hover{
background:#2563eb;
}

/* ? DOCUMENT ITEM */
.doc-item{
background:#1e293b;
padding:15px;
margin-top:12px;
border-radius:8px;
display:flex;
justify-content:space-between;
align-items:center;
gap:10px;
flex-wrap:wrap;
}

/* FILE NAME */
.doc-item div:first-child{
word-break:break-word;
font-size:14px;
}

/* BUTTON GROUP */
.btn-group{
display:flex;
gap:8px;
flex-wrap:wrap;
}

/* ? NO DATA */
.no-data{
text-align:center;
margin-top:40px;
background:#1e293b;
padding:30px;
border-radius:10px;
}

.no-data h3{
color:#94a3b8;
margin-bottom:8px;
}

.no-data p{
color:#cbd5f5;
font-size:14px;
}

/* ? MOBILE */
@media(max-width:768px){

input{
width:100%;
}

.doc-item{
flex-direction:column;
align-items:flex-start;
}

.btn-group{
width:100%;
flex-direction:column;
}

button{
width:100%;
}

}

/* ? SMALL MOBILE */
@media(max-width:480px){

.container{
padding:5px;
}

}
</style>

</head>

<body>

<!-- ? SWEET ALERT -->
<%
String msg = (String)session.getAttribute("msg");
if(msg != null){
%>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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

<%@include file="navbar.jsp"%>
<div class="container">

<h2>My Documents</h2>

<div class="upload-box">

<form action="UploadDocumentServlet" method="post" enctype="multipart/form-data">
<input type="file" name="file" required>
<button type="submit">Upload</button>
</form>

</div>

<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root",
"root"
);

PreparedStatement ps = con.prepareStatement(
"SELECT * FROM student_documents WHERE student_username=? ORDER BY id DESC"
);

ps.setString(1,username);

ResultSet rs = ps.executeQuery();

boolean found=false;

while(rs.next()){

found=true;
%>

<div class="doc-item">

<div><%=rs.getString("file_name")%></div>

<div>

<a href="FileServlet?name=...">
<button>View</button>
</a>
<a href="FileServlet?name=..." download>
<button>Download</button>
</a>

</div>

</div>

<%
}

if(!found){
%>

<div class="no-data">
<h3>No Documents Found ?</h3>
<p>Upload your documents to access them anytime.</p>
</div>

<%
}

con.close();
%>

</div>
<script>
function toggleMenu(){
let nav=document.getElementById("navLinks");
nav.classList.toggle("active");
}
</script>
</body>
</html>