<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%

HttpSession s = request.getSession(false);

if (s == null || !"FACULTY".equals(s.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}

String branch = (String)s.getAttribute("branch");
if(branch == null) branch = "";

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root",
"root"
);

/* SAVE MARKS */
if(request.getMethod().equals("POST")){

String semester = request.getParameter("semester");
String subject = request.getParameter("subject");

String[] enrollment = request.getParameterValues("enrollment");
String[] mst1 = request.getParameterValues("mst1");
String[] mst2 = request.getParameterValues("mst2");

if(enrollment != null){

for(int i=0;i<enrollment.length;i++){

Integer m1 = (mst1[i]==null || mst1[i].trim().equals("")) ? null : Integer.parseInt(mst1[i]);
Integer m2 = (mst2[i]==null || mst2[i].trim().equals("")) ? null : Integer.parseInt(mst2[i]);

int total = (m1==null?0:m1) + (m2==null?0:m2);

PreparedStatement check = con.prepareStatement(
"SELECT * FROM mst_marks WHERE username=? AND semester=? AND subject=?");

check.setString(1,enrollment[i]);
check.setString(2,semester);
check.setString(3,subject);

ResultSet crs = check.executeQuery();

if(crs.next()){

PreparedStatement ups = con.prepareStatement(
"UPDATE mst_marks SET mst1=?, mst2=?, total=? WHERE username=? AND semester=? AND subject=?");

if(m1==null) ups.setNull(1,Types.INTEGER); else ups.setInt(1,m1);
if(m2==null) ups.setNull(2,Types.INTEGER); else ups.setInt(2,m2);

ups.setInt(3,total);
ups.setString(4,enrollment[i]);
ups.setString(5,semester);
ups.setString(6,subject);

ups.executeUpdate();

}else{

PreparedStatement ins = con.prepareStatement(
"INSERT INTO mst_marks(username,semester,subject,mst1,mst2,total) VALUES(?,?,?,?,?,?)");

ins.setString(1,enrollment[i]);
ins.setString(2,semester);
ins.setString(3,subject);

if(m1==null) ins.setNull(4,Types.INTEGER); else ins.setInt(4,m1);
if(m2==null) ins.setNull(5,Types.INTEGER); else ins.setInt(5,m2);

ins.setInt(6,total);

ins.executeUpdate();
}
}
%>

<script>alert("Marks Saved Successfully ?");</script>

<%
}
}
%>

<!DOCTYPE html>
<html>
</head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Faculty MST</title>

<link rel="stylesheet" href="faculty.css">
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>

*{box-sizing:border-box;}

body{
background:#dfe3e8;
font-family:Segoe UI;
margin:0;
overflow-x:hidden;
padding-top: 120px;
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
.container{
background:#fff;
padding:30px;
margin-top:50px;
border-radius:12px;
max-width:1100px;
margin:auto;
}

.top{
display:flex;
gap:10px;
flex-wrap:wrap;
margin-bottom:20px;
align-items:center;
}

.top select,.top input{
padding:8px;
}

.table-container{
overflow-x:auto;
border-radius:10px;
}

/* TABLE */
table{
width:100%;
border-collapse:collapse;
min-width:800px;
}

th{
background:#334155;
color:#fff;
padding:12px;
}

td{
padding:10px;
text-align:center;
border-bottom:1px solid #e2e8f0;
}

input[type="number"]{
width:60px;
padding:5px;
text-align:center;
}

tr:hover{
background:#e2e8f0;
}

.save-btn{
margin-top:20px;
background:#334155;
color:#fff;
padding:10px 20px;
border:none;
border-radius:6px;
cursor:pointer;
}




</style>

<script>
function calcTotal(row){
let m1=row.querySelector(".mst1").value || 0;
let m2=row.querySelector(".mst2").value || 0;
row.querySelector(".total").innerText = Number(m1)+Number(m2);
}
</script>

</head>
<body>
<div class="navbar">
<h2 class="logo">Campus<span>Hub</span></h2>
<div class="nav-links">
<a href="FacultyDashboard.jsp">Dashboard</a>
<a href="LogoutServlet">Logout</a>
</div>
</div>

<div class="container">

<h2 align="center">Update MST Marks (Branch : <%=branch%>)</h2>

<form method="post">

<div class="top">

<label><b>Semester :</b></label>
<select name="semester" required>
<option>Semester 1</option>
<option>Semester 2</option>
<option>Semester 3</option>
<option>Semester 4</option>
<option>Semester 5</option>
<option>Semester 6</option>
<option>Semester 7</option>
<option>Semester 8</option>
</select>

<label><b>Subject :</b></label>
<input type="text" name="subject" required>

</div>

<div class="table-container">

<table>

<tr>
<th>Roll No</th>
<th>Name</th>
<th>MST1</th>
<th>MST2</th>
<th>Total</th>
</tr>

<%

PreparedStatement psStudents = con.prepareStatement(
"SELECT username,name FROM students WHERE branch=?");

psStudents.setString(1,branch);

ResultSet rs = psStudents.executeQuery();

while(rs.next()){

String roll = rs.getString("username");
String name = rs.getString("name");
%>

<tr oninput="calcTotal(this)">

<td>
<%=roll%>
<input type="hidden" name="enrollment" value="<%=roll%>">
</td>

<td><%=name%></td>

<td><input type="number" name="mst1" class="mst1" min="0" max="20"></td>
<td><input type="number" name="mst2" class="mst2" min="0" max="20"></td>

<td class="total">0</td>

</tr>

<%
}

rs.close();
psStudents.close();
con.close();
%>

</table>

</div>

<button class="save-btn" type="submit">Save Marks</button>

</form>

</div>

</body>
</html>