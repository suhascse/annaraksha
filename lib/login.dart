import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'screens/admin_home.dart';
import 'screens/warehouse_home.dart';
import 'screens/shop_home.dart';
import 'screens/beneficiary_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _formController;
  late Animation<double> _formSlide;
  late Animation<double> _formFade;

  final _idController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  String _selectedRole = 'Government Admin';
  String? _error;

  final List<Map<String, dynamic>> _roles = [
    {
      'label': 'Government Admin',
      'icon': Icons.account_balance_rounded,
      'id': 'admin',
      'name': 'Admin (State HQ)',
    },
    {
      'label': 'District Warehouse',
      'icon': Icons.warehouse_rounded,
      'id': 'warehouse',
      'name': 'District Warehouse',
    },
    {
      'label': 'Ration Shop Dealer',
      'icon': Icons.storefront_rounded,
      'id': 'shop',
      'name': 'Shop Dealer',
    },
    {
      'label': 'Beneficiary',
      'icon': Icons.people_alt_rounded,
      'id': 'beneficiary',
      'name': 'Beneficiary',
    },
  ];

  static const _credentials = {
    'Government Admin': {'id': 'admin', 'pass': '123456'},
    'District Warehouse': {'id': 'district warehouse', 'pass': '123456'},
    'Ration Shop Dealer': {'id': 'shop dealer', 'pass': '123456'},
    'Beneficiary': {'id': 'beneficiary', 'pass': '123456'},
  };

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _formSlide = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
    );
    _formFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOut),
    );

    _formController.forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _formController.dispose();
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onRoleChanged(String role) {
    setState(() {
      _selectedRole = role;
      _error = null;
      _idController.clear();
      _passController.clear();
    });
    _formController.forward(from: 0);
  }

  Future<void> _login() async {
    final cred = _credentials[_selectedRole]!;
    final enteredId = _idController.text.trim().toLowerCase();
    final enteredPass = _passController.text.trim();

    if (enteredId != cred['id'] || enteredPass != cred['pass']) {
      setState(() => _error = 'Invalid credentials. Please try again.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    Widget home;
    switch (_selectedRole) {
      case 'Government Admin':
        home = const AdminHomePage();
        break;
      case 'District Warehouse':
        home = const WarehouseHomePage();
        break;
      case 'Ration Shop Dealer':
        home = const ShopHomePage();
        break;
      default:
        home = const BeneficiaryHomePage();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => home,
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Color get _accentColor {
    switch (_selectedRole) {
      case 'Government Admin':
        return const Color(0xFF25343F);
      case 'District Warehouse':
        return const Color(0xFF2E7D9F);
      case 'Ration Shop Dealer':
        return const Color(0xFFFF9B51);
      default:
        return const Color(0xFF4A7C6B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    return Scaffold(
      backgroundColor: const Color(0xFF25343F),
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) {
              return CustomPaint(
                size: size,
                painter: _BgPainter(_bgController.value),
              );
            },
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: math.max(size.height - MediaQuery.of(context).padding.top, 600),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.06),

                    // Logo / Brand
                    _buildBrand(isSmall),

                    SizedBox(height: size.height * 0.04),

                    // Role Selector
                    _buildRoleSelector(size),

                    SizedBox(height: size.height * 0.03),

                    // Form Card
                    AnimatedBuilder(
                      animation: _formController,
                      builder: (_, child) => Opacity(
                        opacity: _formFade.value,
                        child: Transform.translate(
                          offset: Offset(0, _formSlide.value),
                          child: child,
                        ),
                      ),
                      child: _buildFormCard(size, isSmall),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Public Distribution System • v2.0',
                        style: TextStyle(
                          color: const Color(0xFFBFC9D1).withOpacity(0.4),
                          fontSize: 11,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrand(bool isSmall) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9B51),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF9B51).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.inventory_2_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'RATIONING PORTAL',
          style: TextStyle(
            color: Color(0xFFEAEFEF),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Secure Access Management',
          style: TextStyle(
            color: Color(0xFFBFC9D1),
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector(Size size) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        physics: const BouncingScrollPhysics(),
        itemCount: _roles.length,
        itemBuilder: (_, i) {
          final role = _roles[i];
          final isSelected = _selectedRole == role['label'];
          return GestureDetector(
            onTap: () => _onRoleChanged(role['label']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF9B51)
                    : const Color(0xFFEAEFEF).withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF9B51)
                      : const Color(0xFFBFC9D1).withOpacity(0.2),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFF9B51).withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        )
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    role['icon'],
                    color: isSelected ? Colors.white : const Color(0xFFBFC9D1),
                    size: 22,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    role['label'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFBFC9D1),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormCard(Size size, bool isSmall) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Container(
        padding: EdgeInsets.all(isSmall ? 20 : 28),
        decoration: BoxDecoration(
          color: const Color(0xFFEAEFEF).withOpacity(0.06),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFFBFC9D1).withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _roles.firstWhere((r) => r['label'] == _selectedRole)['icon'],
                    color: _selectedRole == 'Ration Shop Dealer'
                        ? const Color(0xFFFF9B51)
                        : const Color(0xFFEAEFEF),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedRole,
                      style: const TextStyle(
                        color: Color(0xFFEAEFEF),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'Sign in to continue',
                      style: TextStyle(
                        color: Color(0xFFBFC9D1),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ID field
            _buildField(
              controller: _idController,
              label: _selectedRole == 'Beneficiary'
                  ? 'Ration Card / Phone'
                  : _selectedRole == 'Government Admin'
                      ? 'Admin ID'
                      : '${_selectedRole} ID',
              icon: Icons.badge_outlined,
              hint: _roles.firstWhere((r) => r['label'] == _selectedRole)['name'],
            ),

            const SizedBox(height: 14),

            // Password field
            _buildField(
              controller: _passController,
              label: 'Password / OTP',
              icon: Icons.lock_outline_rounded,
              hint: '••••••',
              obscure: _obscure,
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscure = !_obscure),
                child: Icon(
                  _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: const Color(0xFFBFC9D1),
                  size: 18,
                ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Login Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9B51),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: const Color(0xFFFF9B51).withOpacity(0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFBFC9D1),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEAEFEF).withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFBFC9D1).withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(
              color: Color(0xFFEAEFEF),
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFFBFC9D1).withOpacity(0.4),
                fontSize: 13,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFFBFC9D1), size: 18),
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: suffixIcon,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _BgPainter extends CustomPainter {
  final double t;
  _BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Top-right glow
    paint.color = const Color(0xFFFF9B51).withOpacity(0.06 + 0.04 * math.sin(t * math.pi));
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.1 + 30 * math.sin(t * math.pi)),
      180,
      paint,
    );

    // Bottom-left glow
    paint.color = const Color(0xFFBFC9D1).withOpacity(0.04 + 0.02 * math.cos(t * math.pi));
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.85 + 20 * math.cos(t * math.pi)),
      220,
      paint,
    );

    // Center accent
    paint.color = const Color(0xFF25343F).withOpacity(0.5);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.45),
      300,
      paint,
    );
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.t != t;
}
