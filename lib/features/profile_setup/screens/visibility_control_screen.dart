import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'social_links_screen.dart';

class VisibilityControlScreen extends StatefulWidget {
  const VisibilityControlScreen({
    super.key,
    required this.links,
    required this.onBack,
    required this.onContinue,
    required this.onSaveForLater,
  });

  /// Social links received from Step 2.
  final List<SocialLink> links;

  final VoidCallback onBack;

  /// Returns each link's visibility setting.
  final ValueChanged<Map<String, bool>> onContinue;

  final VoidCallback onSaveForLater;

  @override
  State<VisibilityControlScreen> createState() =>
      _VisibilityControlScreenState();
}

class _VisibilityControlScreenState
    extends State<VisibilityControlScreen> {
  late List<SocialLink> _links;
  late List<bool> _visibility;

  @override
  void initState() {
    super.initState();

    _links = List<SocialLink>.from(widget.links);

    // All links are public by default.
    // Change this to false if you prefer privacy by default.
    _visibility = List<bool>.filled(
      _links.length,
      true,
    );
  }

  // ----------------------------------------------------------
  // TOGGLE VISIBILITY
  // ----------------------------------------------------------

  void _toggleVisibility(int index, bool value) {
    setState(() {
      _visibility[index] = value;
    });
  }

  // ----------------------------------------------------------
  // CONTINUE
  // ----------------------------------------------------------

  void _continue() {
    final Map<String, bool> visibilitySettings = {};

    for (int i = 0; i < _links.length; i++) {
      visibilitySettings[_links[i].title] = _visibility[i];
    }

    widget.onContinue(
      Map<String, bool>.unmodifiable(visibilitySettings),
    );
  }

  // ----------------------------------------------------------
  // MAIN UI
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FF),
      body: Stack(
        children: [
          const Positioned.fill(
            child: _VisibilityBackground(),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      28,
                    ),
                    child: Column(
                      children: [
                        const _ProfileProgressIndicator(),
                        const SizedBox(height: 30),
                        _buildMainCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // APP BAR
  // ----------------------------------------------------------

  Widget _buildAppBar() {
    return SizedBox(
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 20,
            child: Material(
              color: AppColors.white,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: widget.onBack,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 54,
                  height: 54,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 28,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          const Text(
            'Visibility Control',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // MAIN CARD
  // ----------------------------------------------------------

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        22,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.white,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Choose what others can see',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              height: 1.3,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 16,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: 'You’re in control. ',
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text:
                  'Show or hide each field on your TapID profile.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Visibility list.
          _buildVisibilityList(),

          const SizedBox(height: 20),

          // Privacy information.
          const _PrivacyInformationCard(),

          const SizedBox(height: 20),

          // Continue button.
          _buildContinueButton(),

          const SizedBox(height: 16),

          // Save for later.
          TextButton(
            onPressed: widget.onSaveForLater,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryPurple,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
              ),
            ),
            child: const Text(
              'Save for later',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // VISIBILITY LIST
  // ----------------------------------------------------------

  Widget _buildVisibilityList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.purple100,
          width: 1.2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        itemCount: _links.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEDEDF5),
          );
        },
        itemBuilder: (context, index) {
          return _buildVisibilityTile(index);
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // VISIBILITY TILE
  // ----------------------------------------------------------

  Widget _buildVisibilityTile(int index) {
    final SocialLink link = _links[index];
    final bool isPublic = _visibility[index];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      child: Row(
        children: [
          // Social platform icon.
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: link.backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              link.icon,
              color: link.color,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          // Link title and value.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  link.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  link.value.trim().isEmpty
                      ? 'Not added'
                      : link.value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Public / Hidden status.
          _VisibilityBadge(isPublic: isPublic),

          const SizedBox(width: 8),

          // Visibility switch.
          _VisibilitySwitch(
            value: isPublic,
            onChanged: (value) {
              _toggleVisibility(index, value);
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CONTINUE BUTTON
  // ----------------------------------------------------------

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 76,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryPurple,
            AppColors.primaryPurple600,
            AppColors.primaryPurple800,
          ],
        ),
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(
              alpha: 0.18,
            ),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _continue,
          borderRadius: BorderRadius.circular(19),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 24),
              Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// PUBLIC / HIDDEN BADGE
// ==================================================================

class _VisibilityBadge extends StatelessWidget {
  const _VisibilityBadge({
    required this.isPublic,
  });

  final bool isPublic;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isPublic
        ? const Color(0xFFEAF9EF)
        : const Color(0xFFF1F2F7);

    final Color foregroundColor = isPublic
        ? const Color(0xFF16803D)
        : AppColors.textPrimary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        isPublic ? 'Public' : 'Hidden',
        style: TextStyle(
          color: foregroundColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ==================================================================
// CUSTOM ANIMATED SWITCH
// ==================================================================

class _VisibilitySwitch extends StatelessWidget {
  const _VisibilitySwitch({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: value ? 'Public' : 'Hidden',
      toggled: value,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          width: 58,
          height: 34,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient: value
                ? const LinearGradient(
              colors: [
                AppColors.primaryPurple,
                AppColors.primaryPurple600,
              ],
            )
                : null,
            color: value ? null : const Color(0xFFE4E5EC),
            borderRadius: BorderRadius.circular(30),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: value
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(
                      alpha: 0.12,
                    ),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// PROFILE PROGRESS INDICATOR — STEP 3
// ==================================================================

class _ProfileProgressIndicator extends StatelessWidget {
  const _ProfileProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              _step(completed: true),
              const Expanded(
                child: _ProgressLine(active: true),
              ),
              _step(completed: true),
              const Expanded(
                child: _ProgressLine(active: true),
              ),
              _step(number: '3', active: true),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Social Links',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Visibility',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _step({
    String number = '1',
    bool active = false,
    bool completed = false,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: active || completed
            ? AppColors.primaryPurple
            : const Color(0xFFE9EAF0),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: completed
          ? const Icon(
        Icons.check_rounded,
        color: AppColors.white,
        size: 24,
      )
          : Text(
        number,
        style: TextStyle(
          color: active
              ? AppColors.white
              : AppColors.textTertiary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    this.active = false,
  });

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E6ED),
        borderRadius: BorderRadius.circular(10),
      ),
      child: active
          ? Container(
        decoration: BoxDecoration(
          color: AppColors.primaryPurple,
          borderRadius: BorderRadius.circular(10),
        ),
      )
          : null,
    );
  }
}

// ==================================================================
// PRIVACY INFORMATION CARD
// ==================================================================

class _PrivacyInformationCard extends StatelessWidget {
  const _PrivacyInformationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purple50,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.purple100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              size: 30,
              color: AppColors.primaryPurple,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your privacy matters',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Hidden items won’t be visible on your '
                      'TapID profile. You can change this anytime.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// BACKGROUND
// ==================================================================

class _VisibilityBackground extends StatelessWidget {
  const _VisibilityBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF2F2FF),
                Color(0xFFF7F9FF),
                Color(0xFFFCFCFF),
              ],
            ),
          ),
          child: SizedBox.expand(),
        ),
        Positioned(
          top: -130,
          left: -150,
          child: _circle(
            330,
            AppColors.primaryPurple.withValues(alpha: 0.045),
          ),
        ),
        Positioned(
          top: 280,
          right: -190,
          child: _circle(
            360,
            AppColors.primaryBlue.withValues(alpha: 0.035),
          ),
        ),
      ],
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}