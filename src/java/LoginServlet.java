import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class LoginServlet extends HttpServlet {

protected void doPost(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {

response.setContentType("text/html;charset=UTF-8");

String username = request.getParameter("un");
String password = request.getParameter("up");
String selectedRole = request.getParameter("role");

/* 🔥 NULL CHECK */
if (username == null || password == null || selectedRole == null ||
    username.trim().equals("") || password.trim().equals("")) {

request.setAttribute("error","Please fill all fields");

RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
rd.forward(request,response);
return;
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false",
"root",
"root"
);

/* 🔥 CLEAN QUERY */
String sql =
"SELECT l.username, l.role, " +
"s.id AS student_id, s.name AS student_name, s.branch AS student_branch, " +
"f.name AS faculty_name, f.branch AS faculty_branch " +
"FROM login l " +
"LEFT JOIN students s ON l.username = s.username " +
"LEFT JOIN faculty f ON l.username = f.username " +
"WHERE l.username=? AND l.password=?";

ps = con.prepareStatement(sql);

ps.setString(1,username);
ps.setString(2,password);

rs = ps.executeQuery();

if(!rs.next()){

request.setAttribute("error","Invalid Username or Password");

RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
rd.forward(request,response);
return;
}

/* 🔥 ROLE CHECK */
String dbRole = rs.getString("role");

if(!dbRole.equalsIgnoreCase(selectedRole)){

request.setAttribute("error","Wrong role selected!");

RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
rd.forward(request,response);
return;
}

/* 🔥 SESSION */
HttpSession session = request.getSession(true);

session.setAttribute("username",username);
session.setAttribute("role",dbRole);
session.setMaxInactiveInterval(30*60);

/* ================= STUDENT ================= */

if("STUDENT".equalsIgnoreCase(dbRole)){

int studentId = rs.getInt("student_id");
String branch = rs.getString("student_branch");
String name = rs.getString("student_name");

session.setAttribute("studentId",studentId);
session.setAttribute("branch",branch);
session.setAttribute("name",name);

response.sendRedirect("studentHome.jsp");
return;
}

/* ================= FACULTY ================= */

else if("FACULTY".equalsIgnoreCase(dbRole)){

String branch = rs.getString("faculty_branch");
String name = rs.getString("faculty_name");

session.setAttribute("branch",branch);
session.setAttribute("name",name);

response.sendRedirect("FacultyDashboard.jsp");
return;
}

/* 🔥 UNKNOWN ROLE */

else{

request.setAttribute("error","Invalid role in database");

RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
rd.forward(request,response);
}

}catch(Exception e){

e.printStackTrace();

request.setAttribute("error","Server Error");

RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
rd.forward(request,response);

}finally{

try{ if(rs!=null) rs.close(); }catch(Exception e){}
try{ if(ps!=null) ps.close(); }catch(Exception e){}
try{ if(con!=null) con.close(); }catch(Exception e){}

}

}

protected void doGet(HttpServletRequest req,HttpServletResponse res)
throws ServletException,IOException{

doPost(req,res);

}
}