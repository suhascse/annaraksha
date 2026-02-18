import 'dart:math' as math;
import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════
//  CONSTANTS
// ══════════════════════════════════════════════════════════════
const kBlue   = Color(0xFF2563EB);
const kBlueL  = Color(0xFF60A5FA);
const kGreen  = Color(0xFF16A34A);
const kOrange = Color(0xFFEA580C);
const kRed    = Color(0xFFDC2626);
const kPurple = Color(0xFF7C3AED);
const kYellow = Color(0xFFCA8A04);
const kGrey   = Color(0xFF94A3B8);
const kDark1  = Color(0xFF0F172A);
const kDark2  = Color(0xFF1E293B);
const kBg     = Color(0xFFF1F5F9);

// ══════════════════════════════════════════════════════════════
//  ENTRY POINT — WarehouseHomePage
// ══════════════════════════════════════════════════════════════
class WarehouseHomePage extends StatelessWidget {
  const WarehouseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainShell();
  }
}

// ══════════════════════════════════════════════════════════════
//  MAIN SHELL — bottom nav + page switcher
// ══════════════════════════════════════════════════════════════
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;

  final _pages = const [
    HomePage(),
    ReceivePage(),
    DispatchPage(),
    InventoryPage(),
    ReportsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0.04, 0), end: Offset.zero)
                .animate(anim),
            child: child,
          ),
        ),
        child: KeyedSubtree(key: ValueKey(_idx), child: _pages[_idx]),
      ),
      bottomNavigationBar:
          _BottomNav(idx: _idx, onTap: (i) => setState(() => _idx = i)),
    );
  }
}

// ── bottom nav bar ──────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int idx;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.idx, required this.onTap});

  static const _items = [
    {'icon': Icons.dashboard_rounded, 'label': 'Home'},
    {'icon': Icons.download_rounded, 'label': 'Receive'},
    {'icon': Icons.upload_rounded, 'label': 'Dispatch'},
    {'icon': Icons.inventory_2_rounded, 'label': 'Inventory'},
    {'icon': Icons.bar_chart_rounded, 'label': 'Reports'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x18000000),
              blurRadius: 20,
              offset: Offset(0, -4))
        ],
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final sel = i == idx;
          final icon = _items[i]['icon'] as IconData;
          final label = _items[i]['label'] as String;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(sel ? 7 : 0),
                    decoration: BoxDecoration(
                      color: sel
                          ? kBlue.withOpacity(.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon,
                        color: sel ? kBlue : kGrey, size: 22),
                  ),
                  const SizedBox(height: 3),
                  Text(label,
                      style: TextStyle(
                          color: sel ? kBlue : kGrey,
                          fontSize: 9,
                          fontWeight: sel
                              ? FontWeight.w800
                              : FontWeight.w500)),
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── shared header ───────────────────────────────────────────
class _Header extends StatelessWidget {
  final String title, sub;
  final List<Widget>? trailing;
  const _Header({required this.title, required this.sub, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 20,
          right: 20,
          bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [kDark1, kDark2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kBlue.withOpacity(.3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kBlue.withOpacity(.5)),
          ),
          child: const Icon(Icons.warehouse_rounded,
              color: kBlueL, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(sub,
                  style: const TextStyle(
                      color: kGrey, fontSize: 11, letterSpacing: 1)),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
            ])),
        ...?trailing,
      ]),
    );
  }
}

Widget _sectionTitle(String t) => Text(t,
    style: const TextStyle(
        color: kDark2, fontSize: 16, fontWeight: FontWeight.w800));

