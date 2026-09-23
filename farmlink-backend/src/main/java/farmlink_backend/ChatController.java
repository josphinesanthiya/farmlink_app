package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import farmlink_backend.User;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
public class ChatController {

    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    public ChatController(
            ChatMessageRepository chatMessageRepository,
            UserRepository userRepository,
            NotificationService notificationService) {

        this.chatMessageRepository = chatMessageRepository;
        this.userRepository = userRepository;
        this.notificationService = notificationService;
    }

    // Send a message
    @PostMapping("/{userId}")
    public ResponseEntity<?> sendMessage(
            @PathVariable Long userId,
            @RequestBody ChatMessage chatMessage,
            Authentication authentication) {

        User sender = (User) authentication.getPrincipal();

        User receiver = userRepository.findById(userId)
                .orElse(null);

        if (receiver == null) {
            return ResponseEntity.notFound().build();
        }

        if (sender.getId().equals(receiver.getId())) {
            return ResponseEntity.badRequest()
                    .body("You cannot send a message to yourself");
        }

        if (chatMessage.getMessage() == null
                || chatMessage.getMessage().isBlank()) {

            return ResponseEntity.badRequest()
                    .body("Message cannot be empty");
        }

        chatMessage.setSender(sender);
        chatMessage.setReceiver(receiver);

        ChatMessage savedMessage =
                chatMessageRepository.save(chatMessage);

        notificationService.createNotification(
                receiver,
                sender.getName() + " sent you a message."
        );

        return ResponseEntity.ok(savedMessage);
    }

    // Get conversation with another user
    @GetMapping("/{userId}")
    public ResponseEntity<?> getConversation(
            @PathVariable Long userId,
            Authentication authentication) {

        User currentUser = (User) authentication.getPrincipal();

        if (!userRepository.existsById(userId)) {
            return ResponseEntity.notFound().build();
        }

        List<ChatMessage> messages =
                chatMessageRepository
                        .findBySenderIdAndReceiverIdOrReceiverIdAndSenderIdOrderByCreatedAtAsc(
                                currentUser.getId(),
                                userId,
                                currentUser.getId(),
                                userId
                        );

        return ResponseEntity.ok(messages);
    }
    // Delete my message
@DeleteMapping("/message/{messageId}")
public ResponseEntity<?> deleteMessage(
        @PathVariable Long messageId,
        Authentication authentication) {

    User currentUser = (User) authentication.getPrincipal();

    ChatMessage message =
            chatMessageRepository.findById(messageId)
                    .orElse(null);

    if (message == null) {
        return ResponseEntity.notFound().build();
    }

    if (!message.getSender().getId()
            .equals(currentUser.getId())) {

        return ResponseEntity.status(403)
                .body("You can only delete your own messages");
    }

    chatMessageRepository.delete(message);

    return ResponseEntity.ok(
            "Message deleted successfully"
    );
}
}