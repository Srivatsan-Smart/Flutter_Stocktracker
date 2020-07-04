import 'package:flutter/material.dart';
import 'package:stocktrackerapp/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name='';
  String currentAddress='';
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String message = '';





  Position _location = Position(latitude: 0.0, longitude: 0.0);

  void _displayCurrentLocation() async {

    final location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _location = location;
    });

    _getAddress(_location);
  }

  void _getAddress(Position _location) async{
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(_location.latitude, _location.longitude);
    Placemark address = placemark[0];
    final curaddress = '${address.name},${address.thoroughfare},${address.locality},${address.postalCode},${address.subAdministrativeArea},${address.administrativeArea},${address.country}';
    setState(() {
      currentAddress = curaddress;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('StockTrackerApp'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async{
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('Logout')
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
            children:<Widget> [
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val){
                  if(val.length>0){
                        return null;
                  }
                  else{
                      return 'Enter a valid email';
                  }
                },
                onChanged: (val){
                  setState(() => name = val);
                },
              ),
             SizedBox(height: 20.0),
              RaisedButton(
              color: Colors.pink[400],
              child: Text('Save Address',
                style: TextStyle(color: Colors.white),),
                onPressed: () async{
                if(_formKey.currentState.validate()){
                  _displayCurrentLocation();
                  print('Current address is ${currentAddress}');
                  Firestore.instance.collection('tracker').document()
                      .setData({ 'Name': name, 'Address': currentAddress });
                  setState(() {
                    message = 'Address Saved';
                  });
                }
              },
            ),
              SizedBox(height: 20.0),
              Text(
                message,
                style: TextStyle(color: Colors.red,fontSize: 14.0),

              )
          ],
    ),
    ),
    ),
    );
  }
}

