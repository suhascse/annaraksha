import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BeneficiaryDistributionHistoryPage extends StatefulWidget {
  const BeneficiaryDistributionHistoryPage({super.key});
  @override
  State<BeneficiaryDistributionHistoryPage> createState() =>
      _BeneficiaryDistributionHistoryPageState();
}

class _BeneficiaryDistributionHistoryPageState
    extends State<BeneficiaryDistributionHistoryPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnim;
  String _filterMonth = 'All';
  String? _expandedReceipt;

  final List<Map<String, dynamic>> _history = [
    {
      'receiptId': 'RCP-0041',
      'date': '19 Jan 2026',
      'month': 'Jan',
      'items': [
        {'name': 'Rice', 'qty': 6.0, 'unit': 'kg'},
        {'name': 'Dal', 'qty': 2.0, 'unit': 'kg'},
        {'name': 'Sugar', 'qty': 0.5, 'unit': 'kg'},
      ],
      'status': 'Collected',
      'dealer': 'Ravi Kumar',
      'shopId': 'RS-2024-0341',
    },
    {
      'receiptId': 'RCP-0038',
      'date': '22 Dec 2025',
      'month': 'Dec',
      'items': [
        {'name': 'Rice', 'qty': 10.0, 'unit': 'kg'},
        {'name': 'Wheat', 'qty': 8.0, 'unit': 'kg'},
        {'name': 'Oil', 'qty': 1.0, 'unit': 'L'},
      ],
      'status': 'Collected',
      'dealer': 'Ravi Kumar',
      'shopId': 'RS-2024-0341',
    },
    {
      'receiptId': 'RCP-0035',
      'date': '18 Nov 2025',
      'month': 'Nov',
      'items': [
        {'name': 'Rice', 'qty': 10.0, 'unit': 'kg'},
        {'name': 'Wheat', 'qty': 8.0, 'unit': 'kg'},
      ],
      'status': 'Restitution',
      'dealer': 'Ravi Kumar',
      'shopId': 'RS-2024-0341',
    },
    {
      'receiptId': 'RCP-0031',
      'date': '20 Oct 2025',
      'month': 'Oct',
      'items': [
        {'name': 'Rice', 'qty': 10.0, 'unit': 'kg'},
        {'name': 'Dal', 'qty': 3.0, 'unit': 'kg'},
        {'name': 'Sugar', 'qty': 2.0, 'unit': 'kg'},
        {'name': 'Oil', 'qty': 1.0, 'unit': 'L'},
      ],
      'status': 'Collected',
      'dealer': 'Ravi Kumar',
      'shopId': 'RS-2024-0341',
    },
  ];

  final List<String> _months = ['All', 'Jan', 'Dec', 'Nov', 'Oct'];

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered => _filterMonth == 'All'
      ? _history
      : _history.where((h) => h['month'] == _filterMonth).toList();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pad = MediaQuery.of(context).padding;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFEAEFEF),
        body: Column(children: [
          _buildHeader(size, pad),
          _buildFilterRow(size),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.055,
                  size.height * 0.02,
                  size.width * 0.055,
                  size.height * 0.03),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _buildReceiptCard(_filtered[i], i, size),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildHeader(Size size, EdgeInsets pad) {
    return AnimatedBuilder(
      animation: _headerAnim,
      builder: (_, child) => Opacity(
          opacity: _headerAnim.value.clamp(0.0, 1.0), child: child),
      child: Container(
        padding: EdgeInsets.only(
          top: pad.top + size.height * 0.018,
          left: size.width * 0.055,
          right: size.width * 0.055,
          bottom: size.height * 0.025,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF25343F),
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(size.width * 0.075)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF25343F).withOpacity(0.4),
                blurRadius: size.width * 0.08,
                offset: Offset(0, size.height * 0.015))
          ],
        ),
        child: Row(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(size.width * 0.022),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(size.width * 0.025),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: const Color(0xFFEAEFEF), size: size.width * 0.045),
            ),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Distribution History',
                  style: TextStyle(
                      color: const Color(0xFFEAEFEF),
                      fontSize: size.width * 0.048,
                      fontWeight: FontWeight.w900)),
              Text('RC-0042 • All transactions',
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.029)),
            ]),
          ),
          Container(
            padding: EdgeInsets.all(size.width * 0.028),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9B51).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_long_rounded,
                color: const Color(0xFFFF9B51), size: size.width * 0.055),
          ),
        ]),
      ),
    );
  }

  Widget _buildFilterRow(Size size) {
    return Container(
      height: size.height * 0.065,
      margin: EdgeInsets.only(top: size.height * 0.015),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.055),
        itemCount: _months.length,
        itemBuilder: (_, i) {
          final m = _months[i];
          final sel = m == _filterMonth;
          return GestureDetector(
            onTap: () => setState(() => _filterMonth = m),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: size.width * 0.03),
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.012),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFF25343F) : Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.04),
                boxShadow: sel
                    ? [
                        BoxShadow(
                            color: const Color(0xFF25343F).withOpacity(0.3),
                            blurRadius: size.width * 0.04,
                            offset: Offset(0, size.height * 0.006))
                      ]
                    : [],
              ),
              child: Text(m,
                  style: TextStyle(
                      color: sel ? const Color(0xFFFF9B51) : const Color(0xFFBFC9D1),
                      fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                      fontSize: size.width * 0.034)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReceiptCard(Map<String, dynamic> record, int i, Size size) {
    final isExpanded = _expandedReceipt == record['receiptId'];
    final isRestitution = record['status'] == 'Restitution';
    final statusColor =
        isRestitution ? const Color(0xFFFF9B51) : const Color(0xFF4CAF50);
    final items = record['items'] as List;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + i * 80),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
          opacity: v,
          child: Transform.translate(offset: Offset(-20 * (1 - v), 0), child: child)),
      child: GestureDetector(
        onTap: () => setState(() =>
            _expandedReceipt = isExpanded ? null : record['receiptId'] as String),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.only(bottom: size.height * 0.015),
          padding: EdgeInsets.all(size.width * 0.045),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size.width * 0.05),
            border: isExpanded
                ? Border.all(color: const Color(0xFFFF9B51).withOpacity(0.4), width: 1.5)
                : Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(isExpanded ? 0.1 : 0.05),
                  blurRadius: size.width * (isExpanded ? 0.06 : 0.03),
                  offset: Offset(0, size.height * 0.007))
            ],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: size.width * 0.11,
                height: size.width * 0.11,
                decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(
                  isRestitution
                      ? Icons.account_balance_wallet_rounded
                      : Icons.check_circle_rounded,
                  color: statusColor,
                  size: size.width * 0.055,
                ),
              ),
              SizedBox(width: size.width * 0.035),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(record['receiptId'] as String,
                      style: TextStyle(
                          color: const Color(0xFF25343F),
                          fontSize: size.width * 0.038,
                          fontWeight: FontWeight.w800)),
                  Text(record['date'] as String,
                      style: TextStyle(
                          color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
                ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.022, vertical: size.height * 0.004),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(size.width * 0.02),
                  ),
                  child: Text(record['status'] as String,
                      style: TextStyle(
                          color: statusColor,
                          fontSize: size.width * 0.026,
                          fontWeight: FontWeight.w800)),
                ),
                SizedBox(height: size.height * 0.005),
                Text('${items.length} items',
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1), fontSize: size.width * 0.026)),
              ]),
              SizedBox(width: size.width * 0.02),
              AnimatedRotation(
                duration: const Duration(milliseconds: 250),
                turns: isExpanded ? 0.5 : 0,
                child: Icon(Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFFBFC9D1), size: size.width * 0.05),
              ),
            ]),

            // Expanded details
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(children: [
                SizedBox(height: size.height * 0.018),
                Container(
                  height: 1,
                  color: const Color(0xFFEAEFEF),
                ),
                SizedBox(height: size.height * 0.015),
                ...items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.01),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['name'] as String,
                            style: TextStyle(
                                color: const Color(0xFF25343F),
                                fontSize: size.width * 0.033,
                                fontWeight: FontWeight.w600)),
                        Text(
                            '${(item['qty'] as double).toStringAsFixed(1)} ${item['unit']}',
                            style: TextStyle(
                                color: const Color(0xFFFF9B51),
                                fontSize: size.width * 0.033,
                                fontWeight: FontWeight.w700)),
                      ]),
                )),
                SizedBox(height: size.height * 0.012),
                Container(
                  padding: EdgeInsets.all(size.width * 0.035),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEFEF),
                    borderRadius: BorderRadius.circular(size.width * 0.03),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dealer',
                                  style: TextStyle(
                                      color: const Color(0xFFBFC9D1),
                                      fontSize: size.width * 0.026)),
                              Text(record['dealer'] as String,
                                  style: TextStyle(
                                      color: const Color(0xFF25343F),
                                      fontSize: size.width * 0.032,
                                      fontWeight: FontWeight.w700)),
                            ]),
                        Column(crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Shop ID',
                                  style: TextStyle(
                                      color: const Color(0xFFBFC9D1),
                                      fontSize: size.width * 0.026)),
                              Text(record['shopId'] as String,
                                  style: TextStyle(
                                      color: const Color(0xFF25343F),
                                      fontSize: size.width * 0.032,
                                      fontWeight: FontWeight.w700)),
                            ]),
                      ]),
                ),
                SizedBox(height: size.height * 0.012),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.014),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25343F),
                      borderRadius: BorderRadius.circular(size.width * 0.03),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.qr_code_rounded,
                          color: const Color(0xFFFF9B51), size: size.width * 0.045),
                      SizedBox(width: size.width * 0.02),
                      Text('View Digital Receipt',
                          style: TextStyle(
                              color: const Color(0xFFEAEFEF),
                              fontSize: size.width * 0.033,
                              fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
              ]),
              crossFadeState:
                  isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ]),
        ),
      ),
    );
  }
}
