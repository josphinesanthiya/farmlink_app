package farmlink_backend;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ChatMessageRepository
        extends JpaRepository<ChatMessage, Long> {

    List<ChatMessage> findBySenderIdAndReceiverIdOrReceiverIdAndSenderIdOrderByCreatedAtAsc(
            Long senderId,
            Long receiverId,
            Long receiverId2,
            Long senderId2
    );

    List<ChatMessage> findByReceiverIdOrderByCreatedAtDesc(
            Long receiverId
    );
}