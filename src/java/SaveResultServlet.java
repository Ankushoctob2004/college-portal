import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class SaveResultServlet extends HttpServlet {

protected void doPost(HttpServletRequest req,HttpServletResponse res)
throws ServletException,IOException{

String username=req.getParameter("username");
String name=req.getParameter("name");
String branch=req.getParameter("branch");
String sem=req.getParameter("semester");
String status=req.getParameter("status");
double sgpa=Double.parseDouble(req.getParameter("sgpa"));

String[] code=req.getParameterValues("code");
String[] subject=req.getParameterValues("subject");
String[] credit=req.getParameterValues("credit");
String[] earned=req.getParameterValues("earned");
String[] grade=req.getParameterValues("grade");

try{
Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root",
"root"
);
PreparedStatement del=con.prepareStatement(
"DELETE FROM results WHERE username=?");
del.setString(1,username);
del.executeUpdate();

PreparedStatement ps=con.prepareStatement(
"INSERT INTO results VALUES(NULL,?,?,?,?,?,?,?,?,?,?,?)");

for(int i=0;i<code.length;i++){

ps.setString(1,username);
ps.setString(2,name);
ps.setString(3,branch);
ps.setString(4,sem);
ps.setString(5,status);
ps.setString(6,code[i]);
ps.setString(7,subject[i]);
ps.setInt(8,Integer.parseInt(credit[i]));
ps.setInt(9,Integer.parseInt(earned[i]));
ps.setString(10,grade[i]);
ps.setDouble(11,sgpa);

ps.executeUpdate();
}

res.sendRedirect("FacultyResult.jsp");

}catch(Exception e){
e.printStackTrace();
}
}
}