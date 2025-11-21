import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderConfirmedPage extends StatelessWidget {
  final int deliveryMinutes;   // usually 10 minutes
  final String orderId;

  const OrderConfirmedPage({
    super.key,
    this.deliveryMinutes = 10,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // ---------- ✔ SUCCESS ANIMATION ----------
              

              const SizedBox(height: 20),

              // ---------- ORDER CONFIRMED TITLE ----------
              const Text(
                "Order Confirmed!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5A00D2),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Your order has been placed successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 30),

              // ---------- DELIVERY TIME CARD ----------
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.timer, size: 40, color: Colors.deepPurple),
                    const SizedBox(height: 10),
                    Text(
                      "Estimated Delivery Time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$deliveryMinutes Minutes",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ---------- ORDER ID ----------
              Text(
                "Order ID: $orderId",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),

              // ---------- RETURN HOME BUTTON ----------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
