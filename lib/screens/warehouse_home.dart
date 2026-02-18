import 'package:flutter/material.dart';

class WarehouseHomePage extends StatefulWidget {
  const WarehouseHomePage({super.key});

  @override
  State<WarehouseHomePage> createState() => _WarehouseHomePageState();
}

class _WarehouseHomePageState extends State<WarehouseHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
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
      backgroundColor: const Color(0xFFEAEFEF),
      body: FadeTransition(
        opacity: _anim,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildBody(size)),
          ],
        ),
      ),
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
        gradient: LinearGradient(
          colors: [Color(0xFF1A2E3D), Color(0xFF25343F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E6DA4).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF2E6DA4).withOpacity(0.5)),
                ),
                child: const Icon(Icons.warehouse_rounded, color: Color(0xFF6BB8F0), size: 22),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('District Warehouse',
                        style: TextStyle(color: Color(0xFFBFC9D1), fontSize: 12, letterSpacing: 1)),
                    Text('Chennai Central Hub',
                        style: TextStyle(
                            color: Color(0xFFEAEFEF), fontSize: 17, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFFEAEFEF)),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.logout_rounded, color: Color(0xFFBFC9D1), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Stock summary bar
          Row(
            children: [
              _headerChip('Current Stock', '42,800 MT', const Color(0xFF4CAF50)),
              const SizedBox(width: 10),
              _headerChip('Incoming', '8,200 MT', const Color(0xFFFF9B51)),
              const SizedBox(width: 10),
              _headerChip('Low Stock Shops', '14', const Color(0xFFEF5350)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
            Text(label,
                style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Inventory Status'),
          const SizedBox(height: 12),
          _buildInventoryCards(),
          const SizedBox(height: 22),
          _sectionTitle('Recent Shipments'),
          const SizedBox(height: 12),
          _buildShipmentList(),
          const SizedBox(height: 22),
          _sectionTitle('Quick Actions'),
          const SizedBox(height: 12),
          _buildQuickActions(),
          const SizedBox(height: 22),
          _sectionTitle('Alert Center'),
          const SizedBox(height: 12),
          _buildAlerts(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
            color: Color(0xFF25343F), fontSize: 17, fontWeight: FontWeight.w800),
      );

  Widget _buildInventoryCards() {
    final items = [
      {'item': 'Rice', 'stock': '18,400 MT', 'cap': 0.72, 'color': const Color(0xFF1B8A5A)},
      {'item': 'Wheat', 'stock': '12,100 MT', 'cap': 0.56, 'color': const Color(0xFF2E6DA4)},
      {'item': 'Sugar', 'stock': '4,200 MT', 'cap': 0.38, 'color': const Color(0xFFFF9B51)},
      {'item': 'Dal', 'stock': '8,100 MT', 'cap': 0.82, 'color': const Color(0xFF7B5EA7)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.7,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        final cap = item['cap'] as double;
        final color = item['color'] as Color;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 500 + i * 100),
          builder: (_, v, child) =>
              Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 15 * (1 - v)), child: child)),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                        style: const TextStyle(
                            color: Color(0xFF25343F), fontWeight: FontWeight.w800, fontSize: 14)),
                    Text('${(cap * 100).toInt()}%',
                        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
                Text(item['stock'] as String,
                    style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 11)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: cap,
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

  Widget _buildShipmentList() {
    final shipments = [
      {'id': 'SH-2024-0891', 'to': 'Anna Nagar Shop', 'qty': '1,200 MT', 'status': 'Dispatched', 'color': const Color(0xFF2E6DA4)},
      {'id': 'SH-2024-0890', 'to': 'T. Nagar Depot', 'qty': '850 MT', 'status': 'Delivered', 'color': const Color(0xFF1B8A5A)},
      {'id': 'SH-2024-0889', 'to': 'Adyar Shop #3', 'qty': '640 MT', 'status': 'Created', 'color': const Color(0xFFBFC9D1)},
    ];

    return Column(
      children: shipments.map((s) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (s['color'] as Color).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.local_shipping_rounded, color: s['color'] as Color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['id'] as String,
                      style: const TextStyle(color: Color(0xFF25343F), fontWeight: FontWeight.w700, fontSize: 13)),
                  Text('→ ${s['to']}  •  ${s['qty']}',
                      style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: (s['color'] as Color).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                s['status'] as String,
                style: TextStyle(
                    color: s['color'] as Color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'label': 'Receive Stock', 'icon': Icons.download_rounded, 'color': const Color(0xFF1B8A5A)},
      {'label': 'Dispatch to Shop', 'icon': Icons.upload_rounded, 'color': const Color(0xFF2E6DA4)},
      {'label': 'Inventory', 'icon': Icons.list_alt_rounded, 'color': const Color(0xFF7B5EA7)},
      {'label': 'Complaints', 'icon': Icons.report_rounded, 'color': const Color(0xFFEF5350)},
    ];
    return Row(
      children: actions.map((a) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: (a['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: (a['color'] as Color).withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(a['icon'] as IconData, color: a['color'] as Color, size: 22),
                const SizedBox(height: 6),
                Text(a['label'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: a['color'] as Color, fontSize: 9, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildAlerts() {
    final alerts = [
      {'msg': 'Shop #14 stock below threshold', 'type': 'Low Stock', 'urgent': true},
      {'msg': 'Restitution case #RC-0342 pending approval', 'type': 'Restitution', 'urgent': true},
      {'msg': 'Incoming shipment ETA: 3 hrs', 'type': 'Info', 'urgent': false},
    ];

    return Column(
      children: alerts.map((a) {
        final urgent = a['urgent'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: urgent ? const Color(0xFFEF5350).withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: urgent
                    ? const Color(0xFFEF5350).withOpacity(0.3)
                    : Colors.transparent),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
          ),
          child: Row(
            children: [
              Icon(
                urgent ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
                color: urgent ? const Color(0xFFEF5350) : const Color(0xFF2E6DA4),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a['msg'] as String,
                        style: TextStyle(
                            color: const Color(0xFF25343F),
                            fontSize: 12,
                            fontWeight: urgent ? FontWeight.w700 : FontWeight.w500)),
                    Text(a['type'] as String,
                        style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 10)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFBFC9D1)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.dashboard_rounded, 'label': 'Home'},
      {'icon': Icons.download_rounded, 'label': 'Receive'},
      {'icon': Icons.upload_rounded, 'label': 'Dispatch'},
      {'icon': Icons.inventory_rounded, 'label': 'Inventory'},
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
                        color: sel ? const Color(0xFF2E6DA4) : const Color(0xFFBFC9D1),
                        size: 22),
                    const SizedBox(height: 3),
                    Text(items[i]['label'] as String,
                        style: TextStyle(
                            color: sel ? const Color(0xFF2E6DA4) : const Color(0xFFBFC9D1),
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
