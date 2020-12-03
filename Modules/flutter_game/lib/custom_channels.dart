import 'package:flutter/services.dart';

class CustomChannels {
    static final _navigation = MethodChannel("flutterApp/customNavigation", const StandardMethodCodec());

    static Future<void> dismissCurrent() async {
       await _navigation.invokeMethod("dismissCurrent");
     }
}