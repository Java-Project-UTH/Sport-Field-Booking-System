package com.sports.sportsfieldboookingsystem.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.Favorite;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.models.Users;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    
    List<Favorite> findByUser(Users user);
    
    List<Favorite> findByField(SportsField field);
    
    Optional<Favorite> findByUserAndField(Users user, SportsField field);
    
    boolean existsByUserAndField(Users user, SportsField field);
    
    void deleteByUserAndField(Users user, SportsField field);
}
