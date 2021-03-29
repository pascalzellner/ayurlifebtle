
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ayurlifebtle/widgets/scanresulttile.dart';
import 'package:ayurlifebtle/widgets/devicescreen.dart';

class ScanDevicesTest extends StatefulWidget {
  ScanDevicesTest({Key key}) : super(key: key);

  @override
  _ScanDevicesSreenState createState() => _ScanDevicesSreenState();
}

class _ScanDevicesSreenState extends State<ScanDevicesTest> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Rechercher')
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(children: [
            //affiche les devices connectés
            StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(Duration(seconds: 2)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
              initialData: [],
              builder: (c,snapshot) => Column(
                children: snapshot.data.map(
                  (d) => Card(
                    color: Colors.green[100],
                    child: ListTile(
                      title: Text(d.name),
                      subtitle: Text(d.id.toString()),
                      trailing: StreamBuilder<BluetoothDeviceState>(
                        stream: d.state,
                        initialData: BluetoothDeviceState.disconnected,
                        builder: (c,snapshot){
                          if(snapshot.data == BluetoothDeviceState.connected){
                            return TextButton(
                              onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=> DeviceScreen(bluetoothDevice:d)));
                              }, 
                              child: Text('OPEN'),
                            );
                          }
                          return Text(snapshot.data.toString());
                        },
                      ),
                    ),
                  )
                ).toList(),
              ),
            ),
            //affiche les devices non connectés mais détectés
            StreamBuilder(
              stream:FlutterBlue.instance.scanResults,
              initialData: [],
              builder:  (c,snapshot)=>Column(
                children: snapshot.data.map().toList,
              ),
            )
          ],),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}