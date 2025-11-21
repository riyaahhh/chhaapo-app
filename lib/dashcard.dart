import 'package:flutter/material.dart';
import 'package:new_chappo/elevatedbutton.dart';
class Dashcard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  const Dashcard({super.key, required this.title, required this.description, required this.icon});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 210,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: Color.fromARGB(255, 93, 14, 192)),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              Text(description , textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              const SizedBox(height: 12),
              Customelevatedbutton(text: 'Get Started', onPressed: (){}),
            ],
          ),
        ),
      ),
    );
  }
}