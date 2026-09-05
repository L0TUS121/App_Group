import 'package:url_launcher/url_launcher.dart';

class LinkService {
  static Future<void> open(String url) async {
    if (url.isEmpty || url == '-') {
      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
