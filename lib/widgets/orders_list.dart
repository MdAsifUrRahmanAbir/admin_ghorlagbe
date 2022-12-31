import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_admin_panel/model/order_model.dart';

import '../consts/constants.dart';
import '../screens/order_view.dart';
import '../services/global_method.dart';
import 'orders_widget.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({Key? key, this.isInDashboard = true}) : super(key: key);
  final bool isInDashboard;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //there was a null error just add those lines
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: InkWell(
                                onTap: (){
                                  OrderModel data = OrderModel(
                                    price: snapshot.data!.docs[index]['price'].toDouble(),
                                    totalPrice: snapshot.data!.docs[index]['totalPrice'].toDouble(),
                                    productId: snapshot.data!.docs[index]['productId'],
                                    userId: snapshot.data!.docs[index]['userId'],
                                    quantity: snapshot.data!.docs[index]['quantity'],
                                    orderDate: snapshot.data!.docs[index]['orderDate'],
                                    imageUrl: snapshot.data!.docs[index]['imageUrl'],
                                    userName: snapshot.data!.docs[index]['userName'],
                                    userNumber: snapshot.data!.docs[index]['userNumber'],
                                    userEmail: snapshot.data!.docs[index]['userEmail'],
                                    orderId: snapshot.data!.docs[index]['orderId'],
                                  );

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderView(
                                    data: data,
                                  )));
                                },
                                child: OrdersWidget(
                                  price: snapshot.data!.docs[index]['price'].toDouble(),
                                  totalPrice: snapshot.data!.docs[index]['totalPrice'].toDouble(),
                                  productId: snapshot.data!.docs[index]['productId'],
                                  userId: snapshot.data!.docs[index]['userId'],
                                  quantity: snapshot.data!.docs[index]['quantity'],
                                  orderDate: snapshot.data!.docs[index]['orderDate'],
                                  imageUrl: snapshot.data!.docs[index]['imageUrl'],
                                  userName: snapshot.data!.docs[index]['userName'],
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: IconButton(
                                  onPressed: (){
                                    GlobalMethods.warningDialog(
                                        title: 'Delete?',
                                        subtitle: 'Press okay to confirm',

                                        fct: () async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(snapshot.data!.docs[index]['orderId'])
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

                                        context: context
                                    );
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.red)
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          thickness: 3,
                        ),
                      ],
                    );
                  }),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('Your store is empty'),
              ),
            );
          }
        }
        return const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        );
      },
    );
  }
}
