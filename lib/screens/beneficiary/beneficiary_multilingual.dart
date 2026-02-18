import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BeneficiaryMultilingualPage extends StatefulWidget {
  const BeneficiaryMultilingualPage({super.key});
  @override
  State<BeneficiaryMultilingualPage> createState() =>
      _BeneficiaryMultilingualPageState();
}

class _BeneficiaryMultilingualPageState extends State<BeneficiaryMultilingualPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnim;
  String _selectedLang = 'en';
  bool _saved = false;

  final List<Map<String, dynamic>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'native': 'English',
      'flag': '🇬🇧',
      'sample': 'Your monthly ration quota is ready.',
    },
    {
      'code': 'ta',
      'name': 'Tamil',
      'native': 'தமிழ்',
      'flag': '🇮🇳',
      'sample': 'உங்கள் மாதாந்திர ரேஷன் ஒதுக்கீடு தயாராக உள்ளது.',
    },
    {
      'code': 'hi',
      'name': 'Hindi',
      'native': 'हिन्दी',
      'flag': '🇮🇳',
      'sample': 'आपका मासिक राशन कोटा तैयार है।',
    },
    {
      'code': 'te',
      'name': 'Telugu',
      'native': 'తెలుగు',
      'flag': '🇮🇳',
      'sample': 'మీ నెలవారీ రేషన్ కోటా సిద్ధంగా ఉంది.',
    },
    {
      'code': 'kn',
      'name': 'Kannada',
      'native': 'ಕನ್ನಡ',
      'flag': '🇮🇳',
      'sample': 'ನಿಮ್ಮ ಮಾಸಿಕ ರೇಷನ್ ಕೋಟಾ ಸಿದ್ಧವಾಗಿದೆ.',
    },
    {
      'code': 'ml',
      'name': 'Malayalam',
      'native': 'മലയാളം',
      'flag': '🇮🇳',
      'sample': 'നിങ്ങളുടെ മാസിക റേഷൻ ക്വാട്ട തയ്യാറാണ്.',
    },
  ];

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

  Map<String, dynamic> get _currentLang =>
      _languages.firstWhere((l) => l['code'] == _selectedLang);

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
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                  size.width * 0.055,
                  size.height * 0.025,
                  size.width * 0.055,
                  size.height * 0.03),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildPreviewCard(size),
                SizedBox(height: size.height * 0.025),
                Text('Select Language',
                    style: TextStyle(
                        color: const Color(0xFF25343F),
                        fontSize: size.width * 0.044,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: size.height * 0.015),
                ..._languages.asMap().entries.map((e) {
                  final lang = e.value;
                  final sel = lang['code'] == _selectedLang;
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 400 + e.key * 70),
                    curve: Curves.easeOutCubic,
                    builder: (_, v, child) => Opacity(
                        opacity: v,
                        child: Transform.translate(
                            offset: Offset(-20 * (1 - v), 0), child: child)),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _selectedLang = lang['code'] as String;
                        _saved = false;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(bottom: size.height * 0.012),
                        padding: EdgeInsets.all(size.width * 0.045),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFF25343F) : Colors.white,
                          borderRadius: BorderRadius.circular(size.width * 0.045),
                          border: sel
                              ? Border.all(
                                  color: const Color(0xFFFF9B51).withOpacity(0.5),
                                  width: 1.5)
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
                        child: Row(children: [
                          Text(lang['flag'] as String,
                              style: TextStyle(fontSize: size.width * 0.065)),
                          SizedBox(width: size.width * 0.04),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lang['name'] as String,
                                      style: TextStyle(
                                          color: sel
                                              ? const Color(0xFFEAEFEF)
                                              : const Color(0xFF25343F),
                                          fontSize: size.width * 0.038,
                                          fontWeight: FontWeight.w800)),
                                  Text(lang['native'] as String,
                                      style: TextStyle(
                                          color: sel
                                              ? const Color(0xFFBFC9D1)
                                              : const Color(0xFFBFC9D1),
                                          fontSize: size.width * 0.03)),
                                ]),
                          ),
                          if (sel)
                            Container(
                              width: size.width * 0.07,
                              height: size.width * 0.07,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9B51).withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.check_rounded,
                                  color: const Color(0xFFFF9B51),
                                  size: size.width * 0.035),
                            ),
                        ]),
                      ),
                    ),
                  );
                }),
                SizedBox(height: size.height * 0.025),
                _buildNotificationToggle(size),
                SizedBox(height: size.height * 0.025),
                GestureDetector(
                  onTap: () => setState(() => _saved = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFFFF9B51), Color(0xFFFF6B35)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(size.width * 0.045),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFFFF9B51).withOpacity(0.4),
                            blurRadius: size.width * 0.06,
                            offset: Offset(0, size.height * 0.01))
                      ],
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(
                        _saved ? Icons.check_rounded : Icons.save_rounded,
                        color: Colors.white,
                        size: size.width * 0.05,
                      ),
                      SizedBox(width: size.width * 0.025),
                      Text(
                        _saved ? 'Saved!' : 'Save Language Preference',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.038,
                            fontWeight: FontWeight.w800),
                      ),
                    ]),
                  ),
                ),
              ]),
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
              Text('Language Settings',
                  style: TextStyle(
                      color: const Color(0xFFEAEFEF),
                      fontSize: size.width * 0.048,
                      fontWeight: FontWeight.w900)),
              Text('Choose your preferred language',
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
            ]),
          ),
          Text(_currentLang['flag'] as String,
              style: TextStyle(fontSize: size.width * 0.07)),
        ]),
      ),
    );
  }

  Widget _buildPreviewCard(Size size) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0, 0.15), end: Offset.zero)
                  .animate(anim),
              child: child)),
      child: Container(
        key: ValueKey(_selectedLang),
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF25343F), Color(0xFF1A2E3D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(size.width * 0.055),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF25343F).withOpacity(0.3),
                blurRadius: size.width * 0.06,
                offset: Offset(0, size.height * 0.01))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(_currentLang['flag'] as String,
                style: TextStyle(fontSize: size.width * 0.05)),
            SizedBox(width: size.width * 0.025),
            Text('Preview — ${_currentLang['name']}',
                style: TextStyle(
                    color: const Color(0xFFBFC9D1),
                    fontSize: size.width * 0.028,
                    letterSpacing: 0.5)),
          ]),
          SizedBox(height: size.height * 0.014),
          Container(
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(size.width * 0.035),
            ),
            child: Row(children: [
              Icon(Icons.notifications_rounded,
                  color: const Color(0xFFFF9B51), size: size.width * 0.045),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Text(_currentLang['sample'] as String,
                    style: TextStyle(
                        color: const Color(0xFFEAEFEF),
                        fontSize: size.width * 0.032,
                        height: 1.4)),
              ),
            ]),
          ),
          SizedBox(height: size.height * 0.012),
          Text(
              'All notifications, alerts and app content will appear in ${_currentLang['name']}.',
              style: TextStyle(
                  color: const Color(0xFFBFC9D1).withOpacity(0.7),
                  fontSize: size.width * 0.026)),
        ]),
      ),
    );
  }

  bool _smsEnabled = true;
  bool _pushEnabled = true;

  Widget _buildNotificationToggle(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.05),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: size.width * 0.03)
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Notification Preferences',
            style: TextStyle(
                color: const Color(0xFF25343F),
                fontSize: size.width * 0.038,
                fontWeight: FontWeight.w800)),
        SizedBox(height: size.height * 0.015),
        _toggleRow('SMS Alerts', 'Receive ration & shipment alerts via SMS',
            _smsEnabled, (v) => setState(() => _smsEnabled = v), size),
        SizedBox(height: size.height * 0.012),
        Container(height: 1, color: const Color(0xFFEAEFEF)),
        SizedBox(height: size.height * 0.012),
        _toggleRow('Push Notifications', 'Receive alerts in the app',
            _pushEnabled, (v) => setState(() => _pushEnabled = v), size),
      ]),
    );
  }

  Widget _toggleRow(String title, String subtitle, bool value,
      ValueChanged<bool> onChanged, Size size) {
    return Row(children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  color: const Color(0xFF25343F),
                  fontSize: size.width * 0.034,
                  fontWeight: FontWeight.w700)),
          Text(subtitle,
              style: TextStyle(
                  color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
        ]),
      ),
      Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFF9B51),
        activeTrackColor: const Color(0xFFFF9B51).withOpacity(0.25),
        inactiveThumbColor: const Color(0xFFBFC9D1),
        inactiveTrackColor: const Color(0xFFEAEFEF),
      ),
    ]);
  }
}
