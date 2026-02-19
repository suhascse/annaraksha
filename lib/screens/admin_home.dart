import 'dart:math' as math;
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fade;
  late Animation<Offset> _slideUp;
  late Animation<double> _pulse;
  int _navIndex = 0;

  final List<_StatCard> _stats = [
    _StatCard('Total Districts', '38', Icons.map_rounded,
        Color(0xFF25343F), '+2 active'),
    _StatCard('Warehouses', '142', Icons.warehouse_rounded,
        Color(0xFF2E6DA4), 'All operational'),
    _StatCard('Ration Shops', '8,940', Icons.storefront_rounded,
        Color(0xFF1B8A5A), '98.2% active'),
    _StatCard('State Stock (MT)', '2,41,800', Icons.inventory_2_rounded,
        Color(0xFFFF9B51), '68% utilized'),
    _StatCard('Dispatched (Month)', '89,200 MT', Icons.local_shipping_rounded,
        Color(0xFF7B5EA7), 'On track'),
    _StatCard('Missed Incidents', '124', Icons.warning_amber_rounded,
        Color(0xFFE53935), '↓18% this month'),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _pulse = Tween<double>(begin: 0.95, end: 1.05)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    setState(() => _navIndex = index);
    _slideController.reset();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;
    final topPad = mq.padding.top;
    final bottomPad = mq.padding.bottom;
    final isSmall = sw < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFEAEFEF),
      body: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            _buildHeader(sw, sh, topPad, isSmall),
            Expanded(
              child: SlideTransition(
                position: _slideUp,
                child: FadeTransition(
                  opacity: _fade,
                  child: _buildCurrentPage(sw, sh, isSmall),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(sw, bottomPad, isSmall),
    );
  }

  Widget _buildCurrentPage(double sw, double sh, bool isSmall) {
    switch (_navIndex) {
      case 0:
        return _buildDashboard(sw, sh, isSmall);
      case 1:
        return _buildStockPage(sw, sh, isSmall);
      case 2:
        return _buildShipmentsPage(sw, sh, isSmall);
      case 3:
        return _buildRestitutionPage(sw, sh, isSmall);
      case 4:
        return _buildAnalyticsPage(sw, sh, isSmall);
      default:
        return _buildDashboard(sw, sh, isSmall);
    }
  }

  // ── HEADER ─────────────────────────────────────────────
  Widget _buildHeader(double sw, double sh, double topPad, bool isSmall) {
    final hPad = sw * 0.05;
    final iconSize = sw * 0.055;
    final titleSize = isSmall ? 15.0 : sw * 0.045;
    final subtitleSize = isSmall ? 10.0 : sw * 0.03;
    final headerRadius = sw * 0.07;

    return Container(
      padding: EdgeInsets.only(
        top: topPad + sh * 0.02,
        left: hPad,
        right: hPad,
        bottom: sh * 0.025,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF25343F),
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(headerRadius)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(sw * 0.025),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9B51),
                  borderRadius: BorderRadius.circular(sw * 0.035),
                ),
                child: Icon(Icons.account_balance_rounded,
                    color: Colors.white, size: iconSize),
              ),
              SizedBox(width: sw * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Government Admin',
                      style: TextStyle(
                        color: const Color(0xFFBFC9D1),
                        fontSize: subtitleSize,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'State Control Panel',
                      style: TextStyle(
                        color: const Color(0xFFEAEFEF),
                        fontSize: titleSize,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              ScaleTransition(
                scale: _pulse,
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () => _showNotificationsSheet(context),
                      icon: Icon(Icons.notifications_rounded,
                          color: const Color(0xFFEAEFEF), size: iconSize),
                    ),
                    Positioned(
                      right: sw * 0.02,
                      top: sw * 0.02,
                      child: Container(
                        width: sw * 0.022,
                        height: sw * 0.022,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF9B51),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('3',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: sw * 0.012,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(sw * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(sw * 0.025),
                  ),
                  child: Icon(Icons.logout_rounded,
                      color: const Color(0xFFBFC9D1),
                      size: iconSize * 0.82),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNotificationsSheet(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF25343F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Notifications',
                style: TextStyle(
                    color: Color(0xFFEAEFEF),
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            _notifTile(Icons.warning_amber_rounded, 'District 12 stock critical', '2 min ago', Color(0xFFE53935)),
            _notifTile(Icons.local_shipping_rounded, 'Shipment #4821 delivered', '1 hr ago', Color(0xFF1B8A5A)),
            _notifTile(Icons.inventory_2_rounded, 'Monthly report ready', '3 hrs ago', Color(0xFF2E6DA4)),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _notifTile(IconData icon, String msg, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg, style: const TextStyle(color: Color(0xFFEAEFEF), fontSize: 13, fontWeight: FontWeight.w500)),
                Text(time, style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── DASHBOARD ──────────────────────────────────────────
  Widget _buildDashboard(double sw, double sh, bool isSmall) {
    final hPad = sw * 0.04;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: sh * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Overview', sw),
          SizedBox(height: sh * 0.012),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: sw * 0.03,
              mainAxisSpacing: sw * 0.03,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (_, i) => _AnimatedStatCard(card: _stats[i], index: i, sw: sw),
          ),
          SizedBox(height: sh * 0.025),
          _sectionLabel('Quick Actions', sw),
          SizedBox(height: sh * 0.012),
          _buildQuickActions(sw, sh),
          SizedBox(height: sh * 0.025),
          _sectionLabel('Recent Activity', sw),
          SizedBox(height: sh * 0.012),
          _buildRecentActivity(sw),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, double sw) => Text(
        text,
        style: TextStyle(
          color: const Color(0xFF25343F),
          fontSize: sw * 0.042,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      );

  Widget _buildQuickActions(double sw, double sh) {
    final actions = [
      {'icon': Icons.add_box_rounded, 'label': 'Add Stock', 'color': Color(0xFF2E6DA4)},
      {'icon': Icons.local_shipping_rounded, 'label': 'New Dispatch', 'color': Color(0xFF1B8A5A)},
      {'icon': Icons.person_add_rounded, 'label': 'Add Beneficiary', 'color': Color(0xFF7B5EA7)},
      {'icon': Icons.report_rounded, 'label': 'File Report', 'color': Color(0xFFE53935)},
    ];
    return Row(
      children: actions.map((a) {
        final color = a['color'] as Color;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.01),
            child: _PressableButton(
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(sw * 0.03),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(sw * 0.035),
                      border: Border.all(color: color.withOpacity(0.2)),
                    ),
                    child: Icon(a['icon'] as IconData, color: color, size: sw * 0.055),
                  ),
                  SizedBox(height: sw * 0.015),
                  Text(
                    a['label'] as String,
                    style: TextStyle(
                      fontSize: sw * 0.025,
                      color: const Color(0xFF25343F),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentActivity(double sw) {
    final activities = [
      _Activity('Warehouse 41 restocked', 'District 7 • 2 hrs ago', Icons.warehouse_rounded, Color(0xFF2E6DA4)),
      _Activity('3 incidents resolved', 'State HQ • 4 hrs ago', Icons.check_circle_rounded, Color(0xFF1B8A5A)),
      _Activity('Dispatch #8821 in transit', 'District 22 • 6 hrs ago', Icons.local_shipping_rounded, Color(0xFF7B5EA7)),
      _Activity('Monthly quota updated', 'Admin • Yesterday', Icons.update_rounded, Color(0xFFFF9B51)),
    ];
    return Column(
      children: activities.asMap().entries.map((e) {
        final a = e.value;
        return _AnimatedListTile(index: e.key, child: Container(
          margin: EdgeInsets.only(bottom: sw * 0.025),
          padding: EdgeInsets.all(sw * 0.035),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(sw * 0.04),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(sw * 0.025),
                decoration: BoxDecoration(
                  color: a.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(sw * 0.03),
                ),
                child: Icon(a.icon, color: a.color, size: sw * 0.05),
              ),
              SizedBox(width: sw * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.title, style: TextStyle(fontSize: sw * 0.032, fontWeight: FontWeight.w600, color: const Color(0xFF25343F))),
                    SizedBox(height: sw * 0.008),
                    Text(a.subtitle, style: TextStyle(fontSize: sw * 0.027, color: const Color(0xFFBFC9D1))),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: const Color(0xFFBFC9D1), size: sw * 0.05),
            ],
          ),
        ));
      }).toList(),
    );
  }

  // ── STOCK PAGE ─────────────────────────────────────────
  Widget _buildStockPage(double sw, double sh, bool isSmall) {
    final hPad = sw * 0.04;
    final categories = [
      _StockItem('Rice', 82000, 120000, Color(0xFF2E6DA4)),
      _StockItem('Wheat', 65000, 80000, Color(0xFF1B8A5A)),
      _StockItem('Sugar', 18000, 25000, Color(0xFFFF9B51)),
      _StockItem('Pulses', 12000, 16800, Color(0xFF7B5EA7)),
      _StockItem('Kerosene', 9400, 12000, Color(0xFFE53935)),
      _StockItem('Salt', 5100, 6000, Color(0xFF25343F)),
    ];
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: sh * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('State Stock Inventory', sw),
          SizedBox(height: sh * 0.005),
          Text('Total: 2,41,800 MT — 68% utilized',
              style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: sw * 0.028)),
          SizedBox(height: sh * 0.02),
          ...categories.asMap().entries.map((e) => _AnimatedListTile(
            index: e.key,
            child: _StockCard(item: e.value, sw: sw),
          )),
          SizedBox(height: sh * 0.02),
          _sectionLabel('Warehouse Status', sw),
          SizedBox(height: sh * 0.015),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: sw * 0.025,
              mainAxisSpacing: sw * 0.025,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, i) {
              final statuses = ['Optimal', 'Optimal', 'Low', 'Optimal', 'Critical', 'Optimal'];
              final colors = [Color(0xFF1B8A5A), Color(0xFF1B8A5A), Color(0xFFFF9B51), Color(0xFF1B8A5A), Color(0xFFE53935), Color(0xFF1B8A5A)];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(sw * 0.035),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warehouse_rounded, color: colors[i], size: sw * 0.06),
                    SizedBox(height: sw * 0.01),
                    Text('WH-${(i + 1) * 12}', style: TextStyle(fontSize: sw * 0.028, fontWeight: FontWeight.w700, color: const Color(0xFF25343F))),
                    Text(statuses[i], style: TextStyle(fontSize: sw * 0.022, color: colors[i])),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── SHIPMENTS PAGE ─────────────────────────────────────
  Widget _buildShipmentsPage(double sw, double sh, bool isSmall) {
    final hPad = sw * 0.04;
    final shipments = [
      _Shipment('#8821', 'Warehouse 12 → District 7', 'In Transit', '420 MT', Color(0xFF2E6DA4), 0.6),
      _Shipment('#8820', 'Warehouse 3 → District 14', 'Delivered', '310 MT', Color(0xFF1B8A5A), 1.0),
      _Shipment('#8819', 'Warehouse 27 → District 22', 'Delivered', '580 MT', Color(0xFF1B8A5A), 1.0),
      _Shipment('#8818', 'Warehouse 6 → District 2', 'Pending', '195 MT', Color(0xFFFF9B51), 0.0),
      _Shipment('#8817', 'Warehouse 18 → District 30', 'In Transit', '260 MT', Color(0xFF7B5EA7), 0.4),
      _Shipment('#8816', 'Warehouse 9 → District 11', 'Delayed', '340 MT', Color(0xFFE53935), 0.3),
    ];
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: sh * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _sectionLabel('Shipments', sw)),
              _PressableButton(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.035, vertical: sw * 0.018),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25343F),
                    borderRadius: BorderRadius.circular(sw * 0.025),
                  ),
                  child: Text('+ New', style: TextStyle(color: Colors.white, fontSize: sw * 0.03, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          SizedBox(height: sh * 0.008),
          Row(
            children: [
              _StatusChip('All', true, sw),
              _StatusChip('In Transit', false, sw),
              _StatusChip('Delivered', false, sw),
              _StatusChip('Pending', false, sw),
            ],
          ),
          SizedBox(height: sh * 0.015),
          ...shipments.asMap().entries.map((e) => _AnimatedListTile(
            index: e.key,
            child: _ShipmentCard(shipment: e.value, sw: sw),
          )),
        ],
      ),
    );
  }

  // ── RESTITUTION PAGE ───────────────────────────────────
  Widget _buildRestitutionPage(double sw, double sh, bool isSmall) {
    final hPad = sw * 0.04;
    final cases = [
      _RestitutionCase('RC-2024-112', 'Diversion of 2.4 MT Rice', 'District 8', 'Under Review', Color(0xFFFF9B51)),
      _RestitutionCase('RC-2024-108', 'Shop overcharging beneficiaries', 'District 15', 'Action Taken', Color(0xFF1B8A5A)),
      _RestitutionCase('RC-2024-101', 'Missing 0.8 MT Wheat', 'District 3', 'Closed', Color(0xFFBFC9D1)),
      _RestitutionCase('RC-2024-098', 'Fake beneficiary registration', 'District 21', 'Escalated', Color(0xFFE53935)),
      _RestitutionCase('RC-2024-091', 'Warehouse tampering report', 'District 29', 'Under Review', Color(0xFFFF9B51)),
    ];
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: sh * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Restitution Cases', sw),
          SizedBox(height: sh * 0.005),
          Text('124 active incidents — ↓18% this month',
              style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: sw * 0.028)),
          SizedBox(height: sh * 0.02),
          Container(
            padding: EdgeInsets.all(sw * 0.04),
            decoration: BoxDecoration(
              color: const Color(0xFF25343F),
              borderRadius: BorderRadius.circular(sw * 0.045),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniStat('Under Review', '48', Color(0xFFFF9B51), sw),
                _VertDivider(),
                _MiniStat('Escalated', '12', Color(0xFFE53935), sw),
                _VertDivider(),
                _MiniStat('Action Taken', '38', Color(0xFF1B8A5A), sw),
                _VertDivider(),
                _MiniStat('Closed', '26', Color(0xFFBFC9D1), sw),
              ],
            ),
          ),
          SizedBox(height: sh * 0.02),
          ...cases.asMap().entries.map((e) => _AnimatedListTile(
            index: e.key,
            child: _CaseCard(c: e.value, sw: sw),
          )),
        ],
      ),
    );
  }

  // ── ANALYTICS PAGE ─────────────────────────────────────
  Widget _buildAnalyticsPage(double sw, double sh, bool isSmall) {
    final hPad = sw * 0.04;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: sh * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Analytics', sw),
          SizedBox(height: sh * 0.005),
          Text('State-wide performance overview',
              style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: sw * 0.028)),
          SizedBox(height: sh * 0.02),

          // Monthly Dispatch Bar Chart
          _AnalyticsCard(
            title: 'Monthly Dispatches (MT)',
            sw: sw,
            child: _BarChart(sw: sw, sh: sh),
          ),
          SizedBox(height: sw * 0.04),

          // Stock Distribution Donut
          _AnalyticsCard(
            title: 'Stock Distribution',
            sw: sw,
            child: _DonutChart(sw: sw, sh: sh),
          ),
          SizedBox(height: sw * 0.04),

          // Incident Trend Line
          _AnalyticsCard(
            title: 'Incident Trend (6 months)',
            sw: sw,
            child: _LineChart(sw: sw, sh: sh),
          ),
          SizedBox(height: sw * 0.04),

          // District Performance
          _AnalyticsCard(
            title: 'Top Performing Districts',
            sw: sw,
            child: _DistrictBars(sw: sw),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAV ─────────────────────────────────────────
  Widget _buildBottomNav(double sw, double bottomPad, bool isSmall) {
    final items = [
      {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
      {'icon': Icons.inventory_2_rounded, 'label': 'Stock'},
      {'icon': Icons.local_shipping_rounded, 'label': 'Shipments'},
      {'icon': Icons.gavel_rounded, 'label': 'Restitution'},
      {'icon': Icons.bar_chart_rounded, 'label': 'Analytics'},
    ];
    final iconSize = sw * 0.055;
    final labelSize = isSmall ? 8.5 : sw * 0.026;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPad),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: List.generate(items.length, (i) {
          final sel = i == _navIndex;
          final color = sel ? const Color(0xFFFF9B51) : const Color(0xFFBFC9D1);
          return Expanded(
            child: GestureDetector(
              onTap: () => _switchTab(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: sw * 0.03),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: sel ? const Color(0xFFFF9B51) : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: sel ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(items[i]['icon'] as IconData,
                          color: color, size: iconSize),
                    ),
                    SizedBox(height: sw * 0.008),
                    Text(
                      items[i]['label'] as String,
                      style: TextStyle(
                        color: color,
                        fontSize: labelSize,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.normal,
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

// ── ANIMATED STAT CARD ─────────────────────────────────────
class _AnimatedStatCard extends StatefulWidget {
  final _StatCard card;
  final int index;
  final double sw;
  const _AnimatedStatCard({required this.card, required this.index, required this.sw});

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scale = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = widget.sw;
    final c = widget.card;
    return ScaleTransition(
      scale: _scale,
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          padding: EdgeInsets.all(sw * 0.035),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(sw * 0.045),
            boxShadow: [
              BoxShadow(
                color: c.color.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(sw * 0.02),
                    decoration: BoxDecoration(
                      color: c.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(sw * 0.025),
                    ),
                    child: Icon(c.icon, color: c.color, size: sw * 0.045),
                  ),
                  const Spacer(),
                  Container(
                    width: sw * 0.015,
                    height: sw * 0.015,
                    decoration: BoxDecoration(
                      color: c.color.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                c.value,
                style: TextStyle(
                  fontSize: sw * 0.048,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF25343F),
                ),
              ),
              SizedBox(height: sw * 0.005),
              Text(
                c.label,
                style: TextStyle(
                  fontSize: sw * 0.025,
                  color: const Color(0xFFBFC9D1),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: sw * 0.008),
              Text(
                c.sub,
                style: TextStyle(
                  fontSize: sw * 0.022,
                  color: c.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── ANIMATED LIST TILE ─────────────────────────────────────
class _AnimatedListTile extends StatefulWidget {
  final Widget child;
  final int index;
  const _AnimatedListTile({required this.child, required this.index});

  @override
  State<_AnimatedListTile> createState() => _AnimatedListTileState();
}

class _AnimatedListTileState extends State<_AnimatedListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(opacity: _fade, child: widget.child),
    );
  }
}

// ── PRESSABLE BUTTON ───────────────────────────────────────
class _PressableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PressableButton({required this.child, required this.onTap});

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        lowerBound: 0.93,
        upperBound: 1.0)
      ..value = 1.0;
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// ── STOCK CARD ─────────────────────────────────────────────
class _StockCard extends StatelessWidget {
  final _StockItem item;
  final double sw;
  const _StockCard({required this.item, required this.sw});

  @override
  Widget build(BuildContext context) {
    final pct = item.current / item.total;
    return Container(
      margin: EdgeInsets.only(bottom: sw * 0.03),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sw * 0.04),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(item.name, style: TextStyle(fontSize: sw * 0.038, fontWeight: FontWeight.w700, color: const Color(0xFF25343F))),
              const Spacer(),
              Text('${(pct * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: sw * 0.035, fontWeight: FontWeight.w700, color: item.color)),
            ],
          ),
          SizedBox(height: sw * 0.01),
          Text('${_fmt(item.current)} / ${_fmt(item.total)} MT',
              style: TextStyle(fontSize: sw * 0.027, color: const Color(0xFFBFC9D1))),
          SizedBox(height: sw * 0.025),
          ClipRRect(
            borderRadius: BorderRadius.circular(sw * 0.02),
            child: _AnimatedProgressBar(value: pct, color: item.color, sw: sw),
          ),
        ],
      ),
    );
  }

  String _fmt(int v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return '$v';
  }
}

class _AnimatedProgressBar extends StatefulWidget {
  final double value;
  final Color color;
  final double sw;
  const _AnimatedProgressBar({required this.value, required this.color, required this.sw});

  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = Tween<double>(begin: 0, end: widget.value)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => LinearProgressIndicator(
        value: _anim.value,
        backgroundColor: widget.color.withOpacity(0.1),
        valueColor: AlwaysStoppedAnimation(widget.color),
        minHeight: widget.sw * 0.02,
      ),
    );
  }
}

// ── SHIPMENT CARD ──────────────────────────────────────────
class _ShipmentCard extends StatelessWidget {
  final _Shipment shipment;
  final double sw;
  const _ShipmentCard({required this.shipment, required this.sw});

  @override
  Widget build(BuildContext context) {
    final s = shipment;
    return Container(
      margin: EdgeInsets.only(bottom: sw * 0.03),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sw * 0.04),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(s.id, style: TextStyle(fontSize: sw * 0.035, fontWeight: FontWeight.w800, color: const Color(0xFF25343F))),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.025, vertical: sw * 0.01),
                decoration: BoxDecoration(
                  color: s.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(sw * 0.02),
                ),
                child: Text(s.status, style: TextStyle(fontSize: sw * 0.025, color: s.statusColor, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          SizedBox(height: sw * 0.01),
          Text(s.route, style: TextStyle(fontSize: sw * 0.028, color: const Color(0xFFBFC9D1))),
          SizedBox(height: sw * 0.01),
          Text(s.quantity, style: TextStyle(fontSize: sw * 0.03, color: const Color(0xFF25343F), fontWeight: FontWeight.w600)),
          if (s.progress > 0 && s.progress < 1) ...[
            SizedBox(height: sw * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(sw * 0.01),
              child: _AnimatedProgressBar(value: s.progress, color: s.statusColor, sw: sw),
            ),
            SizedBox(height: sw * 0.01),
            Text('${(s.progress * 100).toInt()}% en route',
                style: TextStyle(fontSize: sw * 0.025, color: s.statusColor)),
          ],
        ],
      ),
    );
  }
}

// ── CASE CARD ──────────────────────────────────────────────
class _CaseCard extends StatelessWidget {
  final _RestitutionCase c;
  final double sw;
  const _CaseCard({required this.c, required this.sw});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: sw * 0.03),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sw * 0.04),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        border: Border(left: BorderSide(color: c.statusColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(c.id, style: TextStyle(fontSize: sw * 0.03, fontWeight: FontWeight.w800, color: const Color(0xFF25343F))),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.02, vertical: sw * 0.008),
                decoration: BoxDecoration(
                  color: c.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(sw * 0.02),
                ),
                child: Text(c.status, style: TextStyle(fontSize: sw * 0.023, color: c.statusColor, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          SizedBox(height: sw * 0.01),
          Text(c.description, style: TextStyle(fontSize: sw * 0.03, color: const Color(0xFF25343F), fontWeight: FontWeight.w500)),
          SizedBox(height: sw * 0.005),
          Text(c.district, style: TextStyle(fontSize: sw * 0.026, color: const Color(0xFFBFC9D1))),
        ],
      ),
    );
  }
}

