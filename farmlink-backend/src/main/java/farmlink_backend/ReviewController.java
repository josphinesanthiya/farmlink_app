package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {

    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    public ReviewController(
            ReviewRepository reviewRepository,
            UserRepository userRepository,
            NotificationService notificationService) {

        this.reviewRepository = reviewRepository;
        this.userRepository = userRepository;
        this.notificationService = notificationService;
    }

    // Add a review
    @PostMapping("/{userId}")
    public ResponseEntity<?> addReview(
            @PathVariable Long userId,
            @RequestBody Review review,
            Authentication authentication) {

        User reviewer = (User) authentication.getPrincipal();

        User reviewedUser = userRepository.findById(userId)
                .orElse(null);

        if (reviewedUser == null) {
            return ResponseEntity.notFound().build();
        }

        if (reviewer.getId().equals(reviewedUser.getId())) {
            return ResponseEntity.badRequest()
                    .body("You cannot review yourself");
        }

        if (review.getRating() == null
                || review.getRating() < 1
                || review.getRating() > 5) {

            return ResponseEntity.badRequest()
                    .body("Rating must be between 1 and 5");
        }

        if (reviewRepository
                .findByReviewerIdAndReviewedUserId(
                        reviewer.getId(),
                        reviewedUser.getId())
                .isPresent()) {

            return ResponseEntity.badRequest()
                    .body("You have already reviewed this user");
        }

        review.setReviewer(reviewer);
        review.setReviewedUser(reviewedUser);

        Review savedReview = reviewRepository.save(review);

        notificationService.createNotification(
                reviewedUser,
                reviewer.getName() + " rated you "
                        + review.getRating() + " stars."
        );

        return ResponseEntity.ok(savedReview);
    }

    // Get reviews for a user
    @GetMapping("/{userId}")
    public ResponseEntity<?> getReviews(
            @PathVariable Long userId) {

        if (!userRepository.existsById(userId)) {
            return ResponseEntity.notFound().build();
        }

        List<Review> reviews =
                reviewRepository
                        .findByReviewedUserIdOrderByCreatedAtDesc(userId);

        return ResponseEntity.ok(reviews);
    }
        // Get average rating
@GetMapping("/{userId}/rating")
public ResponseEntity<?> getAverageRating(
        @PathVariable Long userId) {

    if (!userRepository.existsById(userId)) {
        return ResponseEntity.notFound().build();
    }

    Double averageRating =
            reviewRepository.findAverageRatingByUserId(userId);

    if (averageRating == null) {
        averageRating = 0.0;
    }

    long reviewCount =
            reviewRepository.countByReviewedUserId(userId);

    return ResponseEntity.ok(
            new RatingResponse(
                    averageRating,
                    reviewCount
            )
    );
}

public static class RatingResponse {

    private Double averageRating;
    private long reviewCount;

    public RatingResponse(
            Double averageRating,
            long reviewCount) {

        this.averageRating = averageRating;
        this.reviewCount = reviewCount;
    }

    public Double getAverageRating() {
        return averageRating;
    }

    public long getReviewCount() {
        return reviewCount;
    }
}
    
}