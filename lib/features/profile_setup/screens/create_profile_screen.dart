import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_id/widgets/app_name.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/back_button.dart';
import '../widgets/profile_save_continue_button.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({
    super.key,
    required this.onContinue,
    required this.onSkip,
    this.onBack,
    this.onPickPhoto,
    this.onCheckUsername,
  });

  /// Called when the user saves their profile.
  final void Function({
  required String fullName,
  required String username,
  required String bio,
  }) onContinue;
  final VoidCallback onSkip;
  final VoidCallback? onBack;
  final VoidCallback? onPickPhoto;

  /// Connect this to your backend to check username availability.
  final Future<bool> Function(String username)? onCheckUsername;

  @override
  State<CreateProfileScreen> createState() =>
      _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isCheckingUsername = false;
  bool _isUsernameAvailable = false;
  bool _usernameChecked = false;

  bool get _isFormValid {
    return _nameController.text.trim().isNotEmpty &&
        _usernameController.text.trim().isNotEmpty;
  }

  String? _usernameMessage;

  static const int _maxNameLength = 50;
  static const int _maxBioLength = 120;

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // USERNAME VALIDATION
  // ----------------------------------------------------------

  String? _validateUsername(String? value) {
    final username = value?.trim() ?? '';

    if (username.isEmpty) {
      return 'Please choose a username';
    }

    if (username.length < 3 || username.length > 20) {
      return 'Username must contain 3–20 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Use only letters, numbers and underscores';
    }

    return null;
  }

  void _onUsernameChanged() {
    if (!mounted) return;

    setState(() {
      _usernameChecked = false;
      _isUsernameAvailable = false;
      _usernameMessage = null;
    });
  }

  Future<void> _checkUsername() async {
    final username = _usernameController.text.trim();

    final validationError = _validateUsername(username);

    if (validationError != null) {
      setState(() {
        _usernameChecked = false;
        _usernameMessage = validationError;
      });
      return;
    }

    if (widget.onCheckUsername == null) {
      setState(() {
        _usernameChecked = false;
        _usernameMessage =
        'Connect username availability to your backend.';
      });
      return;
    }

    setState(() {
      _isCheckingUsername = true;
      _usernameMessage = null;
      _usernameChecked = false;
    });

    try {
      final available =
      await widget.onCheckUsername!(username);

      if (!mounted) return;

      // Ignore a response if the username changed while checking.
      if (_usernameController.text.trim() != username) return;

      setState(() {
        _isCheckingUsername = false;
        _usernameChecked = true;
        _isUsernameAvailable = available;
        _usernameMessage = available
            ? 'Username is available!'
            : 'This username is already taken.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isCheckingUsername = false;
        _usernameChecked = false;
        _usernameMessage =
        'Could not check username. Please try again.';
      });
    }
  }

  // ----------------------------------------------------------
  // SAVE PROFILE
  // ----------------------------------------------------------

  void _saveAndContinue() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_usernameChecked || !_isUsernameAvailable) {
      setState(() {
        _usernameMessage =
        'Please check that your username is available.';
      });
      return;
    }

    widget.onContinue(
      fullName: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.background,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              /// Main content
              Column(
                children: [
                  const SizedBox(height: 20),

                  /// Top Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Profile',
                        style: GoogleFonts.roboto(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        28,
                      ),
                      child: Column(
                        children: [
                          const _ProfileProgressIndicator(),

                          const SizedBox(height: 30),

                          _buildProfileCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              /// Floating back button
              Positioned(
                top: 15,
                left: 20,
                child: AppBackButton(
                  size: 48,
                  iconSize: 24,
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// PROFILE FORM CARD
  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        32,
        20,
        24,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple
                .withValues(alpha: 0.035),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// Heading 1
            Text(
              'Let’s create your identity',
              style: GoogleFonts.roboto(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            /// Heading 2
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add a few details to get started with ',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                AppName(
                  tapColor: AppColors.black,
                  splitColor: true,
                  fontSize: 18,
                )
              ],
            ),
            const SizedBox(height: 20),

            _buildPhotoPicker(),

            const SizedBox(height: 10),

            /// Heading 3
            Column(
              children: [
                Text(
                  'Add profile photo',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                Text(
                  'JPG, PNG up to 5MB',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildFullNameField(),

            const SizedBox(height: 28),

            _buildUsernameField(),

            const SizedBox(height: 28),

            _buildBioField(),

            const SizedBox(height: 24),

            _buildPrivacyNotice(),

            const SizedBox(height: 24),

            ProfileSaveContinueButton(
              enabled: _isFormValid,
              onTap: _saveAndContinue,
              text: 'Save Profile',
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// PROFILE PHOTO
  Widget _buildPhotoPicker() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 184,
            height: 184,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 184,
                  height: 184,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.purple100,
                    border: Border.all(
                      color: AppColors.white,
                      width: 6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple
                            .withValues(alpha: 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.person_rounded,
                          size: 200,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  right: -2,
                  bottom: 0,
                  child: Material(
                    color: AppColors.primaryPurple,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: widget.onPickPhoto,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white,
                            width: 4,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 25,
                          color: AppColors.white,
                        ),
                      ),
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

  /// FULL NAME
  Widget _buildFullNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// TITLE
        _buildLabel('Full Name'),
        const SizedBox(height: 5),

        TextFormField(
          controller: _nameController,
          maxLength: _maxNameLength,
          /// Text style
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            letterSpacing: 0.2,
            height: 1.4,
          ),
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
              RegExp(r'[\n\r]'),
            ),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            if (value.trim().length < 2) {
              return 'Name must contain at least 2 characters';
            }
            return null;
          },
          decoration: _inputDecoration(
            hint: 'Enter your full name',
            prefixIcon: Icons.person_outline_rounded,
          ).copyWith(counterText: ''),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  /// USERNAME
  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// TITLE
        _buildLabel('Username'),
        const SizedBox(height: 5),

        TextFormField(
          controller: _usernameController,
          maxLength: _maxNameLength,
          /// Text style
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            letterSpacing: 0.2,
            height: 1.4,
          ),
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-Z0-9_]'),
            ),
          ],
          validator: _validateUsername,
          decoration: _inputDecoration(
            hint: 'Enter a unique username',
            prefixIcon: Icons.alternate_email_rounded,
            suffix: _buildUsernameCheckButton(),
          ).copyWith(counterText: ''),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            _usernameMessage ??
                'Username must be 3–20 characters and '
                    'contain letters, numbers or underscores.',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: _usernameChecked
                  ? (_isUsernameAvailable
                  ? Colors.green.shade700
                  : Colors.red.shade600)
                  : AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  /// USERNAME BUTTON
  Widget _buildUsernameCheckButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: TextButton(
        onPressed: _isCheckingUsername ? null : _checkUsername,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.purple50,
          foregroundColor: AppColors.primaryPurple,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: _isCheckingUsername
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryPurple,
          ),
        )
            : Text(
          'Check',
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  /// BIO
  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// TITLE
        _buildLabel('Bio (Optional)'),
        const SizedBox(height: 5),

        TextFormField(
          controller: _bioController,
          maxLength: _maxBioLength,
          maxLines: 4,
          minLines: 4,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.newline,
          decoration: _inputDecoration(
            hint: 'Tell us about yourself...',
            prefixIcon: Icons.edit_outlined,
            alignLabelWithHint: true,
            counter:
            '${_bioController.text.length}/$_maxBioLength',
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  /// PRIVACY NOTICE
  Widget _buildPrivacyNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.skyBlue100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.skyBlue300,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: AppColors.primaryBlue800,
              size: 28,
            ),
          ),

          const SizedBox(width: 10),


           Column(
             mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your profile helps people connect with you.',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'You can change these details anytime.',
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
           ),
        ],
      ),
    );
  }

  /// SHARED FORM STYLES
  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.roboto(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffix,
    String? counter,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.roboto(
        fontSize: 16,
        color: AppColors.textTertiary,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.redAccent,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: AppColors.textSecondary,
        size: 25,
      ),
      suffixIcon: suffix,
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: AppColors.white.withValues(alpha: 0.75),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: AppColors.purple100,
          width: 1.4,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: AppColors.purple100,
          width: 1.4,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: AppColors.primaryPurple,
          width: 1.7,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }
}

// ==================================================================
// THREE-STEP PROGRESS INDICATOR
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
              _stepCircle('1', active: true),

              const Expanded(
                child: _ProgressLine(active: true),
              ),

              _stepCircle('2'),

              const Expanded(
                child: _ProgressLine(),
              ),

              _stepCircle('3'),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  'Complete',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepCircle(
      String number, {
        bool active = false,
      }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? AppColors.primaryPurple
            : const Color(0xFFE9EAF0),
        boxShadow: active
            ? [
          BoxShadow(
            color: AppColors.primaryPurple
                .withValues(alpha: 0.20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
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
          ? Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradient,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      )
          : null,
    );
  }
}

// ==================================================================
// PROFILE AVATAR PLACEHOLDER
// ==================================================================

class _AvatarPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF0EDFF),
          Color(0xFFE3DEFF),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawCircle(
      center,
      size.width / 2,
      backgroundPaint,
    );

    final avatarPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFC9B9FF),
          Color(0xFF8B6CF2),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    // Head.
    canvas.drawCircle(
      Offset(center.dx, size.height * 0.37),
      size.width * 0.18,
      avatarPaint,
    );

    // Shoulders and torso.
    final bodyPath = Path()
      ..moveTo(size.width * 0.19, size.height * 0.91)
      ..lineTo(size.width * 0.19, size.height * 0.82)
      ..cubicTo(
        size.width * 0.19,
        size.height * 0.65,
        size.width * 0.35,
        size.height * 0.57,
        center.dx,
        size.height * 0.57,
      )
      ..cubicTo(
        size.width * 0.65,
        size.height * 0.57,
        size.width * 0.81,
        size.height * 0.65,
        size.width * 0.81,
        size.height * 0.82,
      )
      ..lineTo(size.width * 0.81, size.height * 0.91)
      ..close();

    canvas.drawPath(bodyPath, avatarPaint);
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}