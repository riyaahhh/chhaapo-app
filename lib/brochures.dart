import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chappo/chhaapo_app_bar.dart';
import 'package:new_chappo/elevatedbutton.dart';
import 'package:new_chappo/upload_doc.dart';

class Brochures extends StatefulWidget {
  const Brochures({super.key});

  @override
  State<Brochures> createState() => _BrochuresState();
}

class _BrochuresState extends State<Brochures> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  String uploadedFileUrl = '';

  // PRICE CALCULATION
  int totalPrice = 0;
  int cardCost = 0;

  void calculatePrice() {
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    cardCost = quantity * 3;
    totalPrice = cardCost + 50; // + delivery charge
    setState(() {});
  }

  // FIREBASE UPLOAD FUNCTION
  Future<void> uploadBrochure({
    required int quantity,
    required int ratePerBrochure,
    required String instructions,
    required String uploadedBrochureUrl,
  }) async {
    try {
      final int totalPrice = quantity * ratePerBrochure;

      await FirebaseFirestore.instance.collection("Brochures").add({
        "Quantity": quantity,
        "Rate_Per_Brochure": ratePerBrochure,
        "Total_Price": totalPrice,
        "Instructions": instructions,
        "Design_File_URL": uploadedBrochureUrl,
        "Order_Time": Timestamp.now(),
        "Delivery_Time": Timestamp.fromDate(
          DateTime.now().add(const Duration(minutes: 10)),
        ),
      });

      print("Brochure Order Uploaded ✔️");
    } catch (e) {
      print("Error uploading brochure: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Brochure Printing Service',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 151, 21, 251),
              ),
            ),
            const Text(
              'Design and print eye-catching brochures to promote your business',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Upload & Options Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Upload Brochure Design",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),

                    UploadBox(),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => calculatePrice(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        hintText: "Enter quantity",
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Rate: ₹3 per brochure",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple)),
                    const SizedBox(height: 20),

                    TextField(
                      controller: instructionsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText:
                            "Enter any specific instructions or customization details here",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Add to Cart Button
            Customelevatedbutton(
              text: "Add to Cart",
              onPressed: () {
                int qty = int.tryParse(_quantityController.text) ?? 0;

                uploadBrochure(
                  quantity: qty,
                  ratePerBrochure: 3,
                  instructions: instructionsController.text,
                  uploadedBrochureUrl: uploadedFileUrl,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
