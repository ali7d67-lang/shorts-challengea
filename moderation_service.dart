import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ModerationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> reportVideo(String videoId, String reason) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('reports').add({
      'videoId': videoId,
      'reporterId': user.uid,
      'reason': reason,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }

  bool containsForbiddenWords(String text) {
    final List<String> forbiddenWords = ['spam', 'abuse', 'hack', 'شتم', 'تهكير'];
    for (var word in forbiddenWords) {
      if (text.toLowerCase().contains(word)) {
        return true;
      }
    }
    return false;
  }
}
