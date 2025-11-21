import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chappo/delivery_details.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionTitle("Basic Prints"),
            _buildStream("Basic_Prints"),

            _buildSectionTitle("Brochures"),
            _buildStream("Brochures"),

            _buildSectionTitle("Gift Cards"),
            _buildStream("Gift_Cards"),
          ],
        ),
      ),
    );
  }

  // ---------------------------------
  // SECTION TITLE
  // ---------------------------------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  // ---------------------------------
  // STREAM VIEW
  // ---------------------------------
  Widget _buildStream(String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(10),
            child: Text("No items added.",
                style: TextStyle(color: Colors.grey)),
          );
        }

        return Column(
          children: snapshot.data!.docs
              .map((doc) => CartItemCard(
                    collection: collection,
                    doc: doc,
                  ))
              .toList(),
        );
      },
    );
  }
}

//
// ===============================================
// CART ITEM CARD WIDGET (Updated)
// ===============================================
//

class CartItemCard extends StatelessWidget {
  final DocumentSnapshot doc;
  final String collection;

  const CartItemCard({
    super.key,
    required this.doc,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;

    String title = "";
    List<Widget> items = [];

    // --------------------------
    // BASIC PRINT
    // --------------------------
    if (collection == "Basic_Prints") {
      title = "Basic Print Order";

      int qty = data["Total Pages"] ?? 0;
      int colorCost = data["Color Cost"] ?? 0;
      int paperCost = data["Paper Cost"] ?? 0;
      int bindingCost = data["Binding Cost"] ?? 0;
      bool lam = data["Lamination"] ?? false;
      int laminationCost = lam ? 30 : 0;

      items = [
        _row("Basic Prints", "$qty"),
        _row("Color Cost", "₹$colorCost"),
        _row("Paper Cost", "₹$paperCost"),
        _row("Binding Cost", "₹$bindingCost"),
        _row("Lamination", lam ? "₹30" : "No"),
      ];
    }

    // --------------------------
    // BROCHURES
    // --------------------------
    else if (collection == "Brochures") {
      title = "Brochure Order";

      items = [
        _row("Quantity", "${data['Quantity']}"),
        _row("Rate", "₹${data['Rate_Per_Brochure']} per brochure"),
        _row("Instructions", "${data['Instructions']}"),
      ];
    }

    // --------------------------
    // GIFT CARDS
    // --------------------------
    else if (collection == "Gift_Cards") {
      title = "Gift Card Order";

      items = [
        _row("Occasion", "${data['Occasion']}"),
        _row("Size", "${data['Size']}"),
        _row("Quantity", "${data['Quantity']}"),
        _row("Message", "${data['Message']}"),
      ];
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection(collection)
                        .doc(doc.id)
                        .delete();
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                )
              ],
            ),

            const SizedBox(height: 12),

            // Item Details
            ...items,

            const Divider(height: 20),

            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Price",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  "₹${data['Total Price'] ?? 0}",
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DeliveryDetailsPage(amountToPay: data['Total Price'])),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Checkout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // REUSABLE ROW (makes UI clean & aligned)
  // -------------------------------------------------------------------

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
