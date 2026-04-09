<%@ page session="true" %>
<%
HttpSession s = request.getSession(false);

if (s == null || !"STUDENT".equals(s.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}

String branch = (String)s.getAttribute("branch");
%>

<!DOCTYPE html>
<html>
<head>
  
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<title>Student - View Syllabus</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="navbar.css">

<style>

body{
margin:0;
font-family:Arial;
background:#0f172a;
color:white;
}

.container{
width:80%;
margin:40px auto;
}

.card{
background:#1e293b;
padding:15px;
margin-top:15px;
border-radius:10px;
display:flex;
justify-content:space-between;
align-items:center;
box-shadow:0 4px 10px rgba(0,0,0,0.5);
}

button{
background:#3b82f6;
color:white;
border:none;
padding:8px 14px;
border-radius:6px;
cursor:pointer;
}

button:hover{
background:#2563eb;
}

/* SAME NO DATA UI */

.no-data{
text-align:center;
margin-top:60px;
background:#1e293b;
padding:40px;
border-radius:10px;
}

.no-data h3{
color:#94a3b8;
margin-bottom:10px;
}

.no-data p{
color:#cbd5f5;
}

</style>
</head>

<body>

<%@include file="navbar.jsp"%>

<div class="container">

<h2>Available Syllabus (Branch : <%=branch%>)</h2>

<div id="syllabusList"></div>

</div>

<script>

var branch="<%=branch%>";

function displaySyllabus(){

var list=document.getElementById("syllabusList");

list.innerHTML="";

var syllabus=JSON.parse(localStorage.getItem("syllabus")) || [];

var filtered=[];

for(var i=0;i<syllabus.length;i++){
if(syllabus[i].branch===branch){
filtered.push(syllabus[i]);
}
}

/* NO DATA UI SAME AS OTHER PAGES */

if(filtered.length===0){

list.innerHTML = `
<div class="no-data">
<h3>No Data Available ?</h3>
<p>No content has been uploaded yet for your branch.</p>
</div>
`;

return;
}

/* SHOW DATA */

for(var i=0;i<filtered.length;i++){

var item=filtered[i];

var div=document.createElement("div");

div.className="card";

div.innerHTML=
"<div><b>"+item.subject+"</b><br>"+item.fileName+"</div>"+
"<button onclick='viewPDF(\""+item.fileData+"\")'>View</button>";

list.appendChild(div);

}

}

/* VIEW PDF */

function viewPDF(data){

var byteString=atob(data.split(",")[1]);

var mimeString=data.split(",")[0].split(":")[1].split(";")[0];

var ab=new ArrayBuffer(byteString.length);

var ia=new Uint8Array(ab);

for(var i=0;i<byteString.length;i++){
ia[i]=byteString.charCodeAt(i);
}

var blob=new Blob([ab],{type:mimeString});

var url=URL.createObjectURL(blob);

window.open(url);

}

displaySyllabus();

</script>
<script>
function toggleMenu(){
let nav=document.getElementById("navLinks");
nav.classList.toggle("active");
}
</script>

</body>
</html>