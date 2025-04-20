package com.sports.sportsfieldboookingsystem.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
    @GetMapping("/")
    public String getHomePage(HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser != null) return "redirect:/user/profile";
        
        return "home";
    }
}
