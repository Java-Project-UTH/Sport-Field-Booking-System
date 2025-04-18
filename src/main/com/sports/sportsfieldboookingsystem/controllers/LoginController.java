package com.sports.sportsfieldboookingsystem.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;
import com.sports.sportsfieldboookingsystem.services.UserServices;

import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
    
    @Autowired
    private UserServices userServices;

    @GetMapping("/login")
    public String getLoginPage(HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser != null)
            return "redirect:/";

        return "login";
    }

    @PostMapping("/login")
    public String loginUser(String username, String password, HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser != null)
            return "redirect:/";

        System.out.println("Login attempt for user: " + username);
        
        if (userServices.verifyPassword(username, password)) {
            System.out.println("Login successful for user: " + username);
            SessionHandler.setUsernameSession(session, username);
            return "redirect:/";
        }

        System.out.println("Login failed for user: " + username);
        return "redirect:/login?error=invalid";
    }
}
