package farmlink_backend;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CropRepository extends JpaRepository<Crop, Long> {

    // Get all crops added by a particular farmer
    List<Crop> findByFarmerId(Long farmerId);

    // Search crops by crop name
    List<Crop> findByCropNameContainingIgnoreCase(String cropName);
}