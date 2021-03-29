import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ayurlifebtle/widgets/devicescreen.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key,this.scanResult}) : super(key: key);

  final ScanResult scanResult;

  @override
  Widget build(BuildContext context) {
    if(scanResult.device.name.length>0){
      return Card(
        color: Colors.blue[100],
        child: Column(children: [
          ListTile(
            title: Text(scanResult.device.name.toString()),
            subtitle: Text(scanResult.device.id.toString()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> DeviceScreen(bluetoothDevice:scanResult.device)));
                }, 
                child: Text('EXPLORER'))
          ],),
        ],
        ),
      );
    }else{
      return Card(
        color: Colors.blue[100],
        child: Column(children: [
          ListTile(
            title: Text(scanResult.device.id.toString()),
          ),
        ],),
      );
    }
  }
}