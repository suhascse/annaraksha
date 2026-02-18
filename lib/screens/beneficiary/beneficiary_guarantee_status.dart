import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BeneficiaryGuaranteeStatusPage extends StatefulWidget {
  const BeneficiaryGuaranteeStatusPage({super.key});
  @override
  State<BeneficiaryGuaranteeStatusPage> createState() =>
      _BeneficiaryGuaranteeStatusPageState();
}

class _BeneficiaryGuaranteeStatusPageState
    extends State<BeneficiaryGuaranteeStatusPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnim;
  late AnimationController _pulseAnim;

  final List<Map<String, dynamic>> _cycles = [
    {
      'month': 'January 2026',
      'short': 'JAN',
      'status': 'partial',
      'collected': ['Rice 6kg', 'Dal 2kg', 'Sugar 0.5kg'],
      'missed': ['Wheat 8kg', 'Oil 1L'],
      'compensation': '₹85',
      'compensationStatus': 'pending',
    },
    {
      'month': 'December 2025',
      'short': 'DEC',
      'status': 'complete',
      'collected': ['Rice 10kg', 'Wheat 8kg', 'Sugar 2kg', 'Dal 3kg', 'Oil 1L'],
      'missed': [],
      'compensation': null,
      'compensationStatus': null,
    },
    {
      'month': 'November 2025',
      'short': 'NOV',
      'status': 'restitution',
      'collected': ['Rice 10kg', 'Wheat 8kg'],
      'missed': ['Sugar 2kg', 'Dal 3kg', 'Oil 1L'],
      'compensation': '₹120',
      'compensationStatus': 'credited',
    },
    {
      'month': 'October 2025',
      'short': 'OCT',
      'status': 'complete',
      'collected': ['Rice 10kg', 'Wheat 8kg', 'Sugar 2kg', 'Dal 3kg', 'Oil 1L'],
      'missed': [],
      'compensation': null,
      'compensationStatus': null,
    },
    {
      'month': 'September 2025',
      'short': 'SEP',
      'status': 'complete',
      'collected': ['Rice 10kg', 'Wheat 8kg', 'Sugar 2kg', 'Dal 3kg', 'Oil 1L'],
      'missed': [],
      'compensation': null,
      'compensationStatus': null,
    },
  ];

  int _selectedCycle = 0;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _pulseAnim =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _pulseAnim.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'complete': return const Color(0xFF4CAF50);
      case 'partial': return const Color(0xFFFF9B51);
      case 'restitution': return const Color(0xFFEF5350);
      default: return const Color(0xFFBFC9D1);
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'complete': return Icons.check_circle_rounded;
      case 'partial': return Icons.pending_rounded;
      case 'restitution': return Icons.gavel_rounded;
      default: return Icons.circle_outlined;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'complete': return 'Complete';
      case 'partial': return 'Partial';
      case 'restitution': return 'Restitution';
      default: return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pad = MediaQuery.of(context).padding;
    final cycle = _cycles[_selectedCycle];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFEAEFEF),
        body: Column(children: [
          _buildHeader(size, pad),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.055),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.025),
                  _buildGuaranteeBadge(size),
                  SizedBox(height: size.height * 0.025),
                  _buildCycleTimeline(size),
                  SizedBox(height: size.height * 0.025),
                  _buildCycleDetail(cycle, size),
                  SizedBox(height: size.height * 0.025),
                  if (cycle['compensation'] != null) _buildCompensationCard(cycle, size),
                  if (cycle['compensation'] != null) SizedBox(height: size.height * 0.025),
                  _buildEscalationButton(size),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildHeader(Size size, EdgeInsets pad) {
    return AnimatedBuilder(
      animation: _headerAnim,
      builder: (_, child) =>
          Opacity(opacity: _headerAnim.value.clamp(0.0, 1.0), child: child),
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
                color: const Color(0xFF25343F).withOpacity(0.45),
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
                  borderRadius: BorderRadius.circular(size.width * 0.025)),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: const Color(0xFFEAEFEF), size: size.width * 0.045),
            ),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Guarantee Status',
                  style: TextStyle(
                      color: const Color(0xFFEAEFEF),
                      fontSize: size.width * 0.048,
                      fontWeight: FontWeight.w900)),
              Text('Ration guarantee & compensation tracking',
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.029)),
            ]),
          ),
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Container(
              padding: EdgeInsets.all(size.width * 0.028),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50)
                    .withOpacity(0.1 + 0.08 * _pulseAnim.value),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.verified_user_rounded,
                  color: const Color(0xFF4CAF50), size: size.width * 0.055),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildGuaranteeBadge(Size size) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
          opacity: v,
          child: Transform.translate(offset: Offset(0, 20 * (1 - v)), child: child)),
      child: Container(
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          color: const Color(0xFF25343F),
          borderRadius: BorderRadius.circular(size.width * 0.055),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF25343F).withOpacity(0.3),
                blurRadius: size.width * 0.06,
                offset: Offset(0, size.height * 0.01))
          ],
        ),
        child: Row(children: [
          Container(
            width: size.width * 0.15,
            height: size.width * 0.15,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.35),
                    blurRadius: size.width * 0.05)
              ],
            ),
            child: Icon(Icons.verified_rounded,
                color: Colors.white, size: size.width * 0.07),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Guarantee Active',
                  style: TextStyle(
                      color: const Color(0xFF4CAF50),
                      fontSize: size.width * 0.038,
                      fontWeight: FontWeight.w900)),
              SizedBox(height: size.height * 0.005),
              Text('Your ration rights are protected under PDS guarantee scheme.',
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
              SizedBox(height: size.height * 0.01),
              Row(children: [
                _statChip('4/5 Months', const Color(0xFF4CAF50), size),
                SizedBox(width: size.width * 0.02),
                _statChip('₹205 Comp.', const Color(0xFFFF9B51), size),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _statChip(String label, Color color, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.025, vertical: size.height * 0.005),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(size.width * 0.025),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: size.width * 0.026,
              fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildCycleTimeline(Size size) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Cycle History',
          style: TextStyle(
              color: const Color(0xFF25343F),
              fontSize: size.width * 0.042,
              fontWeight: FontWeight.w900)),
      SizedBox(height: size.height * 0.015),
      SizedBox(
        height: size.height * 0.11,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: _cycles.length,
          itemBuilder: (_, i) {
            final c = _cycles[i];
            final sel = i == _selectedCycle;
            final color = _statusColor(c['status'] as String);
            return GestureDetector(
              onTap: () => setState(() => _selectedCycle = i),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 400 + i * 80),
                builder: (_, v, child) =>
                    Opacity(opacity: v, child: child),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: size.width * 0.03),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.045,
                      vertical: size.height * 0.012),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFF25343F) : Colors.white,
                    borderRadius: BorderRadius.circular(size.width * 0.045),
                    border: sel
                        ? Border.all(color: color.withOpacity(0.5), width: 2)
                        : Border.all(color: Colors.transparent),
                    boxShadow: sel
                        ? [
                            BoxShadow(
                                color: const Color(0xFF25343F).withOpacity(0.3),
                                blurRadius: size.width * 0.05,
                                offset: Offset(0, size.height * 0.008))
                          ]
                        : [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: size.width * 0.02)
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_statusIcon(c['status'] as String),
                          color: color, size: size.width * 0.055),
                      SizedBox(height: size.height * 0.006),
                      Text(c['short'] as String,
                          style: TextStyle(
                              color: sel
                                  ? const Color(0xFFEAEFEF)
                                  : const Color(0xFF25343F),
                              fontSize: size.width * 0.032,
                              fontWeight: FontWeight.w800)),
                      Text(_statusLabel(c['status'] as String),
                          style: TextStyle(
                              color: color,
                              fontSize: size.width * 0.022,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildCycleDetail(Map<String, dynamic> cycle, Size size) {
    final collected = cycle['collected'] as List;
    final missed = cycle['missed'] as List;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(cycle['month']),
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.055),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: size.width * 0.05,
                offset: Offset(0, size.height * 0.008))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(cycle['month'] as String,
                style: TextStyle(
                    color: const Color(0xFF25343F),
                    fontSize: size.width * 0.042,
                    fontWeight: FontWeight.w900)),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03, vertical: size.height * 0.006),
              decoration: BoxDecoration(
                color: _statusColor(cycle['status'] as String).withOpacity(0.1),
                borderRadius: BorderRadius.circular(size.width * 0.025),
              ),
              child: Row(children: [
                Icon(_statusIcon(cycle['status'] as String),
                    color: _statusColor(cycle['status'] as String),
                    size: size.width * 0.035),
                SizedBox(width: size.width * 0.015),
                Text(_statusLabel(cycle['status'] as String),
                    style: TextStyle(
                        color: _statusColor(cycle['status'] as String),
                        fontSize: size.width * 0.028,
                        fontWeight: FontWeight.w800)),
              ]),
            ),
          ]),
          SizedBox(height: size.height * 0.018),
          if (collected.isNotEmpty) ...[
            Text('✅  Collected',
                style: TextStyle(
                    color: const Color(0xFF4CAF50),
                    fontSize: size.width * 0.032,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: size.height * 0.008),
            Wrap(
              spacing: size.width * 0.02,
              runSpacing: size.height * 0.008,
              children: collected
                  .map((c) => _chip(c as String, const Color(0xFF4CAF50), size))
                  .toList(),
            ),
          ],
          if (missed.isNotEmpty) ...[
            SizedBox(height: size.height * 0.015),
            Text('❌  Missed',
                style: TextStyle(
                    color: const Color(0xFFEF5350),
                    fontSize: size.width * 0.032,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: size.height * 0.008),
            Wrap(
              spacing: size.width * 0.02,
              runSpacing: size.height * 0.008,
              children: missed
                  .map((m) => _chip(m as String, const Color(0xFFEF5350), size))
                  .toList(),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _chip(String label, Color color, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03, vertical: size.height * 0.006),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(size.width * 0.025),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: size.width * 0.028,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildCompensationCard(Map<String, dynamic> cycle, Size size) {
    final isPending = cycle['compensationStatus'] == 'pending';
    final color =
        isPending ? const Color(0xFFFF9B51) : const Color(0xFF4CAF50);
    final statusLabel = isPending ? 'Pending Credit' : 'Credited ✓';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (_, v, child) =>
          Opacity(opacity: v, child: Transform.scale(scale: v, child: child)),
      child: Container(
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.12), color.withOpacity(0.04)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(size.width * 0.055),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(children: [
          Container(
            width: size.width * 0.14,
            height: size.width * 0.14,
            decoration: BoxDecoration(
                color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(Icons.account_balance_wallet_rounded,
                color: color, size: size.width * 0.065),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Compensation',
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
              Text(cycle['compensation'] as String,
                  style: TextStyle(
                      color: const Color(0xFF25343F),
                      fontSize: size.width * 0.052,
                      fontWeight: FontWeight.w900)),
              Text(statusLabel,
                  style: TextStyle(
                      color: color,
                      fontSize: size.width * 0.028,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
          if (isPending)
            Container(
              padding: EdgeInsets.all(size.width * 0.025),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(Icons.access_time_rounded,
                  color: color, size: size.width * 0.045),
            ),
        ]),
      ),
    );
  }

  Widget _buildEscalationButton(Size size) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.018),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.045),
          border: Border.all(color: const Color(0xFFEF5350).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: size.width * 0.03)
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.escalator_warning_rounded,
              color: const Color(0xFFEF5350), size: size.width * 0.05),
          SizedBox(width: size.width * 0.025),
          Text('Request Escalation to District',
              style: TextStyle(
                  color: const Color(0xFFEF5350),
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}
