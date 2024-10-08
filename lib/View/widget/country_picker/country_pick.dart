import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:quick_o_deals/contants/color.dart';

class CountryPickerButton extends StatelessWidget {
  final void Function(Country)? onCountrySelected;

  const CountryPickerButton({super.key, this.onCountrySelected});

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
            borderRadius: const BorderRadius.only(
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
            searchTextStyle: const TextStyle(
              color: MyColors.mycolor3,
              fontSize: 18,
            ),
          ),
        );
      },
      child: const Text('Show country picker'),
    );
  }
}
