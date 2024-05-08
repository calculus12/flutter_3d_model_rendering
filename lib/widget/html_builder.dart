import 'dart:convert' show htmlEscape;

import 'package:flutter/material.dart';
import './enums.dart';

abstract class HTMLBuilder {
  HTMLBuilder._();

  static String build({
    String htmlTemplate = '',
    // Attributes
    required final String src,
    final String? poster,
    final bool? seamlessPoster,
    final Loading? loading,

    final bool? cameraControls = true,
    final bool? enablePan,
    final TouchAction? touchAction = TouchAction.none,
    final bool? disableZoom,
    final bool? autoRotate,
    final String? cameraOrbit,
    final String? cameraTarget,
    final String? fieldOfView,


    final num? shadowIntensity,
    final num? shadowSoftness,
    final String? scale,

    final Color backgroundColor = Colors.transparent,
  }) {

    final html = StringBuffer(htmlTemplate);

    html.write('<model-viewer');

    // /assets 디렉토리에 있는 모델 파일 이름
    html.write(' src="${htmlEscape.convert(src)}"');

    // poster -> 로딩을 위한 placeholder
    if (poster != null) {
      html.write(' poster="${htmlEscape.convert(poster)}"');
    }
    // seamless-poster
    if (seamlessPoster ?? false) {
      html.write(' seamless-poster');
    }
    // loading
    if (loading != null) {
      switch (loading) {
        case Loading.auto:
          html.write(' loading="auto"');
          break;
        case Loading.lazy:
          html.write(' loading="lazy"');
          break;
        case Loading.eager:
          html.write(' loading="eager"');
          break;
      }
    }
    // reveal : auto, manual
    html.write(' reveal="auto"');

    // Staging & Cameras Attributes
    // camera-controls
    if (cameraControls ?? false) {
      html.write(' camera-controls');
    }
    // enable-pan
    if (enablePan ?? false) {
      html.write(' enable-pan');
    }
    // touch-action
    if (touchAction != null) {
      switch (touchAction) {
        case TouchAction.none:
          html.write(' touch-action="none"');
          break;
        case TouchAction.panX:
          html.write(' touch-action="pan-x"');
          break;
        case TouchAction.panY:
          html.write(' touch-action="pan-y"');
          break;
      }
    }
    // disable-zoom
    if (disableZoom ?? false) {
      html.write(' disable-zoom');
    }
  
    // auto-rotate
    if (autoRotate ?? false) {
      html.write(' auto-rotate');
    }

    // camera-orbit: $theta, $phi, $radius ex) 0deg, 75deg, 105%
    if (cameraOrbit != null) {
      html.write(' camera-orbit="${htmlEscape.convert(cameraOrbit)}"');
    }
    // camera-target
    if (cameraTarget != null) {
      html.write(' camera-target="${htmlEscape.convert(cameraTarget)}"');
    }
    // field-of-view
    if (fieldOfView != null) {
      html.write(' field-of-view="${htmlEscape.convert(fieldOfView)}"');
    }
    
    
    // shadow-intensity
    if (shadowIntensity != null) {
      if (shadowIntensity < 0 || shadowIntensity > 1) {
        throw RangeError('shadow-intensity must be between 0 and 1');
      }
      html.write(' shadow-intensity="$shadowIntensity"');
    }
    // shadow-softness
    if (shadowSoftness != null) {
      if (shadowSoftness < 0 || shadowSoftness > 1) {
        throw RangeError('shadow-softness must be between 0 and 1');
      }
      html.write(' shadow-softness="$shadowSoftness"');
    }

    // scale: (x, y, z) 방향으로의 scaling ex) 1 1 1 
    if (scale != null) {
      html.write(' scale="${htmlEscape.convert(scale)}"');
    }

    // Styles
    html.write(' style="');
    // CSS Styles
    html.write(
        'background-color: rgba(${backgroundColor.red}, ${backgroundColor.green}, ${backgroundColor.blue}, ${backgroundColor.alpha}); ');

    html.write('"'); // close style


    html.writeln('>'); // attribute 태그 끝
    html.writeln('</model-viewer>'); // 태그 닫기


    debugPrint("HTML generated for model_viewer_plus:");
    debugPrint(html.toString()); // DEBUG

    return html.toString();
  }
}