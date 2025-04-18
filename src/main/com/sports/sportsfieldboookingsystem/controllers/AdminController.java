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
import com.sports.sportsfieldboookingsystem.models.FieldBooking;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.models.SportsField.FieldType;
import com.sports.sportsfieldboookingsystem.models.UserRole;
import com.sports.sportsfieldboookingsystem.models.Users;
import com.sports.sportsfieldboookingsystem.services.FieldBookingService;
import com.sports.sportsfieldboookingsystem.services.SportsFieldService;
import com.sports.sportsfieldboookingsystem.services.UserServices;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserServices userServices;

    @Autowired
    private SportsFieldService sportsFieldService;

    @Autowired
    private FieldBookingService fieldBookingService;

    @GetMapping("")
    public String adminDashboard(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        model.addAttribute("loggedUser", loggedUser);

        // Thống kê
        List<Users> users = userServices.getAllUsers();
        List<SportsField> fields = sportsFieldService.getAllFields();
        List<FieldBooking> bookings = fieldBookingService.getAllBookings();

        model.addAttribute("totalUsers", users.size());
        model.addAttribute("totalFields", fields.size());
        model.addAttribute("totalBookings", bookings.size());

        return "admin/dashboard";
    }

    @GetMapping("/fields")
    public String manageFields(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("fields", sportsFieldService.getAllFields());
        model.addAttribute("fieldTypes", FieldType.values());

        return "admin/fields";
    }

    @GetMapping("/fields/add")
    public String addFieldForm(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("fieldTypes", FieldType.values());

        return "admin/field-form";
    }

    @PostMapping("/fields/add")
    public String addField(
            @RequestParam String fieldName,
            @RequestParam String location,
            @RequestParam FieldType fieldType,
            @RequestParam Float pricePerHour,
            @RequestParam Boolean isIndoor,
            @RequestParam Boolean hasLighting,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String imageUrl,
            HttpSession session) {

        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        SportsField field = new SportsField(fieldName, location, fieldType, pricePerHour, isIndoor, hasLighting, description, imageUrl);
        sportsFieldService.saveField(field);

        return "redirect:/admin/fields?success=added";
    }

    @GetMapping("/fields/edit/{id}")
    public String editFieldForm(@PathVariable Long id, HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        Optional<SportsField> optionalField = sportsFieldService.getFieldById(id);
        if (!optionalField.isPresent()) {
            return "redirect:/admin/fields?error=notFound";
        }

        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("field", optionalField.get());
        model.addAttribute("fieldTypes", FieldType.values());

        return "admin/field-form";
    }

    @PostMapping("/fields/edit/{id}")
    public String updateField(
            @PathVariable Long id,
            @RequestParam String fieldName,
            @RequestParam String location,
            @RequestParam FieldType fieldType,
            @RequestParam Float pricePerHour,
            @RequestParam Boolean isIndoor,
            @RequestParam Boolean hasLighting,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String imageUrl,
            HttpSession session) {

        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        Optional<SportsField> optionalField = sportsFieldService.getFieldById(id);
        if (!optionalField.isPresent()) {
            return "redirect:/admin/fields?error=notFound";
        }

        SportsField field = optionalField.get();
        field.setFieldName(fieldName);
        field.setLocation(location);
        field.setFieldType(fieldType);
        field.setPricePerHour(pricePerHour);
        field.setIsIndoor(isIndoor);
        field.setHasLighting(hasLighting);
        field.setDescription(description);
        field.setImageUrl(imageUrl);

        sportsFieldService.saveField(field);

        return "redirect:/admin/fields?success=updated";
    }

    @PostMapping("/fields/delete/{id}")
    public String deleteField(@PathVariable Long id, HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        sportsFieldService.deleteField(id);

        return "redirect:/admin/fields?success=deleted";
    }

    @GetMapping("/bookings")
    public String manageBookings(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("bookings", fieldBookingService.getAllBookings());

        return "admin/bookings";
    }

    @PostMapping("/bookings/{id}/confirm")
    public String confirmBooking(@PathVariable Long id, HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        fieldBookingService.confirmBooking(id);

        return "redirect:/admin/bookings?success=confirmed";
    }

    @PostMapping("/bookings/{id}/cancel")
    public String cancelBooking(@PathVariable Long id, HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        fieldBookingService.cancelBooking(id);

        return "redirect:/admin/bookings?success=cancelled";
    }

    @PostMapping("/bookings/{id}/complete")
    public String completeBooking(@PathVariable Long id, HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        fieldBookingService.completeBooking(id);

        return "redirect:/admin/bookings?success=completed";
    }

    @GetMapping("/users")
    public String manageUsers(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("users", userServices.getAllUsers());
        model.addAttribute("roles", UserRole.values());

        return "admin/users";
    }

    @PostMapping("/users/{username}/role")
    public String updateUserRole(@PathVariable String username, @RequestParam UserRole role, HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        if (!userServices.isAdmin(loggedUser)) return "redirect:/access-denied";

        userServices.updateUserRole(username, role);

        return "redirect:/admin/users?success=roleUpdated";
    }
}