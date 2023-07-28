package com.fsoft.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fsoft.model.Cart;
import com.fsoft.model.CartDetail;

import jakarta.servlet.http.HttpSession;

@Service
public class ShoppingCartService {
    private static final String CART_SESSION_KEY = "cart";

    @Autowired
    private HttpSession httpSession;

    public Cart getCart() {
        Cart cart = (Cart) httpSession.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new Cart();
            httpSession.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }

    public void addToCart(CartDetail cartItem) {
        Cart cart = getCart();
        List<CartDetail> cartItems = cart.getCartCartDetails();
        if (cartItems == null) {
            cartItems = new ArrayList<>();
            cart.setCartCartDetails(cartItems);
        }
        
        boolean existingItem = false;
        
        for (CartDetail item : cartItems) {
            if (item.getColor().getColorId() == cartItem.getColor().getColorId()) {
                item.setQuantity(item.getQuantity() + 1);
                existingItem = true;
                break;
            }
        }
        
        if (!existingItem) {
            cartItems.add(cartItem);
            cartItem.setCart(cart);
        }
    }
    
    public void removeCart(int colorId) {
        Cart cart = getCart();
        List<CartDetail> cartItems = cart.getCartCartDetails();
        
        if (cartItems != null) {
            Iterator<CartDetail> iterator = cartItems.iterator();
            
            while (iterator.hasNext()) {
                CartDetail cartItem = iterator.next();
                
                if (cartItem.getColor().getColorId() == colorId) {
                    iterator.remove();
                    break;
                }
            }
        }
    }

    public double getCartTotalAmount() {
        Cart cart = getCart();
        double totalAmount = 0.0;
        List<CartDetail> cartItems = cart.getCartCartDetails();
        if (cartItems != null) {
            for (CartDetail cartItem : cartItems) {
                double itemPrice = cartItem.getProduct().getPrice();
                int quantity = cartItem.getQuantity();
                totalAmount += itemPrice * quantity;
            }
        }
        return totalAmount;
    }
   public CartDetail updateCart(int colorId, int quantity) {
        Cart cart = getCart();
        List<CartDetail> cartItems = cart.getCartCartDetails();

        if (cartItems != null) {
            for (CartDetail cartItem : cartItems) {
                if (cartItem.getColor().getColorId() == colorId) {
                    cartItem.setQuantity(quantity);
                    return cartItem;
                }
            }
        }
        
        return null;
    }
   public int getQuantity(int colorId) {
        Cart cart = getCart();
        List<CartDetail> cartItems = cart.getCartCartDetails();

        if (cartItems != null) {
            for (CartDetail cartItem : cartItems) {
                if (cartItem.getColor().getColorId() == colorId) {
                    return cartItem.getQuantity();
                }
            }
        }
        
        return 0;
    }
}
