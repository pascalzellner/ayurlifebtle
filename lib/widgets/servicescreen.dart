import 'package:ayurlifebtle/widgets/characteristicscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({Key key,this.bluetoothService}) : super(key: key);

  final BluetoothService bluetoothService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bluetoothService.uuid.toString(),style: TextStyle(fontSize: 12.0),),
      ),
      body: StreamBuilder<List<BluetoothCharacteristic>>(
        stream: Stream.periodic(Duration(seconds: 1)).asyncMap((_) => bluetoothService.characteristics),
        initialData: [],
        builder: (c,snapshot)=> Column(
          children: snapshot.data.map((c) => Card(
            color: Colors.blue[100],
            child: ListTile(
              title: Text(c.uuid.toString(),style: TextStyle(fontSize: 12.0),),
              trailing: IconButton(icon: Icon(Icons.search), onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CharacteristicScreen(characteristic:c) ));
              },),
            ),
          )
          ).toList(),
        ),
        ),
    );
  }
}