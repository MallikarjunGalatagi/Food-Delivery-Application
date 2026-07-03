import org.mindrot.jbcrypt.BCrypt;

public class BCryptVerify {
    public static void main(String[] args) {
        String plain = "password123";
        String hashed = "$2a$10$eHP/RE2e6etp/4y0V.z5nOvHN6pVt8.tshbNI/CrMPqkzhG.pLmcy";
        try {
            boolean check = BCrypt.checkpw(plain, hashed);
            System.out.println("VERIFICATION_RESULT: " + check);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
