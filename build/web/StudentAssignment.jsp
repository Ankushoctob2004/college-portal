<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%

HttpSession s=request.getSession(false);

if(s==null || !"STUDENT".equals(s.getAttribute("role"))){
response.sendRedirect("login.jsp");
return;
}

String branch=(String)s.getAttribute("branch");
%>

<!DOCTYPE html>
<html>
<head>
    
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Student Assignments</title>

<link rel="stylesheet" href="navbar.css">

<style>
*{box-sizing:border-box;}

body{
background:#0f172a;
color:white;
font-family:Arial;
margin:0;
}

/* ? CONTAINER FIX */
.container{
width:95%;
max-width:900px;
margin:20px auto;
padding:10px;
}

/* ? ASSIGNMENT CARD */
.assignment-box{
background:#1e293b;
padding:18px;
margin-bottom:15px;
border-left:6px solid #3b82f6;
border-radius:10px;
box-shadow:0 4px 10px rgba(0,0,0,0.5);
transition:0.2s;
}

.assignment-box:hover{
transform:scale(1.02);
}

.assignment-box h4{
margin-bottom:6px;
color:#60a5fa;
font-size:16px;
}

.assignment-box p{
color:#cbd5f5;
font-size:14px;
word-break:break-word;
}

/* ? BUTTON GROUP */
.btn-group{
margin-top:10px;
display:flex;
gap:10px;
flex-wrap:wrap;
}

button{
background:#3b82f6;
color:white;
border:none;
padding:8px 14px;
border-radius:6px;
cursor:pointer;
font-size:13px;
}

button:hover{
background:#2563eb;
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
}

/* ? MOBILE */
@media(max-width:768px){

.assignment-box{
padding:15px;
}

.assignment-box h4{
font-size:14px;
}

.assignment-box p{
font-size:13px;
}

button{
width:100%;
}

.btn-group{
flex-direction:column;
}

}

/* ? SMALL MOBILE */
@media(max-width:480px){

.container{
width:95%;
padding:5px;
}

}
</style>

</head>

<body>

<%@include file="navbar.jsp"%>

<div class="container" style="width:100%;overflow-x:auto;">

<h2>Assignments (Branch : <%=branch%>)</h2>

<%

boolean hasData = false;

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

while(rs.next()){
    hasData = true;
%>

<div class="assignment-box">

<h4><%=rs.getString("subject")%></h4>

<p><%=rs.getString("file_name")%></p>

<a href="FileServlet?name=<%=rs.getString("file_path")%>" target="_blank">
<button>View</button>
</a>

<a href="FileServlet?name=<%=rs.getString("file_path")%>" download>
<button>Download</button>
</a>

</div>

<%
}

if(!hasData){
%>

<div class="no-data">
<h3>No Data Available ?</h3>
<p>No content has been uploaded yet for your branch</p>
</div>

<%
}

rs.close();
ps.close();
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