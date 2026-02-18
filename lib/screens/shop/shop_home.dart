// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:math' as math;
// import 'shop_receive_shipment.dart';
// import 'shop_beneficiary_verification.dart';
// import 'shop_distribute_ration.dart';
// import 'shop_stock_management.dart';
// import 'shop_restitution.dart';
// import 'shop_complaints.dart';

// class ShopHomePage extends StatefulWidget {
//   const ShopHomePage({super.key});
//   @override
//   State<ShopHomePage> createState() => _ShopHomePageState();
// }

// class _ShopHomePageState extends State<ShopHomePage>
//     with TickerProviderStateMixin {
//   late AnimationController _headerAnim;
//   late AnimationController _pulseAnim;
//   late AnimationController _cardAnim;
//   int _navIndex = 0;

//   final List<Map<String, dynamic>> _stockItems = [
//     {'name': 'Rice', 'qty': 1840.0, 'max': 2700.0, 'unit': 'kg', 'color': const Color(0xFF1B8A5A), 'icon': '🌾'},
//     {'name': 'Wheat', 'qty': 920.0, 'max': 2200.0, 'unit': 'kg', 'color': const Color(0xFFD4891A), 'icon': '🌿'},
//     {'name': 'Sugar', 'qty': 180.0, 'max': 1000.0, 'unit': 'kg', 'color': const Color(0xFFEF5350), 'icon': '🍬'},
//     {'name': 'Dal', 'qty': 640.0, 'max': 800.0, 'unit': 'kg', 'color': const Color(0xFFBFC9D1), 'icon': '🫘'},
//     {'name': 'Oil', 'qty': 310.0, 'max': 500.0, 'unit': 'L', 'color': const Color(0xFFFF9B51), 'icon': '🫙'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _headerAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
//     _pulseAnim = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
//     _cardAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
//   }

//   @override
//   void dispose() {
//     _headerAnim.dispose();
//     _pulseAnim.dispose();
//     _cardAnim.dispose();
//     super.dispose();
//   }

//   void _navigate(Widget page) {
//     Navigator.push(context, PageRouteBuilder(
//       pageBuilder: (_, a, __) => page,
//       transitionsBuilder: (_, anim, __, child) => SlideTransition(
//         position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
//             .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
//         child: child,
//       ),
//       transitionDuration: const Duration(milliseconds: 350),
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final pad = MediaQuery.of(context).padding;

//     // Each bottom nav tab maps to a full page
//     final List<Widget> _pages = [
//       // 0 – Home dashboard (header + body)
//       Column(children: [
//         _buildHeader(size, pad),
//         Expanded(child: _buildBody(size)),
//       ]),
//       // 1 – Scan QR / Receive Shipment
//       const ShopReceiveShipmentPage(isEmbedded: true),
//       // 2 – Beneficiary Verification
//       const ShopBeneficiaryVerificationPage(isEmbedded: true),
//       // 3 – Stock Management
//       const ShopStockManagementPage(isEmbedded: true),
//       // 4 – More (complaints + restitution quick links)
//       _buildMorePage(size, pad),
//     ];

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFEAEFEF),
//         body: IndexedStack(
//           index: _navIndex,
//           children: _pages,
//         ),
//         bottomNavigationBar: _buildBottomNav(size, pad),
//       ),
//     );
//   }

//   /// "More" tab — quick-launch tiles for Restitution, Complaints, Distribute
//   Widget _buildMorePage(Size size, EdgeInsets pad) {
//     final items = [
//       {
//         'label': 'Distribute Ration',
//         'sub': 'Select items & distribute to beneficiary',
//         'icon': Icons.volunteer_activism_rounded,
//         'color': const Color(0xFFFF9B51),
//         'bg': const Color(0xFFFFF3E0),
//         'page': const ShopDistributeRationPage(isEmbedded: true),
//       },
//       {
//         'label': 'Restitution Cases',
//         'sub': 'Mandatory compensation distribution',
//         'icon': Icons.gavel_rounded,
//         'color': const Color(0xFFFF6B35),
//         'bg': const Color(0xFFFBE9E7),
//         'page': const ShopRestitutionPage(isEmbedded: true),
//       },
//       {
//         'label': 'Raise Complaint',
//         'sub': 'Report issues to district warehouse',
//         'icon': Icons.report_problem_rounded,
//         'color': const Color(0xFFEF5350),
//         'bg': const Color(0xFFFFEBEE),
//         'page': const ShopComplaintsPage(isEmbedded: true),
//       },
//     ];

