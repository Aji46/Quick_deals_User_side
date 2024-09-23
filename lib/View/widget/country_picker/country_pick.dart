import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CountryPickerButton extends StatelessWidget {
  final void Function(Country)? onCountrySelected;

  const CountryPickerButton({Key? key, this.onCountrySelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showCountryPicker(
          context: context,
          exclude: <String>['KN', 'MF'],
          favorite: <String>['SE'],
          showPhoneCode: true,
          onSelect: (Country country) {
            if (onCountrySelected != null) {
              onCountrySelected!(country);
            }
          },
          moveAlongWithKeyboard: false,
          countryListTheme: CountryListThemeData(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            inputDecoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Start typing to search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFF8C98A8).withOpacity(0.2),
                ),
              ),
            ),
            searchTextStyle: TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
        );
      },
      child: const Text('Show country picker'),
    );
  }
}
