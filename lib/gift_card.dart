import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chappo/chhaapo_app_bar.dart';
import 'package:new_chappo/elevatedbutton.dart';
import 'package:new_chappo/enumdropdown.dart';
import 'package:new_chappo/invoice.dart';
class GiftCard extends StatefulWidget {
  const GiftCard({super.key});

  @override
  State<GiftCard> createState() => _GiftCardState();
}
enum occasion {birthday, anniversary, wedding, graduation}
enum size {standard, sqaure, mini}
class _GiftCardState extends State<GiftCard> {
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  occasion? selectedOccasion = occasion.birthday;
  size? selectedSize = size.standard;
  int? selectedTemplateIndex;
  String? chosenTemplate;
  int totalPrice=0;
  int cardCost=0;
  void calculatePrice(){
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    cardCost = quantity * 40;
    totalPrice = (quantity * 40)+50; // Assuming rate is ₹40 per card
  }

final List<String> templates = [
  "assets/templates/t1.jpg",
  "assets/templates/t2.jpg",
  "assets/templates/t3.jpg",
  "assets/templates/t4.jpg",
];
Future<void> uploadGiftCard({
  required String occasion,
  required String size,
  required int quantity,
  required int ratePerCard,
  required String customMessage,
}) async {
  try {
    final int totalPrice = quantity * ratePerCard;

    await FirebaseFirestore.instance.collection("Gift_Cards").add({
      "Occasion": occasion,
      "Size": size,
      "Quantity": quantity,
      "Rate_Per_Card": ratePerCard,
      "Total_Price": totalPrice,
      "Custom_Message": customMessage,
      "Order_Time": Timestamp.now(),
      "Delivery_Time": Timestamp.fromDate(
        DateTime.now().add(const Duration(minutes: 10)),
      ),
    });

    print("Gift Card Order Uploaded ✔️");
  } catch (e) {
    print("Error uploading gift card: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(context),
      body: SingleChildScrollView(
        child: Padding(padding:  EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Gift Card Service', textAlign:TextAlign.left, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold , color: Color.fromARGB(255, 151, 21, 251)),),
            Text('Purchase gift cards for your loved ones', style: TextStyle(fontSize: 16),),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    enumDropdown<occasion>(
                       label: "Select Occasion",
                       value: selectedOccasion,
                       values: occasion.values,
                       onChanged: (val) {
                          setState(() => selectedOccasion = val);
                        },
                     ),
                     SizedBox(height: 20),
                     enumDropdown<size>(
                       label: "Select Size",
                       value: selectedSize,
                       values: size.values,
                       onChanged: (val) {
                          setState(() => selectedSize = val);
                        },
                     ),
                      SizedBox(height: 20),
                     Text('Select Quantity',style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 10),
                      Text(
  "Rate: ₹40 per card",
  style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.deepPurple,
  ),
),
                      SizedBox(height: 20),
                      Text('Custom Message you want to include',style: const TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      TextField(
                        controller: _messageController,
                         decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),    
                        ),
                      ),
                      SizedBox(height: 20),
                      buildTemplatePicker(
                        imagePaths: templates,
                        selectedIndex: selectedTemplateIndex,
                        onSelect: (index, path) {
                        setState(() {
                        selectedTemplateIndex = index;
                        chosenTemplate = path;
                        });
                         print("Selected Template: $path");
                         },
                        ),
                  ],
                ),
                ),
            ),
            SizedBox(height: 20),
            smallInvoiceCard(cardCost: cardCost, deliveryCharge: 50, total: totalPrice),
            SizedBox(height: 20),
            Customelevatedbutton(text: 'Add to Cart', onPressed: (){uploadGiftCard(
  occasion: selectedOccasion?.name ?? '',
  size: selectedSize?.name ?? '',
  quantity: int.tryParse(_quantityController.text) ?? 0,
  ratePerCard: 40,
  customMessage: _messageController.text,
);})
          ],
        ),
        ),
      ),
    );
  }
}

typedef OnTemplateSelected = void Function(String imagePath);

Widget buildTemplatePicker({
  required List<String> imagePaths,
  required int? selectedIndex,
  required Function(int index, String imagePath) onSelect,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Choose a Template",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 10),

      SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: imagePaths.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onSelect(index, imagePaths[index]),
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 3,
                    color: isSelected ? Colors.greenAccent : Colors.transparent,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePaths[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

