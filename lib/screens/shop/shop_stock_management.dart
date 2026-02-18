import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShopStockManagementPage extends StatefulWidget {
  final bool isEmbedded;
  const ShopStockManagementPage({super.key, this.isEmbedded = false});
  @override
  State<ShopStockManagementPage> createState() => _ShopStockManagementPageState();
}

class _ShopStockManagementPageState extends State<ShopStockManagementPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnim;
  late AnimationController _alertAnim;
  int _tabIndex = 0;
  bool _showDamagedForm = false;

  final List<Map<String, dynamic>> _stock = [
    {'name': 'Rice', 'icon': '🌾', 'qty': 1840.0, 'max': 2700.0, 'unit': 'kg', 'threshold': 300.0, 'color': const Color(0xFF1B8A5A), 'lastUpdate': '2 hrs ago'},
    {'name': 'Wheat', 'icon': '🌿', 'qty': 920.0, 'max': 2200.0, 'unit': 'kg', 'threshold': 250.0, 'color': const Color(0xFFD4891A), 'lastUpdate': '2 hrs ago'},
    {'name': 'Sugar', 'icon': '🍬', 'qty': 180.0, 'max': 1000.0, 'unit': 'kg', 'threshold': 200.0, 'color': const Color(0xFFEF5350), 'lastUpdate': '2 hrs ago'},
    {'name': 'Dal', 'icon': '🫘', 'qty': 640.0, 'max': 800.0, 'unit': 'kg', 'threshold': 100.0, 'color': const Color(0xFFBFC9D1), 'lastUpdate': '2 hrs ago'},
    {'name': 'Oil', 'icon': '🫙', 'qty': 310.0, 'max': 500.0, 'unit': 'L', 'threshold': 60.0, 'color': const Color(0xFFFF9B51), 'lastUpdate': '2 hrs ago'},
  ];

  final List<Map<String, dynamic>> _transactions = [
    {'type': 'receive', 'item': 'Rice', 'qty': 800, 'unit': 'kg', 'time': 'Today 08:30', 'ref': 'SH-0892', 'icon': '🌾'},
    {'type': 'distribute', 'item': 'Rice', 'qty': 5, 'unit': 'kg', 'time': 'Today 10:24', 'ref': 'RC-0012', 'icon': '🌾'},
    {'type': 'distribute', 'item': 'Sugar', 'qty': 1, 'unit': 'kg', 'time': 'Today 10:24', 'ref': 'RC-0012', 'icon': '🍬'},
    {'type': 'damage', 'item': 'Wheat', 'qty': 12, 'unit': 'kg', 'time': 'Yesterday', 'ref': 'DMG-004', 'icon': '🌿'},
    {'type': 'distribute', 'item': 'Dal', 'qty': 2, 'unit': 'kg', 'time': 'Today 09:58', 'ref': 'RC-0215', 'icon': '🫘'},
  ];

  String? _damagedItem;
  final _damagedQtyCtrl = TextEditingController();
  final _damagedReasonCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fadeAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
    _alertAnim = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeAnim.dispose();
    _alertAnim.dispose();
    _damagedQtyCtrl.dispose();
    _damagedReasonCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _lowStockItems =>
      _stock.where((s) => (s['qty'] as double) < (s['threshold'] as double)).toList();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pad = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFEF),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            _buildAppBar(size, pad),
            _buildTabs(size),
            Expanded(child: _buildTabContent(size)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(Size size, EdgeInsets pad) {
    return Container(
      width: size.width,
      padding: EdgeInsets.only(
        top: pad.top + size.height * 0.015,
        left: size.width * 0.05,
        right: size.width * 0.05,
        bottom: size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF25343F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(size.width * 0.06)),
      ),
      child: Column(
        children: [
          Row(children: [
            if (!widget.isEmbedded)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                padding: EdgeInsets.all(size.width * 0.025),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(size.width * 0.03),
                ),
                child: Icon(Icons.arrow_back_rounded,
                    color: const Color(0xFFEAEFEF), size: size.width * 0.05),
              ),
            ),
            SizedBox(width: size.width * 0.04),
            if (!widget.isEmbedded) SizedBox(width: size.width * 0.04),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Stock Management',
                  style: TextStyle(
                      color: const Color(0xFFEAEFEF),
                      fontSize: size.width * 0.046,
                      fontWeight: FontWeight.w800)),
              Text('Live inventory • RS-2024-0341',
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.029)),
            ])),
            if (_lowStockItems.isNotEmpty)
              AnimatedBuilder(
                animation: _alertAnim,
                builder: (_, child) => Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.025, vertical: size.height * 0.008),
                  decoration: BoxDecoration(
                    color: Color.lerp(const Color(0xFFEF5350).withOpacity(0.2),
                        const Color(0xFFEF5350).withOpacity(0.4), _alertAnim.value),
                    borderRadius: BorderRadius.circular(size.width * 0.02),
                    border: Border.all(color: const Color(0xFFEF5350).withOpacity(0.5)),
                  ),
                  child: Row(children: [
                    Icon(Icons.warning_rounded,
                        color: const Color(0xFFEF5350), size: size.width * 0.035),
                    SizedBox(width: size.width * 0.01),
                    Text('${_lowStockItems.length} Low',
                        style: TextStyle(
                            color: const Color(0xFFEF5350),
                            fontSize: size.width * 0.028,
                            fontWeight: FontWeight.w800)),
                  ]),
                ),
              ),
          ]),
        ],
      ),
    );
  }

  Widget _buildTabs(Size size) {
    final tabs = ['Inventory', 'Transactions', 'Damaged'];
    return Container(
      margin: EdgeInsets.fromLTRB(
          size.width * 0.055, size.height * 0.018, size.width * 0.055, 0),
      padding: EdgeInsets.all(size.width * 0.012),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
      ),
      child: Row(
        children: tabs.asMap().entries.map((e) {
          final sel = e.key == _tabIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: size.height * 0.012),
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFF25343F) : Colors.transparent,
                  borderRadius: BorderRadius.circular(size.width * 0.03),
                ),
                child: Text(e.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: sel ? Colors.white : const Color(0xFFBFC9D1),
                        fontSize: size.width * 0.032,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(Size size) {
    switch (_tabIndex) {
      case 0: return _buildInventoryTab(size);
      case 1: return _buildTransactionsTab(size);
      case 2: return _buildDamagedTab(size);
      default: return const SizedBox();
    }
  }

  Widget _buildInventoryTab(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.055),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_lowStockItems.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                color: const Color(0xFFEF5350).withOpacity(0.07),
                borderRadius: BorderRadius.circular(size.width * 0.04),
                border: Border.all(color: const Color(0xFFEF5350).withOpacity(0.3)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.warning_amber_rounded,
                      color: const Color(0xFFEF5350), size: size.width * 0.05),
                  SizedBox(width: size.width * 0.025),
                  Text('Auto Alert Sent to District!',
                      style: TextStyle(
                          color: const Color(0xFFEF5350),
                          fontSize: size.width * 0.038,
                          fontWeight: FontWeight.w800)),
                ]),
                SizedBox(height: size.height * 0.01),
                ..._lowStockItems.map((s) => Padding(
                  padding: EdgeInsets.only(top: size.height * 0.006),
                  child: Row(children: [
                    Text(s['icon'] as String, style: TextStyle(fontSize: size.width * 0.035)),
                    SizedBox(width: size.width * 0.02),
                    Text('${s['name']}: ${(s['qty'] as double).toInt()} ${s['unit']} — below threshold',
                        style: TextStyle(
                            color: const Color(0xFFEF5350), fontSize: size.width * 0.028)),
                  ]),
                )),
              ]),
            ),
            SizedBox(height: size.height * 0.02),
          ],
          Text('Live Stock Balance',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.044,
                  fontWeight: FontWeight.w900)),
          SizedBox(height: size.height * 0.015),
          ..._stock.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            final qty = item['qty'] as double;
            final max = item['max'] as double;
            final threshold = item['threshold'] as double;
            final ratio = qty / max;
            final isLow = qty < threshold;
            final color = isLow ? const Color(0xFFEF5350) : item['color'] as Color;

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 350 + i * 80),
              builder: (_, v, child) =>
                  Opacity(opacity: v, child: Transform.translate(offset: Offset(-20 * (1 - v), 0), child: child)),
              child: Container(
                margin: EdgeInsets.only(bottom: size.height * 0.014),
                padding: EdgeInsets.all(size.width * 0.045),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.045),
                  border: Border.all(
                    color: isLow ? const Color(0xFFEF5350).withOpacity(0.3) : Colors.transparent,
                    width: 1.5,
                  ),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                ),
                child: Column(
                  children: [
                    Row(children: [
                      Container(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(size.width * 0.03),
                        ),
                        child: Center(
                          child: Text(item['icon'] as String,
                              style: TextStyle(fontSize: size.width * 0.055)),
                        ),
                      ),
                      SizedBox(width: size.width * 0.035),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Text(item['name'] as String,
                                style: TextStyle(
                                    color: const Color(0xFF25343F),
                                    fontSize: size.width * 0.038,
                                    fontWeight: FontWeight.w800)),
                            const Spacer(),
                            if (isLow)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02, vertical: size.height * 0.003),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF5350).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(size.width * 0.015),
                                ),
                                child: Text('⚠ LOW STOCK',
                                    style: TextStyle(
                                        color: const Color(0xFFEF5350),
                                        fontSize: size.width * 0.022,
                                        fontWeight: FontWeight.w800)),
                              ),
                          ]),
                          SizedBox(height: size.height * 0.004),
                          Row(children: [
                            Text('${qty.toInt()} ${item['unit']}',
                                style: TextStyle(
                                    color: color,
                                    fontSize: size.width * 0.036,
                                    fontWeight: FontWeight.w700)),
                            Text(' / ${max.toInt()} ${item['unit']}',
                                style: TextStyle(
                                    color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
                            const Spacer(),
                            Text('${(ratio * 100).toInt()}%',
                                style: TextStyle(
                                    color: color,
                                    fontSize: size.width * 0.032,
                                    fontWeight: FontWeight.w800)),
                          ]),
                        ]),
                      ),
                    ]),
                    SizedBox(height: size.height * 0.012),
                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(size.width * 0.015),
                        child: LinearProgressIndicator(
                          value: ratio,
                          backgroundColor: color.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation(color),
                          minHeight: size.height * 0.01,
                        ),
                      ),
                      // threshold marker
                      Positioned(
                        left: size.width * 0.855 * (threshold / max),
                        top: 0,
                        bottom: 0,
                        child: Container(
                            width: 2,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF5350).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(1),
                            )),
                      ),
                    ]),
                    SizedBox(height: size.height * 0.006),
                    Row(children: [
                      Text('Threshold: ${threshold.toInt()} ${item['unit']}',
                          style: TextStyle(
                              color: const Color(0xFFBFC9D1), fontSize: size.width * 0.026)),
                      const Spacer(),
                      Text('Updated ${item['lastUpdate']}',
                          style: TextStyle(
                              color: const Color(0xFFBFC9D1), fontSize: size.width * 0.026)),
                    ]),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.055),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stock Transactions',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.044,
                  fontWeight: FontWeight.w900)),
          SizedBox(height: size.height * 0.015),
          ..._transactions.asMap().entries.map((e) {
            final i = e.key;
            final t = e.value;
            final isReceive = t['type'] == 'receive';
            final isDamage = t['type'] == 'damage';
            final color = isReceive
                ? const Color(0xFF1B8A5A)
                : isDamage
                    ? const Color(0xFFEF5350)
                    : const Color(0xFFFF9B51);

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + i * 70),
              builder: (_, v, child) =>
                  Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 10 * (1 - v)), child: child)),
              child: Container(
                margin: EdgeInsets.only(bottom: size.height * 0.012),
                padding: EdgeInsets.all(size.width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                ),
                child: Row(children: [
                  Container(
                    width: size.width * 0.11,
                    height: size.width * 0.11,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isReceive ? Icons.arrow_downward_rounded : isDamage ? Icons.broken_image_rounded : Icons.arrow_upward_rounded,
                      color: color,
                      size: size.width * 0.048,
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('${t['icon']} ${t['item']}',
                            style: TextStyle(
                                color: const Color(0xFF25343F),
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text(
                          '${isReceive ? '+' : '-'}${t['qty']} ${t['unit']}',
                          style: TextStyle(
                              color: color,
                              fontSize: size.width * 0.036,
                              fontWeight: FontWeight.w800),
                        ),
                      ]),
                      SizedBox(height: size.height * 0.004),
                      Row(children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.018, vertical: size.height * 0.003),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(size.width * 0.015),
                          ),
                          child: Text(
                            isReceive ? 'RECEIVED' : isDamage ? 'DAMAGED' : 'DISTRIBUTED',
                            style: TextStyle(
                                color: color,
                                fontSize: size.width * 0.022,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Text(t['ref'] as String,
                            style: TextStyle(
                                color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
                        const Spacer(),
                        Text(t['time'] as String,
                            style: TextStyle(
                                color: const Color(0xFFBFC9D1), fontSize: size.width * 0.026)),
                      ]),
                    ]),
                  ),
                ]),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDamagedTab(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.055),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Report Damaged Goods',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.044,
                  fontWeight: FontWeight.w900)),
          SizedBox(height: size.height * 0.005),
          Text('Damaged stock will be deducted from inventory and reported to district',
              style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: size.width * 0.03)),
          SizedBox(height: size.height * 0.02),
          // Select item
          Text('Select Item',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.034,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: size.height * 0.01),
          Wrap(
            spacing: size.width * 0.025,
            runSpacing: size.height * 0.01,
            children: _stock.map((s) {
              final sel = _damagedItem == s['name'];
              final color = s['color'] as Color;
              return GestureDetector(
                onTap: () => setState(() => _damagedItem = s['name'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04, vertical: size.height * 0.012),
                  decoration: BoxDecoration(
                    color: sel ? color : Colors.white,
                    borderRadius: BorderRadius.circular(size.width * 0.03),
                    border: Border.all(color: sel ? color : const Color(0xFFBFC9D1).withOpacity(0.3)),
                    boxShadow: sel
                        ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)]
                        : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(s['icon'] as String, style: TextStyle(fontSize: size.width * 0.04)),
                    SizedBox(width: size.width * 0.02),
                    Text(s['name'] as String,
                        style: TextStyle(
                            color: sel ? Colors.white : const Color(0xFF25343F),
                            fontSize: size.width * 0.032,
                            fontWeight: FontWeight.w700)),
                  ]),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: size.height * 0.022),
          _buildInputField('Damaged Quantity (kg / L)', _damagedQtyCtrl, size,
              keyboardType: TextInputType.number, hint: 'e.g. 25'),
          SizedBox(height: size.height * 0.015),
          _buildInputField('Reason / Description', _damagedReasonCtrl, size,
              maxLines: 3, hint: 'Describe damage: water damage, pest infestation, etc.'),
          SizedBox(height: size.height * 0.015),
          // Photo upload
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: size.height * 0.12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.04),
                border: Border.all(
                    color: const Color(0xFFBFC9D1).withOpacity(0.4),
                    style: BorderStyle.solid),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add_photo_alternate_rounded,
                    color: const Color(0xFFBFC9D1), size: size.width * 0.08),
                SizedBox(height: size.height * 0.008),
                Text('Tap to add photo evidence',
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1), fontSize: size.width * 0.03)),
              ]),
            ),
          ),
          SizedBox(height: size.height * 0.025),
          SizedBox(
            width: double.infinity,
            height: size.height * 0.065,
            child: ElevatedButton.icon(
              onPressed: _damagedItem == null ? null : () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Damaged goods reported for $_damagedItem'),
                  backgroundColor: const Color(0xFFEF5350),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ));
                setState(() { _damagedItem = null; _damagedQtyCtrl.clear(); _damagedReasonCtrl.clear(); });
              },
              icon: Icon(Icons.report_rounded, size: size.width * 0.05),
              label: Text('Submit Damage Report',
                  style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w800)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF5350),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFBFC9D1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.04)),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Text('Previous Damage Reports',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.038,
                  fontWeight: FontWeight.w800)),
          SizedBox(height: size.height * 0.012),
          ...[
            {'item': '🌿 Wheat', 'qty': '12 kg', 'reason': 'Moisture damage', 'date': 'Yesterday', 'status': 'Reported'},
            {'item': '🌾 Rice', 'qty': '5 kg', 'reason': 'Pest damage', 'date': 'Oct 20', 'status': 'Resolved'},
          ].map((r) => Container(
            margin: EdgeInsets.only(bottom: size.height * 0.012),
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.04),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${r['item']} — ${r['qty']}',
                    style: TextStyle(
                        color: const Color(0xFF25343F),
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w700)),
                Text('${r['reason']} • ${r['date']}',
                    style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
              ])),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.025, vertical: size.height * 0.005),
                decoration: BoxDecoration(
                  color: r['status'] == 'Resolved'
                      ? const Color(0xFF1B8A5A).withOpacity(0.1)
                      : const Color(0xFFFF9B51).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                ),
                child: Text(r['status'] as String,
                    style: TextStyle(
                        color: r['status'] == 'Resolved'
                            ? const Color(0xFF1B8A5A)
                            : const Color(0xFFFF9B51),
                        fontSize: size.width * 0.026,
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController ctrl, Size size,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1, String hint = ''}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: TextStyle(
              color: const Color(0xFF25343F),
              fontSize: size.width * 0.033,
              fontWeight: FontWeight.w700)),
      SizedBox(height: size.height * 0.008),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.035),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
        ),
        child: TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: const Color(0xFF25343F), fontSize: size.width * 0.036),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: const Color(0xFFBFC9D1), fontSize: size.width * 0.034),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(size.width * 0.035),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(size.width * 0.035),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(size.width * 0.035),
              borderSide: const BorderSide(color: Color(0xFFFF9B51), width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04, vertical: size.height * 0.015),
          ),
        ),
      ),
    ]);
  }
}
