package com.sports.sportsfieldboookingsystem.repositories;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.UserMembership;
import com.sports.sportsfieldboookingsystem.models.Users;

@Repository
public interface UserMembershipRepository extends JpaRepository<UserMembership, Long> {
    
    List<UserMembership> findByUser(Users user);
    
    @Query("SELECT um FROM UserMembership um WHERE um.user = ?1 AND um.isActive = true AND um.endDate > ?2 ORDER BY um.endDate DESC")
    List<UserMembership> findActiveByUser(Users user, Date currentDate);
    
    Optional<UserMembership> findTopByUserOrderByEndDateDesc(Users user);
    
    @Query("SELECT um FROM UserMembership um WHERE um.user = ?1 AND um.isActive = true AND um.endDate > ?2 ORDER BY um.endDate DESC")
    Optional<UserMembership> findCurrentActiveByUser(Users user, Date currentDate);
    
}
