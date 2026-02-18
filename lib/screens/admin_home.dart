import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fade;
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
        vsync: this, duration: const Duration(milliseconds: 700));
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
    // ── MediaQuery values ──────────────────────────────────
    final mq          = MediaQuery.of(context);
    final sw          = mq.size.width;
    final sh          = mq.size.height;
    final topPad      = mq.padding.top;
    final bottomPad   = mq.padding.bottom;
    final isSmall     = sw < 360;
    final isMedium    = sw >= 360 && sw < 420;
    // ──────────────────────────────────────────────────────

    return Scaffold(
      backgroundColor: const Color(0xFFEAEFEF),
      body: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            _buildHeader(sw, sh, topPad, isSmall),
            Expanded(
              child: _buildBody(sw, sh, isSmall, isMedium),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(sw, bottomPad, isSmall),
    );
  }

  // ── HEADER ─────────────────────────────────────────────
  Widget _buildHeader(double sw, double sh, double topPad, bool isSmall) {
    final hPad        = sw * 0.05;          // 5% of width
    final iconSize    = sw * 0.055;         // ~22 on 400w
    final titleSize   = isSmall ? 15.0 : sw * 0.045;
    final subtitleSize= isSmall ? 10.0 : sw * 0.03;
    final headerRadius= sw * 0.07;

    return Container(
      padding: EdgeInsets.only(
        top:    topPad + sh * 0.02,
        left:   hPad,
        right:  hPad,
        bottom: sh * 0.025,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF25343F),
        borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(headerRadius)),
      ),
      child: Column(
        children: [
          // ── Top row ──────────────────────────────────
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
              // Notification bell
              Stack(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications_rounded,
                        color: const Color(0xFFEAEFEF),
                        size: iconSize),
                  ),
                  Positioned(
                    right: sw * 0.02,
                    top:   sw * 0.02,
                    child: Container(
                      width:  sw * 0.02,
                      height: sw * 0.02,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF9B51),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              // Logout
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

          SizedBox(height: sh * 0.02),

          // ── Quick stats strip ─────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
              vertical:   sh  * 0.015,
              horizontal: sw  * 0.03,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(sw * 0.04),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickStat('Distributed', '1.84L MT',
                    Icons.check_circle_rounded,
                    const Color(0xFF4CAF50), sw, isSmall),
                _vDivider(sh),
                _quickStat('Restitution', '312 Active',
                    Icons.gavel_rounded,
                    const Color(0xFFFF9B51), sw, isSmall),
                _vDivider(sh),
                _quickStat('Complaints', '89 Open',
                    Icons.report_rounded,
                    const Color(0xFFEF5350), sw, isSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vDivider(double sh) => Container(
        width: 1, height: sh * 0.045,
        color: Colors.white.withOpacity(0.1));

  Widget _quickStat(String label, String value, IconData icon,
      Color color, double sw, bool isSmall) {
    return Column(
      children: [
        Icon(icon, color: color, size: sw * 0.045),
        SizedBox(height: sw * 0.01),
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: isSmall ? 11.0 : sw * 0.032,
                fontWeight: FontWeight.w700)),
        Text(label,
            style: TextStyle(
                color: const Color(0xFFBFC9D1),
                fontSize: isSmall ? 9.0 : sw * 0.025)),
      ],
    );
  }

  // ── BODY ───────────────────────────────────────────────
  Widget _buildBody(double sw, double sh, bool isSmall, bool isMedium) {
    final hPad       = sw * 0.05;
    final sectionSize= isSmall ? 15.0 : sw * 0.045;

    // Grid aspect ratio — more height on small screens
    final cardRatio = isSmall ? 1.25 : isMedium ? 1.45 : 1.6;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
          horizontal: hPad, vertical: sh * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: sectionSize,
                  fontWeight: FontWeight.w800)),
          SizedBox(height: sh * 0.016),

          // ── KPI Grid ──────────────────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing:  sw * 0.03,
              crossAxisSpacing: sw * 0.03,
              childAspectRatio: cardRatio,
            ),
            itemCount: _stats.length,
            itemBuilder: (_, i) => _buildStatCard(_stats[i], i, sw, sh, isSmall),
          ),

          SizedBox(height: sh * 0.03),
          Text('Quick Actions',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: sectionSize,
                  fontWeight: FontWeight.w800)),
          SizedBox(height: sh * 0.016),
          _buildQuickActions(sw, sh, isSmall),

          SizedBox(height: sh * 0.03),
          Text('District Performance',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: sectionSize,
                  fontWeight: FontWeight.w800)),
          SizedBox(height: sh * 0.016),
          _buildDistrictList(sw, sh, isSmall),
          SizedBox(height: sh * 0.02),
        ],
      ),
    );
  }

  // ── STAT CARD ──────────────────────────────────────────
  Widget _buildStatCard(_StatCard card, int index,
      double sw, double sh, bool isSmall) {
    final pad        = sw * 0.035;
    final iconBR     = sw * 0.025;
    final iconSize   = sw * 0.045;
    final valueSize  = isSmall ? 15.0 : sw * 0.042;
    final labelSize  = isSmall ? 9.0  : sw * 0.026;
    final subSize    = isSmall ? 9.0  : sw * 0.026;
    final cardRadius = sw * 0.045;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 80),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
            offset: Offset(0, 20 * (1 - v)), child: child),
      ),
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
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
            // Icon chip
            Container(
              padding: EdgeInsets.all(sw * 0.02),
              decoration: BoxDecoration(
                color: card.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(iconBR),
              ),
              child: Icon(card.icon, color: card.color, size: iconSize),
            ),
            // Values
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(card.value,
                    style: TextStyle(
                        color: const Color(0xFF25343F),
                        fontSize: valueSize,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: sh * 0.003),
                Text(card.label,
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1),
                        fontSize: labelSize),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: sh * 0.004),
                Text(card.sub,
                    style: TextStyle(
                        color: card.color,
                        fontSize: subSize,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── QUICK ACTIONS ──────────────────────────────────────
  Widget _buildQuickActions(double sw, double sh, bool isSmall) {
    final actions = [
      {'label': 'Allocate\nStock',   'icon': Icons.add_box_rounded,        'color': const Color(0xFF25343F)},
      {'label': 'View\nShipments',  'icon': Icons.local_shipping_rounded,  'color': const Color(0xFF2E6DA4)},
      {'label': 'Complaints',        'icon': Icons.report_problem_rounded,  'color': const Color(0xFFE53935)},
      {'label': 'Analytics',         'icon': Icons.bar_chart_rounded,       'color': const Color(0xFF7B5EA7)},
    ];

    return Row(
      children: actions.map((a) {
        final color = a['color'] as Color;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: sw * 0.02),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: sh * 0.018),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(sw * 0.04),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Icon(a['icon'] as IconData,
                        color: color, size: sw * 0.055),
                    SizedBox(height: sh * 0.007),
                    Text(
                      a['label'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: color,
                        fontSize: isSmall ? 8.5 : sw * 0.025,
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

  // ── DISTRICT LIST ──────────────────────────────────────
  Widget _buildDistrictList(double sw, double sh, bool isSmall) {
    final districts = [
      {'name': 'Chennai',    'score': 0.94, 'shops': '1,240'},
      {'name': 'Coimbatore', 'score': 0.88, 'shops': '980'},
      {'name': 'Madurai',    'score': 0.76, 'shops': '870'},
      {'name': 'Salem',      'score': 0.65, 'shops': '640'},
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
          margin: EdgeInsets.only(bottom: sh * 0.012),
          padding: EdgeInsets.symmetric(
              horizontal: sw * 0.04, vertical: sh * 0.016),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(sw * 0.04),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8)
            ],
          ),
          child: Row(
            children: [
              // Avatar circle
              Container(
                width:  sw * 0.1,
                height: sw * 0.1,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (d['name'] as String).substring(0, 2),
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: sw * 0.033),
                  ),
                ),
              ),
              SizedBox(width: sw * 0.035),

              // Name + shops
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d['name'] as String,
                        style: TextStyle(
                            color: const Color(0xFF25343F),
                            fontWeight: FontWeight.w700,
                            fontSize: isSmall ? 13.0 : sw * 0.035)),
                    Text('${d['shops']} shops',
                        style: TextStyle(
                            color: const Color(0xFFBFC9D1),
                            fontSize: isSmall ? 10.0 : sw * 0.028)),
                  ],
                ),
              ),

              // Score + bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${(score * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontSize: isSmall ? 14.0 : sw * 0.038)),
                  SizedBox(height: sh * 0.005),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width:  sw * 0.15,
                      height: sh * 0.005,
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

  // ── BOTTOM NAV ─────────────────────────────────────────
  Widget _buildBottomNav(double sw, double bottomPad, bool isSmall) {
    final items = [
      {'icon': Icons.dashboard_rounded,      'label': 'Dashboard'},
      {'icon': Icons.inventory_2_rounded,    'label': 'Stock'},
      {'icon': Icons.local_shipping_rounded, 'label': 'Shipments'},
      {'icon': Icons.gavel_rounded,          'label': 'Restitution'},
      {'icon': Icons.bar_chart_rounded,      'label': 'Analytics'},
    ];

    final iconSize  = sw * 0.055;
    final labelSize = isSmall ? 8.5 : sw * 0.026;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPad),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 20,
              offset: Offset(0, -4))
        ],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final sel = i == _navIndex;
          final color = sel
              ? const Color(0xFFFF9B51)
              : const Color(0xFFBFC9D1);
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _navIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: sw * 0.03),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Active indicator dot
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width:  sel ? sw * 0.012 : 0,
                      height: sel ? sw * 0.012 : 0,
                      margin: EdgeInsets.only(bottom: sel ? sw * 0.01 : 0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF9B51),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(items[i]['icon'] as IconData,
                        color: color, size: iconSize),
                    SizedBox(height: sw * 0.008),
                    Text(
                      items[i]['label'] as String,
                      style: TextStyle(
                        color: color,
                        fontSize: labelSize,
                        fontWeight: sel
                            ? FontWeight.w700
                            : FontWeight.w500,
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

// ── Data model ─────────────────────────────────────────────
class _StatCard {
  final String label, value, sub;
  final IconData icon;
  final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color, this.sub);
}