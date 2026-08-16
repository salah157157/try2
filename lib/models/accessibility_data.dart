import 'package:flutter/material.dart';

class VisualStep {
  final String stepNumber;
  final String title;
  final String description;
  final String noiseLevel;
  final IconData icon;

  const VisualStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.noiseLevel,
    required this.icon,
  });
}

class AccessibilityFacility {
  final String title;
  final String description;
  final String location;
  final IconData icon;

  const AccessibilityFacility({
    required this.title,
    required this.description,
    required this.location,
    required this.icon,
  });
}

// نموذج طلب المرافق والكرسي
class AssistanceRequest {
  final String passengerName;
  final String flightNumber;
  final String assistanceType; // كرسي متحرك / مرافق بصري / مرافق ذهني
  final String notes;

  AssistanceRequest({
    required this.passengerName,
    required this.flightNumber,
    required this.assistanceType,
    this.notes = '',
  });
}