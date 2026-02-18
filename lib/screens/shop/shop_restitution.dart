import 'package:flutter/material.dart';

class ShopRestitutionPage extends StatefulWidget {
  final bool isEmbedded;
  const ShopRestitutionPage({super.key, this.isEmbedded = false});
  @override
  State<ShopRestitutionPage> createState() => _ShopRestitutionPageState();
}

class _ShopRestitutionPageState extends State<ShopRestitutionPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnim;
  late AnimationController _pulseAnim;
  int _filterIndex = 0;

  final List<Map<String, dynamic>> _cases = [
    {
      'id': 'RC-0099',
      'name': 'Lakshmi D',
      'card': 'RC-TN-2024-00099',
      'missedMonth': 'October 2024',
      'compensation': [
        {'item': 'Rice', 'qty': 5, 'unit': 'kg', 'icon': '🌾', 'color': Color(0xFF1B8A5A)},
        {'item': 'Sugar', 'qty': 1, 'unit': 'kg', 'icon': '🍬', 'color': Color(0xFFEF5350)},
      ],
      'status': 'pending',
      'daysRemaining': 3,
    },
    {
      'id': 'RC-0102',
      'name': 'Murugan K',
      'card': 'RC-TN-2024-00102',
      'missedMonth': 'September 2024',
      'compensation': [
        {'item': 'Rice', 'qty': 5, 'unit': 'kg', 'icon': '🌾', 'color': Color(0xFF1B8A5A)},
        {'item': 'Dal', 'qty': 2, 'unit': 'kg', 'icon': '🫘', 'color': Color(0xFFBFC9D1)},
      ],
      'status': 'overdue',
      'daysRemaining': -1,
    },
    {
      'id': 'RC-0115',
      'name': 'Priya R',
      'card': 'RC-TN-2024-00115',
      'missedMonth': 'October 2024',
      'compensation': [
        {'item': 'Rice', 'qty': 5, 'unit': 'kg', 'icon': '🌾', 'color': Color(0xFF1B8A5A)},
        {'item': 'Wheat', 'qty': 3, 'unit': 'kg', 'icon': '🌿', 'color': Color(0xFFD4891A)},
        {'item': 'Oil', 'qty': 1, 'unit': 'L', 'icon': '🫙', 'color': Color(0xFFFF9B51)},
      ],
      'status': 'pending',
      'daysRemaining': 7,
    },
    {
      'id': 'RC-0088',
      'name': 'Selvam T',
      'card': 'RC-TN-2024-00088',
      'missedMonth': 'August 2024',
      'compensation': [
        {'item': 'Rice', 'qty': 5, 'unit': 'kg', 'icon': '🌾', 'color': Color(0xFF1B8A5A)},
      ],
      'status': 'resolved',
      'daysRemaining': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
    _pulseAnim = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeAnim.dispose();
    _pulseAnim.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    switch (_filterIndex) {
      case 1: return _cases.where((c) => c['status'] == 'pending').toList();
      case 2: return _cases.where((c) => c['status'] == 'overdue').toList();
      case 3: return _cases.where((c) => c['status'] == 'resolved').toList();
      default: return _cases;
    }
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
            _buildSummaryStrip(size),
            _buildFilterRow(size),
            Expanded(child: _buildCaseList(size)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(Size size, EdgeInsets pad) {
    final overdue = _cases.where((c) => c['status'] == 'overdue').length;
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
      child: Row(children: [
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
          Text('Restitution Cases',
              style: TextStyle(
                  color: const Color(0xFFEAEFEF),
                  fontSize: size.width * 0.046,
                  fontWeight: FontWeight.w800)),
          Text('Mandatory compensation distribution',
              style: TextStyle(
                  color: const Color(0xFFBFC9D1), fontSize: size.width * 0.029)),
        ])),
        if (overdue > 0)
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, child) => Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03, vertical: size.height * 0.01),
              decoration: BoxDecoration(
                color: Color.lerp(const Color(0xFFEF5350).withOpacity(0.2),
                    const Color(0xFFEF5350).withOpacity(0.45), _pulseAnim.value),
                borderRadius: BorderRadius.circular(size.width * 0.025),
                border: Border.all(color: const Color(0xFFEF5350).withOpacity(0.5)),
              ),
              child: Row(children: [
                Icon(Icons.priority_high_rounded,
                    color: const Color(0xFFEF5350), size: size.width * 0.038),
                SizedBox(width: size.width * 0.01),
                Text('$overdue Overdue',
                    style: TextStyle(
                        color: const Color(0xFFEF5350),
                        fontSize: size.width * 0.028,
                        fontWeight: FontWeight.w800)),
              ]),
            ),
          ),
      ]),
    );
  }

  Widget _buildSummaryStrip(Size size) {
    final pending = _cases.where((c) => c['status'] == 'pending').length;
    final overdue = _cases.where((c) => c['status'] == 'overdue').length;
    final resolved = _cases.where((c) => c['status'] == 'resolved').length;

    return Container(
      margin: EdgeInsets.fromLTRB(
          size.width * 0.055, size.height * 0.018, size.width * 0.055, 0),
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.016, horizontal: size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _summaryChip('Total', '${_cases.length}', const Color(0xFF25343F), size),
        _vDiv(size),
        _summaryChip('Pending', '$pending', const Color(0xFFFF9B51), size),
        _vDiv(size),
        _summaryChip('Overdue', '$overdue', const Color(0xFFEF5350), size),
        _vDiv(size),
        _summaryChip('Resolved', '$resolved', const Color(0xFF1B8A5A), size),
      ]),
    );
  }

  Widget _vDiv(Size size) => Container(
        width: 1, height: size.height * 0.045, color: const Color(0xFFEAEFEF));

  Widget _summaryChip(String label, String value, Color color, Size size) => Column(children: [
    Text(value,
        style: TextStyle(
            color: color, fontSize: size.width * 0.045, fontWeight: FontWeight.w900)),
    Text(label,
        style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: size.width * 0.026)),
  ]);

  Widget _buildFilterRow(Size size) {
    final filters = ['All', 'Pending', 'Overdue', 'Resolved'];
    return Padding(
      padding: EdgeInsets.fromLTRB(
          size.width * 0.055, size.height * 0.015, size.width * 0.055, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: filters.asMap().entries.map((e) {
            final sel = e.key == _filterIndex;
            return GestureDetector(
              onTap: () => setState(() => _filterIndex = e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: size.width * 0.025),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04, vertical: size.height * 0.01),
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFF25343F) : Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.03),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
                ),
                child: Text(e.value,
                    style: TextStyle(
                        color: sel ? Colors.white : const Color(0xFFBFC9D1),
                        fontSize: size.width * 0.031,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCaseList(Size size) {
    final cases = _filtered;
    if (cases.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.check_circle_rounded,
              color: const Color(0xFF1B8A5A), size: size.width * 0.18),
          SizedBox(height: size.height * 0.02),
          Text('No cases in this category',
              style: TextStyle(color: const Color(0xFFBFC9D1), fontSize: size.width * 0.038)),
        ]),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
          size.width * 0.055, size.height * 0.018, size.width * 0.055, size.height * 0.025),
      itemCount: cases.length,
      itemBuilder: (_, i) => _buildCaseCard(cases[i], i, size),
    );
  }

  Widget _buildCaseCard(Map<String, dynamic> c, int i, Size size) {
    final status = c['status'] as String;
    final isPending = status == 'pending';
    final isOverdue = status == 'overdue';
    final isResolved = status == 'resolved';
    final days = c['daysRemaining'] as int;

    final statusColor = isOverdue
        ? const Color(0xFFEF5350)
        : isPending
            ? const Color(0xFFFF9B51)
            : const Color(0xFF1B8A5A);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + i * 80),
      builder: (_, v, child) =>
          Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 20 * (1 - v)), child: child)),
      child: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.016),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.05),
          border: Border.all(
            color: isOverdue
                ? const Color(0xFFEF5350).withOpacity(0.4)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, size.height * 0.005),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(size.width * 0.045),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: size.width * 0.11,
                    height: size.width * 0.11,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (c['name'] as String).substring(0, 2).toUpperCase(),
                        style: TextStyle(
                            color: statusColor,
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c['name'] as String,
                          style: TextStyle(
                              color: const Color(0xFF25343F),
                              fontSize: size.width * 0.038,
                              fontWeight: FontWeight.w800)),
                      Text('${c['card']} • Missed: ${c['missedMonth']}',
                          style: TextStyle(
                              color: const Color(0xFFBFC9D1), fontSize: size.width * 0.026)),
                    ]),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.025, vertical: size.height * 0.006),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                          color: statusColor,
                          fontSize: size.width * 0.024,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5),
                    ),
                  ),
                ]),
                SizedBox(height: size.height * 0.015),
                // Compensation items
                Text('Compensation Due:',
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
                SizedBox(height: size.height * 0.008),
                Wrap(
                  spacing: size.width * 0.02,
                  runSpacing: size.height * 0.008,
                  children: (c['compensation'] as List).map((item) => Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.025, vertical: size.height * 0.006),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                      border: Border.all(color: (item['color'] as Color).withOpacity(0.2)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(item['icon'] as String, style: TextStyle(fontSize: size.width * 0.03)),
                      SizedBox(width: size.width * 0.015),
                      Text('${item['qty']} ${item['unit']}',
                          style: TextStyle(
                              color: item['color'] as Color,
                              fontSize: size.width * 0.03,
                              fontWeight: FontWeight.w700)),
                    ]),
                  )).toList(),
                ),
                if (!isResolved) ...[
                  SizedBox(height: size.height * 0.012),
                  Row(children: [
                    Icon(
                      isOverdue ? Icons.timer_off_rounded : Icons.timer_rounded,
                      color: statusColor,
                      size: size.width * 0.038,
                    ),
                    SizedBox(width: size.width * 0.015),
                    Text(
                      isOverdue
                          ? 'OVERDUE — Escalated to District'
                          : '$days days remaining to distribute',
                      style: TextStyle(
                          color: statusColor,
                          fontSize: size.width * 0.029,
                          fontWeight: FontWeight.w600),
                    ),
                  ]),
                ],
              ]),
            ),
            if (!isResolved)
              Container(
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.05),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(size.width * 0.05)),
                ),
                child: Row(children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.visibility_rounded,
                          color: const Color(0xFFBFC9D1), size: size.width * 0.04),
                      label: Text('View Details',
                          style: TextStyle(
                              color: const Color(0xFFBFC9D1), fontSize: size.width * 0.03)),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.014)),
                    ),
                  ),
                  Container(
                      width: 1,
                      height: size.height * 0.04,
                      color: const Color(0xFFEAEFEF)),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => setState(() {
                        c['status'] = 'resolved';
                      }),
                      icon: Icon(Icons.check_rounded,
                          color: statusColor, size: size.width * 0.04),
                      label: Text('Mark Resolved',
                          style: TextStyle(
                              color: statusColor,
                              fontSize: size.width * 0.03,
                              fontWeight: FontWeight.w700)),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.014)),
                    ),
                  ),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
