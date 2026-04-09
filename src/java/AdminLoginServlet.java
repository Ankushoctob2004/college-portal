import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html"); // important

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        PrintWriter out = response.getWriter(); // for debug

        try{

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
            "root","root");

            PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM login WHERE username=? AND role='ADMIN'");

            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){

                String hashedPassword = rs.getString("password");

                // ⚠️ IMPORTANT CHECK
                if(password.equals(hashedPassword)){

                    HttpSession session = request.getSession();
                    session.setAttribute("admin", username);

                    response.sendRedirect("AdminDashboard.jsp");

                }else{

                    response.sendRedirect("AdminLogin.jsp?error=1");

                }

            }else{

                response.sendRedirect("AdminLogin.jsp?error=1");

            }

            con.close();

        }catch(Exception e){

            // 🔥 THIS WILL SHOW ERROR (no more blank screen)
            e.printStackTrace();
            out.println("<h2 style='color:red'>ERROR:</h2>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");

        }
    }
}