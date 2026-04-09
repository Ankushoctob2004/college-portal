import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/UploadDocumentServlet")
@MultipartConfig
public class UploadDocumentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);

        if (s == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String username = (String) s.getAttribute("name");
        String branch = (String) s.getAttribute("branch");

        Part filePart = req.getPart("file");

        // ❌ file check
        if (filePart == null || filePart.getSize() == 0) {
            res.getWriter().println("No file selected");
            return;
        }

        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

        // ✅ SAME PATH (IMPORTANT)
        String uploadPath = "C:\\collegeUploads";

        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        File file = new File(dir, fileName);

        // ✅ SAVE FILE
        InputStream input = filePart.getInputStream();
        FileOutputStream output = new FileOutputStream(file);

        byte[] buffer = new byte[4096];
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
                    "jdbc:mysql://localhost:3306/college",
                    "root",
                    "root"
            );

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO student_documents(student_username,branch,file_name,file_path) VALUES(?,?,?,?)"
            );

            ps.setString(1, username);
            ps.setString(2, branch);
            ps.setString(3, fileName);
            ps.setString(4, fileName);

            ps.executeUpdate();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // ✅ SWEET ALERT MESSAGE
        s.setAttribute("msg", "Document Uploaded Successfully");

        // ✅ REDIRECT
        res.sendRedirect("StudentDocuments.jsp");
        return;
    }
}