<%@ page import="java.sql.*,org.json.*" %>

<%
response.setContentType("application/json");

HttpSession s=request.getSession(false);
String branch=(String)s.getAttribute("branch");

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root",
"root"
);
PreparedStatement ps=con.prepareStatement(
"SELECT * FROM notices WHERE branch=? ORDER BY id DESC");

ps.setString(1,branch);

ResultSet rs=ps.executeQuery();

JSONArray arr=new JSONArray();

while(rs.next()){

JSONObject obj=new JSONObject();

obj.put("title",rs.getString("title"));
obj.put("message",rs.getString("message"));
obj.put("type",rs.getString("type")==null?"FACULTY":rs.getString("type"));
obj.put("seen",rs.getInt("seen"));

arr.put(obj);
}

out.print(arr);

rs.close();
ps.close();
con.close();
%>