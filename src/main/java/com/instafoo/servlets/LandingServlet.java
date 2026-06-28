package com.instafoo.servlets;

import java.io.IOException;
import java.util.List;

import com.instafoo.Model.Restaurant;
import com.instafoo.daoImp.RestaurantDaoImp;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/LandingServlet")
public class LandingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RestaurantDaoImp restaurantDao = new RestaurantDaoImp();
        List<Restaurant> allrestaurant = restaurantDao.getAllRestaurants();

        req.setAttribute("allrestaurant", allrestaurant);

        RequestDispatcher rd = req.getRequestDispatcher("views/landing.jsp");
        rd.forward(req, resp);
    }
}