package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/posts")
public class PostCommentController {

    private final PostCommentRepository commentRepository;
    private final PostRepository postRepository;
    private final NotificationService notificationService;

    public PostCommentController(
            PostCommentRepository commentRepository,
            PostRepository postRepository,
            NotificationService notificationService) {

        this.commentRepository = commentRepository;
        this.postRepository = postRepository;
        this.notificationService = notificationService;
    }

    // Add comment
    @PostMapping("/{postId}/comments")
    public ResponseEntity<?> addComment(
            @PathVariable Long postId,
            @RequestBody PostComment comment,
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        Post post = postRepository.findById(postId)
                .orElse(null);

        if (post == null) {
            return ResponseEntity.notFound().build();
        }

        if (comment.getContent() == null
                || comment.getContent().isBlank()) {

            return ResponseEntity.badRequest()
                    .body("Comment cannot be empty");
        }

        comment.setPost(post);
        comment.setUser(user);

        PostComment savedComment =
                commentRepository.save(comment);
        notificationService.createNotification(
        post.getUser(),
        user.getName() + " commented on your post."
);        

        return ResponseEntity.ok(savedComment);
    }

    // Get comments for a post
    @GetMapping("/{postId}/comments")
    public ResponseEntity<?> getComments(
            @PathVariable Long postId) {

        if (!postRepository.existsById(postId)) {
            return ResponseEntity.notFound().build();
        }

        List<PostComment> comments =
                commentRepository
                        .findByPostIdOrderByCreatedAtAsc(postId);

        return ResponseEntity.ok(comments);
    }

    // Delete my comment
    @DeleteMapping("/comments/{commentId}")
    public ResponseEntity<?> deleteComment(
            @PathVariable Long commentId,
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        PostComment comment =
                commentRepository.findById(commentId)
                        .orElse(null);

        if (comment == null) {
            return ResponseEntity.notFound().build();
        }

        if (!comment.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403)
                    .body("You can only delete your own comments");
        }

        commentRepository.delete(comment);

        return ResponseEntity.ok(
                "Comment deleted successfully"
        );
    }
}