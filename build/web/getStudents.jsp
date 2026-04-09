<%@ page import="java.sql.*" %>

<%
String branch = request.getParameter("branch");

out.print("<option>Select Student</option>");

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root",
"root"
);

PreparedStatement ps = con.prepareStatement(
"SELECT username,name,branch,semester,rollno FROM students WHERE branch=?");

ps.setString(1,branch);

ResultSet rs = ps.executeQuery();

while(rs.next()){

String username = rs.getString("username");
String name = rs.getString("name");
String br = rs.getString("branch");
String sem = rs.getString("semester");
String roll = rs.getString("rollno");

if(roll==null || roll.equals("")){
roll = username;
}
%>

<option 
value="<%=username%>"
data-name="<%=name%>"
data-branch="<%=br%>"
data-sem="<%=sem%>"
data-roll="<%=roll%>">

<%=username%>

</option>

<%
}

con.close();

}catch(Exception e){
out.print("<option>Error: "+e.getMessage()+"</option>");
}
%>