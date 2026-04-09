import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteAssignmentServlet extends HttpServlet{

protected void doGet(HttpServletRequest req,HttpServletResponse res)
throws ServletException,IOException{

int id=Integer.parseInt(req.getParameter("id"));

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
"root",
"root"
);

PreparedStatement ps=con.prepareStatement(
"DELETE FROM assignments WHERE id=?"
);

ps.setInt(1,id);

ps.executeUpdate();

con.close();

}catch(Exception e){
e.printStackTrace();
}

res.sendRedirect("FacultyAssignment.jsp");

}

}