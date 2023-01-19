import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zanmutm_pos_client/src/widgets/app_base_screen.dart';
import 'package:zanmutm_pos_client/src/widgets/app_button.dart';

class AppUpdateScreen extends StatefulWidget {
  const AppUpdateScreen({Key? key}) : super(key: key);

  @override
  State<AppUpdateScreen> createState() => _AppUpdateScreenState();
}

class _AppUpdateScreenState extends State<AppUpdateScreen> {
  final ReceivePort _port = ReceivePort();
  String? _taskId;
  int _progress = 0;
  int _downloadStatus = 0;

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'app_update');
    _port.listen((dynamic data) {
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() => {_progress = progress, _downloadStatus = status.value});
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  _downloadApp() async {
    final storePerm = await Permission.storage.request();
    if (storePerm.isGranted) {
      var tempDir = await getExternalStorageDirectory();
      final taskId = await FlutterDownloader.enqueue(
          url: 'http://192.168.105.41:9080/release.apk',
          savedDir: tempDir!.path,
          showNotification: true,
          openFileFromNotification: true,
          saveInPublicStorage: true);
      setState(() => _taskId = taskId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseScreen(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Update app version'),
          Builder(builder: (_) {
            if (_downloadStatus == 0) {
              return AppButton(
                onPress: () => _downloadApp(),
                label: 'Download',
              );
            } else {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: _progress.toDouble(),
                  ),
                  Text(_downloadStatus == 2
                      ? 'Downloading..'
                      : 'Download Completed'),
                  if (_progress == 100 && _downloadStatus == 3)
                    AppButton(
                        onPress: () => FlutterDownloader.open(taskId: _taskId!),
                        label: 'Install')
                ],
              );
            }
          })
        ],
      ),
    ));
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('app_update');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort sendPort = IsolateNameServer.lookupPortByName('app_update')!;
    sendPort.send([id, status, progress]);
  }
}