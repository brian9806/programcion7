import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


class InputWidget extends StatelessWidget {
    const InputWidget({
        super.key, required this.hintText, required this.controller, required this.obscureText, required this.icon
    });

    final String hintText;
    final TextEditingController controller;
    final bool obscureText;
    final Icon icon;

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
                obscureText: obscureText,
                controller: controller,
                decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.poppins(),
                    prefixIcon: icon,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                ),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                textAlignVertical: TextAlignVertical.center,
            ),
        );
    }
}

class InputNumberWidget extends StatelessWidget {
    const InputNumberWidget({
        super.key,
        required this.hintText,
        required this.controller,
        required this.obscureText,
        required this.icon,
        required this.isDecimal
    });

    final String hintText;
    final TextEditingController controller;
    final bool obscureText;
    final Icon icon;
    final bool isDecimal;

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
                obscureText: obscureText,
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')), // Permite solo números y hasta 2 decimales
                ],
                decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.poppins(),
                    prefixIcon: icon,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                ),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                textAlignVertical: TextAlignVertical.center,
            ),
        );
    }
}

class SelectedWidget extends StatelessWidget {
    const SelectedWidget({
        super.key,
        required this.select,
        required this.listOptions,
        required this.onChanged
    });

    final String select;
    final List<String> listOptions;
    final Function(String) onChanged;

    @override
    Widget build(BuildContext context) {
      return Container(
        width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          value: select,
          hint: const Text('Select a option'),
          onChanged: (String? e) {
            if(e != null){
              onChanged(e); 
            }
          },
          items: listOptions.map<DropdownMenuItem<String>>((String status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
        ),
      );
    }
}


