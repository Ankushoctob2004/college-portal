<%@ page session="true" %>
<%
HttpSession s = request.getSession(false);

if (s == null || !"FACULTY".equals(s.getAttribute("role"))) {
response.sendRedirect("login.jsp");
return;
}

String branch = (String)s.getAttribute("branch");
%>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Faculty - Upload Syllabus</title>
<link rel="stylesheet" href="faculty.css">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>

body{background:#dfe3e8;font-family:Segoe UI;}

.container{
width:70%;
margin:40px auto;
background:white;
padding:30px;
border-radius:10px;
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
select,input,button{
width:100%;
padding:10px;
margin-top:10px;
}

button{
background:#2f4356;
color:white;
border:none;
cursor:pointer;
}

.card{
background:#f4f6f9;
padding:15px;
margin-top:15px;
border-radius:8px;
display:flex;
justify-content:space-between;
align-items:center;
}

.delete{
background:red;
}

</style>

</head>

<body>

<!-- ? NAVBAR -->
<div class="navbar">
<h2 class="logo">Campus<span>Hub</span></h2>
  <div class="nav-links">
    <a href="FacultyDashboard.jsp">Dashboard</a>
       <a href="LogoutServlet">Logout</a>
      
  </div>
</div>

<div class="container">

<h2>Upload Syllabus (Branch : <%=branch%>)</h2>

<select id="subject">
<option value="">-- Select Subject --</option>
<option>Mathematics</option>
<option>Physics</option>
<option>Computer Science</option>
</select>

<input type="file" id="file">

<button onclick="uploadSyllabus()">Upload PDF</button>

<hr>

<h3>Uploaded Syllabus</h3>

<div id="list"></div>

</div>


<script>

var branch = "<%=branch%>";

function uploadSyllabus(){

var subject = document.getElementById("subject").value;
var fileInput = document.getElementById("file");

if(subject===""){
Swal.fire({
icon:'warning',
title:'Select Subject',
text:'Please select subject first'
});
return;
}

if(!fileInput.files.length){
Swal.fire({
icon:'warning',
title:'Select File',
text:'Please select PDF file'
});
return;
}

var file=fileInput.files[0];
var reader=new FileReader();

reader.onload=function(){

var syllabus = JSON.parse(localStorage.getItem("syllabus")) || [];

var obj={
branch:branch,
subject:subject,
fileName:file.name,
fileData:reader.result
};

syllabus.push(obj);

localStorage.setItem("syllabus",JSON.stringify(syllabus));

fileInput.value="";
document.getElementById("subject").value="";

loadSyllabus();

Swal.fire({
icon:'success',
title:'Uploaded',
text:'Syllabus uploaded successfully'
});

};

reader.readAsDataURL(file);

}


function loadSyllabus(){

var list=document.getElementById("list");
list.innerHTML="";

var syllabus=JSON.parse(localStorage.getItem("syllabus")) || [];

for(var i=0;i<syllabus.length;i++){

if(syllabus[i].branch===branch){

var div=document.createElement("div");
div.className="card";

div.innerHTML=
"<div><b>"+syllabus[i].subject+"</b><br>"+syllabus[i].fileName+"</div>"+
"<button class='delete' onclick='deleteSyllabus("+i+")'>Delete</button>";

list.appendChild(div);

}

}

}


function deleteSyllabus(index){

Swal.fire({
title:'Delete Syllabus?',
text:'This action cannot be undone',
icon:'warning',
showCancelButton:true,
confirmButtonColor:'#d33',
confirmButtonText:'Delete'
}).then((result)=>{

if(result.isConfirmed){

var syllabus=JSON.parse(localStorage.getItem("syllabus"));

syllabus.splice(index,1);

localStorage.setItem("syllabus",JSON.stringify(syllabus));

loadSyllabus();

Swal.fire({
icon:'success',
title:'Deleted',
text:'Syllabus deleted successfully'
});

}

});

}


loadSyllabus();

</script>

</body>
</html>