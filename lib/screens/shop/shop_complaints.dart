import 'package:flutter/material.dart';

class ShopComplaintsPage extends StatefulWidget {
  final bool isEmbedded;
  const ShopComplaintsPage({super.key, this.isEmbedded = false});
  @override
  State<ShopComplaintsPage> createState() => _ShopComplaintsPageState();
}

class _ShopComplaintsPageState extends State<ShopComplaintsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnim;
  int _tabIndex = 0;
  String? _selectedCategory;
  final _descCtrl = TextEditingController();
  bool _submitted = false;

  final List<String> _categories = [
    'Stock Shortage',
    'Delivery Delay',
    'Quality Issue',
    'System Error',
    'Beneficiary Dispute',
    'Other',
  ];

  final List<IconData> _catIcons = [
    Icons.inventory_2_rounded,
    Icons.local_shipping_rounded,
    Icons.warning_amber_rounded,
    Icons.computer_rounded,
    Icons.people_rounded,
    Icons.more_horiz_rounded,
  ];

  final List<Map<String, dynamic>> _myComplaints = [
    {
      'id': 'CMP-2024-0441',
      'category': 'Stock Shortage',
      'desc': 'Sugar stock not received for past 2 weeks',
      'date': 'Nov 18, 2024',
      'status': 'Under Review',
      'statusColor': Color(0xFF2E6DA4),
    },
    {
      'id': 'CMP-2024-0388',
      'category': 'Delivery Delay',
      'desc': 'Shipment SH-0882 delayed by 4 days',
      'date': 'Nov 10, 2024',
      'status': 'Resolved',
      'statusColor': Color(0xFF1B8A5A),
    },
    {
      'id': 'CMP-2024-0312',
      'category': 'Quality Issue',
      'desc': 'Wheat bags found with moisture damage',
      'date': 'Oct 28, 2024',
      'status': 'Escalated',
      'statusColor': Color(0xFFEF5350),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
  }

  @override
  void dispose() {
    _fadeAnim.dispose();
    _descCtrl.dispose();
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
            _buildTabBar(size),
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
          Text('Complaints',
              style: TextStyle(
                  color: const Color(0xFFEAEFEF),
                  fontSize: size.width * 0.046,
                  fontWeight: FontWeight.w800)),
          Text('Raise and track complaints',
              style: TextStyle(
                  color: const Color(0xFFBFC9D1), fontSize: size.width * 0.029)),
        ])),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.025, vertical: size.height * 0.008),
          decoration: BoxDecoration(
            color: const Color(0xFFEF5350).withOpacity(0.2),
            borderRadius: BorderRadius.circular(size.width * 0.02),
          ),
          child: Text('${_myComplaints.length} Total',
              style: TextStyle(
                  color: const Color(0xFFEF5350),
                  fontSize: size.width * 0.028,
                  fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

  Widget _buildTabBar(Size size) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          size.width * 0.055, size.height * 0.018, size.width * 0.055, 0),
      padding: EdgeInsets.all(size.width * 0.012),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
      ),
      child: Row(children: [
        _tab('Raise Complaint', 0, size),
        _tab('My Complaints', 1, size),
      ]),
    );
  }

  Widget _tab(String label, int index, Size size) {
    final sel = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() { _tabIndex = index; _submitted = false; }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: size.height * 0.013),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFF25343F) : Colors.transparent,
            borderRadius: BorderRadius.circular(size.width * 0.03),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: sel ? Colors.white : const Color(0xFFBFC9D1),
                  fontSize: size.width * 0.032,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildTabContent(Size size) {
    if (_tabIndex == 0) return _buildRaiseTab(size);
    return _buildMyComplaintsTab(size);
  }

  Widget _buildRaiseTab(Size size) {
    if (_submitted) return _buildSubmittedView(size);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.055),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Category',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w800)),
          SizedBox(height: size.height * 0.012),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: size.height * 0.012,
              crossAxisSpacing: size.width * 0.025,
              childAspectRatio: 1.2,
            ),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final sel = _selectedCategory == _categories[i];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = _categories[i]),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 300 + i * 50),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) => Transform.scale(scale: v, child: child),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0xFFFF9B51) : Colors.white,
                      borderRadius: BorderRadius.circular(size.width * 0.04),
                      border: Border.all(
                          color: sel
                              ? const Color(0xFFFF9B51)
                              : const Color(0xFFBFC9D1).withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: sel
                              ? const Color(0xFFFF9B51).withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: sel ? 12 : 6,
                        )
                      ],
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(_catIcons[i],
                          color: sel ? Colors.white : const Color(0xFFBFC9D1),
                          size: size.width * 0.055),
                      SizedBox(height: size.height * 0.007),
                      Text(_categories[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: sel ? Colors.white : const Color(0xFF25343F),
                              fontSize: size.width * 0.025,
                              fontWeight: FontWeight.w600,
                              height: 1.2)),
                    ]),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: size.height * 0.025),
          Text('Description',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w800)),
          SizedBox(height: size.height * 0.01),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.04),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: TextField(
              controller: _descCtrl,
              maxLines: 5,
              style: TextStyle(
                  color: const Color(0xFF25343F), fontSize: size.width * 0.035),
              decoration: InputDecoration(
                hintText: 'Describe the issue in detail...',
                hintStyle: TextStyle(
                    color: const Color(0xFFBFC9D1), fontSize: size.width * 0.034),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                  borderSide: const BorderSide(color: Color(0xFFFF9B51), width: 1.5),
                ),
                contentPadding: EdgeInsets.all(size.width * 0.04),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.018),
          // Photo
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: size.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.04),
                border: Border.all(
                    color: const Color(0xFFBFC9D1).withOpacity(0.4), style: BorderStyle.solid),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.camera_alt_rounded,
                    color: const Color(0xFFBFC9D1), size: size.width * 0.07),
                SizedBox(height: size.height * 0.007),
                Text('Attach Photo (optional)',
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
              onPressed: _selectedCategory == null || _descCtrl.text.isEmpty
                  ? null
                  : () => setState(() => _submitted = true),
              icon: Icon(Icons.send_rounded, size: size.width * 0.05),
              label: Text('Submit Complaint',
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
        ],
      ),
    );
  }

  Widget _buildSubmittedView(Size size) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.08),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: size.width * 0.28,
              height: size.width * 0.28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFFEF5350).withOpacity(0.4),
                      blurRadius: size.width * 0.1,
                      spreadRadius: size.width * 0.015)
                ],
              ),
              child: Icon(Icons.check_rounded, color: Colors.white, size: size.width * 0.13),
            ),
          ),
          SizedBox(height: size.height * 0.04),
          Text('Complaint Submitted!',
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.055,
                  fontWeight: FontWeight.w900)),
          SizedBox(height: size.height * 0.012),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.035, vertical: size.height * 0.008),
            decoration: BoxDecoration(
              color: const Color(0xFFEF5350).withOpacity(0.08),
              borderRadius: BorderRadius.circular(size.width * 0.025),
            ),
            child: Text('ID: CMP-2024-0442',
                style: TextStyle(
                    color: const Color(0xFFEF5350),
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.w700)),
          ),
          SizedBox(height: size.height * 0.012),
          Text('District will review within 24 hours',
              style: TextStyle(
                  color: const Color(0xFFBFC9D1), fontSize: size.width * 0.033)),
          SizedBox(height: size.height * 0.04),
          SizedBox(
            width: double.infinity,
            height: size.height * 0.065,
            child: ElevatedButton(
              onPressed: () => setState(() {
                _submitted = false;
                _selectedCategory = null;
                _descCtrl.clear();
                _tabIndex = 1;
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25343F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.04)),
                elevation: 0,
              ),
              child: Text('View My Complaints',
                  style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildMyComplaintsTab(Size size) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.055),
      itemCount: _myComplaints.length,
      itemBuilder: (_, i) {
        final c = _myComplaints[i];
        final statusColor = c['statusColor'] as Color;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 350 + i * 80),
          builder: (_, v, child) =>
              Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 20 * (1 - v)), child: child)),
          child: Container(
            margin: EdgeInsets.only(bottom: size.height * 0.015),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.05),
              boxShadow: [
                BoxShadow(
                    color: statusColor.withOpacity(0.08),
                    blurRadius: 12,
                    offset: Offset(0, size.height * 0.004))
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(size.width * 0.045),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.025),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(size.width * 0.03),
                        ),
                        child: Icon(
                          _catIcons[_categories.indexOf(c['category'] as String)],
                          color: statusColor,
                          size: size.width * 0.045,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c['category'] as String,
                              style: TextStyle(
                                  color: const Color(0xFF25343F),
                                  fontSize: size.width * 0.036,
                                  fontWeight: FontWeight.w800)),
                          Text(c['id'] as String,
                              style: TextStyle(
                                  color: const Color(0xFFBFC9D1), fontSize: size.width * 0.026)),
                        ]),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.025, vertical: size.height * 0.006),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(size.width * 0.02),
                        ),
                        child: Text(c['status'] as String,
                            style: TextStyle(
                                color: statusColor,
                                fontSize: size.width * 0.024,
                                fontWeight: FontWeight.w800)),
                      ),
                    ]),
                    SizedBox(height: size.height * 0.012),
                    Text(c['desc'] as String,
                        style: TextStyle(
                            color: const Color(0xFF25343F), fontSize: size.width * 0.033)),
                    SizedBox(height: size.height * 0.008),
                    Text('Submitted: ${c['date']}',
                        style: TextStyle(
                            color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
                  ]),
                ),
                // Status timeline
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.045, vertical: size.height * 0.012),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEFEF).withOpacity(0.6),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(size.width * 0.05)),
                  ),
                  child: Row(children: [
                    _timelineDot(const Color(0xFF4CAF50), 'Filed', true, size),
                    _timelineLine(size),
                    _timelineDot(statusColor, 'Review',
                        c['status'] != 'Filed', size),
                    _timelineLine(size),
                    _timelineDot(
                        c['status'] == 'Resolved'
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFBFC9D1),
                        'Resolved',
                        c['status'] == 'Resolved',
                        size),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _timelineDot(Color color, String label, bool active, Size size) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: size.width * 0.05,
        height: size.width * 0.05,
        decoration: BoxDecoration(
          color: active ? color : const Color(0xFFBFC9D1).withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(
              color: active ? color : const Color(0xFFBFC9D1).withOpacity(0.3), width: 1.5),
        ),
        child: active
            ? Icon(Icons.check_rounded, color: Colors.white, size: size.width * 0.025)
            : null,
      ),
      SizedBox(height: size.height * 0.004),
      Text(label,
          style: TextStyle(
              color: active ? color : const Color(0xFFBFC9D1),
              fontSize: size.width * 0.022,
              fontWeight: active ? FontWeight.w700 : FontWeight.w400)),
    ],
  );

  Widget _timelineLine(Size size) => Expanded(
    child: Container(
      height: 1.5,
      margin: EdgeInsets.only(bottom: size.height * 0.022),
      color: const Color(0xFFBFC9D1).withOpacity(0.3),
    ),
  );
}
