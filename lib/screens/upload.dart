import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hiveManilaExam/models/posts.dart';
import '../models/users.dart';
import '../screens/home.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

import 'home.dart';
var dbBatch = Firestore.instance.batch();

class Upload extends StatefulWidget {
  final User currentUser;
  Upload({this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  // File file;
  List<Asset> images = List<Asset>();
  List<Post> imageDetails = [];
    bool isUploading = false;
  
  String _error = 'No Error Dectected';
  List<String> imageUrls = <String>[];



  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Stack(
                children: <Widget>[
                  AssetThumb(
                    asset: asset,
                    width: 600,
                    height: 600,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      BottomAppBar(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: IconButton(icon: Icon(Icons.edit), onPressed: (){}),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 5,
                            ),
                            Expanded(
                              child: IconButton(icon: Icon(Icons.delete), onPressed: (){}),
                            ),
                           
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Titlse',
                        style: Theme.of(context).textTheme.headline,
                        textAlign: TextAlign.center,
                      ),
                      Text(asset.name)
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }




  Future<void> loadAssets() async {
    images = [];
    imageDetails = [];
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          // actionBarColor: "#abcdef",
          actionBarTitle: "Select Photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;


    setState(() {
      images = resultList;
      _error = error;
    });

    for(var x = 0; x< images.length; x++){
     imageDetails.add(
        Post(
          index: x,
          uid: Uuid().v4(),
          title: '',

        )
        );
    }

    print(imageDetails.toString());
    
  }


  // void uploadImages(){
  //   for ( var imageFile in images) {
  //     postImage(imageFile).then((downloadUrl) {
  //       imageUrls.add(downloadUrl.toString());
  //       if(imageUrls.length==images.length){
  //         String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
  //         Firestore.instance.collection('images').document(documnetID).setData({
  //           'urls':imageUrls
  //         }).then((_){
  //           SnackBar snackbar = SnackBar(content: Text('Uploaded Successfully'));
  //           // widget.globalKey.currentState.showSnackBar(snackbar);
  //           setState(() {
  //             images = [];
  //             imageUrls = [];
  //           });
  //         });
  //       }
  //     }).catchError((err) {
  //       print(err);
  //     });
  //   }
  // }

  // Future<dynamic> postImage(Asset imageFile) async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
  //   StorageUploadTask uploadTask = reference.putData((await imageFile.getByteData()).buffer.asUint8List());
  //   StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
  //   print(storageTaskSnapshot.ref.getDownloadURL());
  //   return storageTaskSnapshot.ref.getDownloadURL();
  // }

  handleSubmit() async{
    setState(() {
      isUploading=true;
    });

    

    imageDetails.forEach((x){
      dbBatch.setData(postsRef.document(currentUser.id), 
        x.toMap()
      );
    });

    dbBatch.commit();

    // dbBatch.setData(

    //   postsRef.document(currentUser.id),
    //   datahere
    //   ,
    // ); 
    


  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text(
            'Upload Images',
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Upload'),
              onPressed: handleSubmit
            ),
                        ],
                      ),
                      body: Column(
                        children: <Widget>[
                          // Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 30),
                          //   child: Text(
                          //     'Upload Images'.toUpperCase(),
                          //     style: Theme.of(context).textTheme.display1,
                          //   ),
                          // ),
              
                          // Center(child: Text('Error: $_error')),
                          Expanded(
                            child: buildGridView(),
                          ),
                          // RaisedButton(
                          //   child: Text("Pick images"),
                          //   onPressed: loadAssets,
                          // ),
                        ],
                      ),
                      floatingActionButton: new FloatingActionButton(
                        child: const Icon(Icons.add),
                        onPressed: loadAssets,
                      ),
                      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                      bottomNavigationBar: new BottomAppBar(
                        color: Colors.white,
                        child: new Row(),
                      ),
                    ),
                  );
                }
              
                
}
