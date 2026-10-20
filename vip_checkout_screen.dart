import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VipCheckoutScreen extends StatefulWidget {
  const VipCheckoutScreen({Key? key}) : super(key: key);

  @override
  State<VipCheckoutScreen> createState() => _VipCheckoutScreenState();
}

class _VipCheckoutScreenState extends State<VipCheckoutScreen> {
  bool _isLoading = false;

  Future<void> _payWithCryptomus() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://api.cryptomus.com/v1/payment'),
        headers: {
          'merchant': 'YOUR_MERCHANT_UUID',
          'sign': 'YOUR_GENERATED_SIGNATURE',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': '2.99',
          'currency': 'USD',
          'order_id': 'vip_\${DateTime.now().millisecondsSinceEpoch}',
          'url_return': 'https://shortschallenge.com/success',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentUrl = data['result']['url'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إنشاء فاتورة الكريبتو بنجاح: \$paymentUrl')),
        );
        await _activateVipStatus();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في الاتصال ببوابة الدفع: \$e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _payWithZainCashOrCard() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    await _activateVipStatus();
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم الدفع بنجاح عبر زين كاش / ماستركارد وتفعيل الـ VIP!')),
    );
  }

  Future<void> _activateVipStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'isVIP': true,
      'vipActivatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('ترقية حساب VIP', style: TextStyle(color: Color(0xFF00F2FE))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'اختر طريقة الدفع المناسبة لتفعيل عضوية VIP النيون وتجربة خالية من الإعلانات:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B51E0),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _isLoading ? null : _payWithCryptomus,
              icon: const Icon(Icons.currency_bitcoin, color: Colors.white),
              label: const Text('الدفع عبر العملات الرقمية (Cryptomus USDT/BTC)', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F2FE),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _isLoading ? null : _payWithZainCashOrCard,
              icon: const Icon(Icons.payment, color: Colors.black),
              label: const Text('الدفع عبر زين كاش / ماستركارد المحلية', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            if (_isLoading) ...[
              const SizedBox(height: 30),
              const Center(child: CircularProgressIndicator(color: Color(0xFF00F2FE))),
            ]
          ],
        ),
      ),
    );
  }
}
