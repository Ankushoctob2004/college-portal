import java.awt.Desktop;
import java.net.URI;

public class Launcher {

    public static void main(String[] args) {

        try {

            String url = "http://localhost:8080/collegeportal/login.jsp";

            Desktop.getDesktop().browse(new URI(url));

        } 
        catch (Exception e) {
            e.printStackTrace();
        }

    }
}