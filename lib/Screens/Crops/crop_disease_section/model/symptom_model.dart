class SymptomModels {
  List<String>? englishSymptoms;
  List<String>? hindiSymptoms;
  List<String>? malayalamSymptoms;
  List<String>? tamilSymptoms;
  List<String>? telunguSymptoms;

  // Constructor
  SymptomModels({
    this.englishSymptoms,
    this.hindiSymptoms,
    this.malayalamSymptoms,
    this.tamilSymptoms,
    this.telunguSymptoms,
  });

  // Factory method to create a SymptomModels instance from JSON (Map<String, dynamic>)
  factory SymptomModels.fromJson(Map<String, dynamic> json) {
    return SymptomModels(
      englishSymptoms: List<String>.from(json['englishSymptoms'] ?? []),
      hindiSymptoms: List<String>.from(json['hindiSymptoms'] ?? []),
      malayalamSymptoms: List<String>.from(json['malayalamSymptoms'] ?? []),
      tamilSymptoms: List<String>.from(json['tamilSymptoms'] ?? []),
      telunguSymptoms: List<String>.from(json['telunguSymptoms'] ?? []),
    );
  }

  // Method to convert the SymptomModels instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'englishSymptoms': englishSymptoms,
      'hindiSymptoms': hindiSymptoms,
      'malayalamSymptoms': malayalamSymptoms,
      'tamilSymptoms': tamilSymptoms,
      'telunguSymptoms': telunguSymptoms,
    };
  }
}
