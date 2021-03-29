import 'package:ayurlifebtle/widgets/servicescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key,this.bluetoothDevice}) : super(key: key);

  final BluetoothDevice bluetoothDevice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(bluetoothDevice.name),
        actions: [
          StreamBuilder<BluetoothDeviceState>(
            stream: bluetoothDevice.state,
            builder: (c,snapshot){
              VoidCallback onPressed;
              String text;
              switch(snapshot.data){
                case BluetoothDeviceState.connected:
                onPressed = ()=>bluetoothDevice.disconnect();
                text = 'DISCONNECT';
                break;
                case BluetoothDeviceState.disconnected:
                onPressed = ()=>bluetoothDevice.connect();
                text = 'CONNECT';
                break;
                default:
                onPressed = null;
                text = snapshot.data.toString().substring(21).toUpperCase();
              }
              return TextButton(
                onPressed: onPressed,
                child: Text(text,style: Theme.of(context).primaryTextTheme.button?.copyWith(color:Colors.white),),
              );
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: bluetoothDevice.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${bluetoothDevice.id}'),
                trailing: StreamBuilder<bool>(
                  stream: bluetoothDevice.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => bluetoothDevice.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<BluetoothDeviceState>(
              stream: bluetoothDevice.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c,snapshot){
                if(snapshot.data==BluetoothDeviceState.connected){
                  return Column(
                    children: [
                      StreamBuilder<int>(
                        stream: bluetoothDevice.mtu,
                        initialData: 0,
                        builder: (c, snapshot) => ListTile(
                          title: Text('MTU Size'),
                          subtitle: Text('${snapshot.data} bytes'),
                          trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => bluetoothDevice.requestMtu(223),
                            ),
                          ),
                      ),
                      StreamBuilder<List<BluetoothService>>(
                        stream:bluetoothDevice.services,
                        initialData: [],
                        builder: (c,snapshot)=>Column(
                          children: snapshot.data.map(
                            (s) => ListTile(
                              leading: Icon(Icons.medical_services),
                              title: Text(s.uuid.toString(),style: TextStyle(fontSize: 12.0),),
                              subtitle: Text('Is primary: ${s.isPrimary.toString()}', style: TextStyle(fontSize: 12.0),),
                              trailing: IconButton(icon: Icon(Icons.view_array),onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder:(context)=> ServiceScreen(bluetoothService: s,)));
                              },),
                            ),
                          ).toList(),
                        ),
                      ),
                    ],
                  );
                }else{
                  return Card(
                    color: Colors.red[100],
                    child: Text('Device non connecté'),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}