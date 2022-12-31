import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_admin_panel/Screens/loading_manager.dart';
import 'package:grocery_admin_panel/screens/main_screen.dart';
import 'package:grocery_admin_panel/services/global_method.dart';
import 'package:grocery_admin_panel/services/utils.dart';
import 'package:grocery_admin_panel/widgets/buttons.dart';
import 'package:grocery_admin_panel/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';



class EditProductScreen extends StatefulWidget {
  const EditProductScreen(
      {Key? key,
      required this.id,
      required this.title,
      required this.description,
        required this.map,
        required this.mapUrl,
        required this.call,
      required this.price,
      required this.salePrice,
      required this.productCat,
      required this.imageUrl,
      required this.isOnSale,
      required this.isPiece
      })
      : super(key: key);

  final String id, title, price, productCat, imageUrl, description,map,mapUrl,call;
  final bool isPiece, isOnSale;
  final double salePrice;

  //new added part
  //String mapUrl;
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _formKey = GlobalKey<FormState>();
  // Title and price controllers
  late final TextEditingController _titleController, _priceController, _descriptionController,mapController,callController;
  // Category

  late String _catValue;
  // Sale
   late String percToShow;
  late double _salePrice;
  late bool _isOnSale;
  // Image
  File? _pickedImage;
  Uint8List webImage = Uint8List(10);
  late String _imageUrl;
  // kg or Piece,
  late int val;
  late bool _isPiece;
  // while loading
  bool _isLoading = false;

  @override
  void initState() {
    // set the price and title initial values and initialize the controllers
    _priceController = TextEditingController(text: widget.price);
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);

    //new added part
    mapController = TextEditingController(text: widget.map);
    //new added part

    //new added
    callController = TextEditingController(text: widget.call);
    //new added


    // Set the variables
    _salePrice = widget.salePrice;
    _catValue = widget.productCat;
    _isOnSale = widget.isOnSale;
    _isPiece = widget.isPiece;
    val = _isPiece ? 2 : 1;
    _imageUrl = widget.imageUrl;
    // Calculate the percentage
    percToShow = 'TOP';
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the controllers
    _priceController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();


    //new added part
    mapController.dispose();
    //new added part

    //new added
    callController.dispose();
    //new added

    super.dispose();
  }

  void _updateProduct() async {
    // final isValid = _formKey.currentState!.validate();
    // FocusScope.of(context).unfocus();

      try {
        Uri? imageUri;
        setState(() {
          _isLoading = true;
        });
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.id)
            .update({
          'title': _titleController.text,
          'description': _descriptionController.text,


          //new added part
          'map':mapController.text,
          // 'authEmail': 'ADMIN',
          //new added part


          //new added
          'call':callController.text,
          //new added

          'price': _priceController.text,
          'salePrice': _salePrice,
          'imageUrl':
              _pickedImage == null ? widget.imageUrl : imageUri.toString(),
          'productCategoryName': _catValue,
          'isOnSale': _isOnSale,
          'isPiece': _isPiece,
        });
        await Fluttertoast.showToast(
          msg: "Product has been updated",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }

  }






  //new added part
  Future _mapurlLancher() async {
    if (!await (launch(widget.mapUrl))) throw 'Could not find ${widget.mapUrl}';
  }
