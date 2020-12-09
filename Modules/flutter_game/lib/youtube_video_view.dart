import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const String _iosViewType = "FlutterYoutubeVideoView";
const String _androidViewType = "FlutterYoutubeVideoView";

class YoutubeVideoView extends StatelessWidget {
  final String videoId;

  const YoutubeVideoView({Key key, @required this.videoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      "videoId": videoId
    };
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
