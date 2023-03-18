import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  final GlobalKey inAppWebViewKey = GlobalKey();
  InAppWebViewController? inAppWebViewController;
  double progress = 0;
  String url = "";
  late PullToRefreshController pullToRefreshController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsAirPlayForMediaPlayback: true,
    ),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(),
        onRefresh: () async {
          if (Platform.isAndroid) {
            inAppWebViewController?.reload();
          } else if (Platform.isIOS) {
            inAppWebViewController?.loadUrl(
              urlRequest: URLRequest(
                url: await inAppWebViewController?.getUrl(),
              ),
            );
          }
        });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: const Text(
          "Terms & Condition",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          progress < 1.0
              ? LinearProgressIndicator(
            value: progress,
            color: Colors.blue,
            minHeight: 6,
          )
              : Container(),
          Expanded(
            flex: 15,
            child: InAppWebView(
              initialOptions: options,
              key: inAppWebViewKey,
              initialUrlRequest: URLRequest(
                url: Uri.parse("https://flutterninjas.blogspot.com/2022/12/terms-and-conditions.html"),
              ),
              onWebViewCreated: (controller) {
                inAppWebViewController = controller;
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
