import 'package:flutter/material.dart';

class VerifyOtp extends StatefulWidget {
  final String verificationId;
  final Function(String) onCodeEntered;

  const VerifyOtp(
      {super.key, required this.verificationId, required this.onCodeEntered});

  @override
  // ignore: library_private_types_in_public_api
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Column(
        children: [
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter OTP'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onCodeEntered(_otpController.text);
           
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}
