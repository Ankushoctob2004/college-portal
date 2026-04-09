<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s = request.getSession(false);

if (s == null || !"STUDENT".equalsIgnoreCase((String)s.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}

String username = (String)s.getAttribute("username");

String semester = request.getParameter("semester");
if(semester == null) semester = "Semester 1";

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root",
"root"
);

PreparedStatement ps = con.prepareStatement(
"SELECT subject,mst1,mst2,total FROM mst_marks WHERE username=? AND semester=?"
);

ps.setString(1,username);
ps.setString(2,semester);

ResultSet rs = ps.executeQuery();

/* CHECK DATA */
boolean hasData = rs.isBeforeFirst();

int totalMarks = 0;
int maxTotal = 0;
%>

<!DOCTYPE html>
<html>
<head>
      
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>My MST Marks</title>

<link rel="stylesheet" href="navbar.css">

<style>

*{box-sizing:border-box;}

body{
margin:0;
font-family:Arial;
background:#0f172a;
color:white;
}

/* CONTAINER */
.container{
width:95%;
max-width:900px;
margin:20px auto;
text-align:center;
padding:10px;
}

/* SELECT */
select{
padding:10px;
border-radius:6px;
background:#1e293b;
color:white;
border:none;
margin-top:10px;
}

/* TABLE SCROLL */
.table-container{
width:100%;
overflow-x:auto;
margin-top:20px;
}

/* TABLE */
table{
width:100%;
min-width:600px;
border-collapse:collapse;
background:#1e293b;
border-radius:10px;
overflow:hidden;
}

th,td{
padding:10px;
border-bottom:1px solid #333;
text-align:center;
}

th{
color:#60a5fa;
}

/* TOTAL */
.total-box{
margin-top:15px;
font-size:18px;
}

/* NO DATA */
.no-data{
text-align:center;
margin-top:40px;
background:#1e293b;
padding:30px;
border-radius:10px;
}

/* MOBILE */
@media(max-width:768px){

th,td{
font-size:12px;
padding:8px;
white-space:nowrap;
}

}
</style>

</head>

<body>
<%@include file="navbar.jsp"%>

<div class="container">

<h2>My MST Marks</h2>

<form method="get">

<select name="semester" onchange="this.form.submit()">

<option <%=semester.equals("Semester 1")?"selected":""%>>Semester 1</option>
<option <%=semester.equals("Semester 2")?"selected":""%>>Semester 2</option>
<option <%=semester.equals("Semester 3")?"selected":""%>>Semester 3</option>
<option <%=semester.equals("Semester 4")?"selected":""%>>Semester 4</option>
<option <%=semester.equals("Semester 5")?"selected":""%>>Semester 5</option>
<option <%=semester.equals("Semester 6")?"selected":""%>>Semester 6</option>
<option <%=semester.equals("Semester 7")?"selected":""%>>Semester 7</option>
<option <%=semester.equals("Semester 8")?"selected":""%>>Semester 8</option>

</select>

</form>

<% if(hasData){ %>

<div class="table-container">

<table>

<tr>
<th>Subject</th>
<th>MST1</th>
<th>MST2</th>
<th>Total</th>
</tr>

<%

while(rs.next()){

Integer mst1 = (Integer)rs.getObject("mst1");
Integer mst2 = (Integer)rs.getObject("mst2");

int total = rs.getInt("total");

/* CALC */
totalMarks += total;
maxTotal += 40;
%>

<tr>

<td><%=rs.getString("subject")%></td>

<td><%= (mst1==null ? "-" : mst1) %></td>

<td><%= (mst2==null ? "-" : mst2) %></td>

<td><%= total %></td>

</tr>

<%
}
%>

</table>

</div>

<div class="total-box">
Total : <%=totalMarks%> / <%=maxTotal%>
</div>

<% } else { %>

<div class="no-data">
<h3>No Data Available ?</h3>
<p>Your MST marks have not been uploaded yet.</p>
</div>

<% } %>

<%
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