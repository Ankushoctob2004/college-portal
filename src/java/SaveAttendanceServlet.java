import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;

public class SaveAttendanceServlet extends HttpServlet {

protected void doPost(HttpServletRequest req,HttpServletResponse res)
throws ServletException,IOException{

HttpSession session=req.getSession();

String date=req.getParameter("date");

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root",
"root");

Enumeration<String> params=req.getParameterNames();

while(params.hasMoreElements()){

String param=params.nextElement();

if(param.startsWith("status_")){

String username=param.replace("status_","");
String status=req.getParameter(param);

/* check existing attendance */

PreparedStatement check=con.prepareStatement(
"SELECT * FROM attendance WHERE student_username=? AND attend_date=?"
);

check.setString(1,username);
check.setDate(2,java.sql.Date.valueOf(date));

ResultSet rs=check.executeQuery();

if(rs.next()){

PreparedStatement update=con.prepareStatement(
"UPDATE attendance SET status=? WHERE student_username=? AND attend_date=?"
);

update.setString(1,status);
update.setString(2,username);
update.setDate(3,java.sql.Date.valueOf(date));

update.executeUpdate();

}else{

PreparedStatement insert=con.prepareStatement(
"INSERT INTO attendance(student_username,attend_date,status) VALUES(?,?,?)"
);

insert.setString(1,username);
insert.setDate(2,java.sql.Date.valueOf(date));
insert.setString(3,status);

insert.executeUpdate();

}

}

}

con.close();

}catch(Exception e){
e.printStackTrace();
}

session.setAttribute("msg","Attendance Saved Successfully");

res.sendRedirect("FacultyAttendance.jsp");

}

}