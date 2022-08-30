import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../inner_screens/edit_prod.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String title = '';
  String description = '';
  String map = '';
  String productCat = '';
  String? imageUrl;
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;

  @override
  void initState() {
    getProductsData();
    super.initState();
  }

  Future<void> getProductsData() async {
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        // Add if mounted here
        if (mounted) {
          setState(() {
            title = productsDoc.get('title');
            description = productsDoc.get('description');
            description = productsDoc.get('description');
            map = productsDoc.get('map');
            productCat = productsDoc.get('productCategoryName');
            imageUrl = productsDoc.get('imageUrl');
            price = productsDoc.get('price');
            salePrice = productsDoc.get('salePrice');
            isOnSale = productsDoc.get('isOnSale');
            isPiece = productsDoc.get('isPiece');
          });
        }
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final color = Utils(context).color;
    getProductsData();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditProductScreen(
                  id: widget.id,
                  title: title,
                  description: description,
                  map: map,
                  mapUrl: map,
                  price: price,
                  salePrice: salePrice.toDouble(),
                  productCat: productCat,
                  imageUrl: imageUrl == null
                      ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                      : imageUrl!,
                  isOnSale: isOnSale,
                  isPiece: isPiece,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.network(
                        imageUrl == null
                            ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                            : imageUrl!,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: size.width * 0.21,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditProductScreen(
                                        id: widget.id,
                                        title: title,
                                        description: description,
                                        map: map,
                                        mapUrl: map,
                                        price: price,
                                        salePrice: salePrice.toDouble(),
                                        productCat: productCat,
                                        imageUrl: imageUrl == null
                                            ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                                            : imageUrl!,
                                        isOnSale: isOnSale,
                                        isPiece: isPiece,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Edit'),
                                value: 1,
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  GlobalMethods.warningDialog(
                                      title: 'Delete?',
                                      subtitle: 'Press okay to confirm',
                                      fct: () async {
                                        await FirebaseFirestore.instance
                                            .collection('products')
                                            .doc(widget.id)
                                            .delete();
                                        await Fluttertoast.showToast(
                                          msg: "Product has been deleted",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                        );
                                        while (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      context: context);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                value: 2,
                              ),
                            ])
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    TextWidget(
                      text: 'TK$price',
                      color: color,
                      textSize: 18,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                   
                    const Spacer(),
                    TextWidget(
                      text: isPiece ? 'For Sell' : 'On Rent',
                      color: color,
                      textSize: 18,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                TextWidget(
                  text: title,
                  color: color,
                  textSize: 20,
                  isTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
