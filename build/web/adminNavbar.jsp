<div class="navbar">

<h2>Smart College Portal - Admin</h2>

<div class="menu-icon" onclick="toggleMenu()">    <i class="fa-solid fa-bars"></i>
</div>

<div class="nav-links" id="navLinks">
<a href="AdminDashboard.jsp">Dashboard</a>
<a href="AdminStudents.jsp">Students</a>
<a href="AdminFaculty.jsp">Faculty</a>
<a href="AdminLogoutServlet">Logout</a>
</div>

</div>

<script>
function toggleMenu(){
document.getElementById("navLinks").classList.toggle("active");
}
</script>