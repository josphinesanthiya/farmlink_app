package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/crops")
public class CropController {

    private final CropRepository cropRepository;

    public CropController(CropRepository cropRepository) {
        this.cropRepository = cropRepository;
    }

    // =========================
    // ADD CROP
    // =========================
    @PostMapping
    public ResponseEntity<?> addCrop(
            @RequestBody Crop crop,
            Authentication authentication) {

        User farmer = (User) authentication.getPrincipal();

        crop.setFarmer(farmer);

        Crop savedCrop = cropRepository.save(crop);

        return ResponseEntity.ok(savedCrop);
    }

    // =========================
    // GET ALL CROPS
    // =========================
    @GetMapping
    public ResponseEntity<List<Crop>> getAllCrops() {

        return ResponseEntity.ok(
                cropRepository.findAll()
        );
    }

    // =========================
    // GET MY CROPS
    // =========================
    @GetMapping("/my")
    public ResponseEntity<?> getMyCrops(
            Authentication authentication) {

        User farmer = (User) authentication.getPrincipal();

        List<Crop> crops =
                cropRepository.findByFarmerId(farmer.getId());

        return ResponseEntity.ok(crops);
    }

    // =========================
    // SEARCH CROPS
    // =========================
    @GetMapping("/search")
    public ResponseEntity<List<Crop>> searchCrops(
            @RequestParam String name) {

        return ResponseEntity.ok(
                cropRepository
                        .findByCropNameContainingIgnoreCase(name)
        );
    }

    // =========================
    // DELETE CROP
    // =========================
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCrop(
            @PathVariable Long id,
            Authentication authentication) {

        User farmer = (User) authentication.getPrincipal();

        Crop crop = cropRepository.findById(id)
                .orElse(null);

        if (crop == null) {
            return ResponseEntity.notFound().build();
        }

        // Only the farmer who created the crop can delete it
        if (!crop.getFarmer().getId().equals(farmer.getId())) {
            return ResponseEntity.status(403)
                    .body("You can only delete your own crops");
        }

        cropRepository.delete(crop);

        return ResponseEntity.ok("Crop deleted successfully");
    }
}