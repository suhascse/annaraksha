import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BeneficiaryRaiseComplaintPage extends StatefulWidget {
  const BeneficiaryRaiseComplaintPage({super.key});
  @override
  State<BeneficiaryRaiseComplaintPage> createState() =>
      _BeneficiaryRaiseComplaintPageState();
}

class _BeneficiaryRaiseComplaintPageState
    extends State<BeneficiaryRaiseComplaintPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnim;
  late AnimationController _successAnim;

  String? _selectedCategory;
  final TextEditingController _descController = TextEditingController();
  bool _photoAttached = false;
  bool _submitted = false;
  int _activeTab = 0; // 0 = New, 1 = My Complaints

  final List<String> _categories = [
    'Stock Shortage',
    'Wrong Quantity',
    'Quality Issue',
    'Dealer Misconduct',
    'Delayed Distribution',
    'Overcharging',
    'Other',
  ];

  final List<Map<String, dynamic>> _myComplaints = [
    {
      'id': 'CMP-009',
      'category': 'Wrong Quantity',
      'date': '12 Jan 2026',
      'status': 'resolved',
      'description': 'Received less wheat than entitled quantity.',
    },
    {
      'id': 'CMP-007',
      'category': 'Stock Shortage',
      'date': '18 Nov 2025',
      'status': 'escalated',
      'description': 'Sugar was not available at shop for 2 weeks.',
    },
    {
      'id': 'CMP-005',
      'category': 'Dealer Misconduct',
      'date': '3 Sep 2025',
      'status': 'closed',
      'description': 'Dealer demanded extra payment for ration.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _successAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _successAnim.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_selectedCategory == null || _descController.text.trim().isEmpty) return;
    setState(() => _submitted = true);
    _successAnim.forward();
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'resolved': return const Color(0xFF4CAF50);
      case 'escalated': return const Color(0xFFFF9B51);
      case 'closed': return const Color(0xFFBFC9D1);
      default: return const Color(0xFF2E6DA4);
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case 'resolved': return Icons.check_circle_rounded;
      case 'escalated': return Icons.arrow_upward_rounded;
      case 'closed': return Icons.lock_rounded;
      default: return Icons.pending_rounded;
    }
  }

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
          _buildTabBar(size),
          Expanded(
            child: _activeTab == 0
                ? _submitted
                    ? _buildSuccessView(size)
                    : _buildNewComplaintForm(size)
                : _buildMyComplaints(size),
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
              Text('Raise Complaint',
                  style: TextStyle(
                      color: const Color(0xFFEAEFEF),
                      fontSize: size.width * 0.048,
                      fontWeight: FontWeight.w900)),
              Text('Report issues to district warehouse',
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
            ]),
          ),
          Container(
            padding: EdgeInsets.all(size.width * 0.028),
            decoration: BoxDecoration(
              color: const Color(0xFFEF5350).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.report_problem_rounded,
                color: const Color(0xFFEF5350), size: size.width * 0.055),
          ),
        ]),
      ),
    );
  }

  Widget _buildTabBar(Size size) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          size.width * 0.055, size.height * 0.02, size.width * 0.055, 0),
      padding: EdgeInsets.all(size.width * 0.012),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: size.width * 0.02)
        ],
      ),
      child: Row(
        children: ['New Complaint', 'My Complaints'].asMap().entries.map((e) {
          final sel = e.key == _activeTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = e.key),
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
                        color: sel ? const Color(0xFFFF9B51) : const Color(0xFFBFC9D1),
                        fontSize: size.width * 0.033,
                        fontWeight: sel ? FontWeight.w800 : FontWeight.w500)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNewComplaintForm(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
          size.width * 0.055, size.height * 0.025, size.width * 0.055, size.height * 0.03),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Select Category',
            style: TextStyle(
                color: const Color(0xFF25343F),
                fontSize: size.width * 0.038,
                fontWeight: FontWeight.w800)),
        SizedBox(height: size.height * 0.015),
        Wrap(
          spacing: size.width * 0.025,
          runSpacing: size.height * 0.012,
          children: _categories.map((c) {
            final sel = c == _selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04, vertical: size.height * 0.01),
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFF25343F) : Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.035),
                  border: sel
                      ? Border.all(color: const Color(0xFFFF9B51).withOpacity(0.5))
                      : Border.all(color: Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(sel ? 0.1 : 0.04),
                        blurRadius: size.width * (sel ? 0.04 : 0.02))
                  ],
                ),
                child: Text(c,
                    style: TextStyle(
                        color: sel ? const Color(0xFFFF9B51) : const Color(0xFF25343F),
                        fontSize: size.width * 0.032,
                        fontWeight: sel ? FontWeight.w800 : FontWeight.w500)),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: size.height * 0.025),
        Text('Description',
            style: TextStyle(
                color: const Color(0xFF25343F),
                fontSize: size.width * 0.038,
                fontWeight: FontWeight.w800)),
        SizedBox(height: size.height * 0.012),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size.width * 0.04),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: size.width * 0.03)
            ],
          ),
          child: TextField(
            controller: _descController,
            maxLines: 5,
            style: TextStyle(
                color: const Color(0xFF25343F), fontSize: size.width * 0.034),
            decoration: InputDecoration(
              hintText: 'Describe the issue clearly...',
              hintStyle: TextStyle(
                  color: const Color(0xFFBFC9D1), fontSize: size.width * 0.033),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(size.width * 0.045),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.022),
        GestureDetector(
          onTap: () => setState(() => _photoAttached = !_photoAttached),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(size.width * 0.045),
            decoration: BoxDecoration(
              color: _photoAttached
                  ? const Color(0xFF4CAF50).withOpacity(0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.04),
              border: Border.all(
                color: _photoAttached
                    ? const Color(0xFF4CAF50).withOpacity(0.4)
                    : Colors.transparent,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: size.width * 0.02)
              ],
            ),
            child: Row(children: [
              Icon(
                _photoAttached
                    ? Icons.check_circle_rounded
                    : Icons.add_photo_alternate_rounded,
                color: _photoAttached
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFBFC9D1),
                size: size.width * 0.065,
              ),
              SizedBox(width: size.width * 0.04),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  _photoAttached ? 'Photo Attached' : 'Attach Photo (Optional)',
                  style: TextStyle(
                      color: _photoAttached
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF25343F),
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w700),
                ),
                Text('Tap to ${_photoAttached ? 'remove' : 'upload from gallery'}',
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
              ]),
            ]),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        GestureDetector(
          onTap: _submitComplaint,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: (_selectedCategory != null && _descController.text.isNotEmpty)
                    ? [const Color(0xFFFF9B51), const Color(0xFFFF6B35)]
                    : [const Color(0xFFBFC9D1), const Color(0xFFBFC9D1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(size.width * 0.045),
              boxShadow: [
                if (_selectedCategory != null)
                  BoxShadow(
                      color: const Color(0xFFFF9B51).withOpacity(0.4),
                      blurRadius: size.width * 0.06,
                      offset: Offset(0, size.height * 0.01))
              ],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.send_rounded, color: Colors.white, size: size.width * 0.05),
              SizedBox(width: size.width * 0.025),
              Text('Submit Complaint',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.038,
                      fontWeight: FontWeight.w800)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildSuccessView(Size size) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.elasticOut,
        builder: (_, v, child) =>
            Transform.scale(scale: v, child: child),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.08),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: size.width * 0.3,
              height: size.width * 0.3,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.4),
                      blurRadius: size.width * 0.1)
                ],
              ),
              child: Icon(Icons.check_rounded,
                  color: Colors.white, size: size.width * 0.15),
            ),
            SizedBox(height: size.height * 0.035),
            Text('Complaint Submitted!',
                style: TextStyle(
                    color: const Color(0xFF25343F),
                    fontSize: size.width * 0.052,
                    fontWeight: FontWeight.w900)),
            SizedBox(height: size.height * 0.012),
            Text('CMP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                style: TextStyle(
                    color: const Color(0xFFFF9B51),
                    fontSize: size.width * 0.042,
                    fontWeight: FontWeight.w800)),
            SizedBox(height: size.height * 0.012),
            Text(
              'Your complaint has been forwarded to the district warehouse for review.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color(0xFFBFC9D1), fontSize: size.width * 0.033),
            ),
            SizedBox(height: size.height * 0.04),
            GestureDetector(
              onTap: () => setState(() {
                _submitted = false;
                _selectedCategory = null;
                _descController.clear();
                _photoAttached = false;
              }),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08, vertical: size.height * 0.018),
                decoration: BoxDecoration(
                  color: const Color(0xFF25343F),
                  borderRadius: BorderRadius.circular(size.width * 0.045),
                ),
                child: Text('Raise Another',
                    style: TextStyle(
                        color: const Color(0xFFFF9B51),
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w800)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildMyComplaints(Size size) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
          size.width * 0.055, size.height * 0.022, size.width * 0.055, size.height * 0.03),
      itemCount: _myComplaints.length,
      itemBuilder: (_, i) {
        final c = _myComplaints[i];
        final color = _statusColor(c['status'] as String);
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + i * 80),
          builder: (_, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(offset: Offset(-20 * (1 - v), 0), child: child)),
          child: Container(
            margin: EdgeInsets.only(bottom: size.height * 0.015),
            padding: EdgeInsets.all(size.width * 0.045),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.05),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: size.width * 0.03)
              ],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: size.width * 0.1,
                  height: size.width * 0.1,
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(_statusIcon(c['status'] as String),
                      color: color, size: size.width * 0.05),
                ),
                SizedBox(width: size.width * 0.035),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c['id'] as String,
                        style: TextStyle(
                            color: const Color(0xFF25343F),
                            fontSize: size.width * 0.036,
                            fontWeight: FontWeight.w800)),
                    Text('${c['category']}  •  ${c['date']}',
                        style: TextStyle(
                            color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
                  ]),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.025, vertical: size.height * 0.005),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(size.width * 0.02),
                  ),
                  child: Text((c['status'] as String).toUpperCase(),
                      style: TextStyle(
                          color: color,
                          fontSize: size.width * 0.022,
                          fontWeight: FontWeight.w800)),
                ),
              ]),
              SizedBox(height: size.height * 0.012),
              Text(c['description'] as String,
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.029)),
            ]),
          ),
        );
      },
    );
  }
}
