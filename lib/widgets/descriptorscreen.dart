import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DescriptorScreen extends StatelessWidget {
  const DescriptorScreen({Key key,this.descriptor}) : super(key: key);

  final BluetoothDescriptor descriptor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(descriptor.uuid.toString(),style: TextStyle(fontSize: 12.0),),
      ),
    );
  }
}