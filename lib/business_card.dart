import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chappo/chhaapo_app_bar.dart';
import 'package:new_chappo/elevatedbutton.dart';
import 'package:new_chappo/enumdropdown.dart';
import 'package:new_chappo/invoice.dart';
import 'package:new_chappo/upload_doc.dart';
class BusinessCard extends StatefulWidget {
  const BusinessCard({super.key});

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}
enum size {standard, sqaure, mini}
class _BusinessCardState extends State<BusinessCard> {
  size? selectedsize = size.standard;
  TextEditingController _quantityController = TextEditingController();
  int totalPrice=0;
  int cardCost=0;
  void calculatePrice(){
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    cardCost = quantity * 5;
    totalPrice = (quantity * 5)+50; 
  }
  Future<void> uploadBusinessCard({
  required String cardSize,
  required int quantity,
  required int ratePerCard,
}) async {
  try {
    final int totalPrice = quantity * ratePerCard;

    await FirebaseFirestore.instance.collection("Business_Cards").add({
      "Card_Size": cardSize,
      "Quantity": quantity,
      "Rate_Per_Card": ratePerCard,
      "Total_Price": totalPrice,
      "Order_Time": Timestamp.now(),
      "Delivery_Time": Timestamp.fromDate(
        DateTime.now().add(const Duration(minutes: 10)),
      ),
    });

    print("Business Card Order Uploaded ✔️");
  } catch (e) {
    print("Error uploading business card: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Business Card Service', textAlign:TextAlign.left, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold , color: Color.fromARGB(255, 151, 21, 251)),),
              Text('Create professional business cards to make a lasting impression', style: TextStyle(fontSize: 16),),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SingleChildScrollView(
                  child: Padding(padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      enumDropdown(label: 'Select Your Business card size', value:selectedsize , values: size.values, onChanged: (val){
                        setState(() {
                          selectedsize = val;
                        }
                        );
                      }),
                      SizedBox(height: 20),
                      UploadBox(),
                      SizedBox(height: 20),
                      Text('Select Quantity',style: const TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                        TextField(
                          controller: _quantityController,
                          onChanged: (_) => calculatePrice(),
                          keyboardType: TextInputType.number,
                           decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text('Rate: ₹5 per card',style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple,
                        )),
                    ],
                  ),
                  ),
                ),
            ),
             SizedBox(height: 20),
            smallInvoiceCard(cardCost: cardCost, deliveryCharge: 50, total: totalPrice),
SizedBox(height: 20),
Customelevatedbutton(
  text: 'Add to Cart',
  onPressed: () async {
    final int quantity = int.tryParse(_quantityController.text) ?? 0;
    final String cardSize = selectedsize?.toString().split('.').last ?? 'standard';
    await uploadBusinessCard(
      cardSize: cardSize,
      quantity: quantity,
      ratePerCard: 5,
    );
    setState(() {
      calculatePrice();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Business card order uploaded')),
    );
  },
),
            ],
          ),
        ),
      )
    );
  }
}