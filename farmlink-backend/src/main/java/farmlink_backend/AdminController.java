package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    private final UserRepository userRepository;
    private final CropRepository cropRepository;
    private final OrderRepository orderRepository;
    private final PostRepository postRepository;

    public AdminController(
            UserRepository userRepository,
            CropRepository cropRepository,
            OrderRepository orderRepository,
            PostRepository postRepository) {

        this.userRepository = userRepository;
        this.cropRepository = cropRepository;
        this.orderRepository = orderRepository;
        this.postRepository = postRepository;
    }

    @GetMapping("/users")
    public ResponseEntity<?> getAllUsers(Authentication authentication) {
        User admin = (User) authentication.getPrincipal();

        if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
            return ResponseEntity.status(403).body("Only admins can access this");
        }

        List<User> users = userRepository.findAll();
        return ResponseEntity.ok(users);
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<?> deleteUser(
            @PathVariable Long id,
            Authentication authentication) {

        User admin = (User) authentication.getPrincipal();

        if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
            return ResponseEntity.status(403).body("Only admins can delete users");
        }

        User user = userRepository.findById(id).orElse(null);

        if (user == null) {
            return ResponseEntity.notFound().build();
        }

        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            return ResponseEntity.badRequest()
                    .body("Admin accounts cannot be deleted");
        }

        userRepository.delete(user);

        return ResponseEntity.ok("User deleted successfully");
    }

    @PatchMapping("/users/{id}/verify")
    public ResponseEntity<?> verifyUser(
            @PathVariable Long id,
            Authentication authentication) {

        User admin = (User) authentication.getPrincipal();

        if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
            return ResponseEntity.status(403)
                    .body("Only admins can verify users");
        }

        User user = userRepository.findById(id).orElse(null);

        if (user == null) {
            return ResponseEntity.notFound().build();
        }

        user.setVerified(true);
        userRepository.save(user);

        return ResponseEntity.ok("User verified successfully");
    }

    @PatchMapping("/users/{id}/unverify")
    public ResponseEntity<?> unverifyUser(
            @PathVariable Long id,
            Authentication authentication) {

        User admin = (User) authentication.getPrincipal();

        if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
            return ResponseEntity.status(403)
                    .body("Only admins can unverify users");
        }

        User user = userRepository.findById(id).orElse(null);

        if (user == null) {
            return ResponseEntity.notFound().build();
        }

        user.setVerified(false);
        userRepository.save(user);

        return ResponseEntity.ok("User unverified successfully");
    }

    @GetMapping("/dashboard")
    public ResponseEntity<?> getDashboardStats(
            Authentication authentication) {

        User admin = (User) authentication.getPrincipal();

        if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
            return ResponseEntity.status(403)
                    .body("Only admins can access dashboard");
        }

        long totalUsers = userRepository.count();
        long totalCrops = cropRepository.count();
        long totalOrders = orderRepository.count();
        long totalPosts = postRepository.count();

        return ResponseEntity.ok(
                new DashboardResponse(
                        totalUsers,
                        totalCrops,
                        totalOrders,
                        totalPosts
                )
        );
    }

    public static class DashboardResponse {

        private long totalUsers;
        private long totalCrops;
        private long totalOrders;
        private long totalPosts;

        public DashboardResponse(
                long totalUsers,
                long totalCrops,
                long totalOrders,
                long totalPosts) {

            this.totalUsers = totalUsers;
            this.totalCrops = totalCrops;
            this.totalOrders = totalOrders;
            this.totalPosts = totalPosts;
        }

        public long getTotalUsers() {
            return totalUsers;
        }

        public long getTotalCrops() {
            return totalCrops;
        }

        public long getTotalOrders() {
            return totalOrders;
        }

        public long getTotalPosts() {
            return totalPosts;
        }
    }
}