import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

/// Initializes a listener for deep links.
///
/// - [onUriReceived] is a callback that will be triggered whenever
///   a deep link URI is received.
/// - Internally subscribes to [AppLinks.uriLinkStream].
class DeepLinkService {
  StreamSubscription<Uri>? _sub;

  void initListener(void Function(Uri) onUriReceived) {
    final appLinks = AppLinks();

    _sub = appLinks.uriLinkStream.listen((uri) {
      debugPrint("🔗 Received URI: $uri");
      onUriReceived(uri);
    });
  }

  void dispose() {
    _sub?.cancel();
  }
}
