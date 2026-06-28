<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.instafoo.Model.Restaurant" %>
<%@ page import="com.instafoo.Model.User" %>

<%
    List<Restaurant> restaurantList = (List<Restaurant>) request.getAttribute("allrestaurant");
    User loggedInUser = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods – Bengaluru's Top Food Delivery</title>
  <meta name="description" content="Instafoods delivers Bengaluru's finest gourmet food to your doorstep in minutes. From Nagarjuna to Shiro — real-time tracking, top-tier chefs, absolute speed.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    @keyframes fadeSlideUp {
      from { opacity: 0; transform: translateY(28px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes pulse-dot {
      0%, 100% { opacity: 1; transform: scale(1); }
      50%       { opacity: 0.5; transform: scale(1.5); }
    }

    /* ---- Featured Restaurant Cards ---- */
    .feat-card {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 16px;
      overflow: hidden;
      text-decoration: none;
      color: inherit;
      display: block;
      transition: transform 0.35s cubic-bezier(0.34,1.56,0.64,1),
                  box-shadow 0.35s ease,
                  border-color 0.3s ease;
      position: relative;
      animation: fadeSlideUp 0.6s ease both;
    }
    .feat-card:nth-child(1) { animation-delay: 0.05s; }
    .feat-card:nth-child(2) { animation-delay: 0.13s; }
    .feat-card:nth-child(3) { animation-delay: 0.21s; }
    .feat-card:nth-child(4) { animation-delay: 0.29s; }
    .feat-card:nth-child(5) { animation-delay: 0.37s; }
    .feat-card:nth-child(6) { animation-delay: 0.45s; }
    .feat-card:hover {
      border-color: var(--primary);
      transform: translateY(-10px) scale(1.015);
      box-shadow: 0 24px 60px rgba(0,0,0,0.6), 0 0 28px rgba(202,255,0,0.10);
    }
    /* Shimmer on hover */
    .feat-card::before {
      content: '';
      position: absolute;
      top: 0; left: -100%; width: 55%; height: 100%;
      background: linear-gradient(105deg, transparent 20%, rgba(202,255,0,0.04) 50%, transparent 80%);
      transition: left 0.5s ease;
      z-index: 2; pointer-events: none;
    }
    .feat-card:hover::before { left: 160%; }

    .feat-img {
      width: 100%; height: 200px;
      position: relative; overflow: hidden;
    }
    .feat-img img {
      width: 100%; height: 100%; object-fit: cover;
      display: block;
      transition: transform 0.5s ease;
    }
    .feat-card:hover .feat-img img { transform: scale(1.08); }
    .feat-img::after {
      content: '';
      position: absolute; inset: 0;
      background: linear-gradient(to top, rgba(8,8,8,0.72) 0%, transparent 60%);
      pointer-events: none;
    }
    .feat-img-name {
      position: absolute; bottom: 14px; left: 16px; right: 56px;
      z-index: 3;
      font-family: var(--font-heading); font-weight: 900;
      font-size: 1.15rem; text-transform: uppercase;
      color: #fff; line-height: 1.1;
      text-shadow: 0 2px 8px rgba(0,0,0,0.7);
    }
    .feat-badge-open {
      position: absolute; top: 12px; right: 12px; z-index: 4;
      background: var(--primary); color: #000;
      font-family: var(--font-heading); font-weight: 900;
      font-size: 0.68rem; text-transform: uppercase;
      padding: 5px 13px; border-radius: 50px;
      display: flex; align-items: center; gap: 5px;
      box-shadow: 0 4px 12px rgba(202,255,0,0.35);
      animation: fadeSlideUp 0.5s ease both;
    }
    .feat-badge-closed {
      position: absolute; top: 12px; right: 12px; z-index: 4;
      background: #2a2a2a; color: var(--text-muted);
      border: 1px solid var(--border);
      font-family: var(--font-heading); font-weight: 900;
      font-size: 0.68rem; text-transform: uppercase;
      padding: 5px 13px; border-radius: 50px;
      display: flex; align-items: center; gap: 5px;
    }
    .feat-badge-open .dot {
      width: 6px; height: 6px; border-radius: 50%;
      background: #000;
      animation: pulse-dot 1.4s ease-in-out infinite;
    }
    .feat-info { padding: 16px 18px 18px; }
    .feat-cuisine {
      display: inline-block; padding: 3px 10px;
      border-radius: 4px;
      background: rgba(202,255,0,0.1);
      border: 1px solid rgba(202,255,0,0.2);
      font-family: var(--font-heading); font-weight: 800;
      font-size: 0.66rem; text-transform: uppercase;
      color: var(--primary); letter-spacing: 0.8px;
      margin-bottom: 8px;
    }
    .feat-name {
      font-family: var(--font-heading); font-size: 1.1rem;
      font-weight: 900; text-transform: uppercase;
      margin-bottom: 6px; line-height: 1.1;
    }
    .feat-address {
      font-size: 0.8rem; color: var(--text-muted);
      margin-bottom: 14px;
      display: flex; align-items: flex-start; gap: 6px;
    }
    .feat-address i { color: var(--primary); font-size: 0.72rem; margin-top: 2px; }
    .feat-meta {
      display: flex; align-items: center;
      justify-content: space-between;
      border-top: 1px solid var(--border);
      padding-top: 12px; gap: 8px; flex-wrap: wrap;
    }
    .feat-meta-group { display: flex; align-items: center; gap: 14px; }
    .feat-meta-item {
      display: flex; align-items: center; gap: 5px;
      font-size: 0.8rem; color: var(--text-muted);
    }
    .feat-meta-item i { color: var(--primary); font-size: 0.75rem; }
    .feat-meta-item strong {
      color: var(--text-primary);
      font-family: var(--font-heading); font-weight: 900; font-size: 0.88rem;
    }
    .feat-view-btn {
      display: inline-flex; align-items: center; gap: 5px;
      padding: 7px 14px; border-radius: 50px;
      border: 1px solid var(--border); color: var(--text-muted);
      font-family: var(--font-heading); font-weight: 800;
      font-size: 0.7rem; text-transform: uppercase;
      text-decoration: none; transition: all 0.25s ease;
    }
    .feat-view-btn:hover {
      background: var(--primary); border-color: var(--primary);
      color: #000;
    }
  </style>
</head>
<body>

  <!-- Header / Navigation -->
  <header class="navbar" id="navbar">
    <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
      <span class="logo-text">insta<span>foods</span></span>
    </a>
    
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/ResturantServlet">Restaurants</a></li>
      <li><a href="${pageContext.request.contextPath}/MenuServlet">Menu</a></li>
      <li><a href="${pageContext.request.contextPath}/OrderTrackerServlet">Insta-Tracker</a></li>
      <li><a href="${pageContext.request.contextPath}/CartServlet" onclick="return checkCartAccess(event)"><i class="fa-solid fa-cart-shopping" style="margin-right:5px;"></i>Cart</a></li>
    </ul>

    <div class="nav-actions">
      <%
          if (loggedInUser != null) {
              char firstLetter = 'U';
              if (loggedInUser.getUsername() != null && !loggedInUser.getUsername().trim().isEmpty()) {
                  firstLetter = loggedInUser.getUsername().trim().toUpperCase().charAt(0);
              }
      %>
          <!-- Profile Dropdown Component -->
          <div class="user-profile-dropdown">
            <button class="user-avatar-badge" onclick="toggleUserDropdown(event)" style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #caff00 0%, #00e5ff 100%); color: #000000; display: inline-flex; align-items: center; justify-content: center; font-family: var(--font-heading), sans-serif; font-weight: 900; font-size: 1.05rem; text-transform: uppercase; box-shadow: 0 0 15px rgba(202, 255, 0, 0.35); border: 1.5px solid rgba(255, 255, 255, 0.15); flex-shrink: 0; cursor: pointer; user-select: none; padding: 0; outline: none; transition: transform 0.2s ease;" title="<%= loggedInUser.getUsername() %>">
              <%= firstLetter %>
            </button>
            <div class="dropdown-menu" id="userDropdownMenu" style="display: none; position: absolute; right: 0; top: 48px; background-color: #121212; border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 8px; box-shadow: 0 10px 30px rgba(0,0,0,0.65); min-width: 160px; z-index: 1000; overflow: hidden; box-sizing: border-box; text-align: left;">
              <div style="padding: 12px 16px; border-bottom: 1px solid rgba(255, 255, 255, 0.08); font-size: 0.8rem; color: #888; font-family: var(--font-heading), sans-serif; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px; white-space: nowrap;">
                <%= loggedInUser.getUsername() %>
              </div>
              <a href="${pageContext.request.contextPath}/LogoutServlet" style="display: flex; align-items: center; gap: 8px; padding: 12px 16px; color: #ff4a4a; text-decoration: none; font-size: 0.82rem; font-family: var(--font-heading), sans-serif; font-weight: 800; text-transform: uppercase; transition: background 0.2s;" onmouseover="this.style.backgroundColor='rgba(255, 74, 74, 0.08)'" onmouseout="this.style.backgroundColor='transparent'">
                <i class="fa-solid fa-arrow-right-from-bracket" style="font-size: 0.9rem;"></i> Sign Out
              </a>
            </div>
          </div>
      <% } else { %>
          <a href="${pageContext.request.contextPath}/views/login.jsp" class="btn btn-outline" style="border: none; padding: 10px 16px;">Sign In</a>
          <a href="${pageContext.request.contextPath}/views/signup.jsp" class="btn btn-primary">Join Instafoods</a>
      <% } %>
    </div>

    <div class="hamburger" id="hamburger">
      <span></span>
      <span></span>
      <span></span>
    </div>
  </header>

  <!-- Hero Section -->
  <section class="hero">
    <div class="hero-content">
      <h1>
        Outrun your<br>
        <span class="highlight">cravings.</span>
      </h1>
      <p>
        Instafoods tracks every order, chef, and delivery route. Instant gourmet dishes delivered to your doorstep in under 15 minutes.
      </p>
      
      <div class="hero-actions">
        <a href="#menu" class="btn btn-primary">
          <span>Order Now</span>
          <i class="fa-solid fa-arrow-right"></i>
        </a>
        <a href="${pageContext.request.contextPath}/views/signup.jsp" class="btn btn-outline">
          <span>Get Free Delivery</span>
        </a>
      </div>

      <!-- Quick Metrics inside Hero -->
      <div class="metric-row">
        <div class="metric-card">
          <div class="icon"><i class="fa-solid fa-truck-fast"></i></div>
          <div class="details">
            <div class="title">12 MINS</div>
            <div class="sub">Average Delivery Time</div>
          </div>
        </div>
        <div class="metric-card">
          <div class="icon"><i class="fa-solid fa-fire-flame-curry"></i></div>
          <div class="details">
            <div class="title">HOT &amp; FRESH</div>
            <div class="sub">Gourmet Temperature Shield</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Right Side Mockup Showcases -->
    <div class="hero-visual">
      <!-- Live Tracker Mockup Phone -->
      <div class="phone-mockup">
        <div class="phone-screen">
          <div class="screen-header">
            <span>Live Activity</span>
            <span class="highlight"><i class="fa-solid fa-signal"></i></span>
          </div>
          
          <div style="text-align: center; margin: 32px 0;">
            <div style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase; font-family: var(--font-heading); font-weight: 800;">Estimated Arrival</div>
            <div style="font-size: 3.2rem; font-family: var(--font-heading); font-weight: 900; color: var(--primary); margin: 8px 0;">08:45</div>
            <div style="font-size: 0.85rem; font-weight: 600;">Rider is 1.2 miles away</div>
          </div>

          <div class="screen-card">
            <span class="label-green">On The Way</span>
            <div class="food-title">Gosht Dum Biryani</div>
            <div class="delivery-time">Prepared by Chef Iqbal • Dum Pukht Jolly Nabobs</div>
            <div class="delivery-tracker">
              <div class="tracker-bar">
                <div class="tracker-progress"></div>
              </div>
            </div>
          </div>

          <div class="screen-card" style="margin-top: auto; display: flex; align-items: center; justify-content: space-between;">
            <div>
              <div style="font-size: 0.75rem; color: var(--text-muted);">Active Order Total</div>
              <div style="font-size: 1.1rem; font-weight: 800; font-family: var(--font-heading);">₹1,460</div>
            </div>
            <button class="btn btn-primary" style="padding: 8px 14px; font-size: 0.75rem; border-radius: 4px;">Track Route</button>
          </div>
        </div>
      </div>

      <!-- Food Menu Mockup Phone -->
      <div class="phone-mockup offset">
        <div class="phone-screen">
          <div class="screen-header">
            <span>Today's Specials</span>
            <span><i class="fa-solid fa-heart" style="color: var(--primary);"></i></span>
          </div>

          <%
          if (restaurantList != null && !restaurantList.isEmpty()) {
              Restaurant first = restaurantList.get(0);
          %>
          <div class="screen-card" style="margin-top: 10px;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <span class="label-green" style="background:#ffffff;color:#000000;">Bestseller</span>
                <div class="food-title" style="font-size: 0.95rem;"><%= first.getName() %></div>
                <div style="font-size: 0.75rem; color: var(--text-muted);">₹320 • 680 kcal</div>
              </div>
              <div style="width:50px;height:50px;background:#1a0d05;border-radius:8px;border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.4rem;">🍗</div>
            </div>
          </div>
          <% } %>

          <div class="screen-card">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <span class="label-green">Trending</span>
                <div class="food-title" style="font-size: 0.95rem;">Black Garlic Tonkotsu Ramen</div>
                <div style="font-size: 0.75rem; color: var(--text-muted);">₹920 • 720 kcal</div>
              </div>
              <div style="width:50px;height:50px;background:#0a0c0e;border-radius:8px;border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.4rem;">🍜</div>
            </div>
          </div>

          <div class="screen-card">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <span class="label-green" style="background:#ff4757;color:#fff;">Chef Special</span>
                <div class="food-title" style="font-size: 0.95rem;">Galouti Kebab + Warqi Paratha</div>
                <div style="font-size: 0.75rem; color: var(--text-muted);">₹780 • 540 kcal</div>
              </div>
              <div style="width:50px;height:50px;background:#160a04;border-radius:8px;border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.4rem;">🍢</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Featured Restaurants Section -->
  <section class="section" id="restaurants" style="padding-top: 0;">
    <div class="section-header">
      <h2>Namma Bengaluru's <span class="highlight">Top Restaurants.</span></h2>
      <p>Handpicked culinary destinations from Koramangala to MG Road. Real-time open status. Delivered to your door in minutes.</p>
    </div>

    <div class="restaurant-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(310px, 1fr)); gap: 28px;">

      <%
      if (restaurantList != null && !restaurantList.isEmpty()) {
          // Show up to 6 restaurants on the landing page
          int count = 0;
          for (Restaurant r : restaurantList) {
              if (count >= 6) break;

              // Resolve image based on cuisine type
              String cuisine = r.getCuisine_type().toLowerCase();
              String imgSrc = "images/rest_modern.png";
              if (cuisine.contains("south indian"))                   imgSrc = "images/rest_south_indian.png";
              else if (cuisine.contains("north indian"))              imgSrc = "images/rest_biryani.png";
              else if (cuisine.contains("asian"))                     imgSrc = "images/rest_asian.png";
              else if (cuisine.contains("italian") || cuisine.contains("pizza")) imgSrc = "images/rest_italian.png";
              else if (cuisine.contains("cafe") || cuisine.contains("brunch"))   imgSrc = "images/rest_cafe.png";
              else if (cuisine.contains("vegetarian"))                imgSrc = "images/rest_indian.png";
              
              if (r.getImage_path() != null && !r.getImage_path().trim().isEmpty()) {
                  imgSrc = r.getImage_path();
              }
      %>

      <a href="MenuServlet?restaurant_id=<%= r.getResturant_id() %>" class="feat-card">
        <div class="feat-img">
          <img src="<%= imgSrc %>" alt="<%= r.getName() %>" loading="lazy">
          <% if (r.getIs_active()) { %>
            <span class="feat-badge-open"><span class="dot"></span>Open</span>
          <% } else { %>
            <span class="feat-badge-closed"><span class="dot" style="background:var(--text-muted);animation:none;"></span>Closed</span>
          <% } %>
          <div class="feat-img-name"><%= r.getName() %></div>
        </div>
        <div class="feat-info">
          <span class="feat-cuisine"><%= r.getCuisine_type() %></span>
          <div class="feat-name"><%= r.getName() %></div>
          <div class="feat-address"><i class="fa-solid fa-location-dot"></i><%= r.getAddress() %></div>
          <div class="feat-meta">
            <div class="feat-meta-group">
              <div class="feat-meta-item"><i class="fa-solid fa-star"></i><strong><%= r.getRating() %></strong></div>
              <div class="feat-meta-item"><i class="fa-solid fa-clock"></i><strong><%= r.getDelivery_time() %> mins</strong></div>
            </div>
            <span class="feat-view-btn">View Menu <i class="fa-solid fa-arrow-right"></i></span>
          </div>
        </div>
      </a>

      <%
              count++;
          }
      } else {
      %>
        <div style="grid-column:1/-1;text-align:center;padding:60px 20px;color:var(--text-muted);">
          <i class="fa-solid fa-utensils" style="font-size:3rem;color:var(--primary);margin-bottom:16px;display:block;"></i>
          <p>No restaurants available right now. Check back soon!</p>
        </div>
      <% } %>

    </div>

    <!-- View All Restaurants Button -->
    <div style="text-align: center; margin-top: 48px;">
      <a href="${pageContext.request.contextPath}/ResturantServlet" class="btn btn-outline">
        <span>View All Restaurants</span>
        <i class="fa-solid fa-arrow-right"></i>
      </a>
    </div>
  </section>

  <!-- CTA Section -->
  <section class="cta-section">
    <div class="cta-banner">
      <div>
        <h2>Craving Something Else? <span class="highlight">Join The Club.</span></h2>
        <p>Unlock free deliveries across Bengaluru, exclusive experimental chef menus, and priority dispatch on every order.</p>
      </div>
      <a href="${pageContext.request.contextPath}/views/signup.jsp" class="btn btn-primary" style="flex-shrink: 0;">Unlock Membership</a>
    </div>
  </section>

  <!-- Footer -->
  <footer>
    <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
      <span class="logo-text">insta<span>foods</span></span>
    </a>
    
    <p>&copy; 2026 Instafoods Technologies. Namma Bengaluru's Delivery Movement.</p>

    <ul class="footer-nav">
      <li><a href="#">Privacy policy</a></li>
      <li><a href="#">Terms of use</a></li>
      <li><a href="#">Support desk</a></li>
    </ul>
  </footer>

  <script>
    // Navbar scroll effect
    const navbar = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
      navbar.classList.toggle('scrolled', window.scrollY > 40);
    });

    // Mobile hamburger menu
    const hamburger = document.getElementById('hamburger');
    if (hamburger) {
      hamburger.addEventListener('click', () => {
        document.querySelector('.nav-links').classList.toggle('open');
        hamburger.classList.toggle('open');
      });
    }

    /* ---- Profile Dropdown Toggle ---- */
    function toggleUserDropdown(event) {
      event.stopPropagation();
      const menu = document.getElementById('userDropdownMenu');
      if (menu) {
        const isVisible = menu.style.display === 'block';
        menu.style.display = isVisible ? 'none' : 'block';
      }
    }
    window.addEventListener('click', function() {
      const menu = document.getElementById('userDropdownMenu');
      if (menu) {
        menu.style.display = 'none';
      }
    });

    function checkCartAccess(event) {
      <% if (session.getAttribute("user") == null) { %>
        alert("Please sign in to access your cart!");
        window.location.href = "${pageContext.request.contextPath}/views/login.jsp";
        if (event) event.preventDefault();
        return false;
      <% } %>
      return true;
    }
  </script>
  <script src="${pageContext.request.contextPath}/slider.js?v=4" defer></script>
</body>
</html>
