<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods - Welcome Back</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

  <div class="auth-page">
    <!-- Left panel (Branding) -->
    <div class="auth-branding">
      <div class="branding-logo">
        <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
          <span class="logo-text">insta<span>foods</span></span>
        </a>
      </div>

      <div class="branding-hero">
        <h2>Fuel your<br>body. <span class="highlight">Fast.</span></h2>
        <p style="margin-top: 16px;">Log in to access your customized dashboard, track delivery couriers in real-time, and reorder your preferred gourmet bowls with one click.</p>
      </div>

      <div class="metric-card" style="max-width: 320px; background: rgba(255,255,255,0.03); border-color: var(--border-neon);">
        <div class="icon"><i class="fa-solid fa-medal"></i></div>
        <div class="details">
          <div class="title" style="font-size: 0.95rem; font-family: var(--font-heading); font-weight: 900;">BEST IN CLASS DELIVERIES</div>
          <div class="sub" style="font-size: 0.72rem; color: var(--text-muted);">98.6% orders delivered under 15 mins.</div>
        </div>
      </div>
    </div>

    <!-- Right panel (Login Form) -->
    <div class="auth-form-panel">
      <div class="auth-form-container">

        <div class="auth-header">
          <h1>Sign In</h1>
          <p>Access your instafoods dashboard and active tracking.</p>
        </div>

        <!-- Dynamic Success & Error Banners -->
        <%
            String errorMsg = (String) session.getAttribute("errorMsg");
            if (errorMsg != null) {
        %>
            <div style="background-color: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #f87171; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-family: var(--font-body); font-size: 0.9rem; display: flex; align-items: center; gap: 8px;">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <%= errorMsg %>
            </div>
        <%
                session.removeAttribute("errorMsg");
            }
        %>
        
        <%
            String successMsg = (String) session.getAttribute("successMsg");
            if (successMsg != null) {
        %>
            <div style="background-color: rgba(34, 197, 94, 0.15); border: 1px solid #22c55e; color: #4ade80; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-family: var(--font-body); font-size: 0.9rem; display: flex; align-items: center; gap: 8px;">
                <i class="fa-solid fa-circle-check"></i>
                <%= successMsg %>
            </div>
        <%
                session.removeAttribute("successMsg");
            }
        %>

        <!-- Submit to LoginServlet -->
        <form class="auth-form" action="${pageContext.request.contextPath}/LoginServlet" method="POST">
          <!-- Email -->
          <div class="input-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" placeholder="name@domain.com" required>
          </div>

          <!-- Password -->
          <div class="input-group">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <label for="password">Password</label>
              <a href="#" class="forgot-link" style="font-size: 0.75rem; text-transform: uppercase; font-family: var(--font-heading); font-weight: 800; letter-spacing: 0.5px;">Forgot Password?</a>
            </div>
            <div class="password-wrapper">
              <input type="password" id="password" name="password" placeholder="••••••••••••" required>
              <button type="button" class="toggle-pw" id="togglePwBtn" aria-label="Toggle password visibility">
                <i class="fa-solid fa-eye-slash" id="eyeIcon"></i>
              </button>
            </div>
          </div>

          <!-- Options -->
          <div class="form-options">
            <label>
              <input type="checkbox" name="remember">
              <span>Remember this browser</span>
            </label>
          </div>

          <!-- Action Button -->
          <button type="submit" class="btn btn-primary submit-btn">
            <span>Unlock Dashboard</span>
            <i class="fa-solid fa-arrow-right"></i>
          </button>

          <!-- Create Account Footer -->
          <p class="auth-footer">
            New to the movement? <a href="${pageContext.request.contextPath}/views/signup.jsp">Create an Account</a>
          </p>
        </form>

      </div>
    </div>
  </div>

<script>
  const toggleBtn = document.getElementById('togglePwBtn');
  const passwordInput = document.getElementById('password');
  const eyeIcon = document.getElementById('eyeIcon');

  toggleBtn.addEventListener('click', function () {
    const isHidden = passwordInput.type === 'password';
    passwordInput.type = isHidden ? 'text' : 'password';
    eyeIcon.classList.toggle('fa-eye-slash', !isHidden);
    eyeIcon.classList.toggle('fa-eye', isHidden);
  });
</script>
</body>
</html>
