import 'package:flutter/material.dart';

class ShopDistributeRationPage extends StatefulWidget {
  final bool isEmbedded;
  const ShopDistributeRationPage({super.key, this.isEmbedded = false});
  @override
  State<ShopDistributeRationPage> createState() => _ShopDistributeRationPageState();
}

class _ShopDistributeRationPageState extends State<ShopDistributeRationPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnim;
  late AnimationController _successAnim;
  bool _distributed = false;

  final List<Map<String, dynamic>> _items = [
    {'name': 'Rice', 'icon': '🌾', 'allotted': 20, 'qty': 20, 'unit': 'kg', 'color': const Color(0xFF1B8A5A), 'available': 1840, 'selected': true},
    {'name': 'Wheat', 'icon': '🌿', 'allotted': 12, 'qty': 12, 'unit': 'kg', 'color': const Color(0xFFD4891A), 'available': 920, 'selected': false},
    {'name': 'Sugar', 'icon': '🍬', 'allotted': 4, 'qty': 4, 'unit': 'kg', 'color': const Color(0xFFEF5350), 'available': 380, 'selected': false},
    {'name': 'Dal', 'icon': '🫘', 'allotted': 8, 'qty': 8, 'unit': 'kg', 'color': const Color(0xFFBFC9D1), 'available': 640, 'selected': true},
    {'name': 'Oil', 'icon': '🫙', 'allotted': 2, 'qty': 2, 'unit': 'L', 'color': const Color(0xFFFF9B51), 'available': 310, 'selected': false},
  ];

  @override
  void initState() {
    super.initState();
    _fadeAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
    _successAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _fadeAnim.dispose();
    _successAnim.dispose();
    super.dispose();
  }

  void _distribute() async {
    setState(() => _distributed = true);
    _successAnim.forward();
  }

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
            Expanded(
              child: _distributed ? _buildSuccessView(size) : _buildDistributeView(size),
            ),
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
        bottom: size.height * 0.022,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF25343F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(size.width * 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Distribute Ration',
                    style: TextStyle(
                        color: const Color(0xFFEAEFEF),
                        fontSize: size.width * 0.046,
                        fontWeight: FontWeight.w800)),
                Text('Select items and confirm',
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1), fontSize: size.width * 0.029)),
              ]),
            ),
          ]),
          SizedBox(height: size.height * 0.018),
          // Beneficiary mini card
          Container(
            padding: EdgeInsets.all(size.width * 0.035),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(size.width * 0.035),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(children: [
              Container(
                width: size.width * 0.1,
                height: size.width * 0.1,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9B51),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('KM',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Karthikeyan Murugan',
                    style: TextStyle(
                        color: const Color(0xFFEAEFEF),
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.w700)),
                Text('RC-TN-2024-00341 • 4 members • PHH',
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
              ])),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.025, vertical: size.height * 0.006),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                ),
                child: Text('✓ VERIFIED',
                    style: TextStyle(
                        color: const Color(0xFF4CAF50),
                        fontSize: size.width * 0.024,
                        fontWeight: FontWeight.w800)),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributeView(Size size) {
    final selectedItems = _items.where((i) => i['selected'] as bool).toList();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.055),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Select Items to Distribute',
                style: TextStyle(
                    color: const Color(0xFF25343F),
                    fontSize: size.width * 0.044,
                    fontWeight: FontWeight.w900)),
            const Spacer(),
            TextButton(
              onPressed: () => setState(() { for (final i in _items) { i['selected'] = true; } }),
              child: Text('Select All',
                  style: TextStyle(
                      color: const Color(0xFFFF9B51),
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.w700)),
            ),
          ]),
          SizedBox(height: size.height * 0.015),
          ..._items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            final color = item['color'] as Color;
            final isSelected = item['selected'] as bool;
            final isLowStock = (item['available'] as int) < 200;

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + i * 60),
              builder: (_, v, child) =>
                  Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 15 * (1 - v)), child: child)),
              child: GestureDetector(
                onTap: () => setState(() => item['selected'] = !isSelected),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.only(bottom: size.height * 0.014),
                  padding: EdgeInsets.all(size.width * 0.045),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(size.width * 0.045),
                    border: Border.all(
                      color: isSelected ? color.withOpacity(0.4) : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: color.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))]
                        : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
                  ),
                  child: Row(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: size.width * 0.06,
                      height: size.width * 0.06,
                      decoration: BoxDecoration(
                        color: isSelected ? color : const Color(0xFFBFC9D1).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSelected ? Icons.check_rounded : Icons.add_rounded,
                        color: isSelected ? Colors.white : const Color(0xFFBFC9D1),
                        size: size.width * 0.035,
                      ),
                    ),
                    SizedBox(width: size.width * 0.035),
                    Text(item['icon'] as String, style: TextStyle(fontSize: size.width * 0.055)),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item['name'] as String,
                            style: TextStyle(
                                color: const Color(0xFF25343F),
                                fontSize: size.width * 0.038,
                                fontWeight: FontWeight.w700)),
                        Row(children: [
                          Text('Allotted: ${item['allotted']} ${item['unit']}',
                              style: TextStyle(
                                  color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
                          SizedBox(width: size.width * 0.02),
                          if (isLowStock)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.015, vertical: size.height * 0.002),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF5350).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(size.width * 0.01),
                              ),
                              child: Text('LOW STOCK',
                                  style: TextStyle(
                                      color: const Color(0xFFEF5350),
                                      fontSize: size.width * 0.02,
                                      fontWeight: FontWeight.w700)),
                            ),
                        ]),
                      ]),
                    ),
                    if (isSelected) ...[
                      GestureDetector(
                        onTap: () => setState(() {
                          final v = item['qty'] as int;
                          if (v > 0) item['qty'] = v - 1;
                        }),
                        child: Container(
                          width: size.width * 0.08,
                          height: size.width * 0.08,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(size.width * 0.02),
                          ),
                          child: Icon(Icons.remove_rounded, color: color, size: size.width * 0.04),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.12,
                        child: Text(
                          '${item['qty']} ${item['unit']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color(0xFF25343F),
                              fontSize: size.width * 0.032,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          final v = item['qty'] as int;
                          if (v < (item['allotted'] as int)) item['qty'] = v + 1;
                        }),
                        child: Container(
                          width: size.width * 0.08,
                          height: size.width * 0.08,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(size.width * 0.02),
                          ),
                          child: Icon(Icons.add_rounded, color: color, size: size.width * 0.04),
                        ),
                      ),
                    ],
                  ]),
                ),
              ),
            );
          }),
          if (selectedItems.isEmpty) ...[
            SizedBox(height: size.height * 0.02),
            Center(
              child: Text('Select at least one item to distribute',
                  style: TextStyle(
                      color: const Color(0xFFEF5350), fontSize: size.width * 0.033)),
            ),
          ],
          SizedBox(height: size.height * 0.025),
          // Summary
          if (selectedItems.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(size.width * 0.045),
              decoration: BoxDecoration(
                color: const Color(0xFF25343F).withOpacity(0.05),
                borderRadius: BorderRadius.circular(size.width * 0.04),
                border: Border.all(color: const Color(0xFFBFC9D1).withOpacity(0.3)),
              ),
              child: Column(children: [
                Row(children: [
                  Icon(Icons.receipt_long_rounded,
                      color: const Color(0xFFFF9B51), size: size.width * 0.045),
                  SizedBox(width: size.width * 0.025),
                  Text('Distribution Summary',
                      style: TextStyle(
                          color: const Color(0xFF25343F),
                          fontSize: size.width * 0.036,
                          fontWeight: FontWeight.w800)),
                ]),
                SizedBox(height: size.height * 0.012),
                ...selectedItems.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.008),
                  child: Row(children: [
                    Text(item['icon'] as String, style: TextStyle(fontSize: size.width * 0.04)),
                    SizedBox(width: size.width * 0.02),
                    Expanded(child: Text(item['name'] as String,
                        style: TextStyle(color: const Color(0xFF25343F), fontSize: size.width * 0.033))),
                    Text('${item['qty']} ${item['unit']}',
                        style: TextStyle(
                            color: item['color'] as Color,
                            fontSize: size.width * 0.033,
                            fontWeight: FontWeight.w700)),
                  ]),
                )),
              ]),
            ),
            SizedBox(height: size.height * 0.02),
            SizedBox(
              width: double.infinity,
              height: size.height * 0.065,
              child: ElevatedButton(
                onPressed: selectedItems.isEmpty ? null : _distribute,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9B51),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.04)),
                  elevation: 0,
                  disabledBackgroundColor: const Color(0xFFBFC9D1),
                ),
                child: Text('Confirm Distribution',
                    style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuccessView(Size size) {
    final selected = _items.where((i) => i['selected'] as bool).toList();
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(size.width * 0.08),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: size.width * 0.28,
              height: size.width * 0.28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFF9B51), Color(0xFFFF6B35)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFFFF9B51).withOpacity(0.4),
                      blurRadius: size.width * 0.12,
                      spreadRadius: size.width * 0.02)
                ],
              ),
              child: Icon(Icons.volunteer_activism_rounded,
                  color: Colors.white, size: size.width * 0.13),
            ),
          ),
          SizedBox(height: size.height * 0.035),
          Text('Ration Distributed!',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.058,
                  fontWeight: FontWeight.w900)),
          SizedBox(height: size.height * 0.01),
          Text('Stock deducted & receipt generated',
              style: TextStyle(
                  color: const Color(0xFFBFC9D1), fontSize: size.width * 0.033)),
          SizedBox(height: size.height * 0.035),
          Container(
            padding: EdgeInsets.all(size.width * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.055),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12)],
            ),
            child: Column(children: [
              Row(children: [
                const Text('🧾', style: TextStyle(fontSize: 22)),
                SizedBox(width: size.width * 0.025),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Receipt: RCP-2024-4921',
                      style: TextStyle(
                          color: const Color(0xFF25343F),
                          fontSize: size.width * 0.036,
                          fontWeight: FontWeight.w800)),
                  Text('Karthikeyan Murugan • ${DateTime.now().toString().substring(0, 10)}',
                      style: TextStyle(
                          color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
                ]),
              ]),
              SizedBox(height: size.height * 0.015),
              Container(height: 1, color: const Color(0xFFEAEFEF)),
              SizedBox(height: size.height * 0.015),
              ...selected.map((item) => Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.01),
                child: Row(children: [
                  Text(item['icon'] as String, style: TextStyle(fontSize: size.width * 0.04)),
                  SizedBox(width: size.width * 0.025),
                  Expanded(child: Text(item['name'] as String,
                      style: TextStyle(color: const Color(0xFF25343F), fontSize: size.width * 0.034))),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.025, vertical: size.height * 0.004),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(size.width * 0.015),
                    ),
                    child: Text('-${item['qty']} ${item['unit']}',
                        style: TextStyle(
                            color: item['color'] as Color,
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w700)),
                  ),
                ]),
              )),
            ]),
          ),
          SizedBox(height: size.height * 0.025),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.share_rounded, size: size.width * 0.045),
                label: Text('Share Receipt',
                    style: TextStyle(fontSize: size.width * 0.033)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF25343F),
                  side: const BorderSide(color: Color(0xFF25343F)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.04)),
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.016),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25343F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.04)),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.016),
                ),
                child: Text('Done', style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.w800)),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
