import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter("/*")

public class AuthFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();

        // Public pages allowed
        if (uri.contains("login.jsp") ||
            uri.contains("LoginServlet") ||
            uri.contains("css") ||
            uri.contains("js") ||
            uri.contains("images")) {

            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("role") == null) {

            res.sendRedirect("login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

}