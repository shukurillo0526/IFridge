// Web-specific YouTube embed using dart:html iframe.
// This file is only imported when running on web (dart.library.html).

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

final Set<String> _registered = {};

Widget buildWebEmbed(String youtubeId, {bool autoplay = false}) {
  final viewKey = 'yt-embed-$youtubeId';
  registerView(youtubeId);
  return HtmlElementView(viewType: viewKey);
}

void registerView(String youtubeId) {
  final viewKey = 'yt-embed-$youtubeId';
  if (_registered.contains(viewKey)) return;
  _registered.add(viewKey);
  try {
    ui_web.platformViewRegistry.registerViewFactory(viewKey, (int id) {
      return html.IFrameElement()
        ..src = 'https://www.youtube.com/embed/$youtubeId?rel=0&modestbranding=1&playsinline=1'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'autoplay; encrypted-media; gyroscope; picture-in-picture'
        ..allowFullscreen = true;
    });
  } catch (_) {}
}
