import 'package:flutter/material.dart';

class VerifyOtp extends StatefulWidget {
  final String verificationId;
  final Function(String) onCodeEntered;

  const VerifyOtp(
      {Key? key, required this.verificationId, required this.onCodeEntered})
      : super(key: key);

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Column(
        children: [
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter OTP'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onCodeEntered(_otpController.text);
           
            },
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }
}
