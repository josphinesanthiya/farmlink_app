package farmlink_backend;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {

    private final PaymentRepository paymentRepository;
    private final OrderRepository orderRepository;
    private final NotificationService notificationService;

    public PaymentController(
            PaymentRepository paymentRepository,
            OrderRepository orderRepository,
            NotificationService notificationService) {

        this.paymentRepository = paymentRepository;
        this.orderRepository = orderRepository;
        this.notificationService = notificationService;
    }

    // Create payment for an order
    @PostMapping("/order/{orderId}")
    public ResponseEntity<?> createPayment(
            @PathVariable Long orderId,
            @RequestBody PaymentRequest request,
            Authentication authentication) {

        User dealer = (User) authentication.getPrincipal();

        Order order = orderRepository.findById(orderId)
                .orElse(null);

        if (order == null) {
            return ResponseEntity.notFound().build();
        }

        if (!order.getDealer().getId().equals(dealer.getId())) {
            return ResponseEntity.status(403)
                    .body("Only the dealer who placed the order can make payment");
        }

        if (!"ACCEPTED".equalsIgnoreCase(order.getStatus())) {
            return ResponseEntity.badRequest()
                    .body("Payment is available only for accepted orders");
        }

        if (paymentRepository.findByOrderId(orderId).isPresent()) {
            return ResponseEntity.badRequest()
                    .body("Payment already exists for this order");
        }

        if (request.getPaymentMethod() == null
                || request.getPaymentMethod().isBlank()) {

            return ResponseEntity.badRequest()
                    .body("Payment method is required");
        }

        Payment payment = new Payment();

        payment.setOrder(order);
        payment.setAmount(order.getTotalPrice());
        payment.setPaymentMethod(request.getPaymentMethod());
        payment.setStatus("SUCCESS");

        Payment savedPayment = paymentRepository.save(payment);

        notificationService.createNotification(
                order.getFarmer(),
                dealer.getName()
                        + " completed payment for your order."
        );

        return ResponseEntity.ok(savedPayment);
    }

    // Get payment for a specific order
    @GetMapping("/order/{orderId}")
    public ResponseEntity<?> getPayment(
            @PathVariable Long orderId,
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        Order order = orderRepository.findById(orderId)
                .orElse(null);

        if (order == null) {
            return ResponseEntity.notFound().build();
        }

        if (!order.getDealer().getId().equals(user.getId())
                && !order.getFarmer().getId().equals(user.getId())) {

            return ResponseEntity.status(403)
                    .body("You are not authorized to view this payment");
        }

        Payment payment = paymentRepository
                .findByOrderId(orderId)
                .orElse(null);

        if (payment == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(payment);
    }

    // Get payments made by dealer
    @GetMapping("/my")
    public ResponseEntity<?> getMyPayments(
            Authentication authentication) {

        User user = (User) authentication.getPrincipal();

        List<Payment> payments;

        if ("DEALER".equalsIgnoreCase(user.getRole())) {

            payments = paymentRepository
                    .findByOrderDealerId(user.getId());

        } else if ("FARMER".equalsIgnoreCase(user.getRole())) {

            payments = paymentRepository
                    .findByOrderFarmerId(user.getId());

        } else {

            return ResponseEntity.status(403)
                    .body("Only farmers and dealers can view payment history");
        }

        return ResponseEntity.ok(payments);
    }

    public static class PaymentRequest {

        private String paymentMethod;

        public String getPaymentMethod() {
            return paymentMethod;
        }

        public void setPaymentMethod(String paymentMethod) {
            this.paymentMethod = paymentMethod;
        }
    }
}