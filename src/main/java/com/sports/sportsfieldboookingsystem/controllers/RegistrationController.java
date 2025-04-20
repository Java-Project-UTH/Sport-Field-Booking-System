package com.sports.sportsfieldboookingsystem.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;
import com.sports.sportsfieldboookingsystem.services.UserServices;

import jakarta.servlet.http.HttpSession;

@Controller
public class RegistrationController {
    
    @Autowired
    private UserServices userServices;

    @GetMapping("/register")
    public String getRegisterPage(HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser != null)
            return "redirect:/";

        return "register";
    }

    @PostMapping("/register")
    public String registerUser(String username, String password, String name, String email, String phone_number,
            Integer age, String gender, String address, HttpSession session) {

        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser != null)
            return "redirect:/";
        
        // Check if username already exists
        if (userServices.findByUsername(username) != null) {
            return "redirect:/register?error=usernameExists";
        }
        
        // Check if email already exists
        if (userServices.findByEmail(email) != null) {
            return "redirect:/register?error=emailExists";
        }

        userServices.insertOneUser(username, password, name, email, phone_number, age, gender, address);

        return "redirect:/login?registered=true";
    }
}
