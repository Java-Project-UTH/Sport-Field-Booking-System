package com.sports.sportsfieldboookingsystem.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.MembershipPlan;
import com.sports.sportsfieldboookingsystem.models.MembershipPlan.PlanType;

@Repository
public interface MembershipPlanRepository extends JpaRepository<MembershipPlan, Long> {
    
    Optional<MembershipPlan> findByPlanType(PlanType planType);
    
}
