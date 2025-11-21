import 'package:flutter/material.dart';
import 'package:new_chappo/cart.dart';
AppBar CustomAppBar(BuildContext context) {
  return AppBar(
    title: Row(
      children: [
        const Icon(Icons.adf_scanner_outlined, color: Colors.black),
        const SizedBox(width: 8),
        const Text(
          'Chhapo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 119, 63, 251),
          ),
        ),
        const SizedBox(width: 130),

        // CART BUTTON
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            );
          },
          icon: const Icon(Icons.shopping_cart),
        ),
      ],
    ),
  );
}
