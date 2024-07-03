import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchLink {
  void makePhoneCall(String phoneNumber) async {
    String digitsOnly = phoneNumber.replaceAll(' ', '');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: digitsOnly,
    );
    await launchUrl(launchUri);
  }

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  void launchEmail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Questions or Concerns', // add subject
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not launch $params';
    }
  }

  void launchURL(String url) async {
    Uri format = Uri.parse(url);
    if (await canLaunchUrl(format)) {
      await launchUrl(format);
    } else {
      throw 'Could not launch $url';
    }
  }
}
