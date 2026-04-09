<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>RGPV Result</title>

<style>
body{
margin:0;
font-family:Arial;
background:#f4f4f4;
}

.container{
width:900px;
margin:20px auto;
background:white;
border:3px solid #d33;
position:relative;
}

/* HEADER */
.header{
text-align:center;
padding:10px;
border-bottom:2px solid #d33;
}

.header h2{
margin:5px;
}

.subhead{
background:#e53935;
color:white;
padding:5px;
display:inline-block;
margin-top:5px;
}

/* INFO */
.info{
padding:10px;
font-size:14px;
}

.info-row{
display:flex;
justify-content:space-between;
margin:5px 0;
}

/* PHOTO */
.photo{
position:absolute;
right:20px;
top:130px;
width:120px;
height:140px;
border:1px solid #000;
background:url('https://via.placeholder.com/120x140') no-repeat center/cover;
}

/* TABLE */
table{
width:100%;
border-collapse:collapse;
font-size:14px;
}

th,td{
border:1px solid #999;
padding:5px;
text-align:center;
}

th{
background:#eee;
}

/* FOOTER */
.footer{
padding:10px;
font-size:14px;
display:flex;
justify-content:space-between;
}

.result{
color:green;
font-weight:bold;
}

.sgpa{
font-weight:bold;
}

</style>
</head>

<body>

<div class="container">

<div class="header">
<h2>RAJIV GANDHI PROUDYOGIKI VISHWAVIDYALAYA, BHOPAL</h2>
<div>(UNIVERSITY OF TECHNOLOGY OF MADHYA PRADESH)</div>
<div class="subhead">STATEMENT OF GRADE</div>
<div>Examination December-2022</div>
</div>

<div class="photo"></div>

<div class="info">
<div class="info-row"><div>Roll No: 0822CS221021</div><div>SR. No:</div></div>
<div class="info-row"><div>Name: ANKUSH CHANDRAVANSHI</div></div>
<div class="info-row"><div>Father Name: RAMESH CHANDRAVANSHI</div></div>
<div class="info-row"><div>Institute: Swami Vivekanand College of Engineering</div></div>
<div class="info-row"><div>Semester: FIRST</div><div>Status: Regular</div></div>
</div>

<table id="marks">
<tr>
<th>Subject Code</th>
<th>Subject Name</th>
<th>Total Credit</th>
<th>Credit Earned</th>
<th>Grade</th>
</tr>

<tr><td>BT101 [T]</td><td>Engineering Chemistry</td><td>3</td><td>3</td><td>C</td></tr>
<tr><td>BT102 [T]</td><td>Mathematics-I</td><td>4</td><td>4</td><td>D++</td></tr>
<tr><td>BT103 [T]</td><td>English Communication</td><td>3</td><td>3</td><td>C+</td></tr>
<tr><td>BT104 [T]</td><td>Basic Electrical</td><td>2</td><td>2</td><td>C</td></tr>
<tr><td>BT105 [T]</td><td>Engineering Graphics</td><td>2</td><td>2</td><td>C</td></tr>

<tr><td>BT101 [P]</td><td>Chemistry Lab</td><td>1</td><td>1</td><td>C+</td></tr>
<tr><td>BT103 [P]</td><td>English Lab</td><td>1</td><td>1</td><td>B+</td></tr>
<tr><td>BT104 [P]</td><td>Electrical Lab</td><td>1</td><td>1</td><td>C+</td></tr>
<tr><td>BT105 [P]</td><td>Graphics Lab</td><td>1</td><td>1</td><td>B+</td></tr>
<tr><td>BT106 [P]</td><td>Manufacturing</td><td>1</td><td>1</td><td>A</td></tr>

<tr><td>BT108 [P]</td><td>Swachh Bharat</td><td>2</td><td>2</td><td>B</td></tr>

</table>

<div class="footer">
<div class="result">RESULT: PASS WITH GRACE</div>
<div class="sgpa">SGPA: <span id="sgpa">0</span></div>
</div>

</div>

<script>

/* GRADE POINT */
const gp={"A+":10,"A":9,"B+":8,"B":7,"C+":6,"C":5,"D++":4};

/* CALCULATE SGPA */
function calc(){
let rows=document.querySelectorAll("#marks tr");
let tc=0,tp=0;

for(let i=1;i<rows.length;i++){
let c=parseFloat(rows[i].children[2].innerText);
let g=rows[i].children[4].innerText.trim();

tc+=c;
tp+=c*(gp[g]||0);
}

document.getElementById("sgpa").innerText=(tp/tc).toFixed(2);
}

calc();

</script>

</body>
</html>