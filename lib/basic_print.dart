import 'package:flutter/material.dart';
import 'package:new_chappo/chhaapo_app_bar.dart';
import 'package:new_chappo/firebase_options.dart';
import 'package:new_chappo/upload_doc.dart';
import 'package:new_chappo/elevatedbutton.dart';
import 'package:new_chappo/chhaapo_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BasicPrint extends StatefulWidget {
  const BasicPrint({super.key});

  @override
  State<BasicPrint> createState() => _BasicPrintState();
}

// -------- ENUMS -------- //
enum OrientationType { portrait, landscape }
enum PaperType { normal, glossy }
enum PrintColor { black_white, colored }
enum PrintSide { front, front_back }
enum Binding { no_binding, stapled, spiral }

class _BasicPrintState extends State<BasicPrint> {
  // -------- CONTROLLERS -------- //
  final TextEditingController _pagesController = TextEditingController();
  final TextEditingController _copiesController = TextEditingController();

  // -------- USER SELECTIONS -------- //
  OrientationType? _orientation = OrientationType.landscape;
  PaperType? _paperType = PaperType.normal;
  PrintColor? _color = PrintColor.black_white;
  PrintSide? _printSide = PrintSide.front;
  Binding? _binding = Binding.no_binding;
  bool lamination = false;

  // -------- PRICE VARIABLES -------- //
  int totalPrice = 0;
  int paperCost = 0, bindingCost = 0, laminationCost = 0, colorCost = 0,totalPages=0;
  String paperTypeName = "Normal";
  String colorTypeName = "Black & White";
  String bindingTypeName = "No Binding";
  String laminationType = "No Lamination";
  
  

  @override
  void initState() {
    super.initState();
    _pagesController.addListener(calculatePrice);
    _copiesController.addListener(calculatePrice);
  }

  // -------- PRICE CALCULATION -------- //
  void calculatePrice() {
    final int pages = int.tryParse(_pagesController.text) ?? 0;
    final int copies = int.tryParse(_copiesController.text) ?? 0;
    final int totalPages = pages * copies;

    // Color rate
    int colorRate =0;
    if (_color == PrintColor.black_white) {
      colorRate = 1;
      colorTypeName = "Black & White";
    } else if (_color == PrintColor.colored) {
      colorRate = 5;
      colorTypeName = "Colored";
    }
    colorCost = pages * copies * colorRate;

    // Paper rate
    int paperRate = 0;
    if (_paperType == PaperType.normal) {
      paperRate = 2;
      paperTypeName = "Normal Paper";
    } else if (_paperType == PaperType.glossy) {
      paperRate = 4;
      paperTypeName = "Glossy Paper";
    }
    paperCost = pages * copies * paperRate;

    // Binding
    bindingCost =0;
    if (_binding == Binding.no_binding) {
      bindingCost = 0;
      bindingTypeName = "No Binding";
    } else if (_binding == Binding.stapled) {
      bindingCost = 10;
      bindingTypeName = "Stapled";
    } else if (_binding == Binding.spiral) {
      bindingCost = 20;
      bindingTypeName = "Spiral";
    } 


    // Lamination
    laminationCost =0;
    if (lamination) {
      laminationCost = 30;
      laminationType = "With Lamination";
    } else {
      laminationCost = 0;
      laminationType = "No Lamination";
    }

    // Final Total
    totalPrice = paperCost + colorCost + bindingCost + laminationCost;

    setState(() {});
  }
  Future<void> uploadToDatabase() async {
  try {
    int pages = int.tryParse(_pagesController.text) ?? 0;
    int copies = int.tryParse(_copiesController.text) ?? 0;
    int totalPages = pages * copies;

    await FirebaseFirestore.instance.collection("Basic_Prints").add({
      "Total_Pages": totalPages,
      "Color": colorTypeName,           // e.g. "Colored"
      "Paper": paperTypeName,           // e.g. "Glossy Paper"
      "Binding": bindingTypeName,       // e.g. "Stapled"
      "Lamination": lamination,         // true/false
      "Total_Price": totalPrice,        // final amount
      "Order_Time": Timestamp.now(),
      "Delivery_Time": Timestamp.fromDate(
        DateTime.now().add(const Duration(minutes: 10)),
      ),
    });

    print("Basic Print Order Uploaded ✔️");

  } catch (e) {
    print("Error uploading data: $e");
  }
}


  // -------- REUSABLE TEXTFIELD -------- //
  Widget buildNumberField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (_) => calculatePrice(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
            hintText: 'Enter $label',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Text(
            'Basic Print Service',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 151, 21, 251)),
          ),
          const Text('Upload your documents and customize your print options', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),

          // Upload Section
          const UploadBox(),
          const SizedBox(height: 20),

          // Print Options Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Print Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),

                buildNumberField("Number of Pages", _pagesController),
                const SizedBox(height: 16),
                buildNumberField("Number of Copies", _copiesController),
                const SizedBox(height: 20),

                _buildRadioGroup("Orientation", _orientation, OrientationType.values, (v) => _orientation = v),
                _buildRadioGroup("Paper Type", _paperType, PaperType.values, (v) => _paperType = v),
                _buildRadioGroup("Color", _color, PrintColor.values, (v) => _color = v),
                _buildRadioGroup("Print Sides", _printSide, PrintSide.values, (v) => _printSide = v),

                const SizedBox(height: 12),

                // Binding
                const Text("Binding", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButtonFormField<Binding>(
                  value: _binding,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
                  ),
                  isExpanded: true,
                  items: Binding.values
                      .map((b) => DropdownMenuItem(value: b, child: Text(b.name)))
                      .toList(),
                  onChanged: (v) {
                    _binding = v;
                    calculatePrice();
                  },
                ),

                // Lamination
                SwitchListTile(
                  value: lamination,
                  title: const Text("Lamination (+₹30)", style: TextStyle(fontSize: 16)),
                  onChanged: (v) {
                    lamination = v;
                    calculatePrice();
                  },
                ),
              ]),
            ),
          ),

          const SizedBox(height: 18),

          // -------- INVOICE CARD -------- //
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("Invoice Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),

                _priceRow("Print Cost", "₹$paperCost"),
                _priceRow("Paper & Color Cost", "₹${paperCost + colorCost}"),
                _priceRow("Binding & Lamination", "₹${bindingCost + laminationCost}"),
                const Divider(thickness: 1),
                _priceRow("Total Price", "₹$totalPrice", bold: true),

                const SizedBox(height: 14),
                Customelevatedbutton(text: "Add To Cart", onPressed: () async { await uploadToDatabase();})
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  // ------- Helper for Price Row------- //
  Widget _priceRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
      ]),
    );
  }

  // ------- Helper for Radio groups ------- //
  Widget _buildRadioGroup<T>(String title, T? groupValue, List<T> values, Function(T?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Column(
          children: values.map((v) {
            return RadioListTile<T>(
              dense: true,
              title: Text(v.toString().split(".").last),
              value: v,
              groupValue: groupValue,
              onChanged: (val) {
                onChanged(val);
                calculatePrice();
              },
            );
          }).toList(),
        )
      ],
    );
  }
}
