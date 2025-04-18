package com.sports.sportsfieldboookingsystem.utils;

import com.sports.sportsfieldboookingsystem.models.Users;

public class RoleUtils {
    
    // Kiểm tra xem người dùng có phải là admin không
    public static boolean isAdmin(Users user) {
        // chỉ tài khoản có username là "admin" được coi là admin
        return user != null && "admin".equals(user.getUsername());
    }
    
    // Kiểm tra xem người dùng có phải là người dùng thông thường không
    public static boolean isUser(Users user) {
        // Tất cả người dùng đều là người dùng thông thường
        return user != null;
    }
}
