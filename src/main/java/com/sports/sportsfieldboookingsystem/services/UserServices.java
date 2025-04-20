package com.sports.sportsfieldboookingsystem.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sports.sportsfieldboookingsystem.handlers.EncryptionHandler;
import com.sports.sportsfieldboookingsystem.models.UserRole;
import com.sports.sportsfieldboookingsystem.models.Users;
import com.sports.sportsfieldboookingsystem.repositories.UserRepository;

@Service
public class UserServices {

    @Autowired
    private UserRepository userRepository;

    public List<Users> getAllUsers() {
        return userRepository.findAll();
    }

    public Users findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public Users findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public Users insertOneUser(String username, String password, String name, String email, String phone_number,
            Integer age, String gender, String address) {

        String hashedPassword = EncryptionHandler.encryptPassword(password);

        Users user = new Users(username, hashedPassword, name, email, phone_number, age, gender, address);
        return userRepository.save(user);
    }

    public boolean verifyPassword(String username, String password) {
        Users user = userRepository.findByUsername(username);
        if (user == null) {
            System.out.println("User not found: " + username);
            return false;
        }

        // Debug information
        System.out.println("Verifying password for user: " + username);
        System.out.println("Stored password hash: " + user.getPassword());

        boolean result = EncryptionHandler.verifyPassword(password, user.getPassword());
        System.out.println("Verification result: " + result);

        return result;
    }

    public Users updateUser(Users user) {
        return userRepository.save(user);
    }

    public void deleteUser(String username) {
        userRepository.deleteById(username);
    }

    public boolean isAdmin(String username) {
        Users user = findByUsername(username);
        return user != null && UserRole.ADMIN.equals(user.getRole());
    }

    public Users updateUserRole(String username, UserRole role) {
        Users user = findByUsername(username);
        if (user != null) {
            user.setRole(role);
            return userRepository.save(user);
        }
        return null;
    }
}
