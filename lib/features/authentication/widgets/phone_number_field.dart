import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.focusNode,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {


  /// AVAILABLE COUNTRIES
  final List<Country> _countries = const [
    Country(
      name: 'India',
      code: '+91',
      flag: '🇮🇳',
      maxLength: 10,
    ),
    Country(
      name: 'United States',
      code: '+1',
      flag: '🇺🇸',
      maxLength: 10,
    ),
    Country(
      name: 'Canada',
      code: '+1',
      flag: '🇨🇦',
      maxLength: 10,
    ),
    Country(
      name: 'United Kingdom',
      code: '+44',
      flag: '🇬🇧',
      maxLength: 10,
    ),
    Country(
      name: 'Australia',
      code: '+61',
      flag: '🇦🇺',
      maxLength: 9,
    ),
    Country(
      name: 'Germany',
      code: '+49',
      flag: '🇩🇪',
      maxLength: 11,
    ),
    Country(
      name: 'France',
      code: '+33',
      flag: '🇫🇷',
      maxLength: 9,
    ),
    Country(
      name: 'Japan',
      code: '+81',
      flag: '🇯🇵',
      maxLength: 10,
    ),
    Country(
      name: 'Singapore',
      code: '+65',
      flag: '🇸🇬',
      maxLength: 8,
    ),
    Country(
      name: 'United Arab Emirates',
      code: '+971',
      flag: '🇦🇪',
      maxLength: 9,
    ),
    Country(
      name: 'Saudi Arabia',
      code: '+966',
      flag: '🇸🇦',
      maxLength: 9,
    ),
    Country(
      name: 'Bangladesh',
      code: '+880',
      flag: '🇧🇩',
      maxLength: 10,
    ),
    Country(
      name: 'Nepal',
      code: '+977',
      flag: '🇳🇵',
      maxLength: 10,
    ),
    Country(
      name: 'Pakistan',
      code: '+92',
      flag: '🇵🇰',
      maxLength: 10,
    ),
    Country(
      name: 'Sri Lanka',
      code: '+94',
      flag: '🇱🇰',
      maxLength: 9,
    ),
  ];

  /// SELECTED COUNTRY
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries.first;
    widget.focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  /// COUNTRY PICKER
  Future<void> _showCountryPicker() async {
    final Country? selected = await showModalBottomSheet<Country>(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return _CountryPickerSheet(
          countries: _countries,
          selectedCountry: _selectedCountry,
        );
      },
    );

    if (selected == null) return;

    setState(() {
      _selectedCountry = selected;
    });

    /// Keep cursor inside phone field
    widget.focusNode.requestFocus();
  }


  @override
  Widget build(BuildContext context) {
    final bool isFocused = widget.focusNode.hasFocus;
    return Container(
      width: double.infinity,
      height: 65,

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFocused
              ? AppColors.primaryPurple1
              : AppColors.textTertiary.withValues(
            alpha: 0.35,
          ),
          width: isFocused ? 2 : 1.5,
        ),
      ),

      child: Row(
        children: [

          /// ═══════════════════════════════════════════════════
          /// COUNTRY SELECTOR
          InkWell(
            onTap: _showCountryPicker,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// FLAG
                  Text(
                    _selectedCountry.flag,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),

                  const SizedBox(width: 5),

                  /// COUNTRY CODE
                  Text(
                    _selectedCountry.code,
                    style: GoogleFonts.roboto(
                      color: AppColors.darkBlue950,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  /// ARROW
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.darkBlue950,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          /// DIVIDER
          Container(
            margin: const EdgeInsets.fromLTRB(
              0, // left
              0, // top
              5, // right
              0, // bottom
            ),
            width: 1.5,
            height: 42,
            color: AppColors.textSecondary.withValues(
              alpha: 0.35,
            ),
          ),

          /// PHONE INPUT
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,

              keyboardType: TextInputType.phone,

              maxLength: _selectedCountry.maxLength,

              style: GoogleFonts.roboto(
                color: AppColors.darkBlue950,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),

              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,

                hintText: 'Enter your mobile number',

                hintStyle: GoogleFonts.roboto(
                  color: AppColors.textTertiary,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),

                contentPadding: const EdgeInsets.only(
                  right: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// COUNTRY MODEL
class Country {
  const Country({
    required this.name,
    required this.code,
    required this.flag,
    required this.maxLength,
  });

  final String name;
  final String code;
  final String flag;
  final int maxLength;
}

/// COUNTRY PICKER SHEET
class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({
    required this.countries,
    required this.selectedCountry,
  });
  final List<Country> countries;
  final Country selectedCountry;
  @override
  State<_CountryPickerSheet> createState() =>
      _CountryPickerSheetState();
}

class _CountryPickerSheetState
    extends State<_CountryPickerSheet> {
  late List<Country> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
  }

  void _searchCountries(String query) {
    final String search = query.toLowerCase().trim();
    setState(() {
      if (search.isEmpty) {
        _filteredCountries = widget.countries;
      } else {
        _filteredCountries = widget.countries.where((country) {
          return country.name.toLowerCase().contains(search) ||
              country.code.contains(search);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.78,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          14,
          20,
          20,
        ),
        child: Column(
          children: [

            /// HANDLE
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(
                  alpha: 0.35,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            Row(
              children: [
                const Spacer(),

                Text(
                  'Select Country',
                  style: GoogleFonts.roboto(
                    color: AppColors.darkBlue950,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const Spacer(),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// SEARCH
            TextField(
              onChanged: _searchCountries,
              decoration: InputDecoration(
                hintText: 'Search country',

                hintStyle: GoogleFonts.roboto(
                  color: AppColors.textTertiary,
                ),

                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryPurple,
                ),

                filled: true,
                fillColor: AppColors.purple50,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// COUNTRY LIST
            Expanded(
              child: ListView.separated(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,

                itemCount: _filteredCountries.length,

                separatorBuilder: (_, __) {
                  return Divider(
                    height: 1,
                    color: AppColors.textSecondary.withValues(
                      alpha: 0.12,
                    ),
                  );
                },

                itemBuilder: (context, index) {
                  final Country country =
                  _filteredCountries[index];

                  final bool isSelected = country.name == widget.selectedCountry.name;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 3,
                    ),

                    onTap: () {
                      Navigator.pop(
                        context,
                        country,
                      );
                    },

                    leading: Text(
                      country.flag,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),

                    title: Text(
                      country.name,
                      style: GoogleFonts.roboto(
                        color: AppColors.darkBlue950,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text(
                          country.code,
                          style: GoogleFonts.roboto(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(width: 10),

                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primaryPurple,
                            size: 22,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}