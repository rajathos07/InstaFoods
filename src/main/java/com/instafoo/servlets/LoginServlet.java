package com.instafoo.servlets;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.instafoo.Model.User;
import com.instafoo.dao.UserDao;
import com.instafoo.daoImp.UserDaoImp;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Track lockout failed attempts per email across sessions
    private static final Map<String, Integer> failedAttemptsMap = new ConcurrentHashMap<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        
        if ("newPuzzle".equals(action) && email != null && !email.trim().isEmpty()) {
            generatePuzzle(request);
            HttpSession session = request.getSession();
            session.setAttribute("successMsg", "A new math puzzle has been generated.");
            response.sendRedirect("views/verify-puzzle.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
        } else {
            response.sendRedirect("views/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        UserDao userDao = new UserDaoImp();
        
        // Action: Verify Math Puzzle Answer
        if ("verifyPuzzle".equals(action)) {
            String email = request.getParameter("email");
            String userAnswer = request.getParameter("answer");
            
            if (email != null && userAnswer != null) {
                email = email.toLowerCase().trim();
                String correctAnswer = (String) session.getAttribute("puzzleAnswer");
                
                if (userAnswer.trim().equals(correctAnswer)) {
                    // Quiz solved! Clear puzzle state
                    session.removeAttribute("puzzleQuestion");
                    session.removeAttribute("puzzleAnswer");
                    
                    // Check if email exists in database
                    List<User> userList = userDao.getAllUser();
                    User matchedUser = null;
                    for (User u : userList) {
                        if (u.getEmail().equalsIgnoreCase(email)) {
                            matchedUser = u;
                            break;
                        }
                    }
                    
                    if (matchedUser != null) {
                        // User exists: forward to reset password page
                        response.sendRedirect("views/reset-password.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                    } else {
                        // User does not exist: clear failures and send to sign up page
                        failedAttemptsMap.remove(email);
                        session.setAttribute("errorMsg", "Email address not found. Please create a new account.");
                        response.sendRedirect("views/signup.jsp");
                    }
                    return;
                }
            }
            // Failed quiz: generate new puzzle and reload
            session.setAttribute("errorMsg", "Incorrect answer. Please solve the puzzle again.");
            generatePuzzle(request);
            response.sendRedirect("views/verify-puzzle.jsp?email=" + java.net.URLEncoder.encode(email != null ? email : "", "UTF-8"));
            return;
        }

        // Action: Reset Password
        if ("resetPassword".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (email != null && password != null && confirmPassword != null) {
                email = email.toLowerCase().trim();
                
                if (!password.equals(confirmPassword)) {
                    session.setAttribute("errorMsg", "Passwords do not match. Please try again.");
                    response.sendRedirect("views/reset-password.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                    return;
                }
                
                // Fetch user to update
                List<User> userList = userDao.getAllUser();
                User targetUser = null;
                for (User u : userList) {
                    if (u.getEmail().equalsIgnoreCase(email)) {
                        targetUser = u;
                        break;
                    }
                }
                
                if (targetUser != null) {
                    // Update password in DB
                    targetUser.setPassword(password);
                    userDao.updateUser(targetUser);
                    
                    // Reset lockout state
                    failedAttemptsMap.remove(email);
                    session.setAttribute("successMsg", "Password reset successful! You can now sign in with your new password.");
                    response.sendRedirect("views/login.jsp");
                    return;
                }
            }
            session.setAttribute("errorMsg", "An error occurred during password reset.");
            response.sendRedirect("views/login.jsp");
            return;
        }

        // Action: Standard Login Submit
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Email is required.");
            response.sendRedirect("views/login.jsp");
            return;
        }

        email = email.toLowerCase().trim();

        // Check if already locked out
        int attempts = failedAttemptsMap.getOrDefault(email, 0);
        if (attempts >= 3) {
            if (session.getAttribute("puzzleQuestion") == null) {
                generatePuzzle(request);
            }
            session.setAttribute("errorMsg", "Account locked due to 3 failed attempts. Please solve the quiz to unlock.");
            response.sendRedirect("views/verify-puzzle.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
            return;
        }

        List<User> userList = userDao.getAllUser();
        User matchedUser = null;

        for (User u : userList) {
            if (u.getEmail().equalsIgnoreCase(email) && u.getPassword().equals(password)) {
                matchedUser = u;
                break;
            }
        }

        if (matchedUser != null) {
            // Successful login: store user in session and clear failures
            session.setAttribute("user", matchedUser);
            failedAttemptsMap.remove(email);
            response.sendRedirect("ResturantServlet");
        } else {
            // Failed login attempt
            attempts = failedAttemptsMap.getOrDefault(email, 0) + 1;
            failedAttemptsMap.put(email, attempts);
            
            if (attempts < 3) {
                session.setAttribute("errorMsg", "Invalid email address or password. " + (3 - attempts) + " attempt(s) remaining.");
                response.sendRedirect("views/login.jsp");
            } else {
                // Max attempts reached: lock account, generate math quiz
                generatePuzzle(request);
                session.setAttribute("errorMsg", "Account locked due to 3 failed attempts. Please solve the quiz to unlock.");
                response.sendRedirect("views/verify-puzzle.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
            }
        }
    }

    // Helper method to generate a simple math equation
    private void generatePuzzle(HttpServletRequest request) {
        Random rand = new Random();
        int op = rand.nextInt(3); // 0: +, 1: -, 2: *
        int a = 2 + rand.nextInt(18); // 2 to 19
        int b = 2 + rand.nextInt(18);
        
        String question;
        int answer;
        
        if (op == 0) {
            question = a + " + " + b;
            answer = a + b;
        } else if (op == 1) {
            if (a < b) {
                int temp = a;
                a = b;
                b = temp;
            }
            question = a + " - " + b;
            answer = a - b;
        } else {
            a = 2 + rand.nextInt(8); // smaller range for multiplication
            b = 2 + rand.nextInt(8);
            question = a + " * " + b;
            answer = a * b;
        }
        
        HttpSession session = request.getSession();
        session.setAttribute("puzzleQuestion", question);
        session.setAttribute("puzzleAnswer", String.valueOf(answer));
    }
}