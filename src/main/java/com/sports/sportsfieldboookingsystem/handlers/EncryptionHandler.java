package com.sports.sportsfieldboookingsystem.handlers;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class EncryptionHandler {
    private static final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public static String encryptPassword(String plainPassword) {
        return encoder.encode(plainPassword);
    }

    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        try {
            return encoder.matches(plainPassword, hashedPassword);
        } catch (Exception e) {
            // Log the exception
            System.err.println("Error verifying password: " + e.getMessage());
            return false;
        }
    }
    
    // For debugging purposes
    public static void main(String[] args) {
        String password = "admin123";
        String encoded = encryptPassword(password);
        System.out.println("Encoded password: " + encoded);
        System.out.println("Verification result: " + verifyPassword(password, encoded));
        
        // Test with the stored hash in the database
        String storedHash = "$2a$10$rPiEAgQNIT1TCoKi3Eqq8eVaRaAhaDJi9mDtoBHx09iyG4PzKv5fW";
        System.out.println("Verification with stored hash: " + verifyPassword(password, storedHash));
    }
}
