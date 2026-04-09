<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f3f5;
        }

        .profile-box {
            width: 480px;
            margin: 70px auto;
            background: #ffffff;
            padding: 30px 35px;
            border-radius: 14px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
            color: #4a47a3;
            margin-bottom: 25px;
        }

        .row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            font-size: 15px;
        }

        .row:last-child {
            border-bottom: none;
        }

        .label {
            font-weight: bold;
            color: #333;
        }

        .value {
            color: #555;
        }

        a {
            display: block;
            margin-top: 25px;
            text-align: center;
            text-decoration: none;
            color: #4a47a3;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="profile-box">
    <h2>My Profile</h2>

    <div class="row">
        <div class="label">Name</div>
        <div class="value">${username}</div>
    </div>

    <div class="row">
        <div class="label">Gender</div>
        <div class="value">${gender}</div>
    </div>

    <div class="row">
        <div class="label">Contact</div>
        <div class="value">${contact}</div>
    </div>

    <div class="row">
        <div class="label">Email</div>
        <div class="value">${email}</div>
    </div>

    <div class="row">
        <div class="label">College</div>
        <div class="value">${college}</div>
    </div>

    <div class="row">
        <div class="label">Course</div>
        <div class="value">${course}</div>
    </div>

    <div class="row">
        <div class="label">Semester</div>
        <div class="value">${semester}</div>
    </div>

    <a href="studentHome.jsp">Back to Home</a>
</div>

</body>
</html>
