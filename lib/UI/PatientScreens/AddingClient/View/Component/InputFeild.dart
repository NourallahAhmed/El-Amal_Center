import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../TherapistScreens/AddingTherapist/viewModel/AddingTherapistVM.dart';

class InputFeild extends StatelessWidget {
   InputFeild({
    Key? key,
    required this.hint,
    required this.iconData,
    required this.txtController,
    required this.keyType,
    required this.label,
  }) : super(key: key);

  final String hint;
  final IconData iconData;
  final TextEditingController txtController;
  final TextInputType keyType;
  final String label;
  bool check = false;
  @override
  Widget build(BuildContext context) {
    check = Provider.of<AddingTherapistVM>(context, listen:  false).check;
    return Consumer<AddingTherapistVM>(builder: (context, provider, child) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
              elevation: 8,
              shadowColor: Colors.black87,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              child: TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Fill this Feild';
                  }
                  if (check == false){
                    return keyType == TextInputType.emailAddress ?   '\t Email Exist \t' : "";
                  }

                  return null;
                },
                keyboardType: keyType,
                controller: txtController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: hint,
                  labelText: label,
                  prefixIcon: Icon(iconData),
                ),

              )

          ),
        );

  });
}
}