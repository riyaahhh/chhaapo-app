import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_chappo/payment_options.dart';

class DeliveryDetailsPage extends StatefulWidget {
  final int amountToPay;
  const DeliveryDetailsPage({super.key,required this.amountToPay});


  @override
  State<DeliveryDetailsPage> createState() => _DeliveryDetailsPageState();
}

class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool loading = false;

  Future<void> submitDeliveryDetails() async {
    setState(() => loading = true);

    try {
      await FirebaseFirestore.instance.collection("Personal_Details").add({
        "Name": nameController.text.trim(),
        "Phone": phoneController.text.trim(),
        "Email": emailController.text.trim(),
        "Pincode": pincodeController.text.trim(),
        "Address": addressController.text.trim(),
        "Order_Time": Timestamp.now(),
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Delivery details saved successfully!")),
      // );

      Navigator.pop(context);
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => loading = false);
  }

  Widget buildField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType type = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: type,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "Enter $label",
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Details"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField(label: "Full Name", controller: nameController),

            buildField(
              label: "Phone Number",
              controller: phoneController,
              type: TextInputType.phone,
            ),

            buildField(
              label: "Email",
              controller: emailController,
              type: TextInputType.emailAddress,
            ),

            buildField(
              label: "Pincode",
              controller: pincodeController,
              type: TextInputType.number,
            ),

            buildField(
              label: "Full Address",
              controller: addressController,
              maxLines: 4,
            ),

            const SizedBox(height: 10),

ElevatedButton(
  onPressed: (){
    Navigator.push(context,MaterialPageRoute(builder: (_) => PaymentOptionsPage(amountToPay: widget.amountToPay)),);
  },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Submit Details",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
