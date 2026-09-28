import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SharePresetsScreen extends StatefulWidget {
  const SharePresetsScreen({
    super.key,
    required this.onBack,
    required this.onContinue,
  });
  final VoidCallback onBack;
  final ValueChanged<SharePreset> onContinue;
  @override
  State<SharePresetsScreen> createState() => _SharePresetsScreenState();
}

// ============================================================
// SHARE PRESET MODEL
// ============================================================

class SharePreset {
  SharePreset({
    required this.id,
    required this.name,
    required this.description,
    required this.visibleFields,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    this.isActive = false,
  });

  final String id;
  String name;
  String description;
  int visibleFields;
  IconData icon;
  Color color;
  Color backgroundColor;
  bool isActive;

  SharePreset copyWith({
    String? id,
    String? name,
    String? description,
    int? visibleFields,
    IconData? icon,
    Color? color,
    Color? backgroundColor,
    bool? isActive,
  }) {
    return SharePreset(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      visibleFields: visibleFields ?? this.visibleFields,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      backgroundColor:
      backgroundColor ?? this.backgroundColor,
      isActive: isActive ?? this.isActive,
    );
  }
}

// ============================================================
// SCREEN
// ============================================================

class _SharePresetsScreenState
    extends State<SharePresetsScreen> {
  late List<SharePreset> _presets;

  @override
  void initState() {
    super.initState();

    _presets = [
      SharePreset(
        id: 'friend',
        name: 'Friend',
        description: 'Personal connections',
        visibleFields: 8,
        icon: Icons.people_alt_rounded,
        color: const Color(0xFF1684EF),
        backgroundColor: const Color(0xFFE8F2FF),
        isActive: true,
      ),
      SharePreset(
        id: 'work',
        name: 'Work',
        description: 'Colleagues & teammates',
        visibleFields: 6,
        icon: Icons.business_center_rounded,
        color: const Color(0xFF13B85A),
        backgroundColor: const Color(0xFFEAFBF0),
      ),
      SharePreset(
        id: 'family',
        name: 'Family',
        description: 'Close family members',
        visibleFields: 7,
        icon: Icons.home_rounded,
        color: const Color(0xFFFF8A16),
        backgroundColor: const Color(0xFFFFF3E8),
      ),
      SharePreset(
        id: 'recruiter',
        name: 'Recruiter',
        description: 'Jobs & opportunities',
        visibleFields: 5,
        icon: Icons.person_outline_rounded,
        color: AppColors.primaryPurple,
        backgroundColor: const Color(0xFFF2EAFE),
      ),
      SharePreset(
        id: 'custom',
        name: 'Custom',
        description: 'Create your own preset',
        visibleFields: 3,
        icon: Icons.star_outline_rounded,
        color: const Color(0xFF08B6C5),
        backgroundColor: const Color(0xFFE8FAF9),
      ),
    ];
  }

  // ==========================================================
  // PRESET ACTIONS
  // ==========================================================

  void _selectPreset(SharePreset preset) {
    setState(() {
      for (final item in _presets) {
        item.isActive = item.id == preset.id;
      }
    });
  }

  void _duplicatePreset(SharePreset preset) {
    final copy = preset.copyWith(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: '${preset.name} Copy',
      isActive: false,
    );

    setState(() {
      final index = _presets.indexOf(preset);
      _presets.insert(index + 1, copy);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${preset.name} preset duplicated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deletePreset(SharePreset preset) {
    if (_presets.length == 1) return;

    setState(() {
      _presets.remove(preset);

      if (preset.isActive) {
        _presets.first.isActive = true;
      }
    });
  }

  Future<void> _editPreset(SharePreset preset) async {
    final nameController =
    TextEditingController(text: preset.name);

    final descriptionController =
    TextEditingController(text: preset.description);

    int fieldCount = preset.visibleFields;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                'Edit preset',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dialogLabel('Preset name'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      maxLength: 30,
                      decoration: _inputDecoration(
                        'Enter preset name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _dialogLabel('Description'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLength: 70,
                      decoration: _inputDecoration(
                        'Add a description',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _dialogLabel('Visible fields'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: fieldCount > 0
                              ? () => setDialogState(
                                () => fieldCount--,
                          )
                              : null,
                          icon: const Icon(
                            Icons.remove_circle_outline,
                          ),
                        ),
                        Text(
                          '$fieldCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          onPressed: fieldCount < 9
                              ? () => setDialogState(
                                () => fieldCount++,
                          )
                              : null,
                          icon: const Icon(
                            Icons.add_circle_outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }

                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        preset.name = nameController.text.trim();
        preset.description =
            descriptionController.text.trim();
        preset.visibleFields = fieldCount;
      });
    }

    nameController.dispose();
    descriptionController.dispose();
  }

  Future<void> _createPreset() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    int fieldCount = 3;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                'Create new preset',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dialogLabel('Preset name'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      maxLength: 30,
                      decoration: _inputDecoration(
                        'e.g. Networking',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _dialogLabel('Description'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLength: 70,
                      decoration: _inputDecoration(
                        'Who is this preset for?',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _dialogLabel('Visible fields'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: fieldCount > 0
                              ? () => setDialogState(
                                () => fieldCount--,
                          )
                              : null,
                          icon: const Icon(
                            Icons.remove_circle_outline,
                          ),
                        ),
                        Text(
                          '$fieldCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          onPressed: fieldCount < 9
                              ? () => setDialogState(
                                () => fieldCount++,
                          )
                              : null,
                          icon: const Icon(
                            Icons.add_circle_outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }

                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && mounted) {
      final newPreset = SharePreset(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? 'Custom sharing preferences'
            : descriptionController.text.trim(),
        visibleFields: fieldCount,
        icon: Icons.star_rounded,
        color: AppColors.primaryPurple,
        backgroundColor: AppColors.purple100,
      );

      setState(() {
        _presets.add(newPreset);
        _selectPreset(newPreset);
      });
    }

    nameController.dispose();
    descriptionController.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FF),
      body: Stack(
        children: [
          const Positioned.fill(
            child: _SharePresetsBackground(),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      24,
                    ),
                    child: Column(
                      children: [
                        const _FourStepProgress(),
                        const SizedBox(height: 30),
                        _buildHeading(),
                        const SizedBox(height: 26),
                        _buildPresetList(),
                        const SizedBox(height: 14),
                        _buildCreatePresetCard(),
                        const SizedBox(height: 20),
                        const _PrivacyBanner(),
                        const SizedBox(height: 18),
                        _buildContinueButton(),
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

  // ==========================================================
  // APP BAR
  // ==========================================================

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
            'Share Presets',
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

  // ==========================================================
  // HEADING
  // ==========================================================

  Widget _buildHeading() {
    return const Column(
      children: [
        Text(
          'Create smart sharing presets',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            height: 1.3,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Choose who you’re sharing with and we’ll '
              'show the right information.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // PRESET LIST
  // ==========================================================

  Widget _buildPresetList() {
    return Column(
      children: [
        for (int i = 0; i < _presets.length; i++) ...[
          _PresetCard(
            preset: _presets[i],
            onUse: () => _selectPreset(_presets[i]),
            onDuplicate: () =>
                _duplicatePreset(_presets[i]),
            onEdit: () => _editPreset(_presets[i]),
            onDelete: () => _confirmDelete(_presets[i]),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Future<void> _confirmDelete(SharePreset preset) async {
    if (_presets.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one preset is required.'),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete preset?'),
        content: Text(
          'Are you sure you want to delete "${preset.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      _deletePreset(preset);
    }
  }

  // ==========================================================
  // CREATE PRESET CARD
  // ==========================================================

  Widget _buildCreatePresetCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _createPreset,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 22,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryPurple.withOpacity(0.45),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: AppColors.purple100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.primaryPurple,
                  size: 34,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create New Preset',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Customize a preset with specific '
                          'information you want to share.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 28,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CONTINUE
  // ==========================================================

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 74,
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
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final selected = _presets.firstWhere(
                  (preset) => preset.isActive,
              orElse: () => _presets.first,
            );

            widget.onContinue(selected);
          },
          borderRadius: BorderRadius.circular(18),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue to Preview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 22),
              Icon(
                Icons.arrow_forward_rounded,
                size: 27,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PRESET CARD
// ============================================================

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.preset,
    required this.onUse,
    required this.onDuplicate,
    required this.onEdit,
    required this.onDelete,
  });

  final SharePreset preset;
  final VoidCallback onUse;
  final VoidCallback onDuplicate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: AppColors.purple100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // On narrow screens, put actions below the details.
          final compact = constraints.maxWidth < 360;

          final details = Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: preset.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  preset.icon,
                  color: preset.color,
                  size: 31,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _PresetDetails(preset: preset),
              ),
            ],
          );

          final actions = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (preset.isActive)
                const _ActiveBadge()
              else
                _UseButton(onPressed: onUse),
              const SizedBox(width: 8),
              _IconActionButton(
                icon: Icons.copy_all_rounded,
                onTap: onDuplicate,
                tooltip: 'Duplicate',
              ),
              const SizedBox(width: 6),
              PopupMenuButton<String>(
                tooltip: 'More options',
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.primaryPurple,
                  size: 24,
                ),
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                    case 'duplicate':
                      onDuplicate();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: _MenuItem(
                      icon: Icons.edit_outlined,
                      label: 'Edit preset',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: _MenuItem(
                      icon: Icons.copy_rounded,
                      label: 'Duplicate',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: _MenuItem(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                details,
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: actions,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: details),
              const SizedBox(width: 8),
              actions,
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// PRESET DETAILS
// ============================================================

class _PresetDetails extends StatelessWidget {
  const _PresetDetails({
    required this.preset,
  });

  final SharePreset preset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          preset.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          preset.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            height: 1.3,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.purple50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  '${preset.visibleFields} fields visible',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              const Icon(
                Icons.visibility_rounded,
                size: 17,
                color: AppColors.primaryPurple,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ACTIVE BADGE
// ============================================================

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF9EF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Active',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF16803D),
        ),
      ),
    );
  }
}

// ============================================================
// USE BUTTON
// ============================================================

class _UseButton extends StatelessWidget {
  const _UseButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryPurple,
        side: const BorderSide(
          color: AppColors.purple200,
          width: 1.2,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        minimumSize: const Size(64, 42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Use',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============================================================
// ICON ACTION BUTTON
// ============================================================

class _IconActionButton extends StatelessWidget {
  const _IconActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.purple50,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(
              icon,
              size: 23,
              color: AppColors.primaryPurple,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MENU ITEM
// ============================================================

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.color = AppColors.textPrimary,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// FOUR-STEP PROGRESS INDICATOR
// ============================================================

class _FourStepProgress extends StatelessWidget {
  const _FourStepProgress();

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Profile',
      'Social Links',
      'Visibility',
      'Share Presets',
    ];

    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < 4; i++) ...[
              _ProgressStep(
                number: i + 1,
                completed: i < 3,
                active: i == 3,
              ),
              if (i != 3)
                const Expanded(
                  child: _ProgressLine(),
                ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 0; i < labels.length; i++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : 2,
                    right: i == 3 ? 0 : 2,
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: i == 3
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ProgressStep extends StatelessWidget {
  const _ProgressStep({
    required this.number,
    required this.completed,
    required this.active,
  });

  final int number;
  final bool completed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed || active
            ? AppColors.primaryPurple
            : const Color(0xFFE8E9F0),
      ),
      alignment: Alignment.center,
      child: completed
          ? const Icon(
        Icons.check_rounded,
        color: AppColors.white,
        size: 23,
      )
          : Text(
        '$number',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: active
              ? AppColors.white
              : AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

// ============================================================
// PRIVACY BANNER
// ============================================================

class _PrivacyBanner extends StatelessWidget {
  const _PrivacyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.purple50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: AppColors.purple100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: AppColors.primaryPurple,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You’re in control',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Presets help you share the right info '
                      'with the right people, every time.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.shield_outlined,
            size: 35,
            color: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BACKGROUND
// ============================================================

class _SharePresetsBackground extends StatelessWidget {
  const _SharePresetsBackground();

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
                Color(0xFFF8F9FF),
                Color(0xFFFCFCFF),
              ],
            ),
          ),
          child: SizedBox.expand(),
        ),
        Positioned(
          top: -120,
          left: -150,
          child: _circle(
            300,
            AppColors.primaryPurple.withOpacity(0.045),
          ),
        ),
        Positioned(
          top: 320,
          right: -200,
          child: _circle(
            350,
            AppColors.primaryBlue.withOpacity(0.035),
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

// ============================================================
// DIALOG HELPERS
// ============================================================

Widget _dialogLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: AppColors.textTertiary,
      fontSize: 14,
    ),
    filled: true,
    fillColor: const Color(0xFFFAFAFF),
    counterText: '',
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 14,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.purple200,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.primaryPurple,
        width: 1.5,
      ),
    ),
  );
}