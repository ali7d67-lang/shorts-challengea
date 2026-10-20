import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateDailyStreak() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _db.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      final data = snapshot.data();
      final lastActive = (data?['lastActive'] as Timestamp?)?.toDate();
      int currentStreak = data?['streak'] ?? 0;

      final now = DateTime.now();
      if (lastActive != null) {
        final difference = now.difference(lastActive).inHours;
        if (difference >= 24 && difference < 48) {
          currentStreak += 1;
        } else if (difference >= 48) {
          currentStreak = 1;
        }
      } else {
        currentStreak = 1;
      }

      await userDoc.update({
        'streak': currentStreak,
        'lastActive': FieldValue.serverTimestamp(),
      });
    }
  }
}
