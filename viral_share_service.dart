import 'package:share_plus/share_plus.dart';

class ViralShareService {
  Future<void> shareToSocialMedia(String videoPath, String referralLink) async {
    await Share.shareXFiles(
      [XFile(videoPath)],
      text: 'شاهد تحديي الجديد على Shorts Challenge وانضم لي عبر الرابط: \$referralLink',
    );
  }
}
