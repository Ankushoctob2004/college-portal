<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%

HttpSession s = request.getSession(false);

if (s == null || !"STUDENT".equalsIgnoreCase((String)s.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}

String studentUsername = (String)s.getAttribute("username");

%>

<!DOCTYPE html>
<html lang="en">
<head>
    
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Attendance</title>


<link rel="stylesheet" href="navbar.css">

<style>
:root{
--present:#2ecc71;
--absent:#e74c3c;
--leave:#f39c12;
}

*{box-sizing:border-box;}

body{
color:white;
font-family:'Segoe UI',sans-serif;
margin:0;
background:#151516;
}

/* CONTAINER */
.container{
width:95%;
max-width:900px;
margin:20px auto;
padding:20px;
border-radius:20px;
background:rgba(255,255,255,0.1);
backdrop-filter:blur(10px);
box-shadow:0 20px 50px rgba(0,0,0,0.4);
}

h1{text-align:center;}

/* INFO */
.student-info{
text-align:center;
margin-bottom:15px;
}

/* SUMMARY */
.summary{
display:flex;
justify-content:center;
gap:10px;
flex-wrap:wrap;
margin-bottom:15px;
}

.card{
background:rgba(255,255,255,0.15);
padding:10px;
border-radius:10px;
min-width:80px;
text-align:center;
font-size:13px;
}

/* MONTH */
.month-nav{
display:flex;
justify-content:center;
align-items:center;
gap:10px;
margin-bottom:10px;
}

.month-nav button{
background:#6366f1;
border:none;
color:white;
padding:6px 10px;
border-radius:6px;
cursor:pointer;
}

/* CALENDAR */
.calendar{
display:grid;
grid-template-columns:repeat(7,1fr);
gap:5px;
}

.day-name{
text-align:center;
font-size:12px;
opacity:0.7;
}

.date{
height:60px;
border-radius:8px;
background:rgba(255,255,255,0.1);
position:relative;
}

.date span{
position:absolute;
top:4px;
right:6px;
font-size:11px;
}

/* COLORS */
.present{background:var(--present)!important;}
.absent{background:var(--absent)!important;}
.leave{background:var(--leave)!important;}

/* LEGEND */
.legend{
display:flex;
justify-content:center;
gap:15px;
margin-top:10px;
flex-wrap:wrap;
}

.legend div{
display:flex;
align-items:center;
gap:5px;
font-size:12px;
}

.box{
width:10px;
height:10px;
border-radius:3px;
}

/* MOBILE */
@media(max-width:480px){
.date{height:50px;}
.card{font-size:11px;}
}
</style>

</head>

<body>

<!-- ? NAVBAR -->
<%@include file="navbar.jsp"%>

<div class="container">

<h1>My Attendance</h1>

<div class="student-info">
Username : <strong><%=studentUsername%></strong>
</div>

<div class="summary">
<div class="card">Present<br><strong id="p">0</strong></div>
<div class="card">Absent<br><strong id="a">0</strong></div>
<div class="card">Leave<br><strong id="l">0</strong></div>
<div class="card">Attendance %<br><strong id="per">0%</strong></div>
</div>

<div class="month-nav">
<button onclick="changeMonth(-1)">&lt;</button>
<h3 id="monthYear"></h3>
<button onclick="changeMonth(1)">&gt;</button>
</div>

<div class="calendar" id="calendar"></div>

<div class="legend">
<div><div class="box" style="background:#2ecc71"></div>Present</div>
<div><div class="box" style="background:#e74c3c"></div>Absent</div>
<div><div class="box" style="background:#f39c12"></div>Leave</div>
</div>

</div>

<!-- ================= DB DATA ================= -->
<script>
let attendanceData={};
</script>

<%

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root","root");

PreparedStatement ps=con.prepareStatement(
"SELECT attend_date,status FROM attendance WHERE student_username=?"
);

ps.setString(1,studentUsername);

ResultSet rs=ps.executeQuery();

while(rs.next()){

String d=rs.getDate("attend_date").toString();
String st=rs.getString("status").toLowerCase();

%>

<script>
attendanceData["<%=d%>"]="<%=st%>";
</script>

<%
}

rs.close();
ps.close();
con.close();
%>

<!-- ================= JS ================= -->
<script>

const cal=document.getElementById("calendar");
const monthYear=document.getElementById("monthYear");

let cur=new Date();

function render(){

cal.innerHTML="";

const days=["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];

days.forEach(d=>{
let el=document.createElement("div");
el.className="day-name";
el.innerText=d;
cal.appendChild(el);
});

let y=cur.getFullYear();
let m=cur.getMonth();

monthYear.innerText=cur.toLocaleString("default",{month:"long",year:"numeric"});

let first=new Date(y,m,1).getDay();
let total=new Date(y,m+1,0).getDate();

for(let i=0;i<first;i++) cal.appendChild(document.createElement("div"));

let p=0,a=0,l=0;

for(let d=1;d<=total;d++){

let box=document.createElement("div");
box.className="date";
box.innerHTML="<span>"+d+"</span>";

let key=y+"-"+String(m+1).padStart(2,"0")+"-"+String(d).padStart(2,"0");

if(attendanceData[key]){
box.classList.add(attendanceData[key]);

if(attendanceData[key]=="present")p++;
if(attendanceData[key]=="absent")a++;
if(attendanceData[key]=="leave")l++;
}

cal.appendChild(box);
}

document.getElementById("p").innerText=p;
document.getElementById("a").innerText=a;
document.getElementById("l").innerText=l;

let t=p+a+l;
document.getElementById("per").innerText=t?((p/t)*100).toFixed(1)+"%":"0%";

}

function changeMonth(x){
cur.setMonth(cur.getMonth()+x);
render();
}

render();

</script>
<script>
function toggleMenu(){
    var nav = document.getElementById("navLinks");

    if(nav){
        nav.classList.toggle("active");
    }else{
        console.log("navLinks not found");
    }
}
</script>
</body>
</html>