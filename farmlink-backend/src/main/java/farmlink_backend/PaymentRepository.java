package farmlink_backend;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PaymentRepository extends JpaRepository<Payment, Long> {

    Optional<Payment> findByOrderId(Long orderId);

    List<Payment> findByOrderDealerId(Long dealerId);

    List<Payment> findByOrderFarmerId(Long farmerId);
}