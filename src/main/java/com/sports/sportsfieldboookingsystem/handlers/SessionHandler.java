package com.sports.sportsfieldboookingsystem.handlers;

import jakarta.servlet.http.HttpSession;

public class SessionHandler {
    private static final String USERNAME_SESSION_KEY = "loggedUser";

    public static String getUsernameSession(HttpSession session) {
        return (String) session.getAttribute(USERNAME_SESSION_KEY);
    }

    public static void setUsernameSession(HttpSession session, String username) {
        session.setAttribute(USERNAME_SESSION_KEY, username);
    }

    public static void removeUsernameSession(HttpSession session) {
        session.removeAttribute(USERNAME_SESSION_KEY);
    }
}
