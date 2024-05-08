import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_screen/widget/html_builder.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'enums.dart';

import 'dart:async' show Completer;
import 'dart:convert' show utf8;
import 'dart:io'
    show File, HttpRequest, HttpServer, HttpStatus, InternetAddress, Platform;


class ModelWidget extends StatefulWidget {
  const ModelWidget({
    super.key,
    // Attributes
    required this.src,
    this.poster,
    this.seamlessPoster,
    this.loading,

    this.cameraControls=true,
    this.enablePan,
    this.touchAction,
    this.disableZoom,
    this.autoRotate,
    this.cameraOrbit,
    this.cameraTarget,
    this.fieldOfView,


    this.shadowIntensity,
    this.shadowSoftness,
    this.scale,

    this.backgroundColor = Colors.transparent,
    });

    final String src;
    final String? poster;
    final bool? seamlessPoster;
    final Loading? loading;
    final bool? cameraControls;
    final bool? enablePan;
    final TouchAction? touchAction;
    final bool? disableZoom;
    final bool? autoRotate;
    final String? cameraOrbit;
    final String? cameraTarget;
    final String? fieldOfView;

    final num? shadowIntensity;
    final num? shadowSoftness;
    final String? scale;
    final Color backgroundColor;


  @override
  State<ModelWidget> createState() => _ModelWidgetState();
}

class _ModelWidgetState extends State<ModelWidget> {
  final Completer<WebViewController> _controller =
    Completer<WebViewController>();

  HttpServer? _httpServer;
  late String _serverURL;

  @override
  void initState() {
    super.initState();
    _initServer();
  }

  @override
  void dispose() {
    super.dispose();
    if (_httpServer != null) {
      _httpServer!.close(force: true);
      _httpServer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _httpServer == null 
    ?
    const Center(
      child: CircularProgressIndicator(),
    ) 
    :
    WebView(
      backgroundColor: Colors.transparent,
      initialUrl: null,
      javascriptMode: JavascriptMode.unrestricted,
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer(),),
      },
      onWebViewCreated: (final WebViewController controller) async {
        _controller.complete(controller);
        await controller.loadUrl(_serverURL);
      },
      
    );
  }

  Future<void> _initServer() async {
    _httpServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);

    _httpServer!.listen((final HttpRequest request) async { 
      final response = request.response;
      if (request.uri.path == '/' || request.uri.path == '/index.html') {
        // html 템플릿 읽어온 후 주어진 인자에 맞게 html 빌드
        final htmlTemplate = await rootBundle.loadString('assets/template.html');
        final responseHtml = utf8.encode(_buildHtml(htmlTemplate));

        response
            ..statusCode = HttpStatus.ok
            ..headers.add("Content-Type", "text/html;charset=UTF-8")
            ..headers.add("Content-Length", responseHtml.length.toString())
            ..add(responseHtml);

        await response.close();
      } else if (request.uri.path == '/model-viewer.min.js') {
        // 로컬에 있는 model_viewer.min.js 보내기
        final model_viewer_byte = await rootBundle.load('assets/model-viewer.min.js');
        final model_viewer = model_viewer_byte.buffer.asUint8List(model_viewer_byte.offsetInBytes, model_viewer_byte.lengthInBytes);

        response
            ..statusCode = HttpStatus.ok
            ..headers.add("Content-Type", "application/javascript;charset=UTF-8")
            ..headers.add("Content-Length", model_viewer.lengthInBytes.toString())
            ..add(model_viewer);
        
        await response.close();
      } else if (request.uri.path == '/model') {
        final model_byte = await rootBundle.load('assets/model/${widget.src}');
        final model = model_byte.buffer.asUint8List(model_byte.offsetInBytes, model_byte.lengthInBytes);

        response
            ..statusCode = HttpStatus.ok
            ..headers.add("Content-Type", "application/octet-stream")
            ..headers.add("Content-Length", model.lengthInBytes.toString())
            ..headers.add("Access-Control-Allow-Origin", "*")
            ..add(model);
          
        await response.close();
      }
    });

    setState(() {
      _httpServer;
      final host = _httpServer!.address.address;
      final port = _httpServer!.port;
      _serverURL = "http://$host:$port/";
    });
  }

  String _buildHtml(final String template) {
    return HTMLBuilder.build(
      htmlTemplate: template,
      src: '/model',
      poster: widget.poster,
      seamlessPoster: widget.seamlessPoster,
      loading: widget.loading,

      cameraControls: widget.cameraControls,
      enablePan: widget.enablePan,
      touchAction: widget.touchAction,
      disableZoom: widget.disableZoom,
      autoRotate: widget.autoRotate,
      cameraOrbit: widget.cameraOrbit,
      cameraTarget: widget.cameraTarget,
      fieldOfView: widget.fieldOfView,

      shadowIntensity: widget.shadowIntensity,
      shadowSoftness: widget.shadowSoftness,
      scale: widget.scale,
      
      backgroundColor: widget.backgroundColor,
    );
  }
}

