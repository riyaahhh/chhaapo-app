import 'package:flutter/material.dart';
Widget smallInvoiceCard({
  required int cardCost,
  required int deliveryCharge,
  required int total,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Price Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),

          SizedBox(height: 6),
          rowText("Card Cost", "₹$cardCost"),

          rowText("Delivery Charge", "₹$deliveryCharge"),

          Divider(height: 14, thickness: 1),

          rowText("Total", "₹$total", isTotal: true),
        ],
      ),
    ),
  );
}

Widget rowText(String label, String value, {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 13 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 13 : 12,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.green : Colors.black,
          ),
        ),
      ],
    ),
  );
}

