import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShopReceiveShipmentPage extends StatefulWidget {
  final bool isEmbedded;
  const ShopReceiveShipmentPage({super.key, this.isEmbedded = false});
  @override
  State<ShopReceiveShipmentPage> createState() => _ShopReceiveShipmentPageState();
}

class _ShopReceiveShipmentPageState extends State<ShopReceiveShipmentPage>
    with TickerProviderStateMixin {
  late AnimationController _scanAnim;
  late AnimationController _fadeAnim;
  bool _scanned = false;
  bool _confirmed = false;
  final Map<String, TextEditingController> _controllers = {};

  final List<Map<String, dynamic>> _items = [
    {'name': 'Rice', 'expected': '800', 'icon': '🌾', 'color': const Color(0xFF1B8A5A)},
    {'name': 'Wheat', 'expected': '400', 'icon': '🌿', 'color': const Color(0xFFD4891A)},
    {'name': 'Sugar', 'expected': '200', 'icon': '🍬', 'color': const Color(0xFFEF5350)},
    {'name': 'Dal', 'expected': '150', 'icon': '🫘', 'color': const Color(0xFFBFC9D1)},
    {'name': 'Oil', 'expected': '100', 'icon': '🫙', 'color': const Color(0xFFFF9B51)},
  ];

  @override
  void initState() {
    super.initState();
    _scanAnim = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _fadeAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    for (final item in _items) {
      _controllers[item['name'] as String] = TextEditingController(text: item['expected'] as String);
    }
  }

  @override
  void dispose() {
    _scanAnim.dispose();
    _fadeAnim.dispose();
    for (final c in _controllers.values) c.dispose();
    super.dispose();
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
              child: _confirmed
                  ? _buildSuccessView(size)
                  : _scanned
                      ? _buildConfirmView(size)
                      : _buildScanView(size),
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
        bottom: size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF25343F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(size.width * 0.06)),
      ),
      child: Row(
        children: [
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
          if (!widget.isEmbedded) SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Receive Shipment',
                    style: TextStyle(
                        color: const Color(0xFFEAEFEF),
                        fontSize: size.width * 0.048,
                        fontWeight: FontWeight.w800)),
                Text('Scan QR and confirm stock',
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1), fontSize: size.width * 0.03)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03, vertical: size.height * 0.008),
            decoration: BoxDecoration(
              color: const Color(0xFF1B8A5A).withOpacity(0.2),
              borderRadius: BorderRadius.circular(size.width * 0.02),
              border: Border.all(color: const Color(0xFF1B8A5A).withOpacity(0.4)),
            ),
            child: Text('SH-0892',
                style: TextStyle(
                    color: const Color(0xFF4CAF50),
                    fontSize: size.width * 0.03,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildScanView(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.055),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          // QR Scanner frame
          Center(
            child: AnimatedBuilder(
              animation: _scanAnim,
              builder: (_, child) {
                return Container(
                  width: size.width * 0.65,
                  height: size.width * 0.65,
                  decoration: BoxDecoration(
                    color: const Color(0xFF25343F),
                    borderRadius: BorderRadius.circular(size.width * 0.06),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9B51).withOpacity(0.2 + 0.15 * _scanAnim.value),
                        blurRadius: size.width * 0.1,
                        spreadRadius: size.width * 0.01 * _scanAnim.value,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Corner brackets
                      ..._buildCornerBrackets(size),
                      // Scan line
                      Positioned(
                        left: size.width * 0.05,
                        right: size.width * 0.05,
                        top: size.width * 0.05 +
                            (size.width * 0.55 - size.width * 0.1) * _scanAnim.value,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                const Color(0xFFFF9B51),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(Icons.qr_code_rounded,
                            color: Colors.white.withOpacity(0.15),
                            size: size.width * 0.25),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Text('Point camera at shipment QR code',
              style: TextStyle(
                  color: const Color(0xFFBFC9D1),
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: size.height * 0.03),
          // Simulate scan button
          SizedBox(
            width: double.infinity,
            height: size.height * 0.065,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _scanned = true),
              icon: Icon(Icons.qr_code_scanner_rounded, size: size.width * 0.055),
              label: Text('Scan QR Code',
                  style: TextStyle(fontSize: size.width * 0.042, fontWeight: FontWeight.w800)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9B51),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.04)),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          TextButton(
            onPressed: () => setState(() => _scanned = true),
            child: Text('Enter Shipment ID Manually',
                style: TextStyle(
                    color: const Color(0xFFBFC9D1), fontSize: size.width * 0.033)),
          ),
          SizedBox(height: size.height * 0.03),
          _buildShipmentInfoCard(size),
        ],
      ),
    );
  }

  List<Widget> _buildCornerBrackets(Size size) {
    final bracketSize = size.width * 0.08;
    final pad = size.width * 0.04;
    const color = Color(0xFFFF9B51);
    const thick = 3.0;
    return [
      // TL
      Positioned(top: pad, left: pad, child: _bracket(bracketSize, color, thick, true, true)),
      Positioned(top: pad, right: pad, child: _bracket(bracketSize, color, thick, true, false)),
      Positioned(bottom: pad, left: pad, child: _bracket(bracketSize, color, thick, false, true)),
      Positioned(bottom: pad, right: pad, child: _bracket(bracketSize, color, thick, false, false)),
    ];
  }

  Widget _bracket(double size, Color color, double thick, bool top, bool left) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BracketPainter(color, thick, top, left),
      ),
    );
  }

  Widget _buildShipmentInfoCard(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.05),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: size.width * 0.04)],
      ),
      child: Column(
        children: [
          Row(children: [
            Icon(Icons.info_outline_rounded, color: const Color(0xFFBFC9D1), size: size.width * 0.045),
            SizedBox(width: size.width * 0.03),
            Text('Expected Shipment Details',
                style: TextStyle(
                    color: const Color(0xFF25343F),
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.w700)),
          ]),
          SizedBox(height: size.height * 0.015),
          ..._items.map((item) => Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.01),
            child: Row(children: [
              Text(item['icon'] as String, style: TextStyle(fontSize: size.width * 0.04)),
              SizedBox(width: size.width * 0.03),
              Expanded(child: Text(item['name'] as String,
                  style: TextStyle(color: const Color(0xFF25343F), fontSize: size.width * 0.035))),
              Text('${item['expected']} kg',
                  style: TextStyle(
                      color: item['color'] as Color,
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w700)),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _buildConfirmView(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.055),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scanned success banner
          Container(
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: const Color(0xFF1B8A5A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(size.width * 0.04),
              border: Border.all(color: const Color(0xFF1B8A5A).withOpacity(0.3)),
            ),
            child: Row(children: [
              Icon(Icons.check_circle_rounded, color: const Color(0xFF4CAF50), size: size.width * 0.06),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('QR Scanned Successfully',
                      style: TextStyle(
                          color: const Color(0xFF25343F),
                          fontSize: size.width * 0.038,
                          fontWeight: FontWeight.w700)),
                  Text('Shipment SH-2024-0892 • From Chennai Central Hub',
                      style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
                ]),
              ),
            ]),
          ),
          SizedBox(height: size.height * 0.025),
          Text('Verify Received Quantities',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w900)),
          Text('Enter actual received quantity for each item',
              style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: size.width * 0.03)),
          SizedBox(height: size.height * 0.02),
          ..._items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            final ctrl = _controllers[item['name'] as String]!;
            final expected = int.parse(item['expected'] as String);
            final entered = int.tryParse(ctrl.text) ?? 0;
            final isOk = entered == expected;
            final isLow = entered < expected;

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + i * 60),
              builder: (_, v, child) =>
                  Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 15 * (1 - v)), child: child)),
              child: Container(
                margin: EdgeInsets.only(bottom: size.height * 0.015),
                padding: EdgeInsets.all(size.width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                  border: Border.all(
                    color: isLow
                        ? const Color(0xFFEF5350).withOpacity(0.4)
                        : isOk
                            ? const Color(0xFF1B8A5A).withOpacity(0.3)
                            : Colors.transparent,
                  ),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                ),
                child: Row(children: [
                  Text(item['icon'] as String, style: TextStyle(fontSize: size.width * 0.06)),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item['name'] as String,
                          style: TextStyle(
                              color: const Color(0xFF25343F),
                              fontSize: size.width * 0.038,
                              fontWeight: FontWeight.w700)),
                      Text('Expected: ${item['expected']} kg',
                          style: TextStyle(
                              color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
                    ]),
                  ),
                  SizedBox(
                    width: size.width * 0.25,
                    child: TextField(
                      controller: ctrl,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isLow
                              ? const Color(0xFFEF5350)
                              : const Color(0xFF25343F),
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w800),
                      decoration: InputDecoration(
                        suffixText: 'kg',
                        suffixStyle: TextStyle(
                            color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(size.width * 0.025),
                          borderSide: BorderSide(
                              color: isLow
                                  ? const Color(0xFFEF5350)
                                  : const Color(0xFFBFC9D1).withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(size.width * 0.025),
                          borderSide: BorderSide(color: const Color(0xFFBFC9D1).withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(size.width * 0.025),
                          borderSide: const BorderSide(color: Color(0xFFFF9B51), width: 1.5),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.025, vertical: size.height * 0.012),
                        isDense: true,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ]),
              ),
            );
          }),
          SizedBox(height: size.height * 0.015),
          // Receipt upload
          Container(
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: const Color(0xFF25343F).withOpacity(0.04),
              borderRadius: BorderRadius.circular(size.width * 0.04),
              border: Border.all(
                  color: const Color(0xFFBFC9D1).withOpacity(0.3),
                  style: BorderStyle.solid),
            ),
            child: Row(children: [
              Icon(Icons.upload_file_rounded, color: const Color(0xFFBFC9D1), size: size.width * 0.06),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Text('Upload Receipt / Delivery Note',
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1), fontSize: size.width * 0.033)),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03, vertical: size.height * 0.008),
                decoration: BoxDecoration(
                  color: const Color(0xFF25343F),
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                ),
                child: Text('Browse',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.028,
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          SizedBox(height: size.height * 0.03),
          SizedBox(
            width: double.infinity,
            height: size.height * 0.065,
            child: ElevatedButton(
              onPressed: () => setState(() => _confirmed = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9B51),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.04)),
                elevation: 0,
              ),
              child: Text('Confirm & Update Inventory',
                  style: TextStyle(
                      fontSize: size.width * 0.042, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(Size size) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                width: size.width * 0.3,
                height: size.width * 0.3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF1B8A5A), Color(0xFF4CAF50)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.4),
                        blurRadius: size.width * 0.12,
                        spreadRadius: size.width * 0.02)
                  ],
                ),
                child: Icon(Icons.check_rounded, color: Colors.white, size: size.width * 0.15),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Text('Stock Updated!',
                style: TextStyle(
                    color: const Color(0xFF25343F),
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.w900)),
            SizedBox(height: size.height * 0.012),
            Text('Inventory has been updated successfully.\nDistrict warehouse notified.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xFFBFC9D1), fontSize: size.width * 0.035)),
            SizedBox(height: size.height * 0.04),
            Container(
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.05),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
              ),
              child: Column(
                children: _items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.01),
                  child: Row(children: [
                    Text(item['icon'] as String, style: TextStyle(fontSize: size.width * 0.04)),
                    SizedBox(width: size.width * 0.03),
                    Expanded(child: Text(item['name'] as String,
                        style: TextStyle(color: const Color(0xFF25343F), fontSize: size.width * 0.035))),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.025, vertical: size.height * 0.004),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B8A5A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(size.width * 0.015),
                      ),
                      child: Text('+${item['expected']} kg',
                          style: TextStyle(
                              color: const Color(0xFF1B8A5A),
                              fontSize: size.width * 0.03,
                              fontWeight: FontWeight.w700)),
                    ),
                  ]),
                )).toList(),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            SizedBox(
              width: double.infinity,
              height: size.height * 0.065,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25343F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.04)),
                  elevation: 0,
                ),
                child: Text('Back to Dashboard',
                    style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final Color color;
  final double thick;
  final bool top, left;
  _BracketPainter(this.color, this.thick, this.top, this.left);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final p = thick / 2;
    if (top && left) {
      canvas.drawLine(Offset(p, p), Offset(size.width, p), paint);
      canvas.drawLine(Offset(p, p), Offset(p, size.height), paint);
    } else if (top && !left) {
      canvas.drawLine(Offset(0, p), Offset(size.width - p, p), paint);
      canvas.drawLine(Offset(size.width - p, p), Offset(size.width - p, size.height), paint);
    } else if (!top && left) {
      canvas.drawLine(Offset(p, 0), Offset(p, size.height - p), paint);
      canvas.drawLine(Offset(p, size.height - p), Offset(size.width, size.height - p), paint);
    } else {
      canvas.drawLine(Offset(size.width - p, 0), Offset(size.width - p, size.height - p), paint);
      canvas.drawLine(Offset(0, size.height - p), Offset(size.width - p, size.height - p), paint);
    }
  }

  @override
  bool shouldRepaint(_BracketPainter old) => false;
}