// ── ANALYTICS WIDGETS ──────────────────────────────────────
class _AnalyticsCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double sw;
  const _AnalyticsCard({required this.title, required this.child, required this.sw});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sw * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sw * 0.045),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: sw * 0.035, fontWeight: FontWeight.w700, color: const Color(0xFF25343F))),
          SizedBox(height: sw * 0.035),
          child,
        ],
      ),
    );
  }
}

class _BarChart extends StatefulWidget {
  final double sw, sh;
  const _BarChart({required this.sw, required this.sh});
  @override
  State<_BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<_BarChart> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = widget.sw;
    final months = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];
    final values = [72000.0, 78000.0, 65000.0, 89000.0, 82000.0, 89200.0];
    final maxVal = values.reduce(math.max);
    final chartH = sw * 0.4;

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Column(
        children: [
          SizedBox(
            height: chartH,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(months.length, (i) {
                final pct = (values[i] / maxVal) * _anim.value;
                final isLast = i == months.length - 1;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.008),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(values[i] / 1000).toStringAsFixed(0)}K',
                          style: TextStyle(fontSize: sw * 0.022, color: isLast ? const Color(0xFFFF9B51) : const Color(0xFFBFC9D1), fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: sw * 0.01),
                        Container(
                          height: chartH * 0.75 * pct,
                          decoration: BoxDecoration(
                            color: isLast ? const Color(0xFFFF9B51) : const Color(0xFF2E6DA4),
                            borderRadius: BorderRadius.circular(sw * 0.015),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: sw * 0.02),
          Row(
            children: months.map((m) => Expanded(
              child: Text(m, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: sw * 0.025, color: const Color(0xFFBFC9D1))),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _DonutChart extends StatefulWidget {
  final double sw, sh;
  const _DonutChart({required this.sw, required this.sh});
  @override
  State<_DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<_DonutChart> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = widget.sw;
    final items = [
      _DonutItem('Rice', 0.34, Color(0xFF2E6DA4)),
      _DonutItem('Wheat', 0.27, Color(0xFF1B8A5A)),
      _DonutItem('Sugar', 0.15, Color(0xFFFF9B51)),
      _DonutItem('Pulses', 0.13, Color(0xFF7B5EA7)),
      _DonutItem('Other', 0.11, Color(0xFFBFC9D1)),
    ];
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Row(
        children: [
          SizedBox(
            width: sw * 0.4,
            height: sw * 0.4,
            child: CustomPaint(
              painter: _DonutPainter(items: items, progress: _anim.value),
            ),
          ),
          SizedBox(width: sw * 0.05),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => Padding(
                padding: EdgeInsets.only(bottom: sw * 0.02),
                child: Row(
                  children: [
                    Container(
                      width: sw * 0.025,
                      height: sw * 0.025,
                      decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
                    ),
                    SizedBox(width: sw * 0.02),
                    Expanded(child: Text(item.label, style: TextStyle(fontSize: sw * 0.028, color: const Color(0xFF25343F)))),
                    Text('${(item.value * 100).toInt()}%',
                        style: TextStyle(fontSize: sw * 0.028, fontWeight: FontWeight.w700, color: item.color)),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<_DonutItem> items;
  final double progress;
  _DonutPainter({required this.items, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) - 4;
    final strokeW = r * 0.38;
    double startAngle = -math.pi / 2;
    final totalSweep = 2 * math.pi * progress;
    var swept = 0.0;

    for (final item in items) {
      final sweep = item.value * totalSweep;
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - strokeW / 2),
        startAngle + swept,
        sweep - 0.015,
        false,
        paint,
      );
      swept += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.progress != progress;
}

class _LineChart extends StatefulWidget {
  final double sw, sh;
  const _LineChart({required this.sw, required this.sh});
  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = widget.sw;
    final values = [180.0, 165.0, 152.0, 140.0, 130.0, 124.0];
    final months = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Column(
        children: [
          SizedBox(
            height: sw * 0.35,
            child: CustomPaint(
              size: Size(sw - 80, sw * 0.35),
              painter: _LinePainter(values: values, progress: _anim.value),
            ),
          ),
          SizedBox(height: sw * 0.02),
          Row(
            children: months.map((m) => Expanded(
              child: Text(m, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: sw * 0.025, color: const Color(0xFFBFC9D1))),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> values;
  final double progress;
  _LinePainter({required this.values, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxV = values.reduce(math.max);
    final minV = values.reduce(math.min);
    final range = maxV - minV;

    Offset getPoint(int i) {
      final x = i / (values.length - 1) * size.width;
      final y = size.height - (values[i] - minV) / range * size.height * 0.8 - size.height * 0.1;
      return Offset(x, y);
    }

    // Count of points to draw based on progress
    final drawCount = (values.length * progress).clamp(0, values.length.toDouble());
    final fullPoints = drawCount.floor();
    final partial = drawCount - fullPoints;

    final path = Path();
    if (fullPoints == 0) return;
    path.moveTo(getPoint(0).dx, getPoint(0).dy);
    for (int i = 1; i < fullPoints; i++) {
      path.lineTo(getPoint(i).dx, getPoint(i).dy);
    }
    if (fullPoints < values.length) {
      final a = getPoint(fullPoints - 1);
      final b = getPoint(math.min(fullPoints, values.length - 1));
      path.lineTo(a.dx + (b.dx - a.dx) * partial, a.dy + (b.dy - a.dy) * partial);
    }

    // Fill
    final fillPath = Path.from(path);
    final lastPt = fullPoints < values.length
        ? Offset(
            getPoint(fullPoints - 1).dx + (getPoint(math.min(fullPoints, values.length - 1)).dx - getPoint(fullPoints - 1).dx) * partial,
            getPoint(fullPoints - 1).dy + (getPoint(math.min(fullPoints, values.length - 1)).dy - getPoint(fullPoints - 1).dy) * partial,
          )
        : getPoint(fullPoints - 1);
    fillPath.lineTo(lastPt.dx, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFFE53935).withOpacity(0.25), Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFE53935)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Dots
    for (int i = 0; i < fullPoints; i++) {
      canvas.drawCircle(getPoint(i), 4,
          Paint()..color = const Color(0xFFE53935));
      canvas.drawCircle(getPoint(i), 2.5,
          Paint()..color = Colors.white);
    }

    // Labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < fullPoints; i++) {
      tp.text = TextSpan(
        text: '${values[i].toInt()}',
        style: const TextStyle(color: Color(0xFF25343F), fontSize: 9, fontWeight: FontWeight.w600),
      );
      tp.layout();
      tp.paint(canvas, getPoint(i).translate(-tp.width / 2, -tp.height - 5));
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.progress != progress;
}

class _DistrictBars extends StatelessWidget {
  final double sw;
  const _DistrictBars({required this.sw});

  @override
  Widget build(BuildContext context) {
    final districts = [
      _DistBar('District 7', 0.97, Color(0xFF1B8A5A)),
      _DistBar('District 14', 0.95, Color(0xFF2E6DA4)),
      _DistBar('District 3', 0.91, Color(0xFF7B5EA7)),
      _DistBar('District 22', 0.89, Color(0xFFFF9B51)),
      _DistBar('District 30', 0.86, Color(0xFF25343F)),
    ];
    return Column(
      children: districts.map((d) => Padding(
        padding: EdgeInsets.only(bottom: sw * 0.025),
        child: Row(
          children: [
            SizedBox(
              width: sw * 0.22,
              child: Text(d.name, style: TextStyle(fontSize: sw * 0.028, color: const Color(0xFF25343F), fontWeight: FontWeight.w500)),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(sw * 0.01),
                child: _AnimatedProgressBar(value: d.score, color: d.color, sw: sw),
              ),
            ),
            SizedBox(width: sw * 0.02),
            Text('${(d.score * 100).toInt()}%',
                style: TextStyle(fontSize: sw * 0.028, fontWeight: FontWeight.w700, color: d.color)),
          ],
        ),
      )).toList(),
    );
  }
}

// ── HELPER WIDGETS ─────────────────────────────────────────
class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final double sw;
  const _StatusChip(this.label, this.selected, this.sw);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: sw * 0.02, bottom: sw * 0.02),
      padding: EdgeInsets.symmetric(horizontal: sw * 0.03, vertical: sw * 0.015),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF25343F) : Colors.white,
        borderRadius: BorderRadius.circular(sw * 0.05),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: sw * 0.027,
          color: selected ? Colors.white : const Color(0xFFBFC9D1),
          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  final double sw;
  const _MiniStat(this.label, this.value, this.color, this.sw);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: sw * 0.055, fontWeight: FontWeight.w800, color: color)),
        SizedBox(height: sw * 0.005),
        Text(label, style: TextStyle(fontSize: sw * 0.022, color: const Color(0xFFBFC9D1))),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: Colors.white12);
}

// ── Data Models ────────────────────────────────────────────
class _StatCard {
  final String label, value, sub;
  final IconData icon;
  final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color, this.sub);
}

class _Activity {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  const _Activity(this.title, this.subtitle, this.icon, this.color);
}

class _StockItem {
  final String name;
  final int current, total;
  final Color color;
  const _StockItem(this.name, this.current, this.total, this.color);
}

class _Shipment {
  final String id, route, status, quantity;
  final Color statusColor;
  final double progress;
  const _Shipment(this.id, this.route, this.status, this.quantity, this.statusColor, this.progress);
}

class _RestitutionCase {
  final String id, description, district, status;
  final Color statusColor;
  const _RestitutionCase(this.id, this.description, this.district, this.status, this.statusColor);
}

class _DonutItem {
  final String label;
  final double value;
  final Color color;
  const _DonutItem(this.label, this.value, this.color);
}

class _DistBar {
  final String name;
  final double score;
  final Color color;
  const _DistBar(this.name, this.score, this.color);
}