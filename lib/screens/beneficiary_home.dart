import 'package:flutter/material.dart';

class BeneficiaryHomePage extends StatefulWidget {
  const BeneficiaryHomePage({super.key});

  @override
  State<BeneficiaryHomePage> createState() => _BeneficiaryHomePageState();
}

class _BeneficiaryHomePageState extends State<BeneficiaryHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFEF),
      body: FadeTransition(
        opacity: _anim,
        child: Column(
          children: [
            _buildHeader(context, size),
            Expanded(child: _buildBody(size)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context, Size size) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E3B), Color(0xFF25343F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back,', style: TextStyle(color: Color(0xFFBFC9D1), fontSize: 13)),
                    Text('Karthikeyan M.', style: TextStyle(color: Color(0xFFEAEFEF), fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.5)),
                ),
                child: const Center(
                  child: Text('KM', style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w800, fontSize: 15)),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.logout_rounded, color: Color(0xFFBFC9D1), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Ration Card: RC-TN-2024-00341',
            style: TextStyle(color: Color(0xFF4CAF50), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
          const SizedBox(height: 20),
          // Monthly entitlement card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Monthly Entitlement', style: TextStyle(color: Color(0xFFBFC9D1), fontSize: 12)),
                    Text('November 2024', style: TextStyle(color: Color(0xFFBFC9D1), fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _entitlement('Rice', '5 kg', '3.2 kg left', const Color(0xFF4CAF50)),
                    _entitlement('Wheat', '3 kg', '3 kg left', const Color(0xFF2196F3)),
                    _entitlement('Sugar', '1 kg', '1 kg left', const Color(0xFFFF9B51)),
                    _entitlement('Dal', '2 kg', '0.8 kg left', const Color(0xFF9C27B0)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _entitlement(String name, String total, String remaining, Color color) {
    return Column(
      children: [
        Text(name, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(total, style: const TextStyle(color: Color(0xFFEAEFEF), fontWeight: FontWeight.w800, fontSize: 14)),
        Text(remaining, style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 9)),
      ],
    );
  }

  Widget _buildBody(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGuaranteeStatus(),
          const SizedBox(height: 22),
          _sectionTitle('Shop Availability'),
          const SizedBox(height: 12),
          _buildShopStatus(),
          const SizedBox(height: 22),
          _sectionTitle('Distribution History'),
          const SizedBox(height: 12),
          _buildHistory(),
          const SizedBox(height: 22),
          _buildAuditWidget(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(
        t,
        style: const TextStyle(color: Color(0xFF25343F), fontSize: 17, fontWeight: FontWeight.w800),
      );

  Widget _buildGuaranteeStatus() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_rounded, color: Color(0xFF4CAF50), size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ration Guarantee Status',
                        style: TextStyle(color: Color(0xFF25343F), fontWeight: FontWeight.w700, fontSize: 14)),
                    Text('Your entitlement is protected',
                        style: TextStyle(color: Color(0xFF4CAF50), fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _guaranteeStat('Missed Cycles', '0', const Color(0xFF4CAF50)),
              const SizedBox(width: 10),
              _guaranteeStat('Compensation', '₹0 Due', const Color(0xFF25343F)),
              const SizedBox(width: 10),
              _guaranteeStat('Next Pickup', 'Nov 28', const Color(0xFF2196F3)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _guaranteeStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 14)),
            Text(label, style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 9), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildShopStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9B51).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.storefront_rounded, color: Color(0xFFFF9B51), size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Assigned Shop: RS-0341', style: TextStyle(color: Color(0xFF25343F), fontWeight: FontWeight.w700, fontSize: 14)),
                    Text('Anna Nagar East, Chennai', style: TextStyle(color: Color(0xFFBFC9D1), fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ShopStockChip('Rice', '680 kg', true),
              _ShopStockChip('Wheat', '420 kg', true),
              _ShopStockChip('Sugar', '90 kg', false),
              _ShopStockChip('Dal', '310 kg', true),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, color: Color(0xFF4CAF50), size: 8),
                SizedBox(width: 8),
                Text('Shop is open • Estimated wait: ~10 min',
                    style: TextStyle(color: Color(0xFF4CAF50), fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    final history = [
      {'date': 'Oct 15, 2024', 'items': 'Rice 5kg, Sugar 1kg, Dal 2kg', 'id': 'RCP-2024-4891'},
      {'date': 'Sep 12, 2024', 'items': 'Rice 5kg, Wheat 3kg', 'id': 'RCP-2024-3102'},
      {'date': 'Aug 08, 2024', 'items': 'Rice 5kg, Sugar 1kg, Wheat 3kg, Dal 2kg', 'id': 'RCP-2024-1980'},
    ];

    return Column(
      children: history.map((h) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF25343F).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF25343F), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h['date'] as String,
                      style: const TextStyle(color: Color(0xFF25343F), fontWeight: FontWeight.w700, fontSize: 13)),
                  Text(h['items'] as String,
                      style: const TextStyle(color: Color(0xFFBFC9D1), fontSize: 10)),
                ],
              ),
            ),
            const Icon(Icons.download_rounded, color: Color(0xFFBFC9D1), size: 18),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildAuditWidget() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF25343F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.how_to_vote_rounded, color: Color(0xFFFF9B51), size: 22),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Community Flash Audit',
                    style: TextStyle(color: Color(0xFFEAEFEF), fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9B51).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('SELECTED', style: TextStyle(color: Color(0xFFFF9B51), fontSize: 9, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'You have been randomly selected for a stock audit. Please confirm the following:',
            style: TextStyle(color: Color(0xFFBFC9D1), fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Stock Available', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF5350),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Issue Found', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.history_rounded, 'label': 'History'},
      {'icon': Icons.shield_rounded, 'label': 'Guarantee'},
      {'icon': Icons.report_problem_rounded, 'label': 'Complaint'},
      {'icon': Icons.language_rounded, 'label': 'Language'},
    ];
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x15000000), blurRadius: 16, offset: Offset(0, -4))],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final sel = i == _navIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _navIndex = i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[i]['icon'] as IconData,
                        color: sel ? const Color(0xFF1B5E3B) : const Color(0xFFBFC9D1), size: 22),
                    const SizedBox(height: 3),
                    Text(items[i]['label'] as String,
                        style: TextStyle(
                            color: sel ? const Color(0xFF1B5E3B) : const Color(0xFFBFC9D1),
                            fontSize: 9,
                            fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ShopStockChip extends StatelessWidget {
  final String name, qty;
  final bool available;
  const _ShopStockChip(this.name, this.qty, this.available);

  @override
  Widget build(BuildContext context) {
    final color = available ? const Color(0xFF1B8A5A) : const Color(0xFFEF5350);
    return Column(
      children: [
        Text(name, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        Text(qty, style: const TextStyle(color: Color(0xFF25343F), fontSize: 11, fontWeight: FontWeight.w600)),
        Icon(
          available ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: color,
          size: 14,
        ),
      ],
    );
  }
}
