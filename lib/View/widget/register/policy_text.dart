import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/register.dart';

class TermsPolicyWidget extends StatelessWidget {
  const TermsPolicyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TermsProvider>(
      builder: (context, termsProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: termsProvider.acceptedTerms,
              onChanged: (value) {
                termsProvider.toggleAcceptedTerms(value);
              },
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Flexible(
                    child: Text(
                      "I understood the terms & policy",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to terms and policy page or show a dialog
                    },
                    child: const Text(
                      "Terms & Policy",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