// ══════════════════════════════════════════════════════════════
//  PAGE 2 — HOME
// ══════════════════════════════════════════════════════════════
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: FadeTransition(
        opacity: _anim,
        child: Column(children: [
          _buildHeader(context),
          Expanded(child: _buildBody()),
        ]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 20,
          right: 20,
          bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [kDark1, kDark2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kBlue.withOpacity(.3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBlue.withOpacity(.5)),
            ),
            child: const Icon(Icons.warehouse_rounded,
                color: kBlueL, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('District Warehouse',
                    style: TextStyle(
                        color: kGrey, fontSize: 12, letterSpacing: 1)),
                Text('Chennai Central Hub',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
              ])),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.white)),
          GestureDetector(
            onTap: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const _LoginRedirect())),
            child: const Icon(Icons.logout_rounded,
                color: kGrey, size: 20),
          ),
        ]),
        const SizedBox(height: 18),
        Row(children: [
          _chip('Current Stock', '42,800 MT', kGreen),
          const SizedBox(width: 10),
          _chip('Incoming', '8,200 MT', kOrange),
          const SizedBox(width: 10),
          _chip('Low Shops', '14', kRed),
        ]),
      ]),
    );
  }

  Widget _chip(String label, String value, Color color) => Expanded(
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(.25)),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: 13)),
                Text(label,
                    style:
                        const TextStyle(color: kGrey, fontSize: 9)),
              ]),
        ),
      );

  Widget _buildBody() => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Inventory Status'),
              const SizedBox(height: 12),
              _inventoryGrid(),
              const SizedBox(height: 22),
              _sectionTitle('Recent Shipments'),
              const SizedBox(height: 12),
              _shipmentList(),
              const SizedBox(height: 22),
              _sectionTitle('Quick Actions'),
              const SizedBox(height: 12),
              _quickActions(),
              const SizedBox(height: 22),
              _sectionTitle('Alert Center'),
              const SizedBox(height: 12),
              _alerts(),
            ]),
      );

  Widget _inventoryGrid() {
    final items = [
      {'item': 'Rice', 'stock': '18,400 MT', 'cap': 0.72, 'color': kGreen},
      {'item': 'Wheat', 'stock': '12,100 MT', 'cap': 0.56, 'color': kBlue},
      {'item': 'Sugar', 'stock': '4,200 MT', 'cap': 0.38, 'color': kOrange},
      {'item': 'Dal', 'stock': '8,100 MT', 'cap': 0.82, 'color': kPurple},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.7),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final cap = items[i]['cap'] as double;
        final color = items[i]['color'] as Color;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 500 + i * 120),
          curve: Curves.easeOutBack,
          builder: (_, v, child) => Opacity(
              opacity: v.clamp(0.0, 1.0),
              child: Transform.translate(
                  offset: Offset(0, 20 * (1 - v.clamp(0.0, 1.0))),
                  child: child)),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: color.withOpacity(.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(items[i]['item'] as String,
                            style: const TextStyle(
                                color: kDark2,
                                fontWeight: FontWeight.w800,
                                fontSize: 14)),
                        Text('${(cap * 100).toInt()}%',
                            style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                      ]),
                  Text(items[i]['stock'] as String,
                      style:
                          const TextStyle(color: kGrey, fontSize: 11)),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                          value: cap,
                          backgroundColor: color.withOpacity(.12),
                          valueColor: AlwaysStoppedAnimation(color),
                          minHeight: 5)),
                ]),
          ),
        );
      },
    );
  }

  Widget _shipmentList() {
    final data = [
      {
        'id': 'SH-2024-0891',
        'to': 'Anna Nagar Shop',
        'qty': '1,200 MT',
        'status': 'Dispatched',
        'color': kBlue
      },
      {
        'id': 'SH-2024-0890',
        'to': 'T. Nagar Depot',
        'qty': '850 MT',
        'status': 'Delivered',
        'color': kGreen
      },
      {
        'id': 'SH-2024-0889',
        'to': 'Adyar Shop #3',
        'qty': '640 MT',
        'status': 'Created',
        'color': kGrey
      },
    ];
    return Column(
        children: data
            .map((s) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 8)
                      ]),
                  child: Row(children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color:
                                (s['color'] as Color).withOpacity(.12),
                            shape: BoxShape.circle),
                        child: Icon(Icons.local_shipping_rounded,
                            color: s['color'] as Color, size: 18)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                          Text(s['id'] as String,
                              style: const TextStyle(
                                  color: kDark2,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                          Text(
                              '→ ${s['to']}  •  ${s['qty']}',
                              style: const TextStyle(
                                  color: kGrey, fontSize: 11)),
                        ])),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: (s['color'] as Color).withOpacity(.12),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(s['status'] as String,
                          style: TextStyle(
                              color: s['color'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                  ]),
                ))
            .toList());
  }

  Widget _quickActions() {
    final actions = [
      {'label': 'Receive', 'icon': Icons.download_rounded, 'color': kGreen},
      {'label': 'Dispatch', 'icon': Icons.upload_rounded, 'color': kBlue},
      {'label': 'Inventory', 'icon': Icons.list_alt_rounded, 'color': kPurple},
      {'label': 'Reports', 'icon': Icons.bar_chart_rounded, 'color': kOrange},
    ];
    return Row(
        children: actions
            .map((a) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: (a['color'] as Color).withOpacity(.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color:
                                (a['color'] as Color).withOpacity(.2)),
                      ),
                      child: Column(children: [
                        Icon(a['icon'] as IconData,
                            color: a['color'] as Color, size: 22),
                        const SizedBox(height: 6),
                        Text(a['label'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: a['color'] as Color,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                ))
            .toList());
  }

  Widget _alerts() {
    final alerts = [
      {
        'msg': 'Shop #14 stock below threshold',
        'type': 'Low Stock',
        'urgent': true
      },
      {
        'msg': 'Restitution case #RC-0342 pending',
        'type': 'Restitution',
        'urgent': true
      },
      {
        'msg': 'Incoming shipment ETA: 3 hrs',
        'type': 'Info',
        'urgent': false
      },
    ];
    return Column(children: alerts.map((a) {
      final urgent = a['urgent'] as bool;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: urgent ? kRed.withOpacity(.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: urgent
                  ? kRed.withOpacity(.3)
                  : Colors.transparent),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.04), blurRadius: 8)
          ],
        ),
        child: Row(children: [
          Icon(
              urgent
                  ? Icons.warning_amber_rounded
                  : Icons.info_outline_rounded,
              color: urgent ? kRed : kBlue,
              size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(a['msg'] as String,
                    style: TextStyle(
                        color: kDark2,
                        fontSize: 12,
                        fontWeight: urgent
                            ? FontWeight.w700
                            : FontWeight.w500)),
                Text(a['type'] as String,
                    style:
                        const TextStyle(color: kGrey, fontSize: 10)),
              ])),
          const Icon(Icons.chevron_right_rounded, color: kGrey),
        ]),
      );
    }).toList());
  }
}

