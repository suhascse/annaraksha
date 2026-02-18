import 'package:flutter/material.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: FadeTransition(
        opacity: _anim,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildBody(size)),
          ],
        ),
      ),
      floatingActionButton: _buildFab(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF25343F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9B51).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.storefront_rounded, color: Color(0xFFFF9B51), size: 22),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ration Shop Dealer', style: TextStyle(color: Color(0xFFBFC9D1), fontSize: 11, letterSpacing: 1)),
                    Text('Shop ID: RS-2024-0341', style: TextStyle(color: Color(0xFFEAEFEF), fontSize: 17, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.logout_rounded, color: Color(0xFFBFC9D1), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Trust score
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _trustItem('Trust Score', '94%', Icons.verified_rounded, const Color(0xFF4CAF50)),
                ),
                Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
                Expanded(
                  child: _trustItem("Today's Served", '148', Icons.people_rounded, const Color(0xFFFF9B51)),
                ),
                Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
                Expanded(
                  child: _trustItem('Pending Cases', '3', Icons.pending_actions_rounded, const Color(0xFFEF5350)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _trustItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15)),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 9)),
      ],
    );
  }

  Widget _buildBody(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Stock Availability'),
          const SizedBox(height: 12),
          _buildStockCards(),
          const SizedBox(height: 22),
          _sectionTitle('Recent Distributions'),
          const SizedBox(height: 12),
          _buildDistributions(),
          const SizedBox(height: 22),
          _sectionTitle('Restitution Cases'),
          const SizedBox(height: 12),
          _buildRestitutionCases(),
          const SizedBox(height: 22),
          _sectionTitle('Incoming Shipment'),
          const SizedBox(height: 12),
          _buildIncomingShipment(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(color: Color(0xFF25343F), fontSize: 17, fontWeight: FontWeight.w800),
      );

  Widget _buildStockCards() {
    final items = [
      {'item': 'Rice', 'qty': '1,840 kg', 'remaining': 0.68, 'threshold': false, 'color': const Color(0xFF1B8A5A)},
      {'item': 'Wheat', 'qty': '920 kg', 'remaining': 0.42, 'threshold': false, 'color': const Color(0xFF2E6DA4)},
      {'item': 'Sugar', 'qty': '180 kg', 'remaining': 0.18, 'threshold': true, 'color': const Color(0xFFEF5350)},
      {'item': 'Dal', 'qty': '640 kg', 'remaining': 0.72, 'threshold': false, 'color': const Color(0xFF7B5EA7)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        final color = item['color'] as Color;
        final low = item['threshold'] as bool;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + i * 80),
          builder: (_, v, child) =>
              Opacity(opacity: v, child: Transform.scale(scale: 0.9 + 0.1 * v, child: child)),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: low ? const Color(0xFFEF5350).withOpacity(0.4) : Colors.transparent),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['item'] as String,
                        style: const TextStyle(color: Color(0xFF25343F), fontWeight: FontWeight.w700, fontSize: 14)),
                    if (low)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF5350).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('LOW', style: TextStyle(color: Color(0xFFEF5350), fontSize: 8, fontWeight: FontWeight.w800)),
                      ),
                  ],
                ),
                Text(item['qty'] as String,
                    style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 12)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item['remaining'] as double,
                    backgroundColor: color.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDistributions() {
    final list = [
      {'card': 'RC-0012', 'name': 'Karthikeyan M', 'items': 'Rice 5kg, Sugar 1kg', 'time': '10:24 AM'},
      {'card': 'RC-0088', 'name': 'Meena S', 'items': 'Rice 5kg, Dal 2kg', 'time': '10:12 AM'},
      {'card': 'RC-0215', 'name': 'Ramesh P', 'items': 'Wheat 5kg, Sugar 1kg', 'time': '9:58 AM'},
    ];

    return Column(
      children: list.map((d) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1B8A5A).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8A5A), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d['name'] as String,
                      style: const TextStyle(color: Color(0xFF25343F), fontWeight: FontWeight.w700, fontSize: 13)),
                  Text('${d['card']}  •  ${d['items']}',
                      style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 10)),
                ],
              ),
            ),
            Text(d['time'] as String,
                style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 11)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildRestitutionCases() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9B51).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF9B51).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.gavel_rounded, color: Color(0xFFFF9B51), size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('3 Mandatory Restitution Cases',
                    style: TextStyle(color: Color(0xFF25343F), fontWeight: FontWeight.w700, fontSize: 13)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9B51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Resolve', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...[
            'RC-0099 – Lakshmi D – Missed Oct cycle',
            'RC-0102 – Murugan K – Missed Sep cycle',
            'RC-0115 – Priya R – Missed Oct cycle',
          ].map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Color(0xFFFF9B51), size: 6),
                const SizedBox(width: 10),
                Text(c, style: const TextStyle(color: Color(0xFF25343F), fontSize: 12)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildIncomingShipment() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E6DA4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_shipping_rounded, color: Color(0xFF2E6DA4), size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SH-2024-0892', style: TextStyle(color: Color(0xFF25343F), fontWeight: FontWeight.w700, fontSize: 14)),
                Text('Rice 800kg, Wheat 400kg, Sugar 200kg', style: TextStyle(color: Color(0xFFBFC9D1), fontSize: 11)),
                SizedBox(height: 4),
                Text('Expected arrival: ~2 hrs', style: TextStyle(color: Color(0xFF2E6DA4), fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF25343F), size: 28),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: const Color(0xFFFF9B51),
      icon: const Icon(Icons.person_search_rounded, color: Colors.white),
      label: const Text('Verify & Distribute', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.dashboard_rounded, 'label': 'Home'},
      {'icon': Icons.qr_code_scanner_rounded, 'label': 'Scan QR'},
      {'icon': Icons.people_alt_rounded, 'label': 'Beneficiary'},
      {'icon': Icons.inventory_2_rounded, 'label': 'Stock'},
      {'icon': Icons.report_rounded, 'label': 'Reports'},
    ];
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x15000000), blurRadius: 16, offset: Offset(0, -4))],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final sel = i == _navIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _navIndex = i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[i]['icon'] as IconData,
                        color: sel ? const Color(0xFFFF9B51) : const Color(0xFFBFC9D1), size: 22),
                    const SizedBox(height: 3),
                    Text(items[i]['label'] as String,
                        style: TextStyle(
                            color: sel ? const Color(0xFFFF9B51) : const Color(0xFFBFC9D1),
                            fontSize: 9,
                            fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
