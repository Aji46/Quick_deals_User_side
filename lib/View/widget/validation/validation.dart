class ValidationUtils {
  static var validateUsername;

  static String? validate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    } else if (value.contains(' ')) {
      return 'Spaces are not allowed in $fieldName';
    }
    return null;
  }

static String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  } 
  
  if (value.contains('  ')) {
    return 'Multiple spaces are not allowed in the phone number';
  } 
  
  if (!RegExp(r'^\+?[0-9\s\-\(\)]+$').hasMatch(value)) {
    return 'Invalid phone number format. Only numbers, spaces, dashes, and parentheses are allowed.';
  } 
  
  // Remove spaces and check for valid length and correct start digit
  final cleanedValue = value.replaceAll(RegExp(r'\s+'), '');
  if (!RegExp(r'^\+?[1-9][0-9]{9,14}$').hasMatch(cleanedValue)) {
    return 'Invalid phone number. Please enter a valid number with or without country code.';
  }
  
  return null;
}


  static String? validateemail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@gmail\.com$').hasMatch(value)) {
      return 'Please enter a valid Email address';
    }
    return null;
  }

  // New OTP validation method
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    // Additional OTP validation logic (if needed)
    return null;
  }

// Product Name Validation - No spaces or symbols allowed
static String? validateProductName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Product name is required';
  } else if (value.length < 3) {
    return 'Product name must be at least 3 characters long';
  } else if (RegExp(r'[^\w]').hasMatch(value)) {
    return 'Product name cannot contain spaces or symbols';
  }
  return null;
}

// Product Details Validation - No symbols allowed, but spaces are allowed
static String? validateProductDetails(String? value) {
  if (value == null || value.isEmpty) {
    return 'Product details are required';
  } else if (value.length < 10) {
    return 'Product details must be at least 10 characters long';
  } else if (RegExp(r'[^\w\s]').hasMatch(value)) {
    return 'Product details cannot contain symbols';
  }
  return null;
}

// Product Price Validation - Must be a valid number, no spaces or symbols allowed except decimal point
static String? validateProductPrice(String? value) {
  if (value == null || value.isEmpty) {
    return 'Product price is required';
  } else if (double.tryParse(value) == null || double.parse(value) <= 0) {
    return 'Please enter a valid positive price';
  } else if (RegExp(r'[^\d.]').hasMatch(value)) {
    return 'Product price cannot contain spaces or symbols';
  }
  return null;
}

// Additional Information Validation - No symbols allowed, but spaces are allowed
static String? validateAdditionalInfo(String? value) {
  if (value != null && value.length > 200) {
    return 'Additional information should be less than 200 characters';
  } else if (value != null && RegExp(r'[^\w\s]').hasMatch(value)) {
    return 'Additional information cannot contain symbols';
  }
  return null;
}



}
