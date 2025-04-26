package com.sports.sportsfieldboookingsystem.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.services.FavoriteService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/favorites")
public class FavoriteController {
    
    @Autowired
    private FavoriteService favoriteService;
    
    /**
     * Display user's favorite fields
     */
    @GetMapping("")
    public String getFavorites(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) {
            return "redirect:/login?error=needLogin";
        }
        
        model.addAttribute("loggedUser", loggedUser);
        
        List<SportsField> favoriteFields = favoriteService.getFavoriteFieldsByUsername(loggedUser);
        model.addAttribute("fields", favoriteFields);
        
        return "favorites";
    }
    
    /**
     * Toggle favorite status (AJAX)
     */
    @PostMapping("/toggle/{fieldId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleFavorite(
            @PathVariable Long fieldId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) {
            response.put("success", false);
            response.put("error", "Vui lòng đăng nhập để thực hiện chức năng này");
            return ResponseEntity.ok(response);
        }
        
        boolean result = favoriteService.toggleFavorite(loggedUser, fieldId);
        boolean isFavorite = favoriteService.isFavorite(loggedUser, fieldId);
        
        response.put("success", result);
        response.put("isFavorite", isFavorite);
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * Check if a field is in favorites (AJAX)
     */
    @GetMapping("/check/{fieldId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkFavorite(
            @PathVariable Long fieldId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) {
            response.put("success", false);
            response.put("error", "Vui lòng đăng nhập để thực hiện chức năng này");
            return ResponseEntity.ok(response);
        }
        
        boolean isFavorite = favoriteService.isFavorite(loggedUser, fieldId);
        
        response.put("success", true);
        response.put("isFavorite", isFavorite);
        
        return ResponseEntity.ok(response);
    }
}
