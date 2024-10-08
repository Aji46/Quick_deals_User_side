import 'package:flutter/material.dart';
import 'package:quick_o_deals/Controller/auth/provider/Serach_provider.dart';

class FilterModal extends StatefulWidget {
  final ProductSearchProvider provider;

  const FilterModal({Key? key, required this.provider}) : super(key: key);

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  double _minPrice = 0;
  double _maxPrice = 0;
  bool _recentlyAdded = false;

  @override
  void initState() {
    super.initState();
    widget.provider.fetchMaxProductPrice();
    _maxPrice = widget.provider.maxProductPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Filter by:'),
          DropdownButton<String>(
            hint: const Text('Select Category'),
            value: widget.provider.selectedCategory.isEmpty ? null : widget.provider.selectedCategory,
            onChanged: (String? newValue) {
              if (newValue != null) {
                widget.provider.selectCategory(newValue); // Use the Provider method to update category
              }
            },
            items: widget.provider.categories.map<DropdownMenuItem<String>>(
              (category) {
                return DropdownMenuItem<String>(
                  value: category.id, // Use the category ID as the value
                  child: Text(category.name),
                );
              },
            ).toList(),
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: widget.provider.maxProductPrice,
            divisions: 100,
            labels: RangeLabels(
              _minPrice.round().toString(),
              _maxPrice.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Recently Added'),
            value: _recentlyAdded,
            onChanged: (bool value) {
              setState(() {
                _recentlyAdded = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              widget.provider.filterProducts(
                categoryId: widget.provider.selectedCategory, // Use selected category from provider
                minPrice: _minPrice,
                maxPrice: _maxPrice,
                recentlyAdded: _recentlyAdded,
              );
              Navigator.pop(context);
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
