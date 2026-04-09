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


<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Student Time Table</title>

<link rel="stylesheet" href="navbar.css">

<style>

*{box-sizing:border-box;}

body{
background:#0f172a;
font-family:Segoe UI;
color:white;
margin:0;
}

/* ? CONTAINER */
.container{
width:95%;
max-width:1100px;
margin:20px auto;
padding:15px;
text-align:center;
}

h1{
margin-bottom:20px;                           
}

/* ? TABLE DESKTOP */
table{
width:100%;
border-collapse:collapse;
background:#1e293b;
border-radius:10px;
overflow:hidden;
}

th,td{
padding:12px;
border-bottom:1px solid #333;
text-align:center;
}

th{
color:#60a5fa;
}

tr:hover{
background:#273449;
}

/* ? NO DATA */
.no-data{
text-align:center;
margin-top:40px;
background:#1e293b;
padding:30px;
border-radius:10px;
}

/* ? MOBILE CARD VIEW */
@media(max-width:768px){

table, thead, tbody, th, td, tr{
display:block;
width:100%;
}

thead{
display:none;
}

tr{
background:#1e293b;
margin-bottom:15px;
border-radius:12px;
padding:12px;
box-shadow:0 4px 10px rgba(0,0,0,0.5);
}

td{
text-align:left;
padding:8px;
border:none;
position:relative;
padding-left:50%;
}
/* ? MOBILE CARD UI */
.tt-card{
background:#1e293b;
padding:15px;
margin-bottom:15px;
border-radius:12px;
box-shadow:0 5px 15px rgba(0,0,0,0.4);
text-align:left;
transition:0.3s;
}

.tt-card:hover{
transform:scale(1.02);
background:#273449;
}

.tt-card div{
margin-bottom:8px;
font-size:14px;
}

.tt-card b{
color:#60a5fa;
}

/* LABELS */
td:before{
position:absolute;
left:10px;
top:8px;
font-weight:bold;
color:#60a5fa;
}

td:nth-child(1):before{content:"Day";}
td:nth-child(2):before{content:"Subject";}
td:nth-child(3):before{content:"Faculty";}
td:nth-child(4):before{content:"Room";}
td:nth-child(5):before{content:"Time";}

}

</style>

</head>

<body>

<%@include file="navbar.jsp"%>
<div class="container">

    <h1>My Time Table (Branch : <%=branch%>)</h1>

<%

boolean hasData = false;

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root",
"root"
);

PreparedStatement ps=con.prepareStatement(
"SELECT * FROM timetable WHERE branch=? ORDER BY day"
);

ps.setString(1,branch);

ResultSet rs=ps.executeQuery();

%>

<table>

<thead>
<tr>
<th>Day</th>
<th>Subject</th>
<th>Faculty</th>
<th>Room</th>
<th>Time</th>
</tr>
</thead>

<tbody>

<%

while(rs.next()){
hasData = true;
%>
<div class="tt-card">

<div><b>Day:</b> <%=rs.getString("day")%></div>

<div><b>Subject:</b> <%=rs.getString("subject")%></div>

<div><b>Faculty:</b> <%=rs.getString("faculty")%></div>

<div><b>Room:</b> <%=rs.getString("room")%></div>

<div><b>Time:</b> 
<%=rs.getString("start_time")%> - <%=rs.getString("end_time")%>
</div>

</div>
<%
}
%>

</tbody>

</table>

<%

if(!hasData){
%>

<div class="no-data">
<h3>No Data Available ?</h3>
<p>No timetable has been uploaded yet for your branch.</p>
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