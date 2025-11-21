
import 'package:flutter/material.dart';
 Widget Customelevatedbutton({required String text, required  VoidCallback onPressed}) {
  return ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text( text, style: TextStyle(color: Colors.white)),
              );
 }