// ══════════════════════════════════════════════════════════════
//  PAGE 3 — RECEIVE
// ══════════════════════════════════════════════════════════════
class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});
  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  static const _received = [
    {
      'id': 'RCV-2024-0412',
      'item': 'Rice',
      'qty': '3,500 MT',
      'from': 'FCI Trichy',
      'date': 'Feb 17, 2025',
      'color': kGreen
    },
    {
      'id': 'RCV-2024-0411',
      'item': 'Wheat',
      'qty': '2,200 MT',
      'from': 'FCI Coimbatore',
      'date': 'Feb 15, 2025',
      'color': kBlue
    },
    {
      'id': 'RCV-2024-0410',
      'item': 'Dal',
      'qty': '800 MT',
      'from': 'NAFED Delhi',
      'date': 'Feb 14, 2025',
      'color': kPurple
    },
    {
      'id': 'RCV-2024-0409',
      'item': 'Sugar',
      'qty': '1,100 MT',
      'from': 'NFCSF Chennai',
      'date': 'Feb 12, 2025',
      'color': kOrange
    },
  ];

  static const _incoming = [
    {
      'id': 'INC-2024-0088',
      'item': 'Rice',
      'qty': '4,000 MT',
      'from': 'FCI Madurai',
      'eta': 'Today in 3 hrs',
      'days': 0,
      'color': kGreen
    },
    {
      'id': 'INC-2024-0087',
      'item': 'Wheat',
      'qty': '1,800 MT',
      'from': 'FCI Salem',
      'eta': 'In 2 days',
      'days': 2,
      'color': kBlue
    },
    {
      'id': 'INC-2024-0086',
      'item': 'Sugar',
      'qty': '900 MT',
      'from': 'NFCSF Vellore',
      'eta': 'In 4 days',
      'days': 4,
      'color': kOrange
    },
    {
      'id': 'INC-2024-0085',
      'item': 'Dal',
      'qty': '1,500 MT',
      'from': 'NAFED Nashik',
      'eta': 'In 7 days',
      'days': 7,
      'color': kPurple
    },
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        const _Header(
            title: 'Receive Stock', sub: 'Warehouse Operations'),
        Container(
          color: kDark2,
          child: TabBar(
            controller: _tab,
            labelColor: kBlueL,
            unselectedLabelColor: kGrey,
            indicatorColor: kBlueL,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 12),
            tabs: const [Tab(text: 'RECEIVED'), Tab(text: 'INCOMING')],
          ),
        ),
        Expanded(
            child: TabBarView(controller: _tab, children: [
          _receivedTab(),
          _incomingTab(),
        ])),
      ]),
    );
  }

  Widget _receivedTab() => ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            _miniStat('Total Received', '7,600 MT', kGreen,
                Icons.check_circle_outline),
            const SizedBox(width: 10),
            _miniStat('Shipments', '4', kBlue,
                Icons.local_shipping_outlined),
          ]),
          const SizedBox(height: 16),
          ..._received.asMap().entries.map((e) {
            final s = e.value;
            final color = s['color'] as Color;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 400 + e.key * 100),
              curve: Curves.easeOutCubic,
              builder: (_, v, ch) => Opacity(
                  opacity: v.clamp(0.0, 1.0),
                  child: Transform.translate(
                      offset: Offset(30 * (1 - v.clamp(0.0, 1.0)), 0),
                      child: ch)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: color.withOpacity(.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4))
                    ]),
                child: Row(children: [
                  Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: color.withOpacity(.12),
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.inventory_2_outlined,
                          color: color, size: 22)),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(s['item'] as String,
                                  style: const TextStyle(
                                      color: kDark2,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14)),
                              Text(s['qty'] as String,
                                  style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                            ]),
                        const SizedBox(height: 4),
                        Text('${s['id']}  •  ${s['from']}',
                            style: const TextStyle(
                                color: kGrey, fontSize: 11)),
                        const SizedBox(height: 2),
                        Row(children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 11, color: kGrey),
                          const SizedBox(width: 4),
                          Text(s['date'] as String,
                              style: const TextStyle(
                                  color: kGrey, fontSize: 10)),
                        ]),
                      ])),
                ]),
              ),
            );
          }),
        ],
      );

  Widget _incomingTab() => ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            _miniStat('Total Incoming', '8,200 MT', kOrange,
                Icons.moving_outlined),
            const SizedBox(width: 10),
            _miniStat('Expected', '4 shipments', kBlue,
                Icons.directions_boat_outlined),
          ]),
          const SizedBox(height: 16),
          ..._incoming.asMap().entries.map((e) {
            final s = e.value;
            final days = s['days'] as int;
            final color = s['color'] as Color;
            final urgColor =
                days == 0 ? kGreen : (days <= 2 ? kOrange : kGrey);
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 400 + e.key * 100),
              curve: Curves.easeOutCubic,
              builder: (_, v, ch) => Opacity(
                  opacity: v.clamp(0.0, 1.0),
                  child: Transform.translate(
                      offset: Offset(30 * (1 - v.clamp(0.0, 1.0)), 0),
                      child: ch)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: days == 0
                      ? Border.all(color: kGreen.withOpacity(.4))
                      : null,
                  boxShadow: [
                    BoxShadow(
                        color: color.withOpacity(.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                                color: color.withOpacity(.12),
                                borderRadius:
                                    BorderRadius.circular(12)),
                            child: Icon(Icons.local_shipping_outlined,
                                color: color, size: 22)),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(s['item'] as String,
                                        style: const TextStyle(
                                            color: kDark2,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14)),
                                    Text(s['qty'] as String,
                                        style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13)),
                                  ]),
                              Text('${s['id']}  •  ${s['from']}',
                                  style: const TextStyle(
                                      color: kGrey, fontSize: 11)),
                            ])),
                      ]),
                      const SizedBox(height: 14),
                      Row(children: [
                        Icon(Icons.access_time_rounded,
                            size: 14, color: urgColor),
                        const SizedBox(width: 6),
                        Text('ETA: ${s['eta']}',
                            style: TextStyle(
                                color: urgColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12)),
                        const Spacer(),
                        if (days == 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: kGreen.withOpacity(.12),
                                borderRadius:
                                    BorderRadius.circular(20)),
                            child: const Text('ARRIVING TODAY',
                                style: TextStyle(
                                    color: kGreen,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800)),
                          ),
                      ]),
                      const SizedBox(height: 8),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                              value: days == 0
                                  ? 1.0
                                  : (1 - days / 10).clamp(0.1, 1.0),
                              backgroundColor:
                                  kGrey.withOpacity(.15),
                              valueColor:
                                  AlwaysStoppedAnimation(urgColor),
                              minHeight: 4)),
                      const SizedBox(height: 4),
                      Text(
                          days == 0
                              ? 'Arriving today'
                              : '$days day${days > 1 ? 's' : ''} remaining',
                          style: TextStyle(
                              color: urgColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ]),
              ),
            );
          }),
        ],
      );

  Widget _miniStat(
          String label, String value, Color color, IconData icon) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: color.withOpacity(.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(.2))),
          child: Row(children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(value,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontSize: 15)),
                  Text(label,
                      style:
                          const TextStyle(color: kGrey, fontSize: 10)),
                ])),
          ]),
        ),
      );
}

