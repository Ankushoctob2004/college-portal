
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
HttpSession s = request.getSession(false);

if(s==null || !"FACULTY".equals(s.getAttribute("role"))){
response.sendRedirect("login.jsp");
return;
}

String branch=(String)s.getAttribute("branch");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="faculty.css">
<title>RGPV Result Portal</title>

<style>
body{font-family:Arial;background:#f2f2f2;padding:20px;}
.container{max-width:900px;margin:auto;background:white;border:1px solid #ccc;}
.top{display:flex;gap:18px;padding:10px;background:#eee;flex-wrap:wrap;}
input,select{padding:5px;}
.uni{background:#e6dfc6;text-align:center;padding:10px;font-weight:bold;}
table{width:100%;border-collapse:collapse;}
td,th{border:1px solid #aaa;padding:6px;}
th{background:#ddd;}
.edit{background:#fffbe6;}
.preview .edit{background:white;pointer-events:none;}
.btn{padding:8px 12px;margin:10px;border:none;cursor:pointer;color:white;}
.green{background:green;} .blue{background:#007bff;}
.red{background:red;} .orange{background:orange;}

.nav-links{
display:flex;
gap:12px;
flex-wrap:wrap;
align-items:center;
}



.nav-links a:hover{
background:#334155;
}

</style>

</head>

<body>

<div class="container" id="resultBox">

<div class="top">

Enrollment No 
<select id="enroll"></select>

Branch 
<select id="branch" onchange="loadStudents();loadSubjects();">
<option value="CSE">CSE</option>
<option value="IT">IT</option>
<option value="ME">ME</option>
<option value="CE">CE</option>
</select>

Semester 
<select id="sem" onchange="loadSubjects()">
<option>1</option><option>2</option><option>3</option>
<option>4</option><option>5</option><option>6</option>
<option>7</option><option>8</option>
</select>

<label><input type="radio" checked> Grading</label>

</div>

<div class="uni">Rajiv Gandhi Proudyogiki Vishwavidyalaya, Bhopal</div>

<table>
<tr><th colspan="4">Statement of Marks</th></tr>

<tr>
<td>Name</td>
<td class="edit" contenteditable="true">Student Name</td>
<td>Roll No.</td>
<td class="edit" contenteditable="true">---</td>
</tr>

<tr>
<td>Course</td>
<td class="edit" contenteditable="true">B.Tech</td>
<td>Branch</td>
<td class="edit" id="branchDisplay" contenteditable="true">CSE</td>
</tr>

<tr>
<td>Semester</td>
<td class="edit" id="semDisplay" contenteditable="true">1</td>
<td>Status</td>
<td class="edit" contenteditable="true">Regular</td>
</tr>
</table>

<table id="marks"></table>

<table>
<tr>
<th>Result</th>
<th>SGPA</th>
<th>CGPA</th>
</tr>
<tr>
<td class="edit" contenteditable="true">PASS</td>
<td id="sgpa">0</td>
<td id="cgpa">0</td>
</tr>
</table>

<div style="text-align:center;">
<button class="btn green" onclick="enableEdit()">Faculty Edit</button>
<button class="btn blue" onclick="preview()">Preview</button>
<button class="btn orange" onclick="submitData()">Submit</button>
<button class="btn red" onclick="window.print()">Download</button>
</div>

</div>

<script>

/* ? LOAD STUDENTS */
function loadStudents(){

let branch=document.getElementById("branch").value;

fetch("/collegeportal/getStudents.jsp?branch="+branch)
.then(res=>res.text())
.then(data=>{
document.getElementById("enroll").innerHTML=data;

/* ? IMPORTANT: load details after students load */
setTimeout(()=>{
loadStudentDetails();
},200);

});
}

/* ? AUTO LOAD STUDENT DETAILS */
function loadStudentDetails(){

let select=document.getElementById("enroll");
let o=select.options[select.selectedIndex];

if(!o || !o.value) return;

/* NAME */
document.querySelectorAll("td")[1].innerText = o.dataset.name || "Student Name";

/* ? ROLL FIX */
document.querySelectorAll("td")[3].innerText = o.dataset.roll || o.value;

/* BRANCH */
document.getElementById("branchDisplay").innerText = o.dataset.branch || document.getElementById("branch").value;

/* SEM */
document.getElementById("semDisplay").innerText = o.dataset.sem || document.getElementById("sem").value;

/* SUBJECT LOAD */
loadSubjects();
}

/* ? CHANGE EVENT */
document.getElementById("enroll").addEventListener("change",loadStudentDetails);
const data = {

CSE:{
1:[["BT101","Maths-1",4],["BT102","Physics",3],["BT103","Electrical",3],["BT104","Mechanics",3],["BT105","Lab",1]],
2:[["BT201","Maths-2",4],["BT202","Chemistry",3],["BT203","Electronics",3],["BT204","C Programming",3],["BT205","Lab",1]],
3:[["CS301","DS",4],["CS302","DLD",3],["CS303","COA",3],["CS304","Discrete",3],["CS305","Lab",1]],
4:[["CS401","OS",4],["CS402","DBMS",3],["CS403","TOC",3],["CS404","OOP",3],["CS405","Lab",1]],
5:[["CS501","CN",4],["CS502","SE",3],["CS503","Compiler",3],["CS504","AI",3],["CS505","Lab",1]],
6:[["CS601","ML",4],["CS602","Data Mining",3],["CS603","Cloud",3],["CS604","Cyber Security",3],["CS605","Lab",1]],
7:[["CS701","Big Data",4],["CS702","IoT",3],["CS703","Blockchain",3],["CS704","Elective",3],["CS705","Lab",1]],
8:[["CS801","Ethics",3],["CS802","Elective",3],["CS803","Project",6],["CS804","Seminar",2],["CS805","Internship",2]]
},

IT:{
1:[["BT101","Maths",4],["BT102","Physics",3],["BT103","Electrical",3],["BT104","Mechanics",3],["BT105","Lab",1]],
2:[["BT201","Maths",4],["BT202","Chemistry",3],["BT203","Electronics",3],["BT204","C",3],["BT205","Lab",1]],
3:[["IT301","DS",4],["IT302","Web",3],["IT303","COA",3],["IT304","DBMS",3],["IT305","Lab",1]],
4:[["IT401","OS",4],["IT402","Java",3],["IT403","Automata",3],["IT404","Networks",3],["IT405","Lab",1]],
5:[["IT501","SE",4],["IT502","AI",3],["IT503","Analytics",3],["IT504","Cloud",3],["IT505","Lab",1]],
6:[["IT601","Security",4],["IT602","Mobile",3],["IT603","Data Mining",3],["IT604","IoT",3],["IT605","Lab",1]],
7:[["IT701","Big Data",4],["IT702","Blockchain",3],["IT703","Elective",3],["IT704","Project",2],["IT705","Lab",1]],
8:[["IT801","Ethics",3],["IT802","Project",6],["IT803","Seminar",2],["IT804","Internship",2],["IT805","Viva",1]]
},

ME:{
1:[["BT101","Maths",4],["BT102","Physics",3],["BT103","Electrical",3],["BT104","Mechanics",3],["BT105","Lab",1]],
2:[["BT201","Maths",4],["BT202","Chemistry",3],["BT203","Electronics",3],["BT204","Workshop",3],["BT205","Lab",1]],
3:[["ME301","Thermo",4],["ME302","SOM",3],["ME303","Manufacturing",3],["ME304","Fluid",3],["ME305","Lab",1]],
4:[["ME401","Kinematics",4],["ME402","Design",3],["ME403","Heat",3],["ME404","Dynamics",3],["ME405","Lab",1]],
5:[["ME501","IC Engine",4],["ME502","CAD",3],["ME503","Refrigeration",3],["ME504","Robotics",3],["ME505","Lab",1]],
6:[["ME601","Heat Transfer",4],["ME602","Design",3],["ME603","Fluid",3],["ME604","IC Engine",3],["ME605","Lab",1]],
7:[["ME701","Industrial",4],["ME702","Mechatronics",3],["ME703","Automobile",3],["ME704","Project",2],["ME705","Lab",1]],
8:[["ME801","Management",3],["ME802","Project",6],["ME803","Seminar",2],["ME804","Internship",2],["ME805","Viva",1]]
},

CE:{
1:[["BT101","Maths",4],["BT102","Physics",3],["BT103","Electrical",3],["BT104","Mechanics",3],["BT105","Lab",1]],
2:[["BT201","Maths",4],["BT202","Chemistry",3],["BT203","Electronics",3],["BT204","Workshop",3],["BT205","Lab",1]],
3:[["CE301","Survey",4],["CE302","Materials",3],["CE303","Fluid",3],["CE304","Lab",1],["CE305","Drawing",2]],
4:[["CE401","Structural",4],["CE402","Geotech",3],["CE403","Env Engg",3],["CE404","Lab",1],["CE405","Survey",2]],
5:[["CE501","Transport",4],["CE502","Irrigation",3],["CE503","RCC",3],["CE504","Lab",1],["CE505","Design",2]],
6:[["CE601","Structural",4],["CE602","Geotech",3],["CE603","Env Engg",3],["CE604","Soil Lab",1],["CE605","Transportation",3]],
7:[["CE701","Construction",4],["CE702","Advanced Struct",3],["CE703","Project",2],["CE704","Lab",1],["CE705","Elective",3]],
8:[["CE801","Professional Practice",3],["CE802","Project",6],["CE803","Seminar",2],["CE804","Internship",2],["CE805","Viva",1]]
}

};


/* ? SUBJECT LOAD */
function loadSubjects(){

let b=document.getElementById("branch").value;
let s=document.getElementById("sem").value;

let table=document.getElementById("marks");

table.innerHTML="<tr><th>Code</th><th>Subject</th><th>Credit</th><th>Grade</th></tr>";

let subs=data[b]?.[s];

if(!subs) return;

subs.forEach(x=>{
let r=table.insertRow();

r.insertCell().innerText=x[0];
r.insertCell().innerText=x[1];

let c=r.insertCell();
c.innerText=x[2];
c.contentEditable=true;
c.classList.add("edit");

let g=r.insertCell();
g.innerText="A";
g.contentEditable=true;
g.classList.add("edit");
});

calc();
}

/* ? SGPA */
const gp={"A+":10,"A":9,"B+":8,"B":7,"C":6,"D":5,"F":0};

function calc(){

let rows=document.querySelectorAll("#marks tr");

let tc=0,tp=0;

for(let i=1;i<rows.length;i++){

let c=parseFloat(rows[i].cells[2].innerText)||0;
let g=rows[i].cells[3].innerText.trim();

tc+=c;
tp+=c*(gp[g]||0);
}

let sg = tc ? (tp/tc).toFixed(2) : 0;

document.getElementById("sgpa").innerText=sg;
document.getElementById("cgpa").innerText=(sg/2).toFixed(2);
}

document.addEventListener("input",calc);

/* ? EDIT MODE */
function enableEdit(){
document.querySelectorAll(".edit").forEach(e=>{
e.contentEditable=true;
e.style.background="#fffbe6";
});
}

/* ? PREVIEW */
function preview(){
document.querySelectorAll(".edit").forEach(e=>{
e.contentEditable=false;
e.style.background="white";
});
}

/* ? SUBMIT */
function submitData(){
alert("Result Submitted ?");
}

/* ? EVENTS */
document.getElementById("branch").addEventListener("change",loadStudents);
document.getElementById("sem").addEventListener("change",loadSubjects);

/* INIT */
loadStudents();
</script>

</body>
</html>