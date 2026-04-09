<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Swami Vivekanand College of Engineering</title>

<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:Segoe UI;}

body{
height:100vh;
background:
linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
url("college.jpg");
background-size:cover;
background-position:center;
display:flex;
justify-content:center;
align-items:center;
}

.login-box{
width:380px;
background:rgba(255,255,255,0.15);
padding:35px;
border-radius:15px;
box-shadow:0 15px 35px rgba(0,0,0,0.4);
text-align:center;
backdrop-filter: blur(10px);
border:1px solid rgba(255,255,255,0.3);
color:white;
}

.college-title{
font-size:24px;
font-weight:700;
color:#1b3a57;
margin-bottom:25px;
}

.error{
background:#ff4d4d;
padding:10px;
border-radius:6px;
margin-bottom:15px;
font-size:14px;
}

label{
display:block;
text-align:left;
margin-bottom:6px;
}

input,select{
width:100%;
padding:10px;
border-radius:8px;
border:1px solid rgba(255,255,255,0.5);
margin-bottom:15px;
background:rgba(255,255,255,0.2);
color:white;
}

select option{color:black;}

.password-box{position:relative;}

.toggle-pass{
position:absolute;
right:10px;
top:10px;
cursor:pointer;
font-size:12px;
}

input[type=submit]{
width:100%;
padding:11px;
background:linear-gradient(135deg,#667eea,#764ba2);
border:none;
color:white;
border-radius:8px;
cursor:pointer;
}
/* 🔥 BODY FIX (MAIN ISSUE YAHI THA) */
body{
min-height:100vh;
background:
linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
url("college.jpg");
background-size:cover;
background-position:center;

/* ❌ remove strict center */
display:flex;
justify-content:center;
align-items:center;

/* ✅ ADD */
padding:20px;
}

/* 🔥 LOGIN BOX FIX */
.login-box{
width:100%;
max-width:420px;   /* 🔥 bada kiya */
background:rgba(255,255,255,0.15);
padding:40px;      /* 🔥 padding increase */
border-radius:15px;
box-shadow:0 15px 35px rgba(0,0,0,0.4);
text-align:center;
backdrop-filter: blur(10px);
border:1px solid rgba(255,255,255,0.3);
color:white;
}

/* 🔥 MOBILE PERFECT */
@media(max-width:768px){

body{
    hieght:100vh;
    display: flex;
    justify-content:center;
align-items:center;   /* 🔥 IMPORTANT */
padding-top:40px;
}

.login-box{
max-width:500%;
max-width: 90vw;
padding:45px;

}

/* TITLE */
.college-title{
font-size:20px;
}

/* INPUT */
input,select{
font-size:15px;
padding:12px;
}

/* BUTTON */
input[type=submit]{
padding:12px;
font-size:15px;
}

}

/* 🔥 SMALL MOBILE */
@media(max-width:480px){

body{
padding:15px;
padding-top:30px;
}

.login-box{
padding:20px;
}

.college-title{
font-size:18px;
}

}

/* 🔥 EXTRA SMALL */
@media(max-width:350px){

.college-title{
font-size:16px;
}

input,select{
font-size:13px;
}

}
</style>

<script>

function togglePassword(){
let pass=document.getElementById("pass");
pass.type = (pass.type==="password") ? "text" : "password";
}

/* ✅ ROLE VALIDATION */
function validateForm(){

let role=document.getElementById("role").value;

if(role===""){
alert("Please select role (Student / Faculty)");
return false;
}

return true;
}

</script>

</head>

<body>

<div class="login-box">

<div class="college-title">
Swami Vivekanand College of Engineering
</div>

<%
String error = (String)request.getAttribute("error");
if(error != null){
%>
<div class="error"><%= error %></div>
<%
}
%>

<form action="LoginServlet" method="post" onsubmit="return validateForm()">

<label>User Name</label>
<input type="text" name="un" required>

<label>Password</label>

<div class="password-box">
<input type="password" name="up" id="pass" required>
<span class="toggle-pass" onclick="togglePassword()">Show</span>
</div>

<label>Login As</label>

<select name="role" id="role" required>
<option value="">-- Select Role --</option>
<option value="STUDENT">Student</option>
<option value="FACULTY">Faculty</option>
</select>

<input type="submit" value="Login">

</form>

</div>

</body>
</html>