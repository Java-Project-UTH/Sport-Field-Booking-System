package com.sports.sportsfieldboookingsystem.controllers;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;
import com.sports.sportsfieldboookingsystem.models.MembershipPlan;
import com.sports.sportsfieldboookingsystem.models.UserMembership;
import com.sports.sportsfieldboookingsystem.services.MembershipService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/membership")
public class MembershipController {
    
    @Autowired
    private MembershipService membershipService;
    
    /**
     * Display membership plans
     */
    @GetMapping("")
    public String getMembershipPlans(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) {
            return "redirect:/login?error=needLogin";
        }
        
        model.addAttribute("loggedUser", loggedUser);
        
        // Get all plans
        List<MembershipPlan> plans = membershipService.getAllPlans();
        model.addAttribute("plans", plans);
        
        // Get user's current membership
        Optional<UserMembership> currentMembership = membershipService.getUserActiveMembership(loggedUser);
        currentMembership.ifPresent(membership -> model.addAttribute("currentMembership", membership));
        
        return "membership";
    }
    
    /**
     * Display membership history
     */
    @GetMapping("/history")
    public String getMembershipHistory(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) {
            return "redirect:/login?error=needLogin";
        }
        
        model.addAttribute("loggedUser", loggedUser);
        
        // Get user's membership history
        List<UserMembership> membershipHistory = membershipService.getUserMembershipHistory(loggedUser);
        model.addAttribute("membershipHistory", membershipHistory);
        
        return "membershipHistory";
    }
    
    /**
     * Display subscription form
     */
    @GetMapping("/subscribe/{planId}")
    public String getSubscriptionForm(@PathVariable Long planId, HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) {
            return "redirect:/login?error=needLogin";
        }
        
        model.addAttribute("loggedUser", loggedUser);
        
        // Get plan details
        Optional<MembershipPlan> planOpt = membershipService.getPlanById(planId);
        if (!planOpt.isPresent()) {
            return "redirect:/membership?error=planNotFound";
        }
        
        model.addAttribute("plan", planOpt.get());
        
        return "subscriptionForm";
    }
    
    /**
     * Process subscription
     */
    @PostMapping("/subscribe/{planId}")
    public String processSubscription(
            @PathVariable Long planId,
            @RequestParam(required = false) String paymentMethod,
            @RequestParam(required = false) String paymentReference,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) {
            return "redirect:/login?error=needLogin";
        }
        
        try {
            // For free plan, no payment needed
            Optional<MembershipPlan> planOpt = membershipService.getPlanById(planId);
            if (!planOpt.isPresent()) {
                return "redirect:/membership?error=planNotFound";
            }
            
            MembershipPlan plan = planOpt.get();
            
            // If it's a free plan, just subscribe
            if (plan.getPrice() == 0) {
                membershipService.subscribeToPlan(loggedUser, planId, "FREE_PLAN");
                return "redirect:/membership?success=subscribed";
            }
            
            // For paid plans, validate payment info
            if (paymentMethod == null || paymentMethod.isEmpty()) {
                return "redirect:/membership/subscribe/" + planId + "?error=paymentMethodRequired";
            }
            
            // In a real system, you would process payment here
            // For now, we'll just create the subscription
            String paymentRef = paymentReference != null ? paymentReference : "PAYMENT_" + System.currentTimeMillis();
            membershipService.subscribeToPlan(loggedUser, planId, paymentRef);
            
            return "redirect:/membership?success=subscribed";
            
        } catch (Exception e) {
            return "redirect:/membership?error=" + e.getMessage();
        }
    }
    
    /**
     * Initialize default plans (admin only)
     */
    @GetMapping("/admin/initialize-plans")
    public String initializeDefaultPlans(HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) {
            return "redirect:/login?error=needLogin";
        }
        
        // In a real system, check if user is admin
        
        membershipService.initializeDefaultPlans();
        
        return "redirect:/membership?success=plansInitialized";
    }
}