//new added part





  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      // key: context.read<MenuController>().getEditProductscaffoldKey,
      // drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: size.width > 650 ? 650 : size.width,
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  child: Form(
                    // key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        TextWidget(
                          text: 'House Location*',
                          color: color,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _titleController,
                          key: const ValueKey('Title'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a Title';
                            }
                            return null;
                          },
                          decoration: inputDecoration,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextWidget(
                          text: 'House description*',
                          color: color,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 5,
                          controller: _descriptionController,
                          key: const ValueKey('Description'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                          decoration: inputDecoration,
                        ),



                        //new added part
                        TextWidget(
                          text: 'House Location Link*',
                          color: color,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: mapController,
                          key: const ValueKey('Map'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a Title';
                            }
                            return null;
                          },
                          decoration: inputDecoration,
                        ),


                        /*const SizedBox(
                          height: 20,
                        ),*/



                        //new added part
                        TextWidget(
                          text: 'Mobile Number*',
                          color: color,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: callController,
                          key: const ValueKey('Call'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please mobile number';
                            }
                            return null;
                          },
                          decoration: inputDecoration,
                        ),


                        const SizedBox(
                          height: 20,
                        ),



                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: 'Price in TK*',
                                      color: color,
                                      isTitle: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: _priceController,
                                        key: const ValueKey('Price TK'),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Price is missed';
                                          }
                                          return null;
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        decoration: inputDecoration,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextWidget(
                                      text: 'House category*',
                                      color: color,
                                      isTitle: true,
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      color: _scaffoldColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: catDropDownWidget(color),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextWidget(
                                      text: 'Measure unit*',
                                      color: color,
                                      isTitle: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextWidget(text: 'Rent', color: color),
                                        Radio(
                                          value: 1,
                                          groupValue: val,
                                          onChanged: (value) {
                                            setState(() {
                                              val = 1;
                                              _isPiece = false;
                                            });
                                          },
                                          activeColor: Colors.green,
                                        ),
                                        TextWidget(text: 'Sell', color: color),
                                        Radio(
                                          value: 2,
                                          groupValue: val,
                                          onChanged: (value) {
                                            setState(() {
                                              val = 2;
                                              _isPiece = true;
                                            });
                                          },
                                          activeColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _isOnSale,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _isOnSale = newValue!;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        TextWidget(
                                          text: 'VIP',
                                          color: color,
                                          isTitle: true,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  height: size.width > 650
                                      ? 350
                                      : size.width * 0.50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: _pickedImage == null
                                        ? Image.network(_imageUrl)
                                        : (kIsWeb)
                                            ? Image.memory(
                                                webImage,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.file(
                                                _pickedImage!,
                                                fit: BoxFit.fill,
                                              ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    FittedBox(
                                      child: TextButton(
                                        onPressed: () {
                                          _pickImage();
                                        },
                                        child: TextWidget(
                                          text: 'Update image',
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ButtonsWidget(
                                onPressed: () async {

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

                                      context: context
                                  );// global dialog

                                },
                                text: 'Delete',
                                icon: IconlyBold.danger,
                                backgroundColor: Colors.red.shade700,
                              ),
                              ButtonsWidget(
                                onPressed: () {
                                   _updateProduct();
                                   debugPrint('Updated');
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                                },
                                text: 'Update',
                                icon: IconlyBold.setting,
                                backgroundColor: Colors.blue,
                              ),
                            ],
                          ),
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  //_mapurlLancher();
                                  launch('tel:${widget.call}');
                                });
                              },
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.blue,
                                ),

                                child: const Icon(Icons.call,color: Colors.white,),
                              ),
                            ),



                            const SizedBox(width: 20,),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  _mapurlLancher();
                                });
                              },
                              child: Container(
                                height: 45,
                                width: 240,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.blue,
                                ),

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.location_pin,color: Colors.white,),
                                    Text("Directions",style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),



                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // DropdownButtonHideUnderline salePourcentageDropDownWidget(Color color) {
  //   return DropdownButtonHideUnderline(
  //     child: DropdownButton<String>(
  //       style: TextStyle(color: color),
  //       items: const [
  //         DropdownMenuItem<String>(
  //           child: Text('2%'),
  //           value: '2',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('5%'),
  //           value: '5',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('8%'),
  //           value: '8',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('10%'),
  //           value: '10',
  //         ),
  //
  //       ],
  //       onChanged: (value) {
  //         if (value == '0') {
  //           return;
  //         } else {
  //           setState(() {
  //             _salePercent = value;
  //             _salePrice = double.parse(widget.price) -
  //                 (double.parse(value!) * double.parse(widget.price) / 100);
  //           });
  //         }
  //       },
  //       hint: Text(_salePercent ?? percToShow),
  //       value: _salePercent,
  //     ),
  //   );
  // }

  DropdownButtonHideUnderline catDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem<String>(
            child: Text('To-Let'),
            value: 'To-Let',
          ),
          DropdownMenuItem<String>(
            child: Text('Flat'),
            value: 'Flat',
          ),
          DropdownMenuItem<String>(
            child: Text('Plot'),
            value: 'Plot',
          ),
          DropdownMenuItem<String>(
            child: Text('Duplex'),
            value: 'Duplex',
          ),
          DropdownMenuItem<String>(
            child: Text('Hostel'),
            value: 'Hostel',
          ),
          DropdownMenuItem<String>(
            child: Text('Hotel'),
            value: 'Hotel',
          ),
        ],
        onChanged: (value) {
          setState(() {
            _catValue = value!;
          });
        },
        hint: const Text('Select a Category'),
        value: _catValue,
      ),
    );
  }

  Future<void> _pickImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _pickedImage = selected;
        });
      } else {
        log('No file selected');
        // showToast("No file selected");
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _pickedImage = File("a");
          webImage = f;
        });
      } else {
        log('No file selected');
      }
    } else {
      log('Perm not granted');
    }
  }
}
