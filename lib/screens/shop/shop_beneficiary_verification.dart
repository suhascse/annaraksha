import 'package:flutter/material.dart';

class ShopBeneficiaryVerificationPage extends StatefulWidget {
  final bool isEmbedded;
  const ShopBeneficiaryVerificationPage({super.key, this.isEmbedded = false});
  @override
  State<ShopBeneficiaryVerificationPage> createState() =>
      _ShopBeneficiaryVerificationPageState();
}

class _ShopBeneficiaryVerificationPageState
    extends State<ShopBeneficiaryVerificationPage> with TickerProviderStateMixin {
  late AnimationController _fadeAnim;
  late AnimationController _resultAnim;
  final _searchCtrl = TextEditingController();
  bool _searching = false;
  bool _found = false;
  int _searchType = 0; // 0 = card, 1 = phone

  final Map<String, dynamic> _beneficiary = {
    'name': 'Karthikeyan Murugan',
    'card': 'RC-TN-2024-00341',
    'phone': '98765 43210',
    'members': 4,
    'category': 'PHH',
    'shop': 'RS-0341 Anna Nagar',
    'entitlement': [
      {'item': 'Rice', 'allotted': 20, 'received': 12, 'unit': 'kg', 'icon': '🌾', 'color': Color(0xFF1B8A5A)},
      {'item': 'Wheat', 'allotted': 12, 'received': 12, 'unit': 'kg', 'icon': '🌿', 'color': Color(0xFFD4891A)},
      {'item': 'Sugar', 'allotted': 4, 'received': 0, 'unit': 'kg', 'icon': '🍬', 'color': Color(0xFFEF5350)},
      {'item': 'Dal', 'allotted': 8, 'received': 4, 'unit': 'kg', 'icon': '🫘', 'color': Color(0xFFBFC9D1)},
      {'item': 'Oil', 'allotted': 2, 'received': 0, 'unit': 'L', 'icon': '🫙', 'color': Color(0xFFFF9B51)},
    ],
    'history': [
      {'month': 'October 2024', 'date': 'Oct 15', 'items': 'Rice 20kg, Sugar 4kg, Dal 8kg', 'id': 'RCP-4891', 'status': 'complete'},
      {'month': 'September 2024', 'date': 'Sep 10', 'items': 'Rice 20kg, Wheat 12kg, Oil 2L', 'id': 'RCP-3102', 'status': 'complete'},
      {'month': 'August 2024', 'date': '—', 'items': 'Missed — Restitution applied', 'id': 'RCP-0000', 'status': 'missed'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _fadeAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
    _resultAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  }

  @override
  void dispose() {
    _fadeAnim.dispose();
    _resultAnim.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    if (_searchCtrl.text.isEmpty) return;
    setState(() { _searching = true; _found = false; });
    _resultAnim.reset();
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() { _searching = false; _found = true; });
    _resultAnim.forward();
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
            Expanded(child: _buildBody(size)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (!widget.isEmbedded) GestureDetector(
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
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Beneficiary Verification',
                  style: TextStyle(
                      color: const Color(0xFFEAEFEF),
                      fontSize: size.width * 0.046,
                      fontWeight: FontWeight.w800)),
              Text('Search by card or phone number',
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.029)),
            ]),
          ]),
          SizedBox(height: size.height * 0.02),
          // Toggle
          Container(
            padding: EdgeInsets.all(size.width * 0.012),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(size.width * 0.03),
            ),
            child: Row(children: [
              _searchToggle('Ration Card', 0, size),
              _searchToggle('Phone Number', 1, size),
            ]),
          ),
          SizedBox(height: size.height * 0.015),
          // Search input
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(size.width * 0.035),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(children: [
              SizedBox(width: size.width * 0.04),
              Icon(
                _searchType == 0 ? Icons.credit_card_rounded : Icons.phone_rounded,
                color: const Color(0xFFBFC9D1),
                size: size.width * 0.05,
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  style: TextStyle(color: Colors.white, fontSize: size.width * 0.038),
                  decoration: InputDecoration(
                    hintText: _searchType == 0 ? 'RC-TN-2024-XXXXX' : '98765 XXXXX',
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3), fontSize: size.width * 0.034),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.016),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _search,
                child: Container(
                  margin: EdgeInsets.all(size.width * 0.015),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04, vertical: size.height * 0.012),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9B51),
                    borderRadius: BorderRadius.circular(size.width * 0.025),
                  ),
                  child: _searching
                      ? SizedBox(
                          width: size.width * 0.04,
                          height: size.width * 0.04,
                          child: const CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(Icons.search_rounded, color: Colors.white, size: size.width * 0.045),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _searchToggle(String label, int index, Size size) {
    final sel = _searchType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _searchType = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: size.height * 0.012),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFFFF9B51) : Colors.transparent,
            borderRadius: BorderRadius.circular(size.width * 0.025),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: sel ? Colors.white : const Color(0xFFBFC9D1),
                  fontSize: size.width * 0.03,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildBody(Size size) {
    if (!_found) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.person_search_rounded,
              color: const Color(0xFFBFC9D1), size: size.width * 0.2),
          SizedBox(height: size.height * 0.02),
          Text('Search for a beneficiary',
              style: TextStyle(
                  color: const Color(0xFFBFC9D1), fontSize: size.width * 0.04)),
        ]),
      );
    }

    return AnimatedBuilder(
      animation: _resultAnim,
      builder: (_, child) => Opacity(
        opacity: _resultAnim.value,
        child: Transform.translate(offset: Offset(0, 30 * (1 - _resultAnim.value)), child: child),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(size.width * 0.055),
        child: Column(
          children: [
            _buildBeneficiaryCard(size),
            SizedBox(height: size.height * 0.02),
            _buildEntitlementCard(size),
            SizedBox(height: size.height * 0.02),
            _buildHistoryCard(size),
            SizedBox(height: size.height * 0.025),
            SizedBox(
              width: double.infinity,
              height: size.height * 0.065,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.volunteer_activism_rounded, size: size.width * 0.055),
                label: Text('Proceed to Distribute',
                    style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w800)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9B51),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.04)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeneficiaryCard(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xFF25343F),
        borderRadius: BorderRadius.circular(size.width * 0.055),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF25343F).withOpacity(0.3),
              blurRadius: size.width * 0.08,
              offset: Offset(0, size.height * 0.015))
        ],
      ),
      child: Column(
        children: [
          Row(children: [
            Container(
              width: size.width * 0.15,
              height: size.width * 0.15,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFF9B51), Color(0xFFFF6B35)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (_beneficiary['name'] as String).substring(0, 2).toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_beneficiary['name'] as String,
                    style: TextStyle(
                        color: const Color(0xFFEAEFEF),
                        fontSize: size.width * 0.042,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: size.height * 0.004),
                Text(_beneficiary['card'] as String,
                    style: TextStyle(
                        color: const Color(0xFFFF9B51),
                        fontSize: size.width * 0.032,
                        fontWeight: FontWeight.w600)),
                Text('${_beneficiary['members']} members • ${_beneficiary['category']}',
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
              ]),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.025, vertical: size.height * 0.008),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.2),
                borderRadius: BorderRadius.circular(size.width * 0.02),
                border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.4)),
              ),
              child: Text('VERIFIED',
                  style: TextStyle(
                      color: const Color(0xFF4CAF50),
                      fontSize: size.width * 0.025,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1)),
            ),
          ]),
          SizedBox(height: size.height * 0.018),
          Container(height: 1, color: Colors.white.withOpacity(0.08)),
          SizedBox(height: size.height * 0.015),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _infoItem(Icons.phone_rounded, _beneficiary['phone'] as String, size),
            _infoItem(Icons.storefront_rounded, _beneficiary['shop'] as String, size),
          ]),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String text, Size size) => Row(children: [
    Icon(icon, color: const Color(0xFFBFC9D1), size: size.width * 0.04),
    SizedBox(width: size.width * 0.02),
    Text(text, style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: size.width * 0.03)),
  ]);

  Widget _buildEntitlementCard(Size size) {
    final entitlement = _beneficiary['entitlement'] as List;
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.055),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.inventory_2_rounded, color: const Color(0xFFFF9B51), size: size.width * 0.05),
            SizedBox(width: size.width * 0.025),
            Text('Monthly Entitlement — November 2024',
                style: TextStyle(
                    color: const Color(0xFF25343F),
                    fontSize: size.width * 0.036,
                    fontWeight: FontWeight.w800)),
          ]),
          SizedBox(height: size.height * 0.018),
          ...entitlement.map((e) {
            final allotted = e['allotted'] as int;
            final received = e['received'] as int;
            final remaining = allotted - received;
            final color = e['color'] as Color;
            return Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.014),
              child: Column(
                children: [
                  Row(children: [
                    Text(e['icon'] as String, style: TextStyle(fontSize: size.width * 0.045)),
                    SizedBox(width: size.width * 0.03),
                    Expanded(child: Text(e['item'] as String,
                        style: TextStyle(color: const Color(0xFF25343F),
                            fontSize: size.width * 0.035, fontWeight: FontWeight.w700))),
                    Text('$remaining ${e['unit']} remaining',
                        style: TextStyle(
                            color: remaining == 0 ? const Color(0xFFBFC9D1) : color,
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w700)),
                  ]),
                  SizedBox(height: size.height * 0.006),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(size.width * 0.01),
                    child: LinearProgressIndicator(
                      value: allotted > 0 ? received / allotted : 0,
                      backgroundColor: color.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: size.height * 0.008,
                    ),
                  ),
                  SizedBox(height: size.height * 0.004),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Received: $received ${e['unit']}',
                          style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: size.width * 0.026)),
                      Text('Total: $allotted ${e['unit']}',
                          style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: size.width * 0.026)),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Size size) {
    final history = _beneficiary['history'] as List;
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.055),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.history_rounded, color: const Color(0xFF25343F), size: size.width * 0.05),
            SizedBox(width: size.width * 0.025),
            Text('Distribution History',
                style: TextStyle(
                    color: const Color(0xFF25343F),
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.w800)),
          ]),
          SizedBox(height: size.height * 0.018),
          ...history.map((h) {
            final isMissed = h['status'] == 'missed';
            return Container(
              margin: EdgeInsets.only(bottom: size.height * 0.012),
              padding: EdgeInsets.all(size.width * 0.035),
              decoration: BoxDecoration(
                color: isMissed
                    ? const Color(0xFFEF5350).withOpacity(0.05)
                    : const Color(0xFFEAEFEF).withOpacity(0.5),
                borderRadius: BorderRadius.circular(size.width * 0.03),
                border: Border.all(
                    color: isMissed
                        ? const Color(0xFFEF5350).withOpacity(0.2)
                        : Colors.transparent),
              ),
              child: Row(children: [
                Icon(
                  isMissed ? Icons.cancel_rounded : Icons.check_circle_rounded,
                  color: isMissed ? const Color(0xFFEF5350) : const Color(0xFF4CAF50),
                  size: size.width * 0.05,
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(h['month'] as String,
                        style: TextStyle(
                            color: const Color(0xFF25343F),
                            fontSize: size.width * 0.033,
                            fontWeight: FontWeight.w700)),
                    Text(h['items'] as String,
                        style: TextStyle(
                            color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
                  ]),
                ),
                Text(h['date'] as String,
                    style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
              ]),
            );
          }),
        ],
      ),
    );
  }
}
