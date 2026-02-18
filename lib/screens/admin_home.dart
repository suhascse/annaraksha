import 'package:flutter/material.dart';
import 'dart:math' as math;

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fade;
  int _navIndex = 0;

  final List<_StatCard> _stats = [
    _StatCard('Total Districts', '38', Icons.map_rounded, Color(0xFF25343F), '+2 active'),
    _StatCard('Warehouses', '142', Icons.warehouse_rounded, Color(0xFF2E6DA4), 'All operational'),
    _StatCard('Ration Shops', '8,940', Icons.storefront_rounded, Color(0xFF1B8A5A), '98.2% active'),
    _StatCard('State Stock (MT)', '2,41,800', Icons.inventory_2_rounded, Color(0xFFFF9B51), '68% utilized'),
    _StatCard('Dispatched (Month)', '89,200 MT', Icons.local_shipping_rounded, Color(0xFF7B5EA7), 'On track'),
    _StatCard('Missed Incidents', '124', Icons.warning_amber_rounded, Color(0xFFE53935), '↓18% this month'),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFEF),
      body: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            _buildHeader(size),
            Expanded(
              child: _buildBody(size),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 20,
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
                  color: const Color(0xFFFF9B51),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Government Admin',
                      style: TextStyle(color: Color(0xFFBFC9D1), fontSize: 12, letterSpacing: 1),
                    ),
                    Text(
                      'State Control Panel',
                      style: TextStyle(
                        color: Color(0xFFEAEFEF),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_rounded, color: Color(0xFFEAEFEF)),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF9B51),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout_rounded, color: Color(0xFFBFC9D1), size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickStat('Distributed', '1.84L MT', Icons.check_circle_rounded, const Color(0xFF4CAF50)),
                _vDivider(),
                _quickStat('Restitution', '312 Active', Icons.gavel_rounded, const Color(0xFFFF9B51)),
                _vDivider(),
                _quickStat('Complaints', '89 Open', Icons.report_rounded, const Color(0xFFEF5350)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(width: 1, height: 36, color: Colors.white.withOpacity(0.1));

  Widget _quickStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 10)),
      ],
    );
  }

  Widget _buildBody(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(color: Color(0xFF25343F), fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: size.width < 380 ? 1.4 : 1.6,
            ),
            itemCount: _stats.length,
            itemBuilder: (_, i) => _buildStatCard(_stats[i], i),
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Actions',
            style: TextStyle(color: Color(0xFF25343F), fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          _buildQuickActions(),
          const SizedBox(height: 24),
          const Text(
            'District Performance',
            style: TextStyle(color: Color(0xFF25343F), fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          _buildDistrictList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(_StatCard card, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 80),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 20 * (1 - v)), child: child),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: card.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(card.icon, color: card.color, size: 18),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.value,
                  style: const TextStyle(
                    color: Color(0xFF25343F),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  card.label,
                  style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 10),
                ),
                const SizedBox(height: 4),
                Text(
                  card.sub,
                  style: TextStyle(
                    color: card.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'label': 'Allocate Stock', 'icon': Icons.add_box_rounded, 'color': const Color(0xFF25343F)},
      {'label': 'View Shipments', 'icon': Icons.local_shipping_rounded, 'color': const Color(0xFF2E6DA4)},
      {'label': 'Complaints', 'icon': Icons.report_problem_rounded, 'color': const Color(0xFFE53935)},
      {'label': 'Analytics', 'icon': Icons.bar_chart_rounded, 'color': const Color(0xFF7B5EA7)},
    ];

    return Row(
      children: actions.map((a) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: (a['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: (a['color'] as Color).withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Icon(a['icon'] as IconData, color: a['color'] as Color, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      a['label'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: a['color'] as Color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDistrictList() {
    final districts = [
      {'name': 'Chennai', 'score': 0.94, 'shops': '1,240'},
      {'name': 'Coimbatore', 'score': 0.88, 'shops': '980'},
      {'name': 'Madurai', 'score': 0.76, 'shops': '870'},
      {'name': 'Salem', 'score': 0.65, 'shops': '640'},
    ];

    return Column(
      children: districts.map((d) {
        final score = d['score'] as double;
        final color = score > 0.85
            ? const Color(0xFF1B8A5A)
            : score > 0.7
                ? const Color(0xFFFF9B51)
                : const Color(0xFFE53935);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (d['name'] as String).substring(0, 2),
                    style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d['name'] as String,
                      style: const TextStyle(
                        color: Color(0xFF25343F),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${d['shops']} shops',
                      style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 11),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(score * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: 60,
                      height: 4,
                      child: LinearProgressIndicator(
                        value: score,
                        backgroundColor: color.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
      {'icon': Icons.inventory_2_rounded, 'label': 'Stock'},
      {'icon': Icons.local_shipping_rounded, 'label': 'Shipments'},
      {'icon': Icons.gavel_rounded, 'label': 'Restitution'},
      {'icon': Icons.bar_chart_rounded, 'label': 'Analytics'},
    ];

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final sel = i == _navIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _navIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[i]['icon'] as IconData,
                      color: sel ? const Color(0xFFFF9B51) : const Color(0xFFBFC9D1),
                      size: 22,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[i]['label'] as String,
                      style: TextStyle(
                        color: sel ? const Color(0xFFFF9B51) : const Color(0xFFBFC9D1),
                        fontSize: 9,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
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

class _StatCard {
  final String label, value, sub;
  final IconData icon;
  final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color, this.sub);
}