//     return Column(
//       children: [
//         Container(
//           width: size.width,
//           padding: EdgeInsets.only(
//             top: pad.top + size.height * 0.018,
//             left: size.width * 0.055,
//             right: size.width * 0.055,
//             bottom: size.height * 0.025,
//           ),
//           decoration: BoxDecoration(
//             color: const Color(0xFF25343F),
//             borderRadius: BorderRadius.vertical(
//                 bottom: Radius.circular(size.width * 0.075)),
//           ),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text('More',
//                 style: TextStyle(
//                     color: const Color(0xFFBFC9D1),
//                     fontSize: size.width * 0.03,
//                     letterSpacing: 1.5)),
//             SizedBox(height: size.height * 0.004),
//             Text('Quick Actions',
//                 style: TextStyle(
//                     color: const Color(0xFFEAEFEF),
//                     fontSize: size.width * 0.052,
//                     fontWeight: FontWeight.w900)),
//           ]),
//         ),
//         Expanded(
//           child: ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             padding: EdgeInsets.all(size.width * 0.055),
//             itemCount: items.length,
//             itemBuilder: (_, i) {
//               final item = items[i];
//               final color = item['color'] as Color;
//               return TweenAnimationBuilder<double>(
//                 tween: Tween(begin: 0, end: 1),
//                 duration: Duration(milliseconds: 300 + i * 80),
//                 curve: Curves.easeOutCubic,
//                 builder: (_, v, child) => Opacity(
//                     opacity: v,
//                     child: Transform.translate(
//                         offset: Offset(0, 20 * (1 - v)), child: child)),
//                 child: GestureDetector(
//                   onTap: () => _navigate(item['page'] as Widget),
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: size.height * 0.018),
//                     padding: EdgeInsets.all(size.width * 0.05),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(size.width * 0.055),
//                       boxShadow: [
//                         BoxShadow(
//                             color: color.withOpacity(0.12),
//                             blurRadius: size.width * 0.05,
//                             offset: Offset(0, size.height * 0.008))
//                       ],
//                     ),
//                     child: Row(children: [
//                       Container(
//                         width: size.width * 0.14,
//                         height: size.width * 0.14,
//                         decoration: BoxDecoration(
//                           color: item['bg'] as Color,
//                           borderRadius: BorderRadius.circular(size.width * 0.04),
//                         ),
//                         child: Icon(item['icon'] as IconData,
//                             color: color, size: size.width * 0.07),
//                       ),
//                       SizedBox(width: size.width * 0.04),
//                       Expanded(
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(item['label'] as String,
//                                   style: TextStyle(
//                                       color: const Color(0xFF25343F),
//                                       fontSize: size.width * 0.042,
//                                       fontWeight: FontWeight.w800)),
//                               SizedBox(height: size.height * 0.005),
//                               Text(item['sub'] as String,
//                                   style: TextStyle(
//                                       color: const Color(0xFFBFC9D1),
//                                       fontSize: size.width * 0.029)),
//                             ]),
//                       ),
//                       Icon(Icons.arrow_forward_ios_rounded,
//                           color: const Color(0xFFBFC9D1), size: size.width * 0.04),
//                     ]),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeader(Size size, EdgeInsets pad) {
//     return AnimatedBuilder(
//       animation: _headerAnim,
//       builder: (_, child) => Transform.translate(
//         offset: Offset(0, -30 * (1 - _headerAnim.value)),
//         child: Opacity(opacity: _headerAnim.value, child: child),
//       ),
//       child: Container(
//         width: size.width,
//         padding: EdgeInsets.only(
//           top: pad.top + size.height * 0.018,
//           left: size.width * 0.055,
//           right: size.width * 0.055,
//           bottom: size.height * 0.025,
//         ),
//         decoration: BoxDecoration(
//           color: const Color(0xFF25343F),
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(size.width * 0.075),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF25343F).withOpacity(0.5),
//               blurRadius: size.width * 0.08,
//               offset: Offset(0, size.height * 0.015),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 _buildShopAvatar(size),
//                 SizedBox(width: size.width * 0.035),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'RATION SHOP DEALER',
//                         style: TextStyle(
//                           color: const Color(0xFFFF9B51),
//                           fontSize: size.width * 0.028,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 1.5,
//                         ),
//                       ),
//                       SizedBox(height: size.height * 0.004),
//                       Text(
//                         'RS-2024-0341 • Anna Nagar',
//                         style: TextStyle(
//                           color: const Color(0xFFEAEFEF),
//                           fontSize: size.width * 0.042,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 _buildNotifBell(size),
//                 SizedBox(width: size.width * 0.025),
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     padding: EdgeInsets.all(size.width * 0.022),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(size.width * 0.025),
//                     ),
//                     child: Icon(Icons.logout_rounded,
//                         color: const Color(0xFFBFC9D1), size: size.width * 0.045),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: size.height * 0.022),
//             _buildTopStats(size),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildShopAvatar(Size size) {
//     return AnimatedBuilder(
//       animation: _pulseAnim,
//       builder: (_, child) => Container(
//         width: size.width * 0.13,
//         height: size.width * 0.13,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFFF9B51), Color(0xFFFF6B35)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFFF9B51).withOpacity(0.3 + 0.2 * _pulseAnim.value),
//               blurRadius: size.width * 0.06,
//               spreadRadius: size.width * 0.005 * _pulseAnim.value,
//             ),
//           ],
//         ),
//         child: Icon(Icons.storefront_rounded, color: Colors.white, size: size.width * 0.065),
//       ),
//     );
//   }

