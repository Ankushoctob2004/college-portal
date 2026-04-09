import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class ProfileServlet extends HttpServlet
{
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        HttpSession session = request.getSession(false);

        // 🔐 Session check
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try
        {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/college?useSSL=false&serverTimezone=UTC",
                "root","root"
            );

            String sql = "SELECT * FROM students WHERE username=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);

            rs = ps.executeQuery();

            if (rs.next())
            {
                // 🔹 Basic Info
                request.setAttribute("username", rs.getString("username"));
                request.setAttribute("gender", rs.getString("gender"));
                request.setAttribute("contact", rs.getString("contact"));
                request.setAttribute("email", rs.getString("email"));

                // 🔹 College Info
                request.setAttribute("college", rs.getString("college"));
                request.setAttribute("course", rs.getString("course"));
                request.setAttribute("semester", rs.getString("semester"));

                // ➡ Forward to profile.jsp
                RequestDispatcher rd =
                    request.getRequestDispatcher("profile.jsp");
                rd.forward(request, response);
            }
            else
            {
                response.getWriter().println(
                    "<h3>No profile data found</h3>"
                );
            }
        }
        catch (Exception e)
        {
            response.getWriter().println("Error : " + e);
        }
        finally
        {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {}
        }
    }

    // POST support (optional)
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doGet(req, res);
    }
}
