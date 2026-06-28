<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Security Verification - Instafoods</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      background-color: #0c0c0c;
      color: #ffffff;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      margin: 0;
      font-family: var(--font-body), sans-serif;
    }
    .quiz-container {
      background: var(--bg-card);
      border: 1px solid var(--border);
      padding: 48px;
      border-radius: 16px;
      max-width: 440px;
      width: 100%;
      box-shadow: 0 20px 50px rgba(0,0,0,0.6);
      box-sizing: border-box;
      animation: fadeSlideUp 0.6s ease both;
    }
    @keyframes fadeSlideUp {
      from { opacity: 0; transform: translateY(30px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .quiz-header {
      text-align: center;
      margin-bottom: 32px;
    }
    .quiz-header h2 {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.8rem;
      margin-bottom: 12px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .quiz-header p {
      color: var(--text-muted);
      font-size: 0.92rem;
      line-height: 1.5;
    }
    .quiz-card {
      background: #111;
      border: 1px solid rgba(255,255,255,0.06);
      padding: 24px;
      border-radius: 8px;
      text-align: center;
      margin-bottom: 24px;
    }
    .quiz-question {
      font-size: 2.2rem;
      font-family: var(--font-heading), monospace;
      font-weight: 900;
      color: var(--primary);
      letter-spacing: 2px;
      text-shadow: 0 0 10px rgba(202,255,0,0.2);
    }
    .quiz-input-field {
      width: 100%;
      background: #181818;
      border: 1.5px solid var(--border);
      padding: 16px;
      border-radius: 8px;
      color: #fff;
      font-size: 1.3rem;
      text-align: center;
      margin-bottom: 24px;
      box-sizing: border-box;
      transition: border-color 0.2s;
    }
    .quiz-input-field:focus {
      border-color: var(--primary);
      outline: none;
    }
    .quiz-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 24px;
      font-size: 0.85rem;
    }
    .quiz-footer a {
      color: var(--primary);
      text-decoration: none;
      font-weight: 800;
      font-family: var(--font-heading);
      text-transform: uppercase;
    }
    .quiz-footer a:hover {
      color: var(--primary-light);
    }
  </style>
</head>
<body>

  <%
      String email = request.getParameter("email");
      String puzzleQuestion = (String) session.getAttribute("puzzleQuestion");
      String errorMsg = (String) session.getAttribute("errorMsg");
      
      // If puzzle is somehow missing, redirect to login
      if (puzzleQuestion == null) {
          response.sendRedirect(request.getContextPath() + "/views/login.jsp");
          return;
      }
  %>

  <div class="quiz-container">

    <div class="quiz-header">
      <h2>Solve the Quiz</h2>
      <p>Your account has been locked due to 3 failed attempts. Please solve this simple math puzzle to verify your identity.</p>
    </div>

    <% if (errorMsg != null) { %>
        <div style="background-color: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #f87171; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-family: var(--font-body); font-size: 0.9rem; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <%= errorMsg %>
        </div>
    <% 
            session.removeAttribute("errorMsg");
        } 
    %>

    <div class="quiz-card">
      <div style="font-size: 0.72rem; text-transform: uppercase; font-family: var(--font-heading); font-weight: 900; color: var(--text-muted); margin-bottom: 6px; letter-spacing: 0.5px;">Mathematical Equation</div>
      <div class="quiz-question"><%= puzzleQuestion %> = ?</div>
    </div>

    <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
      <input type="hidden" name="action" value="verifyPuzzle">
      <input type="hidden" name="email" value="<%= email %>">
      
      <input type="number" name="answer" class="quiz-input-field" placeholder="Enter Answer" required autocomplete="off">
      
      <button type="submit" class="btn btn-primary" style="width: 100%; box-sizing: border-box; padding: 14px 20px;">Verify Answer</button>
    </form>

    <div class="quiz-footer">
      <span style="color: var(--text-muted);">Confused?</span>
      <a href="LoginServlet?action=newPuzzle&email=<%= java.net.URLEncoder.encode(email != null ? email : "", "UTF-8") %>">Get New Quiz</a>
    </div>

  </div>

</body>
</html>
