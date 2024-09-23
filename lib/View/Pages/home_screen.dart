// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // Make sure to import the flutter_bloc package
// import 'package:quick_o_deals/Controller/product_bloc.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Product List')),
//       body: BlocBuilder<ProductBloc, ProductState>(
//         builder: (context, state) {
//           if (state is ProductListLoaded) {
//             return ListView.builder(
//               itemCount: state.products.length,
//               itemBuilder: (context, index) {
//                 final product = state.products[index];
//                 return ListTile(
//                   leading: Image.network(product.imageUrl),
//                   title: Text(product.name),
//                   subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
//                 );
//               },
//             );
//           } else {
//             return CircularProgressIndicator(); 
//           }
//         },
//       ),
//     );
//   }
// }
