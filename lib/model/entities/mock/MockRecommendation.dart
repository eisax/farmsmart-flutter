import 'package:farmsmart_flutter/model/entities/mock/mock_crop_catalog.dart';

const _factorScores = {
  'hi': 10.0,
  'med': 5.0,
  'lo': 0.0,
};

Map<String, double> _weights({
  double skill = 0.34,
  double location = 0.33,
  double agrozone = 0.33,
}) =>
    {
      'Skill Level': skill,
      'Location': location,
      'Agrozone': agrozone,
    };

Map<String, Map<String, double>> _factors() => {
      'Skill Level': Map<String, double>.from(_factorScores),
      'Location': Map<String, double>.from(_factorScores),
      'Agrozone': Map<String, double>.from(_factorScores),
    };

/// Match weights per crop (higher = better fit for default mock farmer profile).
final harryWeights = {
  for (final crop in MockCropCatalog.all)
    crop.name: _weights(
      skill: _skillWeight(crop.name),
      location: _locationWeight(crop.name),
      agrozone: _agroWeight(crop.name),
    ),
  'max': _weights(skill: 1.0, location: 1.0, agrozone: 1.0),
};

final harryInputFactors = {
  for (final crop in MockCropCatalog.all) crop.name: _factors(),
  'max': _factors(),
};

/// Factor option ids must match keys in [_factorScores] (hi / med / lo).
final plotInfo = {
  'Skill Level': {
    'id': 'med',
    'title': 'Beginner',
    'value': 'Beginner',
  },
  'Location': {
    'id': 'med',
    'title': 'Harare',
    'value': 'Harare',
  },
  'Agrozone': {
    'id': 'med',
    'title': 'Natural Region II',
    'value': 'Natural Region II',
  },
};

double _skillWeight(String crop) {
  switch (crop) {
    case 'Tomatoes':
    case 'Chillies':
    case 'Cucumber':
    case 'Onions':
      return 0.25;
    case 'Maize':
    case 'Cowpeas':
    case 'Beans':
    case 'Sorghum':
    case 'Sweet Potato':
    case 'Kale (Sukuma Wiki)':
    case 'Beetroot':
      return 0.45;
    default:
      return 0.34;
  }
}

double _locationWeight(String crop) {
  switch (crop) {
    case 'Tomatoes':
    case 'Kale (Sukuma Wiki)':
    case 'Beans':
      return 0.4;
    case 'Sorghum':
    case 'Cowpeas':
      return 0.35;
    default:
      return 0.33;
  }
}

double _agroWeight(String crop) {
  switch (crop) {
    case 'Maize':
    case 'Beans':
    case 'Kale (Sukuma Wiki)':
      return 0.42;
    case 'Sorghum':
    case 'Cowpeas':
      return 0.38;
    default:
      return 0.33;
  }
}
