package com.sports.sportsfieldboookingsystem.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;

import jakarta.servlet.http.HttpSession;

@Controller
public class LogoutController {
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        SessionHandler.removeUsernameSession(session);
        return "redirect:/";
    }
}
