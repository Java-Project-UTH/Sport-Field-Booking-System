package com.sports.sportsfieldboookingsystem.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.Users;

@Repository
public interface UserRepository extends JpaRepository<Users, String> {
    Users findByUsername(String username);
    Users findByEmail(String email);
}
