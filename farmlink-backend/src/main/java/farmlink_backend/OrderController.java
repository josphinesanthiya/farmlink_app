package farmlink_backend;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.util.List;
@RestController
@RequestMapping("/api/orders")
public class OrderController {
    private final OrderRepository orderRepository;
    private final CropRepository cropRepository;
    private final NotificationService notificationService;

    public OrderController(
            OrderRepository orderRepository,
            CropRepository cropRepository,
            NotificationService notificationService) {

        this.orderRepository = orderRepository;
        this.cropRepository = cropRepository;
        this.notificationService = notificationService;
    }

    // =========================
    // PLACE ORDER
    // =========================
    @PostMapping
    public ResponseEntity<?> placeOrder(
            @RequestBody Order order,
            Authentication authentication) {

        User dealer = (User) authentication.getPrincipal();

        // Only DEALER can place orders
        if (!"DEALER".equalsIgnoreCase(dealer.getRole())) {
            return ResponseEntity.status(403)
                    .body("Only dealers can place orders");
        }

        // Check crop
        if (order.getCrop() == null || order.getCrop().getId() == null) {
            return ResponseEntity.badRequest()
                    .body("Crop ID is required");
        }

        Crop crop = cropRepository.findById(order.getCrop().getId())
                .orElse(null);

        if (crop == null) {
            return ResponseEntity.badRequest()
                    .body("Crop not found");
        }

        // Validate quantity
        if (order.getQuantity() == null || order.getQuantity() <= 0) {
            return ResponseEntity.badRequest()
                    .body("Quantity must be greater than zero");
        }

        if (order.getQuantity() > crop.getQuantity()) {
            return ResponseEntity.badRequest()
                    .body("Requested quantity exceeds available crop quantity");
        }

        // Set order details from authenticated user and crop
        order.setDealer(dealer);
        order.setCrop(crop);
        order.setFarmer(crop.getFarmer());

        // Calculate total price on server
        double totalPrice =
                crop.getPrice() * order.getQuantity();

        order.setTotalPrice(totalPrice);

        // New orders start as PENDING
        order.setStatus("PENDING");

        Order savedOrder = orderRepository.save(order);

notificationService.createNotification(
        order.getFarmer(),
        dealer.getName() + " placed a new order for "
                + order.getCrop().getCropName()
);

return ResponseEntity.ok(savedOrder);
    }

    // =========================
    // MY ORDERS - DEALER
    // =========================
    @GetMapping("/my")
    public ResponseEntity<?> getMyOrders(
            Authentication authentication) {

        User dealer = (User) authentication.getPrincipal();

        if (!"DEALER".equalsIgnoreCase(dealer.getRole())) {
            return ResponseEntity.status(403)
                    .body("Only dealers can view their orders");
        }

        List<Order> orders =
                orderRepository.findByDealerId(dealer.getId());

        return ResponseEntity.ok(orders);
    }

    // =========================
    // RECEIVED ORDERS - FARMER
    // =========================
    @GetMapping("/received")
    public ResponseEntity<?> getReceivedOrders(
            Authentication authentication) {

        User farmer = (User) authentication.getPrincipal();

        if (!"FARMER".equalsIgnoreCase(farmer.getRole())) {
            return ResponseEntity.status(403)
                    .body("Only farmers can view received orders");
        }

        List<Order> orders =
                orderRepository.findByFarmerId(farmer.getId());

        return ResponseEntity.ok(orders);
    }

   // =========================
// UPDATE ORDER STATUS
// =========================
@PatchMapping("/{id}/status")
public ResponseEntity<?> updateOrderStatus(
        @PathVariable Long id,
        @RequestParam String status,
        Authentication authentication) {

    User farmer = (User) authentication.getPrincipal();

    if (!"FARMER".equalsIgnoreCase(farmer.getRole())) {
        return ResponseEntity.status(403)
                .body("Only farmers can update order status");
    }

    Order order = orderRepository.findById(id)
            .orElse(null);

    if (order == null) {
        return ResponseEntity.notFound().build();
    }

    // Only the farmer who owns the crop can update the order
    if (!order.getFarmer().getId().equals(farmer.getId())) {
        return ResponseEntity.status(403)
                .body("You can only update orders received for your crops");
    }

    // Only PENDING orders can be accepted or rejected
    if (!"PENDING".equalsIgnoreCase(order.getStatus())) {
        return ResponseEntity.badRequest()
                .body("Only PENDING orders can be updated");
    }

    // =========================
    // ACCEPT ORDER
    // =========================
    if ("ACCEPTED".equalsIgnoreCase(status)) {

        Crop crop = order.getCrop();

        // Check available quantity again
        if (order.getQuantity() > crop.getQuantity()) {
            return ResponseEntity.badRequest()
                    .body("Not enough crop quantity available");
        }

        // Reduce available crop quantity
        crop.setQuantity(
                crop.getQuantity() - order.getQuantity()
        );

        cropRepository.save(crop);

        order.setStatus("ACCEPTED");
        notificationService.createNotification(
        order.getDealer(),
        "Your order for " + order.getCrop().getCropName()
                + " has been accepted by the farmer.");
    }

    // =========================
    // REJECT ORDER
    // =========================
    else if ("REJECTED".equalsIgnoreCase(status)) {

        order.setStatus("REJECTED");
        notificationService.createNotification(
        order.getDealer(),
        "Your order for " + order.getCrop().getCropName()
                + " has been rejected by the farmer.");
    }

    else {
        return ResponseEntity.badRequest()
                .body("Status must be ACCEPTED or REJECTED");
    }

    Order updatedOrder = orderRepository.save(order);

    return ResponseEntity.ok(updatedOrder);
}
}