//   Widget _buildNotifBell(Size size) {
//     return Stack(
//       children: [
//         Container(
//           padding: EdgeInsets.all(size.width * 0.022),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(size.width * 0.025),
//           ),
//           child: Icon(Icons.notifications_rounded,
//               color: const Color(0xFFEAEFEF), size: size.width * 0.048),
//         ),
//         Positioned(
//           right: size.width * 0.008,
//           top: size.width * 0.008,
//           child: Container(
//             width: size.width * 0.025,
//             height: size.width * 0.025,
//             decoration: const BoxDecoration(
//               color: Color(0xFFFF9B51),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text('3',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: size.width * 0.02,
//                       fontWeight: FontWeight.w800)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTopStats(Size size) {
//     final stats = [
//       {'label': 'Trust Score', 'value': '94%', 'icon': Icons.verified_rounded, 'color': const Color(0xFF4CAF50)},
//       {'label': 'Distributed', 'value': '148', 'icon': Icons.people_rounded, 'color': const Color(0xFFFF9B51)},
//       {'label': 'Pending', 'value': '3', 'icon': Icons.pending_actions_rounded, 'color': const Color(0xFFEF5350)},
//       {'label': 'Restitution', 'value': '2', 'icon': Icons.gavel_rounded, 'color': const Color(0xFFBFC9D1)},
//     ];
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: size.width * 0.04,
//         vertical: size.height * 0.016,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.07),
//         borderRadius: BorderRadius.circular(size.width * 0.04),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: stats.asMap().entries.map((e) {
//           final s = e.value;
//           final isLast = e.key == stats.length - 1;
//           return Row(
//             children: [
//               Column(
//                 children: [
//                   Icon(s['icon'] as IconData,
//                       color: s['color'] as Color, size: size.width * 0.048),
//                   SizedBox(height: size.height * 0.005),
//                   Text(s['value'] as String,
//                       style: TextStyle(
//                           color: s['color'] as Color,
//                           fontSize: size.width * 0.038,
//                           fontWeight: FontWeight.w900)),
//                   Text(s['label'] as String,
//                       style: TextStyle(
//                           color: const Color(0xFFBFC9D1),
//                           fontSize: size.width * 0.024)),
//                 ],
//               ),
//               if (!isLast) ...[
//                 SizedBox(width: size.width * 0.04),
//                 Container(
//                     width: 1,
//                     height: size.height * 0.055,
//                     color: Colors.white.withOpacity(0.12)),
//                 SizedBox(width: size.width * 0.04),
//               ],
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildBody(Size size) {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: EdgeInsets.fromLTRB(
//         size.width * 0.055,
//         size.height * 0.025,
//         size.width * 0.055,
//         size.height * 0.015,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _sectionLabel('Stock Status', size),
//           SizedBox(height: size.height * 0.015),
//           _buildStockScroll(size),
//           SizedBox(height: size.height * 0.028),
//           _sectionLabel('Quick Actions', size),
//           SizedBox(height: size.height * 0.015),
//           _buildActionGrid(size),
//           SizedBox(height: size.height * 0.028),
//           _buildIncomingShipmentCard(size),
//           SizedBox(height: size.height * 0.028),
//           _sectionLabel("Today's Activity", size),
//           SizedBox(height: size.height * 0.015),
//           _buildActivityFeed(size),
//         ],
//       ),
//     );
//   }

//   Widget _sectionLabel(String text, Size size) {
//     return Row(
//       children: [
//         Container(
//           width: size.width * 0.01,
//           height: size.height * 0.024,
//           decoration: BoxDecoration(
//             color: const Color(0xFFFF9B51),
//             borderRadius: BorderRadius.circular(size.width * 0.005),
//           ),
//         ),
//         SizedBox(width: size.width * 0.03),
//         Text(
//           text,
//           style: TextStyle(
//             color: const Color(0xFF25343F),
//             fontSize: size.width * 0.048,
//             fontWeight: FontWeight.w900,
//             letterSpacing: 0.3,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStockScroll(Size size) {
//     return SizedBox(
//       height: size.height * 0.16,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         itemCount: _stockItems.length,
//         itemBuilder: (_, i) {
//           final item = _stockItems[i];
//           final ratio = (item['qty'] as double) / (item['max'] as double);
//           final isLow = ratio < 0.25;
//           final color = isLow ? const Color(0xFFEF5350) : item['color'] as Color;

//           return TweenAnimationBuilder<double>(
//             tween: Tween(begin: 0, end: 1),
//             duration: Duration(milliseconds: 400 + i * 100),
//             curve: Curves.easeOutCubic,
//             builder: (_, v, child) => Opacity(
//               opacity: v,
//               child: Transform.translate(offset: Offset(0, 20 * (1 - v)), child: child),
//             ),
//             child: GestureDetector(
//               onTap: () => _navigate(const ShopStockManagementPage()),
//               child: Container(
//                 width: size.width * 0.34,
//                 margin: EdgeInsets.only(right: size.width * 0.03),
//                 padding: EdgeInsets.all(size.width * 0.04),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(size.width * 0.055),
//                   border: Border.all(
//                     color: isLow ? const Color(0xFFEF5350).withOpacity(0.4) : Colors.transparent,
//                     width: 1.5,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: color.withOpacity(0.12),
//                       blurRadius: size.width * 0.04,
//                       offset: Offset(0, size.height * 0.006),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(item['icon'] as String, style: TextStyle(fontSize: size.width * 0.055)),
//                         if (isLow)
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: size.width * 0.02, vertical: size.height * 0.003),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFEF5350).withOpacity(0.12),
//                               borderRadius: BorderRadius.circular(size.width * 0.02),
//                             ),
//                             child: Text('LOW',
//                                 style: TextStyle(
//                                     color: const Color(0xFFEF5350),
//                                     fontSize: size.width * 0.022,
//                                     fontWeight: FontWeight.w800)),
//                           ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(item['name'] as String,
//                             style: TextStyle(
//                                 color: const Color(0xFF25343F),
//                                 fontSize: size.width * 0.036,
//                                 fontWeight: FontWeight.w800)),
//                         Text('${(item['qty'] as double).toInt()} ${item['unit']}',
//                             style: TextStyle(
//                                 color: color,
//                                 fontSize: size.width * 0.032,
//                                 fontWeight: FontWeight.w700)),
//                         SizedBox(height: size.height * 0.006),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(size.width * 0.01),
//                           child: LinearProgressIndicator(
//                             value: ratio,
//                             backgroundColor: color.withOpacity(0.12),
//                             valueColor: AlwaysStoppedAnimation(color),
//                             minHeight: size.height * 0.007,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildActionGrid(Size size) {
//     final actions = [
//       {
//         'label': 'Receive\nShipment',
//         'icon': Icons.download_rounded,
//         'color': const Color(0xFF1B8A5A),
//         'bg': const Color(0xFFE8F5E9),
//         'page': const ShopReceiveShipmentPage(),
//       },
//       {
//         'label': 'Verify\nBeneficiary',
//         'icon': Icons.person_search_rounded,
//         'color': const Color(0xFF2E6DA4),
//         'bg': const Color(0xFFE3F2FD),
//         'page': const ShopBeneficiaryVerificationPage(),
//       },
//       {
//         'label': 'Distribute\nRation',
//         'icon': Icons.volunteer_activism_rounded,
//         'color': const Color(0xFFFF9B51),
//         'bg': const Color(0xFFFFF3E0),
//         'page': const ShopDistributeRationPage(),
//       },
//       {
//         'label': 'Stock\nManagement',
//         'icon': Icons.inventory_2_rounded,
//         'color': const Color(0xFF7B5EA7),
//         'bg': const Color(0xFFF3E5F5),
//         'page': const ShopStockManagementPage(),
//       },
//       {
//         'label': 'Restitution\nCases',
//         'icon': Icons.gavel_rounded,
//         'color': const Color(0xFFFF6B35),
//         'bg': const Color(0xFFFFF3E0),
//         'page': const ShopRestitutionPage(),
//       },
//       {
//         'label': 'Raise\nComplaint',
//         'icon': Icons.report_problem_rounded,
//         'color': const Color(0xFFEF5350),
//         'bg': const Color(0xFFFFEBEE),
//         'page': const ShopComplaintsPage(),
//       },
//     ];

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisSpacing: size.height * 0.015,
//         crossAxisSpacing: size.width * 0.03,
//         childAspectRatio: 0.9,
//       ),
//       itemCount: actions.length,
//       itemBuilder: (_, i) {
//         final a = actions[i];
//         return TweenAnimationBuilder<double>(
//           tween: Tween(begin: 0, end: 1),
//           duration: Duration(milliseconds: 500 + i * 80),
//           curve: Curves.elasticOut,
//           builder: (_, v, child) => Transform.scale(scale: v, child: child),
//           child: GestureDetector(
//             onTap: () => _navigate(a['page'] as Widget),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(size.width * 0.05),
//                 boxShadow: [
//                   BoxShadow(
//                     color: (a['color'] as Color).withOpacity(0.15),
//                     blurRadius: size.width * 0.04,
//                     offset: Offset(0, size.height * 0.006),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: size.width * 0.12,
//                     height: size.width * 0.12,
//                     decoration: BoxDecoration(
//                       color: a['bg'] as Color,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(a['icon'] as IconData,
//                         color: a['color'] as Color, size: size.width * 0.058),
//                   ),
//                   SizedBox(height: size.height * 0.01),
//                   Text(
//                     a['label'] as String,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: const Color(0xFF25343F),
//                       fontSize: size.width * 0.028,
//                       fontWeight: FontWeight.w700,
//                       height: 1.3,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildIncomingShipmentCard(Size size) {
//     return GestureDetector(
//       onTap: () => _navigate(const ShopReceiveShipmentPage()),
//       child: AnimatedBuilder(
//         animation: _pulseAnim,
//         builder: (_, child) => Container(
//           padding: EdgeInsets.all(size.width * 0.05),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 const Color(0xFF25343F),
//                 const Color(0xFF1A2E3D),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(size.width * 0.055),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF25343F).withOpacity(0.3 + 0.1 * _pulseAnim.value),
//                 blurRadius: size.width * 0.06,
//                 offset: Offset(0, size.height * 0.01),
//               ),
//             ],
//           ),
//           child: child,
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: size.width * 0.15,
//               height: size.width * 0.15,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFF9B51).withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(size.width * 0.04),
//               ),
//               child: Icon(Icons.local_shipping_rounded,
//                   color: const Color(0xFFFF9B51), size: size.width * 0.08),
//             ),
//             SizedBox(width: size.width * 0.04),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Incoming Shipment',
//                       style: TextStyle(
//                           color: const Color(0xFFBFC9D1),
//                           fontSize: size.width * 0.03,
//                           letterSpacing: 0.8)),
//                   SizedBox(height: size.height * 0.004),
//                   Text('SH-2024-0892',
//                       style: TextStyle(
//                           color: const Color(0xFFEAEFEF),
//                           fontSize: size.width * 0.042,
//                           fontWeight: FontWeight.w800)),
//                   SizedBox(height: size.height * 0.004),
//                   Text('Rice 800kg • Wheat 400kg • Sugar 200kg',
//                       style: TextStyle(
//                           color: const Color(0xFFBFC9D1),
//                           fontSize: size.width * 0.028)),
//                   SizedBox(height: size.height * 0.008),
//                   Row(
//                     children: [
//                       Container(
//                         width: size.width * 0.02,
//                         height: size.width * 0.02,
//                         decoration: const BoxDecoration(
//                             color: Color(0xFF4CAF50), shape: BoxShape.circle),
//                       ),
//                       SizedBox(width: size.width * 0.02),
//                       Text('En route • ETA ~2 hrs',
//                           style: TextStyle(
//                               color: const Color(0xFF4CAF50),
//                               fontSize: size.width * 0.03,
//                               fontWeight: FontWeight.w600)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 Icon(Icons.qr_code_scanner_rounded,
//                     color: const Color(0xFFFF9B51), size: size.width * 0.07),
//                 SizedBox(height: size.height * 0.006),
//                 Text('Scan',
//                     style: TextStyle(
//                         color: const Color(0xFFFF9B51),
//                         fontSize: size.width * 0.025,
//                         fontWeight: FontWeight.w700)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActivityFeed(Size size) {
//     final items = [
//       {'name': 'Karthikeyan M', 'card': 'RC-0012', 'items': 'Rice 5kg, Sugar 1kg', 'time': '10:24 AM', 'status': 'done'},
//       {'name': 'Meena S', 'card': 'RC-0088', 'items': 'Rice 5kg, Dal 2kg', 'time': '10:12 AM', 'status': 'done'},
//       {'name': 'Ramesh P', 'card': 'RC-0215', 'items': 'Wheat 5kg, Sugar 1kg', 'time': '9:58 AM', 'status': 'done'},
//       {'name': 'Lakshmi D', 'card': 'RC-0099', 'items': 'Restitution due', 'time': '—', 'status': 'pending'},
//     ];
//     return Column(
//       children: items.asMap().entries.map((e) {
//         final i = e.key;
//         final item = e.value;
//         final isPending = item['status'] == 'pending';
//         return TweenAnimationBuilder<double>(
//           tween: Tween(begin: 0, end: 1),
//           duration: Duration(milliseconds: 400 + i * 80),
//           builder: (_, v, child) => Opacity(
//               opacity: v,
//               child: Transform.translate(offset: Offset(-20 * (1 - v), 0), child: child)),
//           child: Container(
//             margin: EdgeInsets.only(bottom: size.height * 0.012),
//             padding: EdgeInsets.symmetric(
//                 horizontal: size.width * 0.04, vertical: size.height * 0.016),
//             decoration: BoxDecoration(
//               color: isPending
//                   ? const Color(0xFFFF9B51).withOpacity(0.06)
//                   : Colors.white,
//               borderRadius: BorderRadius.circular(size.width * 0.04),
//               border: Border.all(
//                 color: isPending
//                     ? const Color(0xFFFF9B51).withOpacity(0.3)
//                     : Colors.transparent,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: size.width * 0.02)
//               ],
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: size.width * 0.1,
//                   height: size.width * 0.1,
//                   decoration: BoxDecoration(
//                     color: isPending
//                         ? const Color(0xFFFF9B51).withOpacity(0.15)
//                         : const Color(0xFF1B8A5A).withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     isPending ? Icons.pending_rounded : Icons.check_rounded,
//                     color: isPending ? const Color(0xFFFF9B51) : const Color(0xFF1B8A5A),
//                     size: size.width * 0.05,
//                   ),
//                 ),
//                 SizedBox(width: size.width * 0.035),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(item['name']!,
//                           style: TextStyle(
//                               color: const Color(0xFF25343F),
//                               fontSize: size.width * 0.035,
//                               fontWeight: FontWeight.w700)),
//                       Text('${item['card']}  •  ${item['items']}',
//                           style: TextStyle(
//                               color: const Color(0xFFBFC9D1),
//                               fontSize: size.width * 0.028)),
//                     ],
//                   ),
//                 ),
//                 Text(item['time']!,
//                     style: TextStyle(
//                         color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildBottomNav(Size size, EdgeInsets pad) {
//     final items = [
//       {'icon': Icons.dashboard_rounded, 'label': 'Home'},
//       {'icon': Icons.qr_code_scanner_rounded, 'label': 'Scan'},
//       {'icon': Icons.people_rounded, 'label': 'Beneficiary'},
//       {'icon': Icons.inventory_2_rounded, 'label': 'Stock'},
//       {'icon': Icons.more_horiz_rounded, 'label': 'More'},
//     ];
//     return Container(
//       padding: EdgeInsets.only(bottom: pad.bottom + size.height * 0.008, top: size.height * 0.01),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//               color: const Color(0xFF25343F).withOpacity(0.08),
//               blurRadius: size.width * 0.06,
//               offset: Offset(0, -size.height * 0.004))
//         ],
//       ),
//       child: Row(
//         children: List.generate(items.length, (i) {
//           final sel = i == _navIndex;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _navIndex = i),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       padding: EdgeInsets.all(sel ? size.width * 0.02 : 0),
//                       decoration: BoxDecoration(
//                         color: sel ? const Color(0xFFFF9B51).withOpacity(0.12) : Colors.transparent,
//                         borderRadius: BorderRadius.circular(size.width * 0.03),
//                       ),
//                       child: Icon(
//                         items[i]['icon'] as IconData,
//                         color: sel ? const Color(0xFFFF9B51) : const Color(0xFFBFC9D1),
//                         size: size.width * 0.058,
//                       ),
//                     ),
//                     SizedBox(height: size.height * 0.004),
//                     Text(
//                       items[i]['label'] as String,
//                       style: TextStyle(
//                         color: sel ? const Color(0xFFFF9B51) : const Color(0xFFBFC9D1),
//                         fontSize: size.width * 0.025,
//                         fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }




























