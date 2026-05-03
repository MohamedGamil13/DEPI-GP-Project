import 'package:skillbridge/core/errors/call_exception.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:url_launcher/url_launcher.dart';

class CallService {
  Future<Result<void>> openCall(String path) async {
    try {
      if (path.isEmpty || path.length < 11) {
        return const Failure(InvalidPhoneNumberException());
      } //to Ensure That The path (pohne Number is True)
      final Uri callLaunchUri = Uri(scheme: "tel", path: "2$path");

      if (await canLaunchUrl(callLaunchUri)) {
        await launchUrl(callLaunchUri);
        return const Success(null);
      } else {
        return const Failure(CouldNotLaunchException());
      }
    } catch (e) {
      return Failure(
        UnknownCallException(code: 'unknown', message: e.toString()),
      );
    }
  }
}
