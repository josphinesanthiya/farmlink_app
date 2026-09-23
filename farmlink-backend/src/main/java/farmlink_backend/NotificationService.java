package farmlink_backend;

import org.springframework.stereotype.Service;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;

    public NotificationService(
            NotificationRepository notificationRepository) {

        this.notificationRepository = notificationRepository;
    }

    public void createNotification(
            User user,
            String message) {

        Notification notification = new Notification();

        notification.setUser(user);
        notification.setMessage(message);
        notification.setRead(false);

        notificationRepository.save(notification);
    }
}