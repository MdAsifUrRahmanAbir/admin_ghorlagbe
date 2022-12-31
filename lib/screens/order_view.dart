import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_admin_panel/model/order_model.dart';

import '../services/global_method.dart';

class OrderView extends StatelessWidget {
  final OrderModel data;
  const OrderView({
    Key? key,
    required this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Id: ${data.productId}'),
      ),

      body: _bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Image.network(data.imageUrl),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Buyer Name:',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Wrap(
                         children: [
                           Text(
                               data.userName
                           ),
                         ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Buyer Email:',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Wrap(
                         children: [
                           Text(
                               data.userEmail
                           ),
                         ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Buyer Number:',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Wrap(
                         children: [
                           Text(
                               data.userNumber
                           ),
                         ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Date:',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Wrap(
                        children: [
                          Text(
                            "${data.orderDate.toDate().day.toString()}/${data.orderDate.toDate().month.toString()}/${data.orderDate.toDate().year.toString()}",
                            maxLines: 4,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Card(
            child: ElevatedButton(
              onPressed: (){
                GlobalMethods.warningDialog(
                    title: 'Delete?',
                    subtitle: 'Press okay to confirm',

                    fct: () async {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(data.orderId)
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
              child: const Text('DELETE'),
            ),
          ),
        )
      ],
    );
  }
}
