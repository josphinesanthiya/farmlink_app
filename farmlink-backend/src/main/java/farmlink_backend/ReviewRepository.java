package farmlink_backend;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<Review, Long> {

    List<Review> findByReviewedUserIdOrderByCreatedAtDesc(
            Long userId
    );

    Optional<Review> findByReviewerIdAndReviewedUserId(
            Long reviewerId,
            Long reviewedUserId
    );

    long countByReviewedUserId(Long userId);
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.reviewedUser.id = :userId")
Double findAverageRatingByUserId(@Param("userId") Long userId);
}