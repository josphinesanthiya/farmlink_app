package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    private final NotificationRepository notificationRepository;

    public NotificationController(
            NotificationRepository notificationRepository) {

        this.notificationRepository = notificationRepository;
    }

    // Get my notifications
    @GetMapping
    public ResponseEntity<?> getMyNotifications(
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        List<Notification> notifications =
                notificationRepository
                        .findByUserIdOrderByCreatedAtDesc(user.getId());

        return ResponseEntity.ok(notifications);
    }

    // Get unread notifications
    @GetMapping("/unread")
    public ResponseEntity<?> getUnreadNotifications(
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        List<Notification> notifications =
                notificationRepository
                        .findByUserIdAndIsReadFalseOrderByCreatedAtDesc(
                                user.getId());

        return ResponseEntity.ok(notifications);
    }

    // Get unread notification count
    @GetMapping("/unread/count")
    public ResponseEntity<?> getUnreadCount(
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        long count =
                notificationRepository
                        .countByUserIdAndIsReadFalse(user.getId());

        return ResponseEntity.ok(count);
    }

    // Mark notification as read
    @PatchMapping("/{id}/read")
    public ResponseEntity<?> markAsRead(
            @PathVariable Long id,
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        Notification notification =
                notificationRepository.findById(id)
                        .orElse(null);

        if (notification == null) {
            return ResponseEntity.notFound().build();
        }

        if (!notification.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403)
                    .body("You can only update your own notifications");
        }

        notification.setRead(true);

        notificationRepository.save(notification);

        return ResponseEntity.ok(
                "Notification marked as read"
        );
    }
        // Mark all notifications as read
@PatchMapping("/read-all")
public ResponseEntity<?> markAllAsRead(
        Authentication authentication) {

    User user = (User) authentication.getPrincipal();

    List<Notification> notifications =
            notificationRepository
                    .findByUserIdOrderByCreatedAtDesc(user.getId());

    for (Notification notification : notifications) {
        notification.setRead(true);
    }

    notificationRepository.saveAll(notifications);

    return ResponseEntity.ok(
            "All notifications marked as read"
    );
}
    
}