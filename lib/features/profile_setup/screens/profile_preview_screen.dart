import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class ProfilePreviewScreen extends StatefulWidget {
  const ProfilePreviewScreen({
    super.key,
    this.onBack,
    this.onEditVisibility,
    this.onEditProfile,
    this.onShareProfile,
    this.onOpenPublicPage,
    this.onGoToDashboard,
  });

  final VoidCallback? onBack;
  final VoidCallback? onEditVisibility;
  final VoidCallback? onEditProfile;
  final VoidCallback? onShareProfile;
  final VoidCallback? onOpenPublicPage;
  final VoidCallback? onGoToDashboard;

  @override
  State<ProfilePreviewScreen> createState() =>
      _ProfilePreviewScreenState();
}

class _ProfilePreviewScreenState
    extends State<ProfilePreviewScreen> {
  String _selectedPreset = 'Friend';

  final List<String> _presets = const [
    'Friend',
    'Work',
    'Family',
    'Recruiter',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  20,
                ),
                child: Column(
                  children: [
                    _buildViewerControls(),

                    const SizedBox(height: 24),

                    _buildProfileCard(),

                    const SizedBox(height: 24),

                    _buildQuickActions(),

                    const SizedBox(height: 20),

                    _buildDashboardButton(),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  'Profile Preview',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: _IconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: widget.onBack ??
                            () => Navigator.of(context).maybePop(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'This is how others will see your profile.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // VIEWER PRESET CONTROLS
  // ------------------------------------------------------------

  Widget _buildViewerControls() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.purple100,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(
                    alpha: 0.04,
                  ),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  size: 21,
                  color: AppColors.primaryPurple,
                ),

                const SizedBox(width: 10),

                const Text(
                  'Viewing as:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPreset,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textPrimary,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      dropdownColor: AppColors.white,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPurple,
                      ),
                      items: _presets.map((preset) {
                        return DropdownMenuItem<String>(
                          value: preset,
                          child: Text(
                            preset,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _selectedPreset = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        SizedBox(
          height: 54,
          child: OutlinedButton.icon(
            onPressed: widget.onEditVisibility,
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
            ),
            label: const Text(
              'Edit Visibility',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryPurple,
              backgroundColor: AppColors.white,
              side: const BorderSide(
                color: AppColors.primaryPurple,
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // PROFILE CARD
  // ------------------------------------------------------------

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.purple100,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(
              alpha: 0.055,
            ),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileBanner(),

          Transform.translate(
            offset: const Offset(0, -66),
            child: Column(
              children: [
                _buildAvatar(),

                const SizedBox(height: 24),

                _buildProfileIdentity(),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Column(
                    children: [
                      _SocialLinkTile(
                        icon: Icons.call_rounded,
                        title: 'Phone',
                        subtitle: '+91 98765 43210',
                        iconColor: AppColors.primaryPurple,
                        iconBackground: AppColors.purple50,
                        trailing: const Icon(
                          Icons.call_rounded,
                          color: AppColors.primaryPurple,
                          size: 21,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _SocialLinkTile(
                        icon: Icons.chat_rounded,
                        title: 'WhatsApp',
                        subtitle: '+91 98765 43210',
                        iconColor: const Color(0xFF16B85B),
                        iconBackground: const Color(0xFFEAFBF0),
                        trailing: const Icon(
                          Icons.chat_rounded,
                          color: Color(0xFF16B85B),
                          size: 23,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _SocialLinkTile(
                        icon: Icons.camera_alt_rounded,
                        title: 'Instagram',
                        subtitle: '@rohan.sharma',
                        iconColor: const Color(0xFFE1306C),
                        iconBackground: AppColors.purple50,
                        trailing: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.primaryPurple,
                          size: 23,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _SocialLinkTile(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        subtitle: 'rohan.sharma@gmail.com',
                        iconColor: AppColors.primaryPurple,
                        iconBackground: AppColors.purple50,
                        trailing: const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.primaryPurple,
                          size: 23,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _SocialLinkTile(
                        icon: Icons.work_rounded,
                        title: 'LinkedIn',
                        subtitle: 'linkedin.com/in/rohan-sharma',
                        iconColor: const Color(0xFF0A83C9),
                        iconBackground: AppColors.primaryBlue50,
                        trailing: const Icon(
                          Icons.work_rounded,
                          color: Color(0xFF0A83C9),
                          size: 23,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _SocialLinkTile(
                        icon: Icons.language_rounded,
                        title: 'Website',
                        subtitle: 'www.rohansharma.dev',
                        iconColor: AppColors.primaryPurple,
                        iconBackground: AppColors.purple50,
                        trailing: const Icon(
                          Icons.open_in_new_rounded,
                          color: AppColors.primaryPurple,
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: _buildPrivacyNotice(),
                ),
              ],
            ),
          ),

          // Compensates for the avatar's upward overlap.
          const SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget _buildProfileBanner() {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.purple100,
            AppColors.primaryBlue50,
            AppColors.skyBlue100,
          ],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -45,
            right: -20,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(
                  alpha: 0.28,
                ),
              ),
            ),
          ),

          Positioned(
            left: -45,
            bottom: -90,
            child: Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryPurple.withValues(
                  alpha: 0.06,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 164,
          width: 164,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(
              color: AppColors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(
                  alpha: 0.12,
                ),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const CircleAvatar(
            backgroundColor: Color(0xFFE8E8E8),
            child: Icon(
              Icons.person_rounded,
              size: 100,
              color: AppColors.textTertiary,
            ),
          ),
        ),

        Positioned(
          right: 0,
          bottom: 2,
          child: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF16B85B),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white,
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.white,
              size: 23,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileIdentity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Rohan Sharma',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.7,
                  ),
                ),
              ),

              const SizedBox(width: 7),

              const Icon(
                Icons.verified_rounded,
                color: AppColors.primaryPurple,
                size: 23,
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            '@rohan.sharma',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryPurple,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Designing digital experiences & building '
                'products that make a difference.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PRIVACY NOTICE
  // ------------------------------------------------------------

  Widget _buildPrivacyNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purple50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.purple100,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.purple100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.primaryPurple,
              size: 29,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This is your public view',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Only information you’ve made visible '
                      'is shown here.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // QUICK ACTIONS
  // ------------------------------------------------------------

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.edit_outlined,
            label: 'Edit Profile',
            onTap: widget.onEditProfile,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _QuickActionCard(
            icon: Icons.share_outlined,
            label: 'Share Profile',
            onTap: widget.onShareProfile,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _QuickActionCard(
            icon: Icons.open_in_new_rounded,
            label: 'Open Public Page',
            onTap: widget.onOpenPublicPage,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardButton() {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradient,
          borderRadius: BorderRadius.circular(17),
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
        child: ElevatedButton(
          onPressed: widget.onGoToDashboard,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.transparent,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Go to Home Dashboard',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(width: 14),

              Icon(
                Icons.arrow_forward_rounded,
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REUSABLE SOCIAL LINK TILE
// ============================================================

class _SocialLinkTile extends StatelessWidget {
  const _SocialLinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.iconBackground,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBackground;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 76,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.purple100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 27,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          trailing,
        ],
      ),
    );
  }
}

// ============================================================
// REUSABLE QUICK ACTION CARD
// ============================================================

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 98,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: AppColors.purple100,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(
                  alpha: 0.035,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 25,
                color: AppColors.primaryPurple,
              ),

              const SizedBox(height: 9),

              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REUSABLE CIRCULAR HEADER BUTTON
// ============================================================

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 46,
          width: 46,
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: 25,
          ),
        ),
      ),
    );
  }
}