package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class FollowController {

    private final FollowRepository followRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    public FollowController(
            FollowRepository followRepository,
            UserRepository userRepository,
            NotificationService notificationService) {

        this.followRepository = followRepository;
        this.userRepository = userRepository;
        this.notificationService = notificationService;
    }

    // Follow a user
    @PostMapping("/{userId}/follow")
    public ResponseEntity<?> followUser(
            @PathVariable Long userId,
            Authentication authentication) {

        User follower = (User) authentication.getPrincipal();

        User following = userRepository.findById(userId)
                .orElse(null);

        if (following == null) {
            return ResponseEntity.notFound().build();
        }

        if (follower.getId().equals(following.getId())) {
            return ResponseEntity.badRequest()
                    .body("You cannot follow yourself");
        }

        if (followRepository
                .findByFollowerIdAndFollowingId(
                        follower.getId(),
                        following.getId())
                .isPresent()) {

            return ResponseEntity.badRequest()
                    .body("You are already following this user");
        }

        Follow follow = new Follow();
        follow.setFollower(follower);
        follow.setFollowing(following);

        followRepository.save(follow);
        notificationService.createNotification(
        following,
        follower.getName() + " started following you."
);

        return ResponseEntity.ok(
                "User followed successfully"
        );
    }

    // Unfollow a user
    @DeleteMapping("/{userId}/follow")
    public ResponseEntity<?> unfollowUser(
            @PathVariable Long userId,
            Authentication authentication) {

        User follower = (User) authentication.getPrincipal();

        Follow follow = followRepository
                .findByFollowerIdAndFollowingId(
                        follower.getId(),
                        userId)
                .orElse(null);

        if (follow == null) {
            return ResponseEntity.badRequest()
                    .body("You are not following this user");
        }

        followRepository.delete(follow);

        return ResponseEntity.ok(
                "User unfollowed successfully"
        );
    }

    // Get follower/following counts
    @GetMapping("/{userId}/follow-count")
    public ResponseEntity<?> getFollowCount(
            @PathVariable Long userId) {

        if (!userRepository.existsById(userId)) {
            return ResponseEntity.notFound().build();
        }

        long followers =
                followRepository.countByFollowingId(userId);

        long following =
                followRepository.countByFollowerId(userId);

        return ResponseEntity.ok(
                new FollowCountResponse(
                        followers,
                        following
                )
        );
    }

    public static class FollowCountResponse {

        private long followers;
        private long following;

        public FollowCountResponse(
                long followers,
                long following) {

            this.followers = followers;
            this.following = following;
        }

        public long getFollowers() {
            return followers;
        }

        public long getFollowing() {
            return following;
        }
    }
}