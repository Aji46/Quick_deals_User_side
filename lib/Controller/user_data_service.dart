import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/email_auth.dart';

class UserDataService {
  static Future<Map<String, dynamic>?> getUserDetails(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.user == null) {
      return null;
    }
    
    try {
      return await authProvider.getUserDetails();
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }
}

