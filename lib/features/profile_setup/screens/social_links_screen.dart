import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SocialLink {
  const SocialLink({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    this.isRequired = false,
    this.isCustom = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final bool isRequired;
  final bool isCustom;

  SocialLink copyWith({
    String? title,
    String? value,
    IconData? icon,
    Color? color,
    Color? backgroundColor,
  }) {
    return SocialLink(
      title: title ?? this.title,
      value: value ?? this.value,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isRequired: isRequired,
      isCustom: isCustom,
    );
  }
}

class SocialLinksScreen extends StatefulWidget {
  const SocialLinksScreen({
    super.key,
    required this.initialPhoneNumber,
    required this.onContinue,
    required this.onBack,
    required this.onSkip,
  });

  final String initialPhoneNumber;

  /// Passes the saved links to the next profile creation step.
  final ValueChanged<List<SocialLink>> onContinue;

  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  State<SocialLinksScreen> createState() =>
      _SocialLinksScreenState();
}

class _SocialLinksScreenState extends State<SocialLinksScreen> {
  late List<SocialLink> _links;

  @override
  void initState() {
    super.initState();

    _links = [
      SocialLink(
        title: 'Phone Number',
        value: widget.initialPhoneNumber,
        icon: Icons.call_rounded,
        color: AppColors.primaryPurple,
        backgroundColor: AppColors.purple50,
        isRequired: true,
      ),
      const SocialLink(
        title: 'WhatsApp',
        value: '',
        icon: Icons.chat_rounded,
        color: Color(0xFF16B85B),
        backgroundColor: Color(0xFFE8FAEC),
      ),
      const SocialLink(
        title: 'Instagram',
        value: '',
        icon: Icons.camera_alt_rounded,
        color: Color(0xFFE1306C),
        backgroundColor: Color(0xFFF7F0FA),
      ),
      const SocialLink(
        title: 'Facebook',
        value: '',
        icon: Icons.facebook_rounded,
        color: Color(0xFF1877F2),
        backgroundColor: Color(0xFFEDF5FF),
      ),
      const SocialLink(
        title: 'X (Twitter)',
        value: '',
        icon: Icons.close_rounded,
        color: AppColors.black,
        backgroundColor: Color(0xFFF1F2F4),
      ),
      const SocialLink(
        title: 'LinkedIn',
        value: '',
        icon: Icons.work_rounded,
        color: Color(0xFF0A66C2),
        backgroundColor: Color(0xFFEDF5FF),
      ),
      const SocialLink(
        title: 'Telegram',
        value: '',
        icon: Icons.send_rounded,
        color: Color(0xFF229ED9),
        backgroundColor: Color(0xFFEDF6FF),
      ),
      const SocialLink(
        title: 'Email',
        value: '',
        icon: Icons.mail_outline_rounded,
        color: AppColors.primaryPurple,
        backgroundColor: AppColors.purple50,
      ),
      const SocialLink(
        title: 'Website',
        value: '',
        icon: Icons.language_rounded,
        color: AppColors.primaryPurple,
        backgroundColor: AppColors.purple50,
      ),
    ];
  }

  // ----------------------------------------------------------
  // EDIT LINK
  // ----------------------------------------------------------

  Future<void> _editLink(int index) async {
    final current = _links[index];

    final updated = await _showLinkDialog(
      title: current.title,
      initialValue: current.value,
      isRequired: current.isRequired,
      isCustom: current.isCustom,
    );

    if (!mounted || updated == null) return;

    setState(() {
      _links[index] = current.copyWith(
        title: updated.title,
        value: updated.value,
      );
    });
  }

  // ----------------------------------------------------------
  // ADD CUSTOM LINK
  // ----------------------------------------------------------

  Future<void> _addLink() async {
    final newLink = await _showLinkDialog(
      title: '',
      initialValue: '',
      isRequired: false,
      isCustom: true,
    );

    if (!mounted || newLink == null) return;

    setState(() {
      _links.add(
        SocialLink(
          title: newLink.title,
          value: newLink.value,
          icon: Icons.link_rounded,
          color: AppColors.primaryPurple,
          backgroundColor: AppColors.purple50,
          isCustom: true,
        ),
      );
    });
  }

  // ----------------------------------------------------------
  // LINK EDITOR DIALOG
  // ----------------------------------------------------------

  Future<SocialLink?> _showLinkDialog({
    required String title,
    required String initialValue,
    required bool isRequired,
    required bool isCustom,
  }) async {
    final formKey = GlobalKey<FormState>();

    final titleController = TextEditingController(text: title);
    final valueController = TextEditingController(
      text: initialValue,
    );

    final result = await showDialog<SocialLink>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Text(
            isCustom
                ? 'Add social link'
                : 'Edit ${title.isEmpty ? 'link' : title}',
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCustom) ...[
                    TextFormField(
                      controller: titleController,
                      maxLength: 30,
                      textCapitalization:
                      TextCapitalization.words,
                      decoration: _dialogDecoration(
                        'Link name',
                        Icons.label_outline_rounded,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Enter a link name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: valueController,
                    keyboardType: _keyboardTypeFor(title),
                    textCapitalization:
                    TextCapitalization.none,
                    autocorrect: false,
                    decoration: _dialogDecoration(
                      _hintFor(title),
                      _iconFor(title),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';

                      if (isRequired && text.isEmpty) {
                        return 'This field is required';
                      }

                      if (text.isNotEmpty &&
                          title.toLowerCase() == 'email' &&
                          !RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(text)) {
                        return 'Enter a valid email address';
                      }

                      if (text.isNotEmpty &&
                          title.toLowerCase() == 'website' &&
                          !text.contains('.')) {
                        return 'Enter a valid website';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                final newTitle = isCustom
                    ? titleController.text.trim()
                    : title;

                Navigator.pop(
                  dialogContext,
                  SocialLink(
                    title: newTitle,
                    value: valueController.text.trim(),
                    icon: _iconFor(newTitle),
                    color: AppColors.primaryPurple,
                    backgroundColor: AppColors.purple50,
                    isRequired: isRequired,
                    isCustom: isCustom,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    valueController.dispose();

    return result;
  }

  InputDecoration _dialogDecoration(
      String hint,
      IconData icon,
      ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: AppColors.primaryPurple,
      ),
      filled: true,
      fillColor: const Color(0xFFF9F8FF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.purple100,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.purple100,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.primaryPurple,
          width: 1.5,
        ),
      ),
    );
  }

  TextInputType _keyboardTypeFor(String title) {
    switch (title.toLowerCase()) {
      case 'phone number':
      case 'whatsapp':
        return TextInputType.phone;
      case 'email':
        return TextInputType.emailAddress;
      case 'website':
        return TextInputType.url;
      default:
        return TextInputType.text;
    }
  }

  String _hintFor(String title) {
    switch (title.toLowerCase()) {
      case 'phone number':
      case 'whatsapp':
        return '+91 98765 43210';
      case 'instagram':
        return 'Instagram username';
      case 'facebook':
        return 'Facebook username or URL';
      case 'x (twitter)':
        return 'X username';
      case 'linkedin':
        return 'LinkedIn profile URL';
      case 'telegram':
        return 'Telegram username';
      case 'email':
        return 'you@example.com';
      case 'website':
        return 'https://yourwebsite.com';
      default:
        return 'Enter link or username';
    }
  }

  IconData _iconFor(String title) {
    switch (title.toLowerCase()) {
      case 'phone number':
        return Icons.call_rounded;
      case 'whatsapp':
        return Icons.chat_rounded;
      case 'instagram':
        return Icons.camera_alt_rounded;
      case 'facebook':
        return Icons.facebook_rounded;
      case 'x (twitter)':
        return Icons.close_rounded;
      case 'linkedin':
        return Icons.work_rounded;
      case 'telegram':
        return Icons.send_rounded;
      case 'email':
        return Icons.mail_outline_rounded;
      case 'website':
        return Icons.language_rounded;
      default:
        return Icons.link_rounded;
    }
  }

  // ----------------------------------------------------------
  // REMOVE LINK
  // ----------------------------------------------------------

  Future<void> _removeLink(int index) async {
    final link = _links[index];

    if (link.isRequired) return;

    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Remove link?'),
        content: Text(
          'Are you sure you want to remove ${link.title}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (!mounted || shouldRemove != true) return;

    setState(() {
      _links.removeAt(index);
    });
  }

  // ----------------------------------------------------------
  // CONTINUE
  // ----------------------------------------------------------

  void _continue() {
    final phoneLink = _links.firstWhere(
          (link) => link.isRequired,
    );

    if (phoneLink.value.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your phone number is required.'),
        ),
      );
      return;
    }

    // Return a copy so callers cannot mutate this screen's list.
    widget.onContinue(List<SocialLink>.unmodifiable(_links));
  }

  // ----------------------------------------------------------
  // MAIN UI
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF),
      body: Stack(
        children: [
          const Positioned.fill(
            child: _SocialBackground(),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
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
                        const _SocialProgressIndicator(),
                        const SizedBox(height: 30),
                        _buildContentCard(),
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
  // TOP BAR
  // ----------------------------------------------------------

  Widget _buildTopBar() {
    return SizedBox(
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
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
                      size: 29,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Text(
            'Add Social Links',
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
  // CONTENT CARD
  // ----------------------------------------------------------

  Widget _buildContentCard() {
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
      ),
      child: Column(
        children: [
          const Text(
            'Add your contact methods',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              height: 1.3,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.7,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add, edit or remove your social links and\n'
                'let others connect with you easily.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),

          // Social link list.
          ListView.separated(
            itemCount: _links.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) =>
            const SizedBox(height: 2),
            itemBuilder: (context, index) {
              return _buildLinkTile(index);
            },
          ),

          const SizedBox(height: 18),

          _buildAddLinkButton(),

          const SizedBox(height: 22),

          _buildContinueButton(),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SOCIAL LINK TILE
  // ----------------------------------------------------------

  Widget _buildLinkTile(int index) {
    final link = _links[index];

    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.purple100,
          width: 1.3,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: link.backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              link.icon,
              size: 32,
              color: link.color,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      link.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (link.isRequired)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.purple50,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Text(
                          'Required',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  link.value.isEmpty
                      ? 'Add ${link.title.toLowerCase()}'
                      : link.value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          if (!link.isRequired && link.isCustom)
            IconButton(
              onPressed: () => _removeLink(index),
              tooltip: 'Remove link',
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFE91E63),
                size: 25,
              ),
            )
          else
            IconButton(
              onPressed: () => _editLink(index),
              tooltip: 'Edit ${link.title}',
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.primaryPurple,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ADD ANOTHER LINK
  // ----------------------------------------------------------

  Widget _buildAddLinkButton() {
    return SizedBox(
      width: double.infinity,
      height: 72,
      child: OutlinedButton(
        onPressed: _addLink,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryPurple,
          side: const BorderSide(
            color: AppColors.purple300,
            width: 1.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 25,
            ),
            SizedBox(width: 12),
            Text(
              'Add Another Link',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // CONTINUE BUTTON
  // ----------------------------------------------------------

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 78,
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple
                .withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _continue,
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
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
                  size: 28,
                  color: AppColors.white,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// PROGRESS INDICATOR — STEP 2
// ==================================================================

class _SocialProgressIndicator extends StatelessWidget {
  const _SocialProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              _stepCircle(
                completed: true,
              ),
              const Expanded(
                child: _ProgressLine(active: true),
              ),
              _stepCircle(
                number: '2',
                active: true,
              ),
              const Expanded(
                child: _ProgressLine(),
              ),
              _stepCircle(number: '3'),
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
                    fontWeight: FontWeight.w600,
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

  Widget _stepCircle({
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
      child: Icon(
        completed ? Icons.check_rounded : null,
        color: AppColors.white,
        size: 24,
      ),
    )._withNumber(number, active, completed);
  }
}

extension on Container {
  Widget _withNumber(
      String number,
      bool active,
      bool completed,
      ) {
    if (completed) return this;

    return Stack(
      alignment: Alignment.center,
      children: [
        this,
        Text(
          number,
          style: TextStyle(
            color: active
                ? AppColors.white
                : AppColors.textTertiary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
// BACKGROUND
// ==================================================================

class _SocialBackground extends StatelessWidget {
  const _SocialBackground();

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
                Color(0xFFF1F1FF),
                Color(0xFFF6F9FF),
                Color(0xFFFDFDFF),
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
          top: 260,
          right: -180,
          child: _circle(
            340,
            AppColors.primaryBlue.withValues(alpha: 0.04),
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