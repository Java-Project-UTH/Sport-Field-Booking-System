package com.sports.sportsfieldboookingsystem.services;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sports.sportsfieldboookingsystem.models.MembershipPlan;
import com.sports.sportsfieldboookingsystem.models.MembershipPlan.PlanType;
import com.sports.sportsfieldboookingsystem.models.UserMembership;
import com.sports.sportsfieldboookingsystem.models.Users;
import com.sports.sportsfieldboookingsystem.repositories.MembershipPlanRepository;
import com.sports.sportsfieldboookingsystem.repositories.UserMembershipRepository;
import com.sports.sportsfieldboookingsystem.repositories.UserRepository;

@Service
public class MembershipService {

    @Autowired
    private MembershipPlanRepository membershipPlanRepository;

    @Autowired
    private UserMembershipRepository userMembershipRepository;

    @Autowired
    private UserRepository userRepository;

    /**
     * Get all membership plans
     */
    public List<MembershipPlan> getAllPlans() {
        return membershipPlanRepository.findAll();
    }

    /**
     * Get plan by ID
     */
    public Optional<MembershipPlan> getPlanById(Long id) {
        return membershipPlanRepository.findById(id);
    }

    /**
     * Get plan by type
     */
    public Optional<MembershipPlan> getPlanByType(PlanType planType) {
        return membershipPlanRepository.findByPlanType(planType);
    }

    /**
     * Get user's current active membership
     */
    public Optional<UserMembership> getUserActiveMembership(String username) {
        Users user = userRepository.findByUsername(username);
        if (user == null) {
            return Optional.empty();
        }

        return userMembershipRepository.findCurrentActiveByUser(user, new Date());
    }

    /**
     * Get user's membership history
     */
    public List<UserMembership> getUserMembershipHistory(String username) {
        Users user = userRepository.findByUsername(username);
        if (user == null) {
            return List.of();
        }

        return userMembershipRepository.findByUser(user);
    }

    /**
     * Subscribe user to a membership plan
     */
    @Transactional
    public UserMembership subscribeToPlan(String username, Long planId, String paymentReference) {
        Users user = userRepository.findByUsername(username);
        Optional<MembershipPlan> planOpt = membershipPlanRepository.findById(planId);

        if (user == null || !planOpt.isPresent()) {
            throw new IllegalArgumentException("User or plan not found");
        }

        MembershipPlan plan = planOpt.get();

        // Deactivate any current active memberships
        List<UserMembership> activeMemberships = userMembershipRepository.findActiveByUser(user, new Date());
        for (UserMembership activeMembership : activeMemberships) {
            activeMembership.setIsActive(false);
            userMembershipRepository.save(activeMembership);
        }

        // Calculate start and end dates
        Date startDate = new Date();

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(startDate);
        calendar.add(Calendar.DAY_OF_MONTH, plan.getDurationDays());
        Date endDate = calendar.getTime();

        // Create new membership
        UserMembership newMembership = new UserMembership(user, plan, startDate, endDate);
        newMembership.setPaymentReference(paymentReference);

        return userMembershipRepository.save(newMembership);
    }

    /**
     * Check if user can make a booking based on their membership
     */
    public boolean canUserMakeBooking(String username) {
        Optional<UserMembership> membershipOpt = getUserActiveMembership(username);

        if (!membershipOpt.isPresent()) {
            // If no active membership, check if there's a FREE plan
            Optional<MembershipPlan> freePlanOpt = getPlanByType(PlanType.FREE);
            if (freePlanOpt.isPresent()) {
                MembershipPlan freePlan = freePlanOpt.get();
                return true; // Free plan users can always book up to their limit
            }
            return false;
        }

        UserMembership membership = membershipOpt.get();
        return membership.canMakeBooking();
    }

    /**
     * Get max days in advance a user can book based on their membership
     */
    public int getMaxBookingDaysInAdvance(String username) {
        Optional<UserMembership> membershipOpt = getUserActiveMembership(username);

        if (!membershipOpt.isPresent()) {
            // If no active membership, check if there's a FREE plan
            Optional<MembershipPlan> freePlanOpt = getPlanByType(PlanType.FREE);
            if (freePlanOpt.isPresent()) {
                MembershipPlan freePlan = freePlanOpt.get();
                return freePlan.getMaxBookingDaysInAdvance();
            }
            return 3; // Default value for users without membership
        }

        UserMembership membership = membershipOpt.get();
        return membership.getPlan().getMaxBookingDaysInAdvance();
    }

    /**
     * Get discount percentage for a user based on their membership
     */
    public float getDiscountPercentage(String username) {
        Optional<UserMembership> membershipOpt = getUserActiveMembership(username);

        if (!membershipOpt.isPresent()) {
            return 0.0f; // No discount for users without membership
        }

        UserMembership membership = membershipOpt.get();
        return membership.getPlan().getDiscountPercentage();
    }

    /**
     * Record a booking made by the user
     */
    @Transactional
    public void recordBooking(String username) {
        Optional<UserMembership> membershipOpt = getUserActiveMembership(username);

        if (membershipOpt.isPresent()) {
            UserMembership membership = membershipOpt.get();
            membership.incrementBookingsUsed();
            userMembershipRepository.save(membership);
        }
    }

    /**
     * Initialize default membership plans if they don't exist
     */
    @Transactional
    public void initializeDefaultPlans() {
        // Check if plans already exist
        if (membershipPlanRepository.count() > 0) {
            return;
        }

        // Create FREE plan
        MembershipPlan freePlan = new MembershipPlan(
            PlanType.FREE,
            "Gói Miễn Phí",
            "Gói cơ bản dành cho người mới bắt đầu",
            0.0f,
            Integer.MAX_VALUE, // Never expires
            5, // 5 bookings per month
            3, // Can book 3 days in advance
            0.0f, // No discount
            false, // No priority support
            false // No free rescheduling
        );
        membershipPlanRepository.save(freePlan);

        // Create STANDARD plan
        MembershipPlan standardPlan = new MembershipPlan(
            PlanType.STANDARD,
            "Gói Tiêu Chuẩn",
            "Gói phổ biến với nhiều quyền lợi hơn",
            200000.0f, // 200,000 VND
            30, // 30 days
            15, // 15 bookings per month
            7, // Can book 7 days in advance
            5.0f, // 5% discount
            false, // No priority support
            true // Free rescheduling
        );
        membershipPlanRepository.save(standardPlan);

        // Create PREMIUM plan
        MembershipPlan premiumPlan = new MembershipPlan(
            PlanType.PREMIUM,
            "Gói Cao Cấp",
            "Gói cao cấp với đầy đủ quyền lợi",
            500000.0f, // 500,000 VND
            30, // 30 days
            30, // 30 bookings per month (unlimited)
            14, // Can book 14 days in advance
            10.0f, // 10% discount
            true, // Priority support
            true // Free rescheduling
        );
        membershipPlanRepository.save(premiumPlan);
    }
}
