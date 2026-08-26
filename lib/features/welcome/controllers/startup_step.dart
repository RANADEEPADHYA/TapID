import 'package:flutter/material.dart';

class StartupStep {
  const StartupStep({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final IconData icon;
}