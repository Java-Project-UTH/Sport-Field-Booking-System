package com.sports.sportsfieldboookingsystem.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sports.sportsfieldboookingsystem.models.LoyaltyPoint;
import com.sports.sportsfieldboookingsystem.models.LoyaltyTransaction;
import com.sports.sportsfieldboookingsystem.models.LoyaltyTransaction.TransactionType;
import com.sports.sportsfieldboookingsystem.repositories.LoyaltyPointRepository;
import com.sports.sportsfieldboookingsystem.repositories.LoyaltyTransactionRepository;

@Service
public class LoyaltyPointService {
    
    @Autowired
    private LoyaltyPointRepository loyaltyPointRepository;
    
    @Autowired
    private LoyaltyTransactionRepository loyaltyTransactionRepository;
    
    /**
     * Lấy thông tin điểm tích lũy của người dùng
     */
    public Optional<LoyaltyPoint> getLoyaltyPointByUsername(String username) {
        return loyaltyPointRepository.findByUsername(username);
    }
    
    /**
     * Lấy hoặc tạo mới thông tin điểm tích lũy của người dùng
     */
    public LoyaltyPoint getOrCreateLoyaltyPoint(String username) {
        Optional<LoyaltyPoint> optionalLoyaltyPoint = loyaltyPointRepository.findByUsername(username);
        if (optionalLoyaltyPoint.isPresent()) {
            return optionalLoyaltyPoint.get();
        } else {
            LoyaltyPoint loyaltyPoint = new LoyaltyPoint(username);
            return loyaltyPointRepository.save(loyaltyPoint);
        }
    }
    
    /**
     * Thêm điểm cho người dùng
     */
    @Transactional
    public LoyaltyPoint addPoints(String username, Integer points, Long bookingId, String description) {
        LoyaltyPoint loyaltyPoint = getOrCreateLoyaltyPoint(username);
        loyaltyPoint.addPoints(points);
        loyaltyPoint = loyaltyPointRepository.save(loyaltyPoint);
        
        // Tạo bản ghi giao dịch
        LoyaltyTransaction transaction = new LoyaltyTransaction(
            username,
            points,
            TransactionType.EARN,
            bookingId,
            description
        );
        loyaltyTransactionRepository.save(transaction);
        
        return loyaltyPoint;
    }
    
    /**
     * Sử dụng điểm của người dùng
     */
    @Transactional
    public boolean usePoints(String username, Integer points, Long bookingId, String description) {
        LoyaltyPoint loyaltyPoint = getOrCreateLoyaltyPoint(username);
        
        if (loyaltyPoint.getPoints() < points) {
            return false; // Không đủ điểm
        }
        
        loyaltyPoint.usePoints(points);
        loyaltyPoint = loyaltyPointRepository.save(loyaltyPoint);
        
        // Tạo bản ghi giao dịch
        LoyaltyTransaction transaction = new LoyaltyTransaction(
            username,
            points,
            TransactionType.USE,
            bookingId,
            description
        );
        loyaltyTransactionRepository.save(transaction);
        
        return true;
    }
    
    /**
     * Điều chỉnh điểm của người dùng (dành cho admin)
     */
    @Transactional
    public LoyaltyPoint adjustPoints(String username, Integer points, String description) {
        LoyaltyPoint loyaltyPoint = getOrCreateLoyaltyPoint(username);
        
        if (points > 0) {
            loyaltyPoint.addPoints(points);
        } else {
            loyaltyPoint.usePoints(Math.abs(points));
        }
        
        loyaltyPoint = loyaltyPointRepository.save(loyaltyPoint);
        
        // Tạo bản ghi giao dịch
        LoyaltyTransaction transaction = new LoyaltyTransaction(
            username,
            points,
            TransactionType.ADJUST,
            null,
            description
        );
        loyaltyTransactionRepository.save(transaction);
        
        return loyaltyPoint;
    }
    
    /**
     * Lấy lịch sử giao dịch điểm của người dùng
     */
    public List<LoyaltyTransaction> getTransactionHistory(String username) {
        return loyaltyTransactionRepository.findByUsername(username);
    }
    
    /**
     * Lấy lịch sử giao dịch điểm của người dùng trong khoảng thời gian
     */
    public List<LoyaltyTransaction> getTransactionHistory(String username, LocalDateTime startDate, LocalDateTime endDate) {
        return loyaltyTransactionRepository.findByUsernameAndDateRange(username, startDate, endDate);
    }
    
    /**
     * Tính toán số điểm tích lũy từ giá trị đặt sân
     */
    public Integer calculatePointsFromBooking(Float bookingAmount) {
        // Quy đổi: 10,000 VNĐ = 1 điểm
        return Math.round(bookingAmount / 10000);
    }
    
    /**
     * Tính toán số tiền giảm giá từ điểm tích lũy
     */
    public Float calculateDiscountFromPoints(Integer points) {
        // Quy đổi: 1 điểm = 1,000 VNĐ
        return points * 1000.0f;
    }
    
    /**
     * Tính toán số tiền giảm giá dựa trên cấp độ thành viên
     */
    public Float calculateMembershipDiscount(String username, Float bookingAmount) {
        LoyaltyPoint loyaltyPoint = getOrCreateLoyaltyPoint(username);
        Float discountRate = loyaltyPoint.getDiscountRate();
        return bookingAmount * discountRate / 100;
    }
}
