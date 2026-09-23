package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // Get my profile
    @GetMapping("/profile")
    public ResponseEntity<?> getProfile(
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        user.setPassword(null);

        return ResponseEntity.ok(user);
    }

    // Update my location
    @PatchMapping("/location")
    public ResponseEntity<?> updateLocation(
            @RequestBody LocationRequest request,
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        if (request.getLatitude() == null
                || request.getLongitude() == null) {

            return ResponseEntity.badRequest()
                    .body("Latitude and longitude are required");
        }

        if (request.getLatitude() < -90
                || request.getLatitude() > 90) {

            return ResponseEntity.badRequest()
                    .body("Invalid latitude");
        }

        if (request.getLongitude() < -180
                || request.getLongitude() > 180) {

            return ResponseEntity.badRequest()
                    .body("Invalid longitude");
        }

        user.setLatitude(request.getLatitude());
        user.setLongitude(request.getLongitude());
        user.setLocation(request.getLocation());

        User savedUser = userRepository.save(user);

        savedUser.setPassword(null);

        return ResponseEntity.ok(savedUser);
    }

    // Find nearby farmers/dealers
    @GetMapping("/nearby")
    public ResponseEntity<?> getNearbyUsers(
            @RequestParam String role,
            @RequestParam Double latitude,
            @RequestParam Double longitude,
            @RequestParam(defaultValue = "20") Double radius) {

        List<User> users = userRepository.findByRole(role);

        List<NearbyUserResponse> nearbyUsers = users.stream()
                .filter(user ->
                        user.getLatitude() != null
                        && user.getLongitude() != null)
                .map(user -> {

                    double distance = calculateDistance(
                            latitude,
                            longitude,
                            user.getLatitude(),
                            user.getLongitude()
                    );

                    return new NearbyUserResponse(
                            user.getId(),
                            user.getName(),
                            user.getRole(),
                            user.getLocation(),
                            user.getLatitude(),
                            user.getLongitude(),
                            Math.round(distance * 100.0) / 100.0
                    );
                })
                .filter(user -> user.getDistance() <= radius)
                .sorted((a, b) ->
                        Double.compare(
                                a.getDistance(),
                                b.getDistance()
                        ))
                .toList();

        return ResponseEntity.ok(nearbyUsers);
    }

    // Calculate distance between two locations
    private double calculateDistance(
            double lat1,
            double lon1,
            double lat2,
            double lon2) {

        final int EARTH_RADIUS = 6371;

        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);

        double a = Math.sin(latDistance / 2)
                * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1))
                * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2)
                * Math.sin(lonDistance / 2);

        double c = 2 * Math.atan2(
                Math.sqrt(a),
                Math.sqrt(1 - a)
        );

        return EARTH_RADIUS * c;
    }

    // Location request
    public static class LocationRequest {

        private Double latitude;
        private Double longitude;
        private String location;

        public Double getLatitude() {
            return latitude;
        }

        public void setLatitude(Double latitude) {
            this.latitude = latitude;
        }

        public Double getLongitude() {
            return longitude;
        }

        public void setLongitude(Double longitude) {
            this.longitude = longitude;
        }

        public String getLocation() {
            return location;
        }

        public void setLocation(String location) {
            this.location = location;
        }
    }

    // Nearby user response
    public static class NearbyUserResponse {

        private Long id;
        private String name;
        private String role;
        private String location;
        private Double latitude;
        private Double longitude;
        private Double distance;

        public NearbyUserResponse(
                Long id,
                String name,
                String role,
                String location,
                Double latitude,
                Double longitude,
                Double distance) {

            this.id = id;
            this.name = name;
            this.role = role;
            this.location = location;
            this.latitude = latitude;
            this.longitude = longitude;
            this.distance = distance;
        }

        public Long getId() {
            return id;
        }

        public String getName() {
            return name;
        }

        public String getRole() {
            return role;
        }

        public String getLocation() {
            return location;
        }

        public Double getLatitude() {
            return latitude;
        }

        public Double getLongitude() {
            return longitude;
        }

        public Double getDistance() {
            return distance;
        }
    }
}