import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'shop_receive_shipment.dart';
import 'shop_beneficiary_verification.dart';
import 'shop_distribute_ration.dart';
import 'shop_stock_management.dart';
import 'shop_restitution.dart';
import 'shop_complaints.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});
  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnim;
  late AnimationController _pulseAnim;
  late AnimationController _cardAnim;

  final List<Map<String, dynamic>> _stockItems = [
    {'name': 'Rice', 'qty': 1840.0, 'max': 2700.0, 'unit': 'kg', 'color': const Color(0xFF1B8A5A), 'icon': '🌾'},
    {'name': 'Wheat', 'qty': 920.0, 'max': 2200.0, 'unit': 'kg', 'color': const Color(0xFFD4891A), 'icon': '🌿'},
    {'name': 'Sugar', 'qty': 180.0, 'max': 1000.0, 'unit': 'kg', 'color': const Color(0xFFEF5350), 'icon': '🍬'},
    {'name': 'Dal', 'qty': 640.0, 'max': 800.0, 'unit': 'kg', 'color': const Color(0xFFBFC9D1), 'icon': '🫘'},
    {'name': 'Oil', 'qty': 310.0, 'max': 500.0, 'unit': 'L', 'color': const Color(0xFFFF9B51), 'icon': '🫙'},
  ];

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
    _pulseAnim = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _cardAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _pulseAnim.dispose();
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
        body: Column(
          children: [
            _buildHeader(size, pad),
            Expanded(child: _buildBody(size)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(Size size, EdgeInsets pad) {
    return AnimatedBuilder(
      animation: _headerAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -30 * (1 - _headerAnim.value)),
        child: Opacity(opacity: _headerAnim.value, child: child),
      ),
      child: Container(
        width: size.width,
        padding: EdgeInsets.only(
          top: pad.top + size.height * 0.018,
          left: size.width * 0.055,
          right: size.width * 0.055,
          bottom: size.height * 0.025,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF25343F),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(size.width * 0.075),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF25343F).withOpacity(0.5),
              blurRadius: size.width * 0.08,
              offset: Offset(0, size.height * 0.015),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildShopAvatar(size),
                SizedBox(width: size.width * 0.035),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RATION SHOP DEALER',
                        style: TextStyle(
                          color: const Color(0xFFFF9B51),
                          fontSize: size.width * 0.028,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: size.height * 0.004),
                      Text(
                        'RS-2024-0341 • Anna Nagar',
                        style: TextStyle(
                          color: const Color(0xFFEAEFEF),
                          fontSize: size.width * 0.042,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildNotifBell(size),
                SizedBox(width: size.width * 0.025),
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
            _buildTopStats(size),
          ],
        ),
      ),
    );
  }

  Widget _buildShopAvatar(Size size) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) => Container(
        width: size.width * 0.13,
        height: size.width * 0.13,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9B51), Color(0xFFFF6B35)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF9B51)
                  .withOpacity(0.3 + 0.2 * _pulseAnim.value),
              blurRadius: size.width * 0.06,
              spreadRadius: size.width * 0.005 * _pulseAnim.value,
            ),
          ],
        ),
        child: Icon(Icons.storefront_rounded,
            color: Colors.white, size: size.width * 0.065),
      ),
    );
  }

  Widget _buildNotifBell(Size size) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.022),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(size.width * 0.025),
          ),
          child: Icon(Icons.notifications_rounded,
              color: const Color(0xFFEAEFEF), size: size.width * 0.048),
        ),
        Positioned(
          right: size.width * 0.008,
          top: size.width * 0.008,
          child: Container(
            width: size.width * 0.025,
            height: size.width * 0.025,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9B51),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('3',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.02,
                      fontWeight: FontWeight.w800)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopStats(Size size) {
    final stats = [
      {'label': 'Trust Score', 'value': '94%', 'icon': Icons.verified_rounded, 'color': const Color(0xFF4CAF50)},
      {'label': 'Distributed', 'value': '148', 'icon': Icons.people_rounded, 'color': const Color(0xFFFF9B51)},
      {'label': 'Pending', 'value': '3', 'icon': Icons.pending_actions_rounded, 'color': const Color(0xFFEF5350)},
      {'label': 'Restitution', 'value': '2', 'icon': Icons.gavel_rounded, 'color': const Color(0xFFBFC9D1)},
    ];
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.016,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.asMap().entries.map((e) {
          final s = e.value;
          final isLast = e.key == stats.length - 1;
          return Row(
            children: [
              Column(
                children: [
                  Icon(s['icon'] as IconData,
                      color: s['color'] as Color, size: size.width * 0.048),
                  SizedBox(height: size.height * 0.005),
                  Text(s['value'] as String,
                      style: TextStyle(
                          color: s['color'] as Color,
                          fontSize: size.width * 0.038,
                          fontWeight: FontWeight.w900)),
                  Text(s['label'] as String,
                      style: TextStyle(
                          color: const Color(0xFFBFC9D1),
                          fontSize: size.width * 0.024)),
                ],
              ),
              if (!isLast) ...[
                SizedBox(width: size.width * 0.04),
                Container(
                    width: 1,
                    height: size.height * 0.055,
                    color: Colors.white.withOpacity(0.12)),
                SizedBox(width: size.width * 0.04),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Body
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildBody(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        size.width * 0.055,
        size.height * 0.025,
        size.width * 0.055,
        size.height * 0.015,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Stock Status', size),
          SizedBox(height: size.height * 0.015),
          _buildStockScroll(size),
          SizedBox(height: size.height * 0.028),
          _sectionLabel('Quick Actions', size),
          SizedBox(height: size.height * 0.015),
          _buildActionGrid(size),
          SizedBox(height: size.height * 0.028),
          _buildIncomingShipmentCard(size),
          SizedBox(height: size.height * 0.028),
          _sectionLabel("Today's Activity", size),
          SizedBox(height: size.height * 0.015),
          _buildActivityFeed(size),
          SizedBox(height: size.height * 0.02),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, Size size) {
    return Row(
      children: [
        Container(
          width: size.width * 0.01,
          height: size.height * 0.024,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9B51),
            borderRadius: BorderRadius.circular(size.width * 0.005),
          ),
        ),
        SizedBox(width: size.width * 0.03),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF25343F),
            fontSize: size.width * 0.048,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildStockScroll(Size size) {
    return SizedBox(
      height: size.height * 0.16,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _stockItems.length,
        itemBuilder: (_, i) {
          final item = _stockItems[i];
          final ratio = (item['qty'] as double) / (item['max'] as double);
          final isLow = ratio < 0.25;
          final color = isLow ? const Color(0xFFEF5350) : item['color'] as Color;

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 400 + i * 100),
            curve: Curves.easeOutCubic,
            builder: (_, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(
                  offset: Offset(0, 20 * (1 - v)), child: child),
            ),
            child: GestureDetector(
              onTap: () => _navigate(const ShopStockManagementPage()),
              child: Container(
                width: size.width * 0.34,
                margin: EdgeInsets.only(right: size.width * 0.03),
                padding: EdgeInsets.all(size.width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.055),
                  border: Border.all(
                    color: isLow
                        ? const Color(0xFFEF5350).withOpacity(0.4)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.12),
                      blurRadius: size.width * 0.04,
                      offset: Offset(0, size.height * 0.006),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['icon'] as String,
                            style: TextStyle(fontSize: size.width * 0.055)),
                        if (isLow)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02,
                                vertical: size.height * 0.003),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF5350).withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02),
                            ),
                            child: Text('LOW',
                                style: TextStyle(
                                    color: const Color(0xFFEF5350),
                                    fontSize: size.width * 0.022,
                                    fontWeight: FontWeight.w800)),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'] as String,
                            style: TextStyle(
                                color: const Color(0xFF25343F),
                                fontSize: size.width * 0.036,
                                fontWeight: FontWeight.w800)),
                        Text(
                            '${(item['qty'] as double).toInt()} ${item['unit']}',
                            style: TextStyle(
                                color: color,
                                fontSize: size.width * 0.032,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: size.height * 0.006),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(size.width * 0.01),
                          child: LinearProgressIndicator(
                            value: ratio,
                            backgroundColor: color.withOpacity(0.12),
                            valueColor: AlwaysStoppedAnimation(color),
                            minHeight: size.height * 0.007,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
        'label': 'Receive\nShipment',
        'icon': Icons.download_rounded,
        'color': const Color(0xFF1B8A5A),
        'bg': const Color(0xFFE8F5E9),
        'page': const ShopReceiveShipmentPage(),
      },
      {
        'label': 'Verify\nBeneficiary',
        'icon': Icons.person_search_rounded,
        'color': const Color(0xFF2E6DA4),
        'bg': const Color(0xFFE3F2FD),
        'page': const ShopBeneficiaryVerificationPage(),
      },
      {
        'label': 'Distribute\nRation',
        'icon': Icons.volunteer_activism_rounded,
        'color': const Color(0xFFFF9B51),
        'bg': const Color(0xFFFFF3E0),
        'page': const ShopDistributeRationPage(),
      },
      {
        'label': 'Stock\nManagement',
        'icon': Icons.inventory_2_rounded,
        'color': const Color(0xFF7B5EA7),
        'bg': const Color(0xFFF3E5F5),
        'page': const ShopStockManagementPage(),
      },
      {
        'label': 'Restitution\nCases',
        'icon': Icons.gavel_rounded,
        'color': const Color(0xFFFF6B35),
        'bg': const Color(0xFFFFF3E0),
        'page': const ShopRestitutionPage(),
      },
      {
        'label': 'Raise\nComplaint',
        'icon': Icons.report_problem_rounded,
        'color': const Color(0xFFEF5350),
        'bg': const Color(0xFFFFEBEE),
        'page': const ShopComplaintsPage(),
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
          duration: Duration(milliseconds: 500 + i * 80),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.12,
                    height: size.width * 0.12,
                    decoration: BoxDecoration(
                      color: a['bg'] as Color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(a['icon'] as IconData,
                        color: a['color'] as Color, size: size.width * 0.058),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    a['label'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF25343F),
                      fontSize: size.width * 0.028,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncomingShipmentCard(Size size) {
    return GestureDetector(
      onTap: () => _navigate(const ShopReceiveShipmentPage()),
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) => Container(
          padding: EdgeInsets.all(size.width * 0.05),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF25343F), Color(0xFF1A2E3D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size.width * 0.055),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF25343F)
                    .withOpacity(0.3 + 0.1 * _pulseAnim.value),
                blurRadius: size.width * 0.06,
                offset: Offset(0, size.height * 0.01),
              ),
            ],
          ),
          child: child,
        ),
        child: Row(
          children: [
            Container(
              width: size.width * 0.15,
              height: size.width * 0.15,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9B51).withOpacity(0.15),
                borderRadius: BorderRadius.circular(size.width * 0.04),
              ),
              child: Icon(Icons.local_shipping_rounded,
                  color: const Color(0xFFFF9B51), size: size.width * 0.08),
            ),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Incoming Shipment',
                      style: TextStyle(
                          color: const Color(0xFFBFC9D1),
                          fontSize: size.width * 0.03,
                          letterSpacing: 0.8)),
                  SizedBox(height: size.height * 0.004),
                  Text('SH-2024-0892',
                      style: TextStyle(
                          color: const Color(0xFFEAEFEF),
                          fontSize: size.width * 0.042,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: size.height * 0.004),
                  Text('Rice 800kg • Wheat 400kg • Sugar 200kg',
                      style: TextStyle(
                          color: const Color(0xFFBFC9D1),
                          fontSize: size.width * 0.028)),
                  SizedBox(height: size.height * 0.008),
                  Row(
                    children: [
                      Container(
                        width: size.width * 0.02,
                        height: size.width * 0.02,
                        decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50), shape: BoxShape.circle),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text('En route • ETA ~2 hrs',
                          style: TextStyle(
                              color: const Color(0xFF4CAF50),
                              fontSize: size.width * 0.03,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.qr_code_scanner_rounded,
                    color: const Color(0xFFFF9B51), size: size.width * 0.07),
                SizedBox(height: size.height * 0.006),
                Text('Scan',
                    style: TextStyle(
                        color: const Color(0xFFFF9B51),
                        fontSize: size.width * 0.025,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityFeed(Size size) {
    final items = [
      {'name': 'Karthikeyan M', 'card': 'RC-0012', 'items': 'Rice 5kg, Sugar 1kg', 'time': '10:24 AM', 'status': 'done'},
      {'name': 'Meena S', 'card': 'RC-0088', 'items': 'Rice 5kg, Dal 2kg', 'time': '10:12 AM', 'status': 'done'},
      {'name': 'Ramesh P', 'card': 'RC-0215', 'items': 'Wheat 5kg, Sugar 1kg', 'time': '9:58 AM', 'status': 'done'},
      {'name': 'Lakshmi D', 'card': 'RC-0099', 'items': 'Restitution due', 'time': '—', 'status': 'pending'},
    ];
    return Column(
      children: items.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        final isPending = item['status'] == 'pending';
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + i * 80),
          builder: (_, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(
                  offset: Offset(-20 * (1 - v), 0), child: child)),
          child: Container(
            margin: EdgeInsets.only(bottom: size.height * 0.012),
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.016),
            decoration: BoxDecoration(
              color: isPending
                  ? const Color(0xFFFF9B51).withOpacity(0.06)
                  : Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.04),
              border: Border.all(
                color: isPending
                    ? const Color(0xFFFF9B51).withOpacity(0.3)
                    : Colors.transparent,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: size.width * 0.02)
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: size.width * 0.1,
                  height: size.width * 0.1,
                  decoration: BoxDecoration(
                    color: isPending
                        ? const Color(0xFFFF9B51).withOpacity(0.15)
                        : const Color(0xFF1B8A5A).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPending ? Icons.pending_rounded : Icons.check_rounded,
                    color: isPending
                        ? const Color(0xFFFF9B51)
                        : const Color(0xFF1B8A5A),
                    size: size.width * 0.05,
                  ),
                ),
                SizedBox(width: size.width * 0.035),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name']!,
                          style: TextStyle(
                              color: const Color(0xFF25343F),
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.w700)),
                      Text('${item['card']}  •  ${item['items']}',
                          style: TextStyle(
                              color: const Color(0xFFBFC9D1),
                              fontSize: size.width * 0.028)),
                    ],
                  ),
                ),
                Text(item['time']!,
                    style: TextStyle(
                        color: const Color(0xFFBFC9D1),
                        fontSize: size.width * 0.028)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}