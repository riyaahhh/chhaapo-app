import 'package:flutter/material.dart';
import 'package:new_chappo/basic_print.dart';
import 'package:new_chappo/brochures.dart';
import 'package:new_chappo/bulkorder.dart';
import 'package:new_chappo/business_card.dart';
import 'package:new_chappo/chhaapo_app_bar.dart';
import 'package:new_chappo/dashcard.dart';
import 'package:new_chappo/gift_card.dart';
import 'package:new_chappo/navigation.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome to Chhapo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 99, 23, 183),
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Print to impress. Delivered by express!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your one-stop solution for all printing needs. From basic documents to custom gift cards, we deliver quality prints right to your doorstep.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              /// 📌 Using Wrap for responsiveness
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:  [
                  InkWell(
      onTap: () => navigateTo(context, BasicPrint()),
      child: const Dashcard(
        title: 'Basic Print',
        description: 'Upload your documents and get them printed with various options',
        icon: Icons.print,
      ),
    ),
    InkWell(
      onTap: () => navigateTo(context, const GiftCard()),
      child: const Dashcard(
        title: 'Gift Cards',
        description: 'Create personalized gift cards with our beautiful templates',
        icon: Icons.card_giftcard,
      ),
    ),
    InkWell(
      onTap: () => navigateTo(context, const BusinessCard()),
      child: const Dashcard(
        title: 'Business Cards',
        description: 'Professional business cards printed to perfection',
        icon: Icons.business_center,
      ),
    ),
    InkWell(
      onTap: () => navigateTo(context, const Brochures()),
      child: const Dashcard(
        title: 'Brochures',
        description: 'Eye-catching brochures for your business needs',
        icon: Icons.description_outlined,
      ),
    ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: 360,
                height: 150,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 30,
                              color: Color.fromARGB(255, 93, 14, 192),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Need Bulk Orders?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Contact us for special pricing and services',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {navigateTo(context, Bulkorder());},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Request Bulk Quote',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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
