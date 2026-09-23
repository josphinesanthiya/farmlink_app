package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/posts")
public class PostController {

    private final PostRepository postRepository;

    public PostController(PostRepository postRepository) {
        this.postRepository = postRepository;
    }

    // Create a new post
    @PostMapping
    public ResponseEntity<?> createPost(
            @RequestBody Post post,
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        post.setUser(user);

        Post savedPost = postRepository.save(post);

        return ResponseEntity.ok(savedPost);
    }

    // Get all posts
    @GetMapping
    public ResponseEntity<List<Post>> getAllPosts() {

        return ResponseEntity.ok(
                postRepository.findAll()
        );
    }

    // Get my posts
    @GetMapping("/my")
    public ResponseEntity<?> getMyPosts(
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        List<Post> posts =
                postRepository.findByUserId(user.getId());

        return ResponseEntity.ok(posts);
    }

    // Delete my post
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePost(
            @PathVariable Long id,
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        Post post = postRepository.findById(id)
                .orElse(null);

        if (post == null) {
            return ResponseEntity.notFound().build();
        }

        if (!post.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403)
                    .body("You can only delete your own posts");
        }

        postRepository.delete(post);

        return ResponseEntity.ok(
                "Post deleted successfully"
        );
    }
}