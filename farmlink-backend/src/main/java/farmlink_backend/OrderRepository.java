package farmlink_backend;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {

    // Orders placed by a dealer
    List<Order> findByDealerId(Long dealerId);

    // Orders received by a farmer
    List<Order> findByFarmerId(Long farmerId);

    // Orders for a particular crop
    List<Order> findByCropId(Long cropId);

    // Orders with a particular status
    List<Order> findByStatus(String status);
}
