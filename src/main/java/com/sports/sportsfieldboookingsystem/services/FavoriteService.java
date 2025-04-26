package com.sports.sportsfieldboookingsystem.services;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sports.sportsfieldboookingsystem.models.Favorite;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.models.Users;
import com.sports.sportsfieldboookingsystem.repositories.FavoriteRepository;
import com.sports.sportsfieldboookingsystem.repositories.SportsFieldRepository;
import com.sports.sportsfieldboookingsystem.repositories.UserRepository;

@Service
public class FavoriteService {

    @Autowired
    private FavoriteRepository favoriteRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SportsFieldRepository sportsFieldRepository;

    /**
     * Get all favorite fields for a user
     */
    public List<SportsField> getFavoriteFieldsByUsername(String username) {
        Users user = userRepository.findByUsername(username);
        if (user == null) {
            return List.of();
        }

        List<Favorite> favorites = favoriteRepository.findByUser(user);

        return favorites.stream()
                .map(Favorite::getField)
                .collect(Collectors.toList());
    }

    /**
     * Check if a field is in user's favorites
     */
    public boolean isFavorite(String username, Long fieldId) {
        Users user = userRepository.findByUsername(username);
        Optional<SportsField> fieldOpt = sportsFieldRepository.findById(fieldId);

        if (user == null || !fieldOpt.isPresent()) {
            return false;
        }

        SportsField field = fieldOpt.get();

        return favoriteRepository.existsByUserAndField(user, field);
    }

    /**
     * Add a field to user's favorites
     */
    @Transactional
    public boolean addFavorite(String username, Long fieldId) {
        Users user = userRepository.findByUsername(username);
        Optional<SportsField> fieldOpt = sportsFieldRepository.findById(fieldId);

        if (user == null || !fieldOpt.isPresent()) {
            return false;
        }

        SportsField field = fieldOpt.get();

        // Check if already a favorite
        if (favoriteRepository.existsByUserAndField(user, field)) {
            return true; // Already a favorite
        }

        // Add to favorites
        Favorite favorite = new Favorite(user, field);
        favoriteRepository.save(favorite);

        return true;
    }

    /**
     * Remove a field from user's favorites
     */
    @Transactional
    public boolean removeFavorite(String username, Long fieldId) {
        Users user = userRepository.findByUsername(username);
        Optional<SportsField> fieldOpt = sportsFieldRepository.findById(fieldId);

        if (user == null || !fieldOpt.isPresent()) {
            return false;
        }

        SportsField field = fieldOpt.get();

        Optional<Favorite> favoriteOpt = favoriteRepository.findByUserAndField(user, field);
        if (favoriteOpt.isPresent()) {
            favoriteRepository.delete(favoriteOpt.get());
            return true;
        }

        return false;
    }

    /**
     * Toggle favorite status
     */
    @Transactional
    public boolean toggleFavorite(String username, Long fieldId) {
        if (isFavorite(username, fieldId)) {
            return removeFavorite(username, fieldId);
        } else {
            return addFavorite(username, fieldId);
        }
    }
}
