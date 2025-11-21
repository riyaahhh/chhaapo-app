import 'package:flutter/material.dart';
import 'package:new_chappo/order_confirmed.dart';

class PayUsingWalletPage extends StatefulWidget {
  final int amountToPay;

  const PayUsingWalletPage({
    super.key,
    required this.amountToPay,
  });

  @override
  State<PayUsingWalletPage> createState() => _PayUsingWalletPageState();
}

class _PayUsingWalletPageState extends State<PayUsingWalletPage> {
  int walletBalance = 1000; // default top-up wallet balance
  bool? paymentSuccess;

  void processPayment() {
    setState(() {
      if (walletBalance >= widget.amountToPay) {
        walletBalance -= widget.amountToPay;
        paymentSuccess = true;
      } else {
        paymentSuccess = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      appBar: AppBar(
        title: const Text("Wallet Payment", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ---------------- WALLET CARD ----------------
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Wallet Balance",
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    "₹$walletBalance",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- AMOUNT TO PAY ----------------
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Amount to Pay",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Text(
                    "₹${widget.amountToPay}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- PAY NOW BUTTON ----------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  processPayment();
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => OrderConfirmedPage(orderId: "CHP${DateTime.now().millisecondsSinceEpoch}",deliveryMinutes: 10,),
                  ),
);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Pay Now",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- RESULT MESSAGE ----------------
            if (paymentSuccess == true)
              _successMessage()
            else if (paymentSuccess == false)
              _failureMessage(),
          ],
        ),
      ),
    );
  }

  // SUCCESS UI
  Widget _successMessage() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Text("Payment Successful!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // FAILURE UI
  Widget _failureMessage() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Insufficient Wallet Balance!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
