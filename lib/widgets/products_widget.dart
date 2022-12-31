import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  //new added
  String call = '';
  //new added


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

            //new added
            call = productsDoc.get('call');
            //new added


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

    final color = Utils(context).color;
    getProductsData();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 1,
        color: Theme.of(context).cardColor.withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
                  call: call,
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
            child: SizedBox(
              width: double.infinity,
              height: 130,
              child: Row(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: Container(
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                            imageUrl == null
                                ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                                : imageUrl!,
                          ),
                          fit: BoxFit.fill,
                        )
                      ),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        TextWidget(
                          text: title,
                          color: color,
                          textSize: 16,
                          maxLines: 2,
                          isTitle: true,
                        ),

                        TextWidget(
                          text: description,
                          color: color,
                          maxLines: 1,
                          textSize: 16,
                        ),

                        TextWidget(
                          text: isPiece ? 'For Sell' : 'On Rent',
                          color: color,
                          textSize: 18,
                        ),

                        TextWidget(
                          text: 'TK$price',
                          color: Colors.blue,
                          textSize: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}


/*
Row(
              children: [
                // Expanded(
                //   flex: 1,
                //   child: Image.network(
                //     imageUrl == null
                //         ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                //         : imageUrl!,
                //     fit: BoxFit.fill,
                //   ),
                // ),

                // Container(
                //   height: 120,
                //   width: 100,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     image: DecorationImage(
                //       image: NetworkImage(
                //           imageUrl == null
                //                 ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                //                 : imageUrl!,
                //       )
                //     )
                //   ),
                // ),

                Expanded(
                  flex: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          TextWidget(
                            text: 'TK$price',
                            color: color,
                            textSize: 18,
                          ),

                          const SizedBox(
                            width: 30,
                          ),

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
                      Expanded(
                        flex: 0,
                        child: TextWidget(
                          text: title,
                          color: color,
                          textSize: 16,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
 */

