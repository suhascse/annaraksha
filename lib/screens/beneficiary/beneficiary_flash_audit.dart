import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class BeneficiaryFlashAuditPage extends StatefulWidget {
  const BeneficiaryFlashAuditPage({super.key});
  @override
  State<BeneficiaryFlashAuditPage> createState() =>
      _BeneficiaryFlashAuditPageState();
}

class _BeneficiaryFlashAuditPageState extends State<BeneficiaryFlashAuditPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnim;
  late AnimationController _pulseAnim;
  late AnimationController _successAnim;

  int _step = 0; // 0=intro, 1=questions, 2=done
  int _questionIndex = 0;
  final Map<int, String> _answers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Was stock available at your assigned ration shop this month?',
      'options': ['Yes, fully available', 'Partially available', 'Not available'],
      'type': 'single',
    },
    {
      'question': 'Did you receive the correct quantity as per your entitlement?',
      'options': ['Yes, correct quantity', 'Received less', 'Received more', 'Not collected yet'],
      'type': 'single',
    },
    {
      'question': 'Was the quality of items satisfactory?',
      'options': ['Yes, good quality', 'Acceptable', 'Poor quality'],
      'type': 'single',
    },
    {
      'question': 'Were there any issues with the distribution process?',
      'options': ['No issues', 'Long waiting time', 'Rude behaviour', 'System failure'],
      'type': 'single',
    },
    {
      'question': 'Would you rate your overall experience this month?',
      'options': ['Excellent', 'Good', 'Average', 'Poor'],
      'type': 'rating',
    },
  ];

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _pulseAnim =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _successAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _pulseAnim.dispose();
    _successAnim.dispose();
    super.dispose();
  }

  void _nextQuestion(String answer) {
    setState(() {
      _answers[_questionIndex] = answer;
      if (_questionIndex < _questions.length - 1) {
        _questionIndex++;
      } else {
        _step = 2;
        _successAnim.forward();
      }
    });
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
          Expanded(
            child: _step == 0
                ? _buildIntro(size)
                : _step == 1
                    ? _buildQuestion(size)
                    : _buildSuccess(size),
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
              Text('Flash Audit',
                  style: TextStyle(
                      color: const Color(0xFFEAEFEF),
                      fontSize: size.width * 0.048,
                      fontWeight: FontWeight.w900)),
              Text('Community transparency check',
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.028)),
            ]),
          ),
          if (_step == 1)
            Text('${_questionIndex + 1} / ${_questions.length}',
                style: TextStyle(
                    color: const Color(0xFFFF9B51),
                    fontSize: size.width * 0.036,
                    fontWeight: FontWeight.w900)),
        ]),
      ),
    );
  }

  Widget _buildIntro(Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.055),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (_, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(offset: Offset(0, 30 * (1 - v)), child: child)),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(size.width * 0.06),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFFF9B51), Color(0xFFFF6B35)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(size.width * 0.06),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFFFF9B51).withOpacity(0.4),
                    blurRadius: size.width * 0.08,
                    offset: Offset(0, size.height * 0.015))
              ],
            ),
            child: Column(children: [
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, __) => Container(
                  width: size.width * 0.22,
                  height: size.width * 0.22,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15 + 0.1 * _pulseAnim.value),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.how_to_vote_rounded,
                      color: Colors.white, size: size.width * 0.1),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text('You\'re Selected!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.052,
                      fontWeight: FontWeight.w900)),
              SizedBox(height: size.height * 0.008),
              Text(
                'You have been randomly selected for a community flash audit. Your honest feedback helps improve the PDS system for everyone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: size.width * 0.031),
              ),
            ]),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Text('Why Flash Audits?',
            style: TextStyle(
                color: const Color(0xFF25343F),
                fontSize: size.width * 0.042,
                fontWeight: FontWeight.w900)),
        SizedBox(height: size.height * 0.015),
        ...[
          ['🔍', 'Verify stock accuracy', 'Ensures shops maintain correct stock levels'],
          ['⚖️', 'Detect anomalies', 'Identifies distribution irregularities early'],
          ['🤝', 'Community oversight', 'Gives beneficiaries a voice in the system'],
          ['🏆', 'Reward transparency', 'High audit scores improve shop trust ratings'],
        ].asMap().entries.map((e) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 500 + e.key * 100),
            curve: Curves.easeOutCubic,
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
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: size.width * 0.02)
                ],
              ),
              child: Row(children: [
                Text(e.value[0], style: TextStyle(fontSize: size.width * 0.05)),
                SizedBox(width: size.width * 0.04),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(e.value[1],
                        style: TextStyle(
                            color: const Color(0xFF25343F),
                            fontSize: size.width * 0.034,
                            fontWeight: FontWeight.w700)),
                    Text(e.value[2],
                        style: TextStyle(
                            color: const Color(0xFFBFC9D1), fontSize: size.width * 0.027)),
                  ]),
                ),
              ]),
            ),
          );
        }),
        SizedBox(height: size.height * 0.03),
        GestureDetector(
          onTap: () => setState(() => _step = 1),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            decoration: BoxDecoration(
              color: const Color(0xFF25343F),
              borderRadius: BorderRadius.circular(size.width * 0.045),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF25343F).withOpacity(0.3),
                    blurRadius: size.width * 0.06,
                    offset: Offset(0, size.height * 0.01))
              ],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.play_arrow_rounded,
                  color: const Color(0xFFFF9B51), size: size.width * 0.055),
              SizedBox(width: size.width * 0.025),
              Text('Start Audit',
                  style: TextStyle(
                      color: const Color(0xFFEAEFEF),
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w800)),
            ]),
          ),
        ),
        SizedBox(height: size.height * 0.015),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: size.height * 0.016),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.045),
            ),
            child: Text('Skip for Now',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xFFBFC9D1),
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }

  Widget _buildQuestion(Size size) {
    final q = _questions[_questionIndex];
    final options = q['options'] as List<String>;
    final isRating = q['type'] == 'rating';

    return Padding(
      padding: EdgeInsets.all(size.width * 0.055),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(size.width * 0.01),
          child: LinearProgressIndicator(
            value: (_questionIndex + 1) / _questions.length,
            backgroundColor: const Color(0xFFBFC9D1).withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation(Color(0xFFFF9B51)),
            minHeight: size.height * 0.008,
          ),
        ),
        SizedBox(height: size.height * 0.035),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: ValueKey(_questionIndex),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(size.width * 0.018),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9B51).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text('Q${_questionIndex + 1}',
                    style: TextStyle(
                        color: const Color(0xFFFF9B51),
                        fontSize: size.width * 0.032,
                        fontWeight: FontWeight.w900)),
              ),
              SizedBox(height: size.height * 0.018),
              Text(q['question'] as String,
                  style: TextStyle(
                      color: const Color(0xFF25343F),
                      fontSize: size.width * 0.042,
                      fontWeight: FontWeight.w900,
                      height: 1.35)),
              SizedBox(height: size.height * 0.03),
              if (isRating)
                _buildRatingOptions(options, size)
              else
                ...options.asMap().entries.map((e) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 300 + e.key * 80),
                    builder: (_, v, child) => Opacity(
                        opacity: v,
                        child: Transform.translate(
                            offset: Offset(0, 20 * (1 - v)), child: child)),
                    child: GestureDetector(
                      onTap: () => _nextQuestion(e.value),
                      child: Container(
                        margin: EdgeInsets.only(bottom: size.height * 0.014),
                        padding: EdgeInsets.all(size.width * 0.045),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(size.width * 0.045),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: size.width * 0.03,
                                offset: Offset(0, size.height * 0.006))
                          ],
                        ),
                        child: Row(children: [
                          Container(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9B51).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + e.key),
                                style: TextStyle(
                                    color: const Color(0xFFFF9B51),
                                    fontSize: size.width * 0.032,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.04),
                          Expanded(
                            child: Text(e.value,
                                style: TextStyle(
                                    color: const Color(0xFF25343F),
                                    fontSize: size.width * 0.035,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: const Color(0xFFBFC9D1), size: size.width * 0.035),
                        ]),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
        const Spacer(),
        if (_questionIndex > 0)
          GestureDetector(
            onTap: () => setState(() => _questionIndex--),
            child: Row(children: [
              Icon(Icons.arrow_back_rounded,
                  color: const Color(0xFFBFC9D1), size: size.width * 0.04),
              SizedBox(width: size.width * 0.015),
              Text('Previous',
                  style: TextStyle(
                      color: const Color(0xFFBFC9D1), fontSize: size.width * 0.032)),
            ]),
          ),
      ]),
    );
  }

  Widget _buildRatingOptions(List<String> options, Size size) {
    final icons = [
      Icons.sentiment_very_satisfied_rounded,
      Icons.sentiment_satisfied_rounded,
      Icons.sentiment_neutral_rounded,
      Icons.sentiment_dissatisfied_rounded,
    ];
    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF1B8A5A),
      const Color(0xFFFF9B51),
      const Color(0xFFEF5350),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.asMap().entries.map((e) {
        return GestureDetector(
          onTap: () => _nextQuestion(e.value),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 400 + e.key * 80),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Column(children: [
              Container(
                width: size.width * 0.16,
                height: size.width * 0.16,
                decoration: BoxDecoration(
                  color: colors[e.key].withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icons[e.key],
                    color: colors[e.key], size: size.width * 0.08),
              ),
              SizedBox(height: size.height * 0.008),
              Text(e.value,
                  style: TextStyle(
                      color: const Color(0xFF25343F),
                      fontSize: size.width * 0.026,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSuccess(Size size) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.elasticOut,
        builder: (_, v, child) => Transform.scale(scale: v, child: child),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.08),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Confetti-like dots
            SizedBox(
              height: size.height * 0.12,
              child: Stack(alignment: Alignment.center, children: [
                for (int i = 0; i < 8; i++)
                  Positioned(
                    left: size.width * 0.15 + (i % 4) * size.width * 0.12,
                    top: (i ~/ 4) * size.height * 0.06,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 400 + i * 80),
                      builder: (_, v, __) => Opacity(
                        opacity: v,
                        child: Container(
                          width: size.width * 0.03,
                          height: size.width * 0.03,
                          decoration: BoxDecoration(
                            color: [
                              const Color(0xFFFF9B51),
                              const Color(0xFF4CAF50),
                              const Color(0xFF2E6DA4),
                              const Color(0xFFEF5350),
                            ][i % 4],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: size.width * 0.28,
                  height: size.width * 0.28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFFF9B51), Color(0xFFFF6B35)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFFFF9B51).withOpacity(0.4),
                          blurRadius: size.width * 0.1)
                    ],
                  ),
                  child: Icon(Icons.how_to_vote_rounded,
                      color: Colors.white, size: size.width * 0.13),
                ),
              ]),
            ),
            SizedBox(height: size.height * 0.03),
            Text('Audit Submitted!',
                style: TextStyle(
                    color: const Color(0xFF25343F),
                    fontSize: size.width * 0.052,
                    fontWeight: FontWeight.w900)),
            SizedBox(height: size.height * 0.01),
            Text('Thank you for contributing to community transparency.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xFFBFC9D1), fontSize: size.width * 0.033)),
            SizedBox(height: size.height * 0.025),
            Container(
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.05),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: size.width * 0.04)
                ],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _auditStat('Responses', '${_answers.length}', const Color(0xFFFF9B51), size),
                Container(width: 1, height: size.height * 0.05, color: const Color(0xFFEAEFEF)),
                _auditStat('Audit ID', 'FA-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}', const Color(0xFF4CAF50), size),
              ]),
            ),
            SizedBox(height: size.height * 0.03),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.018),
                decoration: BoxDecoration(
                  color: const Color(0xFF25343F),
                  borderRadius: BorderRadius.circular(size.width * 0.045),
                ),
                child: Text('Back to Dashboard',
                    style: TextStyle(
                        color: const Color(0xFFFF9B51),
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.w800)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _auditStat(String label, String value, Color color, Size size) {
    return Column(children: [
      Text(value,
          style: TextStyle(
              color: color, fontSize: size.width * 0.038, fontWeight: FontWeight.w900)),
      Text(label,
          style: TextStyle(
              color: const Color(0xFFBFC9D1), fontSize: size.width * 0.026)),
    ]);
  }
}
