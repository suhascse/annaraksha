import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'beneficiary_distribution_history.dart';
import 'beneficiary_guarantee_status.dart';
import 'beneficiary_raise_complaint.dart';
import 'beneficiary_flash_audit.dart';
import 'beneficiary_multilingual.dart';

class BeneficiaryHomePage extends StatefulWidget {
  const BeneficiaryHomePage({super.key});
  @override
  State<BeneficiaryHomePage> createState() => _BeneficiaryHomePageState();
}

class _BeneficiaryHomePageState extends State<BeneficiaryHomePage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnim;
  late AnimationController _pulseAnim;
  late AnimationController _floatAnim;
  late AnimationController _cardAnim;

  final String _selectedLang = 'EN';
  bool _auditBannerDismissed = false;

  final List<Map<String, dynamic>> _allocation = [
    {'item': 'Rice', 'icon': '🌾', 'total': 10.0, 'used': 6.0, 'unit': 'kg', 'color': const Color(0xFF1B8A5A)},
    {'item': 'Wheat', 'icon': '🌿', 'total': 8.0, 'used': 8.0, 'unit': 'kg', 'color': const Color(0xFFD4891A)},
    {'item': 'Sugar', 'icon': '🍬', 'total': 2.0, 'used': 0.5, 'unit': 'kg', 'color': const Color(0xFFEF5350)},
    {'item': 'Dal', 'icon': '🫘', 'total': 3.0, 'used': 2.0, 'unit': 'kg', 'color': const Color(0xFF7B5EA7)},
    {'item': 'Oil', 'icon': '🫙', 'total': 1.0, 'used': 1.0, 'unit': 'L', 'color': const Color(0xFFFF9B51)},
  ];

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..forward();
    _pulseAnim = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _floatAnim = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _cardAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..forward();
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _pulseAnim.dispose();
    _floatAnim.dispose();
    _cardAnim.dispose();
    super.dispose();
  }

  void _navigate(Widget page) {
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (_, a, __) => page,
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pad = MediaQuery.of(context).padding;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFEAEFEF),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(size, pad)),
            if (!_auditBannerDismissed)
              SliverToBoxAdapter(child: _buildAuditBanner(size)),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                size.width * 0.055,
                size.height * 0.025,
                size.width * 0.055,
                size.height * 0.015,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildNextPickupCard(size),
                  SizedBox(height: size.height * 0.025),
                  _buildSectionLabel('Monthly Quota', size),
                  SizedBox(height: size.height * 0.015),
                  _buildQuotaCards(size),
                  SizedBox(height: size.height * 0.025),
                  _buildSectionLabel('Quick Actions', size),
                  SizedBox(height: size.height * 0.015),
                  _buildActionGrid(size),
                  SizedBox(height: size.height * 0.025),
                  _buildSectionLabel('Shop Stock Availability', size),
                  SizedBox(height: size.height * 0.015),
                  _buildShopStockCard(size),
                  SizedBox(height: size.height * 0.025),
                  _buildSectionLabel('Recent Activity', size),
                  SizedBox(height: size.height * 0.015),
                  _buildRecentActivity(size),
                  SizedBox(height: size.height * 0.03),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Size size, EdgeInsets pad) {
    return AnimatedBuilder(
      animation: _headerAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -40 * (1 - _headerAnim.value)),
        child: Opacity(opacity: _headerAnim.value.clamp(0.0, 1.0), child: child),
      ),
      child: Container(
        width: size.width,
        padding: EdgeInsets.only(
          top: pad.top + size.height * 0.02,
          left: size.width * 0.055,
          right: size.width * 0.055,
          bottom: size.height * 0.03,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF25343F),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(size.width * 0.08)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF25343F).withOpacity(0.55),
              blurRadius: size.width * 0.1,
              offset: Offset(0, size.height * 0.018),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative floating circles
            Positioned(
              right: -size.width * 0.05,
              top: -size.height * 0.01,
              child: AnimatedBuilder(
                animation: _floatAnim,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, 8 * _floatAnim.value),
                  child: Container(
                    width: size.width * 0.35,
                    height: size.width * 0.35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF9B51).withOpacity(0.06),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: size.width * 0.04,
              top: size.height * 0.02,
              child: AnimatedBuilder(
                animation: _floatAnim,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, -6 * _floatAnim.value),
                  child: Container(
                    width: size.width * 0.18,
                    height: size.width * 0.18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF9B51).withOpacity(0.09),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildAvatar(size),
                    SizedBox(width: size.width * 0.035),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BENEFICIARY',
                              style: TextStyle(
                                  color: const Color(0xFFFF9B51),
                                  fontSize: size.width * 0.028,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.8)),
                          SizedBox(height: size.height * 0.004),
                          Text('Anitha Kumari',
                              style: TextStyle(
                                  color: const Color(0xFFEAEFEF),
                                  fontSize: size.width * 0.048,
                                  fontWeight: FontWeight.w900)),
                          Text('RC-0042 • Ward 7, Anna Nagar',
                              style: TextStyle(
                                  color: const Color(0xFFBFC9D1),
                                  fontSize: size.width * 0.029)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _navigate(const BeneficiaryMultilingualPage()),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.025,
                            vertical: size.height * 0.008),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(size.width * 0.03),
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                        ),
                        child: Text('🌐 EN',
                            style: TextStyle(
                                color: const Color(0xFFEAEFEF),
                                fontSize: size.width * 0.03,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.022),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(size.width * 0.025),
                        ),
                        child: Icon(Icons.logout_rounded,
                            color: const Color(0xFFBFC9D1), size: size.width * 0.045),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.022),
                _buildHeaderStats(size),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Size size) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) => Container(
        width: size.width * 0.14,
        height: size.width * 0.14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9B51), Color(0xFFFF6B35)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF9B51).withOpacity(0.3 + 0.2 * _pulseAnim.value),
              blurRadius: size.width * 0.07,
              spreadRadius: size.width * 0.005 * _pulseAnim.value,
            ),
          ],
        ),
        child: Center(
          child: Text('AK',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }

  Widget _buildHeaderStats(Size size) {
    final stats = [
      {'label': 'Family Size', 'value': '4', 'icon': Icons.people_rounded, 'color': const Color(0xFF4CAF50)},
      {'label': 'Card Type', 'value': 'PHH', 'icon': Icons.credit_card_rounded, 'color': const Color(0xFFFF9B51)},
      {'label': 'Compensation', 'value': '₹120', 'icon': Icons.account_balance_wallet_rounded, 'color': const Color(0xFFBFC9D1)},
      {'label': 'Trust', 'value': '98%', 'icon': Icons.verified_rounded, 'color': const Color(0xFF4CAF50)},
    ];
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.height * 0.016),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(size.width * 0.045),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.asMap().entries.map((e) {
          final s = e.value;
          final isLast = e.key == stats.length - 1;
          return Row(children: [
            Column(children: [
              Icon(s['icon'] as IconData,
                  color: s['color'] as Color, size: size.width * 0.046),
              SizedBox(height: size.height * 0.004),
              Text(s['value'] as String,
                  style: TextStyle(
                      color: s['color'] as Color,
                      fontSize: size.width * 0.036,
                      fontWeight: FontWeight.w900)),
              Text(s['label'] as String,
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1),
                      fontSize: size.width * 0.022)),
            ]),
            if (!isLast) ...[
              SizedBox(width: size.width * 0.035),
              Container(width: 1, height: size.height * 0.05, color: Colors.white.withOpacity(0.12)),
              SizedBox(width: size.width * 0.035),
            ],
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildAuditBanner(Size size) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
          opacity: v,
          child: Transform.translate(offset: Offset(0, 20 * (1 - v)), child: child)),
      child: GestureDetector(
        onTap: () => _navigate(const BeneficiaryFlashAuditPage()),
        child: Container(
          margin: EdgeInsets.fromLTRB(
              size.width * 0.055, size.height * 0.02, size.width * 0.055, 0),
          padding: EdgeInsets.all(size.width * 0.045),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9B51), Color(0xFFFF6B35)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size.width * 0.05),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFFFF9B51).withOpacity(0.4),
                  blurRadius: size.width * 0.06,
                  offset: Offset(0, size.height * 0.01))
            ],
          ),
          child: Row(children: [
            Container(
              padding: EdgeInsets.all(size.width * 0.025),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.how_to_vote_rounded,
                  color: Colors.white, size: size.width * 0.06),
            ),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🔔 Flash Audit Selected!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.038,
                        fontWeight: FontWeight.w900)),
                Text('You have been randomly selected. Tap to respond.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: size.width * 0.028)),
              ]),
            ),
            GestureDetector(
              onTap: () => setState(() => _auditBannerDismissed = true),
              child: Icon(Icons.close_rounded,
                  color: Colors.white.withOpacity(0.7), size: size.width * 0.045),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildNextPickupCard(Size size) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) => Container(
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF25343F), Color(0xFF1A2E3D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(size.width * 0.06),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF25343F)
                  .withOpacity(0.3 + 0.1 * _pulseAnim.value),
              blurRadius: size.width * 0.07,
              offset: Offset(0, size.height * 0.012),
            ),
          ],
        ),
        child: child,
      ),
      child: Row(children: [
        Container(
          width: size.width * 0.16,
          height: size.width * 0.16,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9B51).withOpacity(0.15),
            borderRadius: BorderRadius.circular(size.width * 0.045),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('28',
                style: TextStyle(
                    color: const Color(0xFFFF9B51),
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.w900)),
            Text('FEB',
                style: TextStyle(
                    color: const Color(0xFFBFC9D1),
                    fontSize: size.width * 0.022,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1)),
          ]),
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Next Pickup',
                style: TextStyle(
                    color: const Color(0xFFBFC9D1),
                    fontSize: size.width * 0.028,
                    letterSpacing: 0.8)),
            SizedBox(height: size.height * 0.004),
            Text('9 days remaining',
                style: TextStyle(
                    color: const Color(0xFFEAEFEF),
                    fontSize: size.width * 0.042,
                    fontWeight: FontWeight.w900)),
            SizedBox(height: size.height * 0.006),
            Text('Shop: RS-2024-0341 • Anna Nagar',
                style: TextStyle(
                    color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
            SizedBox(height: size.height * 0.008),
            Row(children: [
              Container(
                width: size.width * 0.018,
                height: size.width * 0.018,
                decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
              ),
              SizedBox(width: size.width * 0.018),
              Text('Stock Available',
                  style: TextStyle(
                      color: const Color(0xFF4CAF50),
                      fontSize: size.width * 0.028,
                      fontWeight: FontWeight.w600)),
            ]),
          ]),
        ),
        Icon(Icons.arrow_forward_ios_rounded,
            color: const Color(0xFFBFC9D1), size: size.width * 0.04),
      ]),
    );
  }

  Widget _buildSectionLabel(String text, Size size) {
    return Row(children: [
      Container(
        width: size.width * 0.01,
        height: size.height * 0.024,
        decoration: BoxDecoration(
          color: const Color(0xFFFF9B51),
          borderRadius: BorderRadius.circular(size.width * 0.005),
        ),
      ),
      SizedBox(width: size.width * 0.03),
      Text(text,
          style: TextStyle(
              color: const Color(0xFF25343F),
              fontSize: size.width * 0.046,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3)),
    ]);
  }

  Widget _buildQuotaCards(Size size) {
    return SizedBox(
      height: size.height * 0.175,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _allocation.length,
        itemBuilder: (_, i) {
          final item = _allocation[i];
          final ratio = (item['used'] as double) / (item['total'] as double);
          final isCompleted = ratio >= 1.0;
          final color = isCompleted ? const Color(0xFF4CAF50) : item['color'] as Color;

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 500 + i * 100),
            curve: Curves.easeOutCubic,
            builder: (_, v, child) => Opacity(
                opacity: v,
                child: Transform.translate(offset: Offset(0, 25 * (1 - v)), child: child)),
            child: Container(
              width: size.width * 0.36,
              margin: EdgeInsets.only(right: size.width * 0.03),
              padding: EdgeInsets.all(size.width * 0.042),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.055),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.13),
                    blurRadius: size.width * 0.045,
                    offset: Offset(0, size.height * 0.007),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(item['icon'] as String,
                        style: TextStyle(fontSize: size.width * 0.055)),
                    if (isCompleted)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.018,
                            vertical: size.height * 0.003),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(size.width * 0.02),
                        ),
                        child: Text('DONE',
                            style: TextStyle(
                                color: const Color(0xFF4CAF50),
                                fontSize: size.width * 0.022,
                                fontWeight: FontWeight.w800)),
                      ),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item['item'] as String,
                        style: TextStyle(
                            color: const Color(0xFF25343F),
                            fontSize: size.width * 0.036,
                            fontWeight: FontWeight.w800)),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: '${(item['used'] as double).toStringAsFixed(1)}',
                              style: TextStyle(
                                  color: color,
                                  fontSize: size.width * 0.032,
                                  fontWeight: FontWeight.w800)),
                          TextSpan(
                              text: ' / ${(item['total'] as double).toStringAsFixed(1)} ${item['unit']}',
                              style: TextStyle(
                                  color: const Color(0xFFBFC9D1),
                                  fontSize: size.width * 0.026)),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.007),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.01),
                      child: LinearProgressIndicator(
                        value: ratio.clamp(0.0, 1.0),
                        backgroundColor: color.withOpacity(0.12),
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: size.height * 0.007,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionGrid(Size size) {
    final actions = [
      {
        'label': 'Distribution\nHistory',
        'icon': Icons.receipt_long_rounded,
        'color': const Color(0xFF1B8A5A),
        'bg': const Color(0xFFE8F5E9),
        'page': const BeneficiaryDistributionHistoryPage(),
      },
      {
        'label': 'Guarantee\nStatus',
        'icon': Icons.verified_user_rounded,
        'color': const Color(0xFF2E6DA4),
        'bg': const Color(0xFFE3F2FD),
        'page': const BeneficiaryGuaranteeStatusPage(),
      },
      {
        'label': 'Raise\nComplaint',
        'icon': Icons.report_problem_rounded,
        'color': const Color(0xFFEF5350),
        'bg': const Color(0xFFFFEBEE),
        'page': const BeneficiaryRaiseComplaintPage(),
      },
      {
        'label': 'Flash\nAudit',
        'icon': Icons.how_to_vote_rounded,
        'color': const Color(0xFFFF9B51),
        'bg': const Color(0xFFFFF3E0),
        'page': const BeneficiaryFlashAuditPage(),
      },
      {
        'label': 'Language\nSettings',
        'icon': Icons.language_rounded,
        'color': const Color(0xFF7B5EA7),
        'bg': const Color(0xFFF3E5F5),
        'page': const BeneficiaryMultilingualPage(),
      },
      {
        'label': 'Digital\nReceipts',
        'icon': Icons.qr_code_rounded,
        'color': const Color(0xFFD4891A),
        'bg': const Color(0xFFFFF8E1),
        'page': const BeneficiaryDistributionHistoryPage(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: size.height * 0.015,
        crossAxisSpacing: size.width * 0.03,
        childAspectRatio: 0.9,
      ),
      itemCount: actions.length,
      itemBuilder: (_, i) {
        final a = actions[i];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 600 + i * 80),
          curve: Curves.elasticOut,
          builder: (_, v, child) => Transform.scale(scale: v, child: child),
          child: GestureDetector(
            onTap: () => _navigate(a['page'] as Widget),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.05),
                boxShadow: [
                  BoxShadow(
                    color: (a['color'] as Color).withOpacity(0.15),
                    blurRadius: size.width * 0.04,
                    offset: Offset(0, size.height * 0.006),
                  ),
                ],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: size.width * 0.12,
                  height: size.width * 0.12,
                  decoration: BoxDecoration(
                      color: a['bg'] as Color, shape: BoxShape.circle),
                  child: Icon(a['icon'] as IconData,
                      color: a['color'] as Color, size: size.width * 0.058),
                ),
                SizedBox(height: size.height * 0.01),
                Text(a['label'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color(0xFF25343F),
                        fontSize: size.width * 0.027,
                        fontWeight: FontWeight.w700,
                        height: 1.3)),
              ]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShopStockCard(Size size) {
    final stock = [
      {'item': 'Rice', 'available': true, 'qty': '320 kg'},
      {'item': 'Wheat', 'available': true, 'qty': '180 kg'},
      {'item': 'Sugar', 'available': false, 'qty': 'Out of stock'},
      {'item': 'Dal', 'available': true, 'qty': '92 kg'},
      {'item': 'Oil', 'available': true, 'qty': '45 L'},
    ];
    return Container(
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
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('RS-2024-0341',
                style: TextStyle(
                    color: const Color(0xFF25343F),
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.w800)),
            Text('Anna Nagar Ration Shop • 0.8 km away',
                style: TextStyle(
                    color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
          ]),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.025, vertical: size.height * 0.006),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(size.width * 0.025),
            ),
            child: Row(children: [
              Container(
                  width: size.width * 0.018,
                  height: size.width * 0.018,
                  decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50), shape: BoxShape.circle)),
              SizedBox(width: size.width * 0.015),
              Text('Open',
                  style: TextStyle(
                      color: const Color(0xFF4CAF50),
                      fontSize: size.width * 0.028,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
        ]),
        SizedBox(height: size.height * 0.018),
        ...stock.map((s) => Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.01),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(s['item'] as String,
                style: TextStyle(
                    color: const Color(0xFF25343F),
                    fontSize: size.width * 0.033,
                    fontWeight: FontWeight.w600)),
            Row(children: [
              Container(
                width: size.width * 0.016,
                height: size.width * 0.016,
                decoration: BoxDecoration(
                  color: (s['available'] as bool)
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFEF5350),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Text(s['qty'] as String,
                  style: TextStyle(
                      color: (s['available'] as bool)
                          ? const Color(0xFF25343F)
                          : const Color(0xFFEF5350),
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.w600)),
            ]),
          ]),
        )),
      ]),
    );
  }

  Widget _buildRecentActivity(Size size) {
    final items = [
      {'label': 'Rice & Dal collected', 'date': '19 Jan 2026', 'receipt': 'RCP-0041', 'icon': Icons.check_circle_rounded, 'color': const Color(0xFF4CAF50)},
      {'label': 'Complaint resolved', 'date': '12 Jan 2026', 'receipt': 'CMP-009', 'icon': Icons.gavel_rounded, 'color': const Color(0xFF2E6DA4)},
      {'label': 'Compensation credited', 'date': '5 Jan 2026', 'receipt': 'RST-002', 'icon': Icons.account_balance_wallet_rounded, 'color': const Color(0xFFFF9B51)},
    ];
    return Column(
      children: items.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + i * 100),
          builder: (_, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(offset: Offset(-20 * (1 - v), 0), child: child)),
          child: Container(
            margin: EdgeInsets.only(bottom: size.height * 0.012),
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.04),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: size.width * 0.02)
              ],
            ),
            child: Row(children: [
              Container(
                width: size.width * 0.1,
                height: size.width * 0.1,
                decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle),
                child: Icon(item['icon'] as IconData,
                    color: item['color'] as Color, size: size.width * 0.05),
              ),
              SizedBox(width: size.width * 0.035),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item['label'] as String,
                      style: TextStyle(
                          color: const Color(0xFF25343F),
                          fontSize: size.width * 0.034,
                          fontWeight: FontWeight.w700)),
                  Text('${item['receipt']}  •  ${item['date']}',
                      style: TextStyle(
                          color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
                ]),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: const Color(0xFFBFC9D1), size: size.width * 0.035),
            ]),
          ),
        );
      }).toList(),
    );
  }
}
