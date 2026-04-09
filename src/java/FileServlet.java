import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/FileServlet")
public class FileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name = req.getParameter("name");

        // ❌ null check
        if (name == null || name.trim().equals("")) {
            res.getWriter().println("Invalid file name");
            return;
        }

        // ✅ SAME PATH (IMPORTANT)
        String path = "C:\\collegeUploads\\" + name;

        File file = new File(path);

        // ❌ file exist check
        if (!file.exists()) {
            res.getWriter().println("File not found");
            return;
        }

        // ✅ CONTENT TYPE (IMPORTANT FOR VIEW)
        String mime = getServletContext().getMimeType(file.getName());
        if (mime == null) {
            mime = "application/octet-stream";
        }

        res.setContentType(mime);

        // 👉 View + Download dono handle karega
        res.setContentLength((int) file.length());

        FileInputStream fis = new FileInputStream(file);
        OutputStream os = res.getOutputStream();

        byte[] buffer = new byte[4096];
        int bytesRead;

        while ((bytesRead = fis.read(buffer)) != -1) {
            os.write(buffer, 0, bytesRead);
        }

        fis.close();
        os.flush();
        os.close();
    }
}