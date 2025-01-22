// import 'package:mmoney_lite/utility/myconstant.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   late IO.Socket socket;
//   late Function(Map<String, dynamic>) onResponse;
//   void connect() {
//     socket = IO.io(MyConstant.urlSocketLtcdev, <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//     socket.connect();
//     socket.on('connect', (_) {
//       print("CONNECT TO SERVER LEO");
//     });
//     socket.on('check_result', (data) {
//       onResponse(data);
//     });
//     socket.on('disconnect', (_) {
//       print('Disconnected from server');
//     });
//   }

//   void sendCheckData(String tranid) {
//     socket.emit('check_data', {'tranid': tranid});
//   }

//   void disconnect() {
//     socket.disconnect();
//   }
// }
