import 'package:flutter/material.dart';
import 'package:new_chappo/chhaapo_app_bar.dart';
import 'package:new_chappo/elevatedbutton.dart';
import 'package:new_chappo/upload_doc.dart';
class Bulkorder extends StatefulWidget {
  const Bulkorder({super.key});

  @override
  State<Bulkorder> createState() => _BulkorderState();
}

class _BulkorderState extends State<Bulkorder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Bulk Order Service', textAlign:TextAlign.left, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold , color: Color.fromARGB(255, 151, 21, 251)),),
            Text('Place large orders with special discounts and offers', style: TextStyle(fontSize: 16),),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter Bulk Order Details',style: const TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextField(
                      maxLines: 4,
                       decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        hintText: 'Provide details about your bulk order requirements',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Upload Relevant Documents',style: const TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    UploadBox(),
                    SizedBox(height: 20),
                    CustomTextField('Select Quantity', 'Select Quantity'),
                    SizedBox(height: 20),
                    CustomTextField('Enter Your Email', 'Enter Your Email'),
                    SizedBox(height: 20),
                    CustomTextField('Enter Phone Number', 'Enter Phone Number'),
                    SizedBox(height: 20),
                    Customelevatedbutton(text: 'Add to Cart', onPressed: (){}) 
                  ],
                ),
                ),
            )
          ],
        ),
        ),
      ),
    );
  }
}
Widget CustomTextField(String hint, String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      TextField(
         decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          hintText: hint,
        ),
      ),
    ],
  );
}