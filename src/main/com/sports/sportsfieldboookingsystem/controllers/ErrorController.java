package com.sports.sportsfieldboookingsystem.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class ErrorController implements org.springframework.boot.web.servlet.error.ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        model.addAttribute("loggedUser", loggedUser);
        
        Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
        
        if (statusCode != null) {
            if (statusCode == 404) {
                return "error-404";
            }
        }
        
        String errorMessage = (String) request.getAttribute("javax.servlet.error.message");
        model.addAttribute("errorMessage", errorMessage);
        
        return "error";
    }
    
    @GetMapping("/access-denied")
    public String accessDenied(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("errorMessage", "Bạn không có quyền truy cập trang này.");
        
        return "error";
    }
}
