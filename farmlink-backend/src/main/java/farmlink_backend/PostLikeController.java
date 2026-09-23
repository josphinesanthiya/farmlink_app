package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/posts")
public class PostLikeController {

    private final PostLikeRepository postLikeRepository;
    private final PostRepository postRepository;
    private final NotificationService notificationService;

    public PostLikeController(
            PostLikeRepository postLikeRepository,
            PostRepository postRepository,
            NotificationService notificationService) {

        this.postLikeRepository = postLikeRepository;
        this.postRepository = postRepository;
        this.notificationService = notificationService;
    }

    // Like a post
    @PostMapping("/{postId}/like")
    public ResponseEntity<?> likePost(
            @PathVariable Long postId,
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        Post post = postRepository.findById(postId)
                .orElse(null);

        if (post == null) {
            return ResponseEntity.notFound().build();
        }

        if (postLikeRepository
                .findByPostIdAndUserId(postId, user.getId())
                .isPresent()) {

            return ResponseEntity.badRequest()
                    .body("You already liked this post");
        }

        PostLike postLike = new PostLike();
        postLike.setPost(post);
        postLike.setUser(user);

        postLikeRepository.save(postLike);
        notificationService.createNotification(
        post.getUser(),
        user.getName() + " liked your post."
);

        return ResponseEntity.ok(
                "Post liked successfully"
        );
    }

    // Unlike a post
    @DeleteMapping("/{postId}/like")
    public ResponseEntity<?> unlikePost(
            @PathVariable Long postId,
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        PostLike postLike = postLikeRepository
                .findByPostIdAndUserId(postId, user.getId())
                .orElse(null);

        if (postLike == null) {
            return ResponseEntity.badRequest()
                    .body("You have not liked this post");
        }

        postLikeRepository.delete(postLike);

        return ResponseEntity.ok(
                "Post unliked successfully"
        );
    }

    // Get like count
    @GetMapping("/{postId}/likes")
    public ResponseEntity<?> getLikeCount(
            @PathVariable Long postId) {

        if (!postRepository.existsById(postId)) {
            return ResponseEntity.notFound().build();
        }

        long likeCount =
                postLikeRepository.countByPostId(postId);

        return ResponseEntity.ok(likeCount);
    }
}