// ══════════════════════════════════════════════════════════════
//  PAGE 4 — DISPATCH
// ══════════════════════════════════════════════════════════════
class DispatchPage extends StatefulWidget {
  const DispatchPage({super.key});
  @override
  State<DispatchPage> createState() => _DispatchPageState();
}

class _DispatchPageState extends State<DispatchPage> {
  String? _shop;
  final Map<String, double> _qty = {};
  bool _done = false;

  static const _shops = [
    {
      'name': 'Anna Nagar #01',
      'district': 'Chennai North',
      'need': 'High',
      'color': kRed
    },
    {
      'name': 'T. Nagar #02',
      'district': 'Chennai South',
      'need': 'High',
      'color': kRed
    },
    {
      'name': 'Adyar #03',
      'district': 'Chennai South',
      'need': 'Medium',
      'color': kOrange
    },
    {
      'name': 'Velachery #04',
      'district': 'Chennai South',
      'need': 'Low',
      'color': kGreen
    },
    {
      'name': 'Tambaram #05',
      'district': 'Chennai West',
      'need': 'Medium',
      'color': kOrange
    },
    {
      'name': 'Porur #06',
      'district': 'Chennai West',
      'need': 'Low',
      'color': kGreen
    },
  ];

  static const _commodities = [
    {'item': 'Rice', 'avail': 18400.0, 'color': kGreen},
    {'item': 'Wheat', 'avail': 12100.0, 'color': kBlue},
    {'item': 'Sugar', 'avail': 4200.0, 'color': kOrange},
    {'item': 'Dal', 'avail': 8100.0, 'color': kPurple},
  ];

