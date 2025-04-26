package com.sports.sportsfieldboookingsystem.repositories;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.LoyaltyTransaction;
import com.sports.sportsfieldboookingsystem.models.LoyaltyTransaction.TransactionType;

@Repository
public interface LoyaltyTransactionRepository extends JpaRepository<LoyaltyTransaction, Long> {
    
    List<LoyaltyTransaction> findByUsername(String username);
    
    List<LoyaltyTransaction> findByUsernameAndType(String username, TransactionType type);
    
    List<LoyaltyTransaction> findByBookingId(Long bookingId);
    
    @Query("SELECT lt FROM LoyaltyTransaction lt WHERE lt.username = ?1 AND lt.transactionDate BETWEEN ?2 AND ?3")
    List<LoyaltyTransaction> findByUsernameAndDateRange(String username, LocalDateTime startDate, LocalDateTime endDate);
}
