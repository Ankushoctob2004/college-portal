<!DOCTYPE html>
<html>
<head>
<title>Admin Login</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- ICON -->
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>

body{
margin:0;
font-family:'Segoe UI', Arial, sans-serif;
background:linear-gradient(135deg,#1e3a8a,#2563eb);
height:100vh;
display:flex;
justify-content:center;
align-items:center;
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
.login-box{
background:white;
padding:35px;
border-radius:14px;
box-shadow:0 10px 30px rgba(0,0,0,0.2);
width:350px;
max-width:90%;
text-align:center;
}

h2{margin-bottom:5px;font-weight:600;}
.sub{color:#64748b;margin-bottom:25px;font-size:14px;}

.input-group{
position:relative;
margin-bottom:20px;
}

.input-group input{
width:100%;
padding:12px;
border:1px solid #ccc;
border-radius:6px;
outline:none;
font-size:14px;
}

.input-group label{
position:absolute;
top:-8px;
left:10px;
background:white;
padding:0 5px;
font-size:12px;
color:#555;
}

/* ?? ICON */
.eye{
position:absolute;
right:10px;
top:50%;
transform:translateY(-50%);
cursor:pointer;
color:#555;
}

button{
width:100%;
padding:12px;
background:#2563eb;
color:white;
border:none;
border-radius:6px;
cursor:pointer;
}

button:hover{background:#1e40af;}

</style>
</head>

<body>

<div class="login-box">
<div class="navbar">
<h2 class="logo">Campus<span>Hub</span></h2>
<p class="sub">Secure Login Access</p>

<form action="AdminLoginServlet" method="post">

<div class="input-group">
<input type="text" name="username" required>
<label>Username</label>
</div>

<div class="input-group">
<input type="password" id="password" name="password" required>
<label>Password</label>
<i class="fa-solid fa-eye eye" onclick="togglePassword()"></i>
</div>

<button type="submit">Login</button>

</form>

</div>

<!-- ALERT -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
const params = new URLSearchParams(window.location.search);

if(error=="1"){
Swal.fire({
icon:'error',
title:'Login Failed',
text:'Invalid Username or Password'
});
}

// ?? PASSWORD TOGGLE
function togglePassword(){
let pass = document.getElementById("password");

if(pass.type === "password"){
pass.type = "text";
}else{
pass.type = "password";
}
}
</script>

</body>
</html>