  bool get _hasQty => _qty.values.any((v) => v > 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        const _Header(
            title: 'Dispatch to Shop', sub: 'Warehouse Operations'),
        Expanded(child: _done ? _successScreen() : _form()),
      ]),
    );
  }

  Widget _successScreen() => Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (_, v, ch) => Transform.scale(scale: v, child: ch),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                      color: kGreen, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 50)),
              const SizedBox(height: 24),
              const Text('Dispatch Created!',
                  style: TextStyle(
                      color: kDark2,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(_shop ?? '',
                  style: const TextStyle(color: kGrey, fontSize: 14),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              ..._qty.entries
                  .where((e) => e.value > 0)
                  .map((e) => Text(
                      '${e.key}: ${e.value.toStringAsFixed(0)} MT',
                      style: const TextStyle(
                          color: kBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600))),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => setState(
                    () {
                      _done = false;
                      _shop = null;
                      _qty.clear();
                    }),
                icon: const Icon(Icons.add_rounded),
                label: const Text('New Dispatch'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: kBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0),
              ),
            ]),
          ),
        ),
      );

  Widget _form() => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _stepBadge('1', 'Select Ration Shop', kBlue),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: _shops.map((shop) {
                  final sel = _shop == shop['name'];
                  final color = shop['color'] as Color;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _shop = shop['name'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: sel
                            ? color.withOpacity(.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: sel ? color : Colors.grey.shade200,
                            width: sel ? 1.8 : 1),
                        boxShadow: [
                          BoxShadow(
                              color: sel
                                  ? color.withOpacity(.18)
                                  : Colors.black.withOpacity(.04),
                              blurRadius: 8)
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Row(children: [
                              Icon(Icons.store_rounded,
                                  color: sel ? color : kGrey,
                                  size: 15),
                              const SizedBox(width: 6),
                              Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              Text(shop['need'] as String,
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800)),
                            ]),
                            const SizedBox(height: 5),
                            Text(shop['name'] as String,
                                style: const TextStyle(
                                    color: kDark2,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text(shop['district'] as String,
                                style: const TextStyle(
                                    color: kGrey, fontSize: 10)),
                          ]),
                    ),
                  );
                }).toList(),
              ),
              if (_shop != null) ...[
                const SizedBox(height: 24),
                _stepBadge('2', 'Set Quantities', kGreen),
                const SizedBox(height: 12),
                ..._commodities.map((c) {
                  final key = c['item'] as String;
                  final avail = c['avail'] as double;
                  final color = c['color'] as Color;
                  final val = _qty[key] ?? 0.0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 8)
                        ]),
                    child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          color: color,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  3))),
                                  const SizedBox(width: 8),
                                  Text(key,
                                      style: const TextStyle(
                                          color: kDark2,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15)),
                                ]),
                                Text(
                                    'Available: ${avail.toStringAsFixed(0)} MT',
                                    style: const TextStyle(
                                        color: kGrey, fontSize: 11)),
                              ]),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                child: SliderTheme(
                              data:
                                  SliderTheme.of(context).copyWith(
                                activeTrackColor: color,
                                thumbColor: color,
                                inactiveTrackColor:
                                    color.withOpacity(.15),
                                trackHeight: 4,
                                thumbShape:
                                    const RoundSliderThumbShape(
                                        enabledThumbRadius: 10),
                                overlayShape:
                                    const RoundSliderOverlayShape(
                                        overlayRadius: 18),
                              ),
                              child: Slider(
                                value: val,
                                min: 0,
                                max: avail,
                                onChanged: (v) => setState(
                                    () => _qty[key] = v),
                              ),
                            )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: color.withOpacity(.1),
                                  borderRadius:
                                      BorderRadius.circular(10)),
                              child: Text(
                                  '${val.toStringAsFixed(0)} MT',
                                  style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12)),
                            ),
                          ]),
                        ]),
                  );
                }),
                if (_hasQty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: kDark2,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text('Dispatch Summary',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('To: $_shop',
                              style: const TextStyle(
                                  color: kGrey, fontSize: 12)),
                          const Divider(
                              color: Colors.white12, height: 20),
                          ..._qty.entries
                              .where((e) => e.value > 0)
                              .map((e) => Padding(
                                    padding: const EdgeInsets
                                        .symmetric(vertical: 3),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          Text(e.key,
                                              style: const TextStyle(
                                                  color: kGrey,
                                                  fontSize: 12)),
                                          Text(
                                              '${e.value.toStringAsFixed(0)} MT',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                  fontSize: 12)),
                                        ]),
                                  )),
                        ]),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _hasQty
                        ? () => setState(() => _done = true)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                      disabledBackgroundColor:
                          kGrey.withOpacity(.3),
                    ),
                    child: const Text('CONFIRM DISPATCH',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            fontSize: 14)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ]),
      );

  Widget _stepBadge(String n, String label, Color color) =>
      Row(children: [
        Container(
            width: 28,
            height: 28,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
                child: Text(n,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13)))),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(
                color: kDark2,
                fontSize: 16,
                fontWeight: FontWeight.w800)),
      ]);
}

// ══════════════════════════════════════════════════════════════
//  PAGE 5 — INVENTORY
// ══════════════════════════════════════════════════════════════
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});
  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _search = '';

  static const _stocks = [
    {
      'item': 'Rice',
      'stock': 18400,
      'cap': 25000,
      'min': 5000,
      'unit': 'MT',
      'color': kGreen,
      'lot': 'LOT-R-2024-08',
      'exp': 'Dec 2025'
    },
    {
      'item': 'Wheat',
      'stock': 12100,
      'cap': 22000,
      'min': 4000,
      'unit': 'MT',
      'color': kBlue,
      'lot': 'LOT-W-2024-06',
      'exp': 'Nov 2025'
    },
    {
      'item': 'Sugar',
      'stock': 4200,
      'cap': 11000,
      'min': 3000,
      'unit': 'MT',
      'color': kOrange,
      'lot': 'LOT-S-2024-09',
      'exp': 'Mar 2026'
    },
    {
      'item': 'Dal',
      'stock': 8100,
      'cap': 10000,
      'min': 2000,
      'unit': 'MT',
      'color': kPurple,
      'lot': 'LOT-D-2024-07',
      'exp': 'Aug 2025'
    },
    {
      'item': 'Kerosene',
      'stock': 62000,
      'cap': 100000,
      'min': 20000,
      'unit': 'KL',
      'color': kYellow,
      'lot': 'LOT-K-2024-10',
      'exp': 'N/A'
    },
    {
      'item': 'Palm Oil',
      'stock': 3100,
      'cap': 8000,
      'min': 1500,
      'unit': 'KL',
      'color': Color(0xFFE67E22),
      'lot': 'LOT-P-2024-09',
      'exp': 'Jun 2025'
    },
  ];

  static const _movements = [
    {
      'type': 'IN',
      'item': 'Rice',
      'qty': '3,500 MT',
      'ref': 'RCV-2024-0412',
      'time': '2h ago',
      'color': kGreen
    },
    {
      'type': 'OUT',
      'item': 'Wheat',
      'qty': '850 MT',
      'ref': 'SH-2024-0890',
      'time': '5h ago',
      'color': kRed
    },
    {
      'type': 'OUT',
      'item': 'Rice',
      'qty': '1,200 MT',
      'ref': 'SH-2024-0891',
      'time': '6h ago',
      'color': kRed
    },
    {
      'type': 'IN',
      'item': 'Sugar',
      'qty': '1,100 MT',
      'ref': 'RCV-2024-0409',
      'time': 'Feb 15',
      'color': kGreen
    },
    {
      'type': 'IN',
      'item': 'Dal',
      'qty': '800 MT',
      'ref': 'RCV-2024-0408',
      'time': 'Feb 14',
      'color': kGreen
    },
    {
      'type': 'OUT',
      'item': 'Dal',
      'qty': '640 MT',
      'ref': 'SH-2024-0889',
      'time': 'Feb 13',
      'color': kRed
    },
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _stocks
        .where((s) => (s['item'] as String)
            .toLowerCase()
            .contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        const _Header(title: 'Inventory', sub: 'Stock Management'),
        Container(
          color: kDark2,
          child: TabBar(
            controller: _tab,
            labelColor: kBlueL,
            unselectedLabelColor: kGrey,
            indicatorColor: kBlueL,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 12),
            tabs: const [
              Tab(text: 'STOCK OVERVIEW'),
              Tab(text: 'MOVEMENT LOG')
            ],
          ),
        ),
        Expanded(
            child: TabBarView(controller: _tab, children: [
          _overviewTab(filtered),
          _movementTab(),
        ])),
      ]),
    );
  }

  Widget _overviewTab(List filtered) => Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8)
                ]),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: const InputDecoration(
                hintText: 'Search commodity...',
                hintStyle: TextStyle(color: kGrey, fontSize: 13),
                prefixIcon: Icon(Icons.search_rounded,
                    color: kGrey, size: 20),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        Expanded(
            child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  color: kDark2,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Warehouse Capacity',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text(
                        'Total: 176,000 MT  •  Used: 107,900 MT',
                        style:
                            TextStyle(color: kGrey, fontSize: 11)),
                    const SizedBox(height: 12),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                            value: 107900 / 176000,
                            backgroundColor: Colors.white12,
                            valueColor:
                                const AlwaysStoppedAnimation(kBlueL),
                            minHeight: 8)),
                    const SizedBox(height: 6),
                    const Text('61.3% utilized',
                        style: TextStyle(
                            color: kBlueL,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ]),
            ),
            ...filtered.asMap().entries.map((e) {
              final s = e.value as Map;
              final stock = s['stock'] as int;
              final cap = s['cap'] as int;
              final min = s['min'] as int;
              final color = s['color'] as Color;
              final fill = stock / cap;
              final low = stock < min;
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration:
                    Duration(milliseconds: 350 + e.key * 80),
                curve: Curves.easeOutCubic,
                builder: (_, v, ch) =>
                    Opacity(opacity: v.clamp(0.0, 1.0), child: ch),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: low
                        ? Border.all(
                            color: kRed.withOpacity(.35))
                        : null,
                    boxShadow: [
                      BoxShadow(
                          color: color.withOpacity(.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: color.withOpacity(.12),
                                  borderRadius:
                                      BorderRadius.circular(10)),
                              child: Icon(
                                  Icons.inventory_2_outlined,
                                  color: color,
                                  size: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(s['item'] as String,
                                          style: const TextStyle(
                                              color: kDark2,
                                              fontWeight:
                                                  FontWeight.w800,
                                              fontSize: 15)),
                                      Text(
                                          '${s['lot']}  •  Exp: ${s['exp']}',
                                          style: const TextStyle(
                                              color: kGrey,
                                              fontSize: 10)),
                                    ]),
                                if (low)
                                  Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3),
                                      decoration: BoxDecoration(
                                          color: kRed
                                              .withOpacity(.1),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  20)),
                                      child: const Text('LOW STOCK',
                                          style: TextStyle(
                                              color: kRed,
                                              fontSize: 8,
                                              fontWeight:
                                                  FontWeight
                                                      .w800))),
                              ])),
                        ]),
                        const SizedBox(height: 14),
                        Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$stock ${s['unit']}',
                                  style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16)),
                              Text('/ $cap ${s['unit']}',
                                  style: const TextStyle(
                                      color: kGrey, fontSize: 12)),
                            ]),
                        const SizedBox(height: 8),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(
                                value: fill,
                                backgroundColor:
                                    color.withOpacity(.1),
                                valueColor:
                                    AlwaysStoppedAnimation(color),
                                minHeight: 6)),
                        const SizedBox(height: 6),
                        Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${(fill * 100).toStringAsFixed(1)}% of capacity',
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight.w600)),
                              Text('Min: $min ${s['unit']}',
                                  style: const TextStyle(
                                      color: kGrey, fontSize: 10)),
                            ]),
                      ]),
                ),
              );
            }),
          ],
        )),
      ]);

  Widget _movementTab() => ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          ..._movements.map((l) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.04),
                          blurRadius: 8)
                    ]),
                child: Row(children: [
                  Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color:
                              (l['color'] as Color).withOpacity(.12),
                          shape: BoxShape.circle),
                      child: Icon(
                          l['type'] == 'IN'
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          color: l['color'] as Color,
                          size: 18)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                        Text(
                            '${l['type'] == 'IN' ? 'Received' : 'Dispatched'} ${l['item']}',
                            style: const TextStyle(
                                color: kDark2,
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                        Text('${l['ref']}  •  ${l['time']}',
                            style: const TextStyle(
                                color: kGrey, fontSize: 11)),
                      ])),
                  Text(l['qty'] as String,
                      style: TextStyle(
                          color: l['color'] as Color,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ]),
              )),
        ],
      );
}

// ══════════════════════════════════════════════════════════════
//  PAGE 6 — REPORTS
// ══════════════════════════════════════════════════════════════
class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});
  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _prog;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400));
    _prog =
        CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        const _Header(
            title: 'Reports & Analytics',
            sub: 'District Warehouse'),
        Expanded(
            child: AnimatedBuilder(
          animation: _prog,
          builder: (_, __) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    _kpi('Dispatched\nThis Month', '24,300 MT',
                        kBlue, Icons.upload_rounded),
                    const SizedBox(width: 10),
                    _kpi('Received\nThis Month', '15,600 MT',
                        kGreen, Icons.download_rounded),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    _kpi('Shops Served', '142', kPurple,
                        Icons.store_rounded),
                    const SizedBox(width: 10),
                    _kpi('Complaints', '7', kRed,
                        Icons.report_outlined),
                  ]),
                  const SizedBox(height: 24),
                  _sectionTitle('Monthly Dispatch (MT)'),
                  const SizedBox(height: 12),
                  _barChart(),
                  const SizedBox(height: 24),
                  _sectionTitle('Stock Distribution'),
                  const SizedBox(height: 12),
                  _donutChart(),
                  const SizedBox(height: 24),
                  _sectionTitle('Commodity Performance'),
                  const SizedBox(height: 12),
                  _commodityTable(),
                  const SizedBox(height: 24),
                  _sectionTitle('Top Shops by Dispatch'),
                  const SizedBox(height: 12),
                  _shopRanking(),
                  const SizedBox(height: 24),
                  _sectionTitle('Efficiency Summary'),
                  const SizedBox(height: 12),
                  _efficiencyRow(),
                  const SizedBox(height: 24),
                ]),
          ),
        )),
      ]),
    );
  }

  Widget _kpi(
          String label, String value, Color color, IconData icon) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [color, color.withOpacity(.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(.35),
                  blurRadius: 12,
                  offset: const Offset(0, 5))
            ],
          ),
          child: Row(children: [
            Icon(icon, color: Colors.white70, size: 26),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18)),
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          height: 1.4)),
                ])),
          ]),
        ),
      );

  Widget _barChart() {
    const data = [
      {'m': 'Sep', 'v': 18200},
      {'m': 'Oct', 'v': 21500},
      {'m': 'Nov', 'v': 19800},
      {'m': 'Dec', 'v': 23100},
      {'m': 'Jan', 'v': 22400},
      {'m': 'Feb', 'v': 24300},
    ];
    const max = 26000.0;
    final colors = [
      kBlue.withOpacity(.45),
      kBlue.withOpacity(.55),
      kBlue.withOpacity(.65),
      kBlue.withOpacity(.75),
      kBlue.withOpacity(.88),
      kBlue,
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12)
          ]),
      child: Column(children: [
        SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.asMap().entries.map((e) {
                final frac =
                    (e.value['v'] as int) / max * _prog.value;
                return Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [
                        Text(
                            '${((e.value['v'] as int) / 1000).toStringAsFixed(1)}k',
                            style: TextStyle(
                                color: colors[e.key],
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Container(
                            height: 120 * frac,
                            decoration: BoxDecoration(
                                color: colors[e.key],
                                borderRadius:
                                    const BorderRadius.vertical(
                                        top: Radius.circular(6)))),
                      ]),
                ));
              }).toList(),
            )),
        const SizedBox(height: 8),
        Row(
            children: data
                .map((d) => Expanded(
                      child: Text(d['m'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: kGrey, fontSize: 10)),
                    ))
                .toList()),
      ]),
    );
  }

  Widget _donutChart() {
    const slices = [
      {'label': 'Rice', 'pct': 0.43, 'color': kGreen},
      {'label': 'Wheat', 'pct': 0.28, 'color': kBlue},
      {'label': 'Dal', 'pct': 0.19, 'color': kPurple},
      {'label': 'Sugar', 'pct': 0.10, 'color': kOrange},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12)
          ]),
      child: Row(children: [
        SizedBox(
            width: 150,
            height: 150,
            child: CustomPaint(
                painter:
                    _DonutPainter(slices, _prog.value))),
        const SizedBox(width: 20),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: slices
                    .map((s) => Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 6),
                          child: Row(children: [
                            Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    color: s['color'] as Color,
                                    borderRadius:
                                        BorderRadius.circular(3))),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(s['label'] as String,
                                    style: const TextStyle(
                                        color: kDark2,
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.w600))),
                            Text(
                                '${((s['pct'] as double) * 100).toInt()}%',
                                style: TextStyle(
                                    color: s['color'] as Color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ]),
                        ))
                    .toList())),
      ]),
    );
  }

  Widget _commodityTable() {
    const rows = [
      {
        'item': 'Rice',
        'recv': '15,000',
        'disp': '10,200',
        'waste': '0.3%',
        'status': 'Good',
        'color': kGreen
      },
      {
        'item': 'Wheat',
        'recv': '8,500',
        'disp': '7,800',
        'waste': '0.5%',
        'status': 'Good',
        'color': kBlue
      },
      {
        'item': 'Sugar',
        'recv': '3,200',
        'disp': '3,100',
        'waste': '0.2%',
        'status': 'Low Stock',
        'color': kOrange
      },
      {
        'item': 'Dal',
        'recv': '2,900',
        'disp': '2,100',
        'waste': '0.4%',
        'status': 'Good',
        'color': kPurple
      },
    ];
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12)
          ]),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            child: Row(children: const [
              Expanded(
                  flex: 2,
                  child: Text('Item',
                      style: TextStyle(
                          color: kGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700))),
              Expanded(
                  child: Text('Recv',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700))),
              Expanded(
                  child: Text('Disp',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700))),
              Expanded(
                  child: Text('Waste',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700))),
              Expanded(
                  child: Text('Status',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w700))),
            ])),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
        ...rows.map((r) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              child: Row(children: [
                Expanded(
                    flex: 2,
                    child: Row(children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: r['color'] as Color,
                              shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(r['item'] as String,
                          style: const TextStyle(
                              color: kDark2,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ])),
                Expanded(
                    child: Text(r['recv'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: kGrey, fontSize: 12))),
                Expanded(
                    child: Text(r['disp'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: kGrey, fontSize: 12))),
                Expanded(
                    child: Text(r['waste'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: kGrey, fontSize: 12))),
                Expanded(
                    child: Center(
                        child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                      color: (r['color'] as Color).withOpacity(.12),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(r['status'] as String,
                      style: TextStyle(
                          color: r['color'] as Color,
                          fontSize: 8,
                          fontWeight: FontWeight.w800)),
                ))),
              ]),
            )),
      ]),
    );
  }

  Widget _shopRanking() {
    const shops = [
      {'name': 'Anna Nagar #01', 'qty': 3200, 'color': kBlue},
      {'name': 'T. Nagar #02', 'qty': 2800, 'color': kGreen},
      {'name': 'Adyar #03', 'qty': 2100, 'color': kPurple},
      {'name': 'Velachery #04', 'qty': 1900, 'color': kOrange},
      {'name': 'Tambaram #05', 'qty': 1600, 'color': kRed},
    ];
    const maxQty = 3200;
    return Column(
        children: shops.asMap().entries.map((e) {
      final s = e.value;
      final color = s['color'] as Color;
      final fill = (s['qty'] as int) / maxQty * _prog.value;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.04),
                  blurRadius: 8)
            ]),
        child: Row(children: [
          Container(
              width: 28,
              height: 28,
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                  child: Text('${e.key + 1}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12)))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(s['name'] as String,
                    style: const TextStyle(
                        color: kDark2,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                const SizedBox(height: 6),
                ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                        value: fill,
                        backgroundColor: color.withOpacity(.1),
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 5)),
              ])),
          const SizedBox(width: 12),
          Text('${s['qty']} MT',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 13)),
        ]),
      );
    }).toList());
  }

  Widget _efficiencyRow() {
    final items = [
      {'label': 'Dispatch\nEfficiency', 'value': '96.4%', 'color': kGreen},
      {'label': 'On-Time\nDelivery', 'value': '91.2%', 'color': kBlue},
      {'label': 'Waste\nRate', 'value': '0.35%', 'color': kOrange},
      {'label': 'Complaint\nRate', 'value': '0.05%', 'color': kRed},
    ];
    return Row(
        children: items
            .map((item) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      decoration: BoxDecoration(
                        color: (item['color'] as Color)
                            .withOpacity(.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: (item['color'] as Color)
                                .withOpacity(.2)),
                      ),
                      child: Column(children: [
                        Text(item['value'] as String,
                            style: TextStyle(
                                color: item['color'] as Color,
                                fontWeight: FontWeight.w900,
                                fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(item['label'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: kGrey,
                                fontSize: 9,
                                height: 1.4)),
                      ]),
                    ),
                  ),
                ))
            .toList());
  }
}

// ══════════════════════════════════════════════════════════════
//  DONUT CHART CUSTOM PAINTER
// ══════════════════════════════════════════════════════════════
class _DonutPainter extends CustomPainter {
  final List<Map<String, dynamic>> slices;
  final double progress;
  const _DonutPainter(this.slices, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) - 2;
    const stroke = 24.0;
    double start = -math.pi / 2;

    for (final s in slices) {
      final sweep =
          (s['pct'] as double) * 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(cx, cy), radius: r - stroke / 2),
        start,
        sweep - 0.05,
        false,
        Paint()
          ..color = s['color'] as Color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }

    final tp = TextPainter(
      text: const TextSpan(
        children: [
          TextSpan(
              text: '42,800\n',
              style: TextStyle(
                  color: kDark2,
                  fontSize: 13,
                  fontWeight: FontWeight.w900)),
          TextSpan(
              text: 'MT Total',
              style: TextStyle(color: kGrey, fontSize: 9)),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas,
        Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.progress != progress;
}

// ══════════════════════════════════════════════════════════════
//  LOGIN REDIRECT HELPER
//  Replace this with your actual LoginPage import/navigation
// ══════════════════════════════════════════════════════════════
class _LoginRedirect extends StatelessWidget {
  const _LoginRedirect();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with your actual LoginPage widget
    // e.g. return const LoginPage();
    return const Scaffold(
      body: Center(
        child: Text('Login Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}