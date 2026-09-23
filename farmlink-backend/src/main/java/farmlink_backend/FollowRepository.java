package farmlink_backend;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface FollowRepository extends JpaRepository<Follow, Long> {

    Optional<Follow> findByFollowerIdAndFollowingId(
            Long followerId,
            Long followingId
    );

    long countByFollowingId(Long userId);

    long countByFollowerId(Long userId);
}