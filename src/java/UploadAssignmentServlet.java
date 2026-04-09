import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.sql.*;

@WebServlet("/UploadAssignmentServlet")
@MultipartConfig
public class UploadAssignmentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String branch = (String) session.getAttribute("branch");
        String subject = req.getParameter("subject");

        Part filePart = req.getPart("file");

        if (filePart == null || filePart.getSize() == 0) {
            res.getWriter().println("File not selected");
            return;
        }

        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

        // ✅ FIXED PATH
        String uploadPath = "C:\\collegeUploads";

        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        File file = new File(dir, fileName);

        // ✅ MANUAL WRITE (IMPORTANT FIX)
        InputStream input = filePart.getInputStream();
        FileOutputStream output = new FileOutputStream(file);

        byte[] buffer = new byte[1024];
        int bytesRead;

        while ((bytesRead = input.read(buffer)) != -1) {
            output.write(buffer, 0, bytesRead);
        }

        output.close();
        input.close();

        // ✅ DATABASE
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/college?useSSL=false&allowPublicKeyRetrieval=true",
"root",
"root");

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO assignments(branch,subject,file_name,file_path) VALUES(?,?,?,?)"
            );

            ps.setString(1, branch);
            ps.setString(2, subject);
            ps.setString(3, fileName);
            ps.setString(4, fileName);

            ps.executeUpdate();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
session.setAttribute("msg", "Assignment Uploaded Successfully");
res.sendRedirect("FacultyAssignment.jsp");
return;
    }
}