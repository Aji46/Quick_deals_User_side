import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/email_auth.dart';
import 'package:quick_o_deals/Controller/auth/provider/phone.dart';
import 'package:quick_o_deals/Model/auth/auth.dart';
import 'package:quick_o_deals/View/widget/custom_bottons/custom_button.dart';
import 'package:quick_o_deals/View/widget/logos/logo.dart';
import 'package:quick_o_deals/View/widget/textformfiled/coustom_text.dart';
import 'package:quick_o_deals/View/widget/validation/validation.dart';

class PhoneNumberPage extends StatelessWidget {
  const PhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhoneNumberProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository: AuthRepository())), // Ensure AuthProvider is properly initialized
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Logo(),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  "assets/OIG1 (1).jpeg",
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Consumer<PhoneNumberProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,
                                    onSelect: (Country country) {
                                      provider.updateCountryCode("+${country.phoneCode}");
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    provider.selectedCountryCode,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: CustomTextFormField(
                                controller: provider.phoneController,
                                labelText: "Phone Number",
                                keyboardType: TextInputType.phone,
                                validator: (value) => ValidationUtils.validatePhoneNumber(value),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          width: 110,
                          child: 
             

                          CustomButton(
                              buttonText: 'Get OTP',
                              onPressed: () {
                                provider.signInWithPhoneNumber(context);
                              },
                            ),
                          
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
