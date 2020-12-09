import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const String _iosViewType = "FlutterMyVideoView";
const String _androidViewType = "FlutterMyVideoView";

class MyVideoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    if (Platform.isIOS) {
      return UiKitView(
        viewType: _iosViewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      return AndroidView(viewType: _androidViewType);
    } else {
      return Container();
    }
  }
}
