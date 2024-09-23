import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/profile_edit_provider.dart';
import 'package:quick_o_deals/View/widget/textformfiled/coustom_text.dart';
import 'package:quick_o_deals/View/widget/validation/validation.dart';

class ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileEditProvider>(context);
    
    return Column(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Contact", style: TextStyle(fontSize: 20)),
          ),
        ),
        const Divider(
          color: Colors.black,
          thickness: 2,
          endIndent: 20,
          indent: 20,
        ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Padding(
        padding: const EdgeInsets.only(top: 13.0), 
        child: ElevatedButton(
          onPressed: null, 
          child: const Text(
            "+91",
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.white, 
            minimumSize: Size(50, 55),
            padding: EdgeInsets.symmetric(horizontal: 16.0), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
              side: BorderSide(color: Colors.black, width: 2), 
            ),
          ),
        ),
            ),
            SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: CustomTextFormField(
          controller: provider.phoneNumberController,
          labelText: "Phone Number",
          keyboardType: TextInputType.phone,
          validator: ValidationUtils.validatePhoneNumber,
        ),
            ),
          ],
        ),
      ),

        Row(
          children: [
            Flexible(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: CustomTextFormField(
                  controller: provider.emailController,
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationUtils.validateemail,
                  
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "@gmail.com",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
