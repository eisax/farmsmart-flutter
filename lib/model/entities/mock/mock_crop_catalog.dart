import 'package:farmsmart_flutter/model/entities/enums.dart';

/// Curated mock crop definitions for local development (Zimbabwe smallholder crops).
class MockCropDefinition {
  final String name;
  final String summary;
  final String imageUrl;
  final CropComplexity complexity;
  final CropType cropType;
  final LoHi profitability;
  final LoHi setupCost;
  final LoHi waterRequirement;
  final List<String> soilTypes;
  final List<String> companions;
  final List<String> nonCompanions;
  final List<String> rotationCrops;
  final List<String> stageTitles;

  const MockCropDefinition({
    required this.name,
    required this.summary,
    required this.imageUrl,
    required this.complexity,
    required this.cropType,
    required this.profitability,
    required this.setupCost,
    required this.waterRequirement,
    required this.soilTypes,
    required this.companions,
    required this.nonCompanions,
    required this.rotationCrops,
    required this.stageTitles,
  });
}

class MockCropCatalog {
  MockCropCatalog._();

  static const _imageBase = 'https://picsum.photos/seed/farmsmart';

  static final List<MockCropDefinition> all = [
    MockCropDefinition(
      name: 'Tomatoes',
      summary:
          'High-value greenhouse or open-field tomatoes suited to warm seasons. Strong local demand year-round.',
      imageUrl: '$_imageBase-tomatoes/400/300',
      complexity: CropComplexity.INTERMEDIATE,
      cropType: CropType.SINGLE,
      profitability: LoHi.HIGH,
      setupCost: LoHi.MEDIUM,
      waterRequirement: LoHi.MEDIUM,
      soilTypes: ['Loam', 'Well-drained sandy loam'],
      companions: ['Basil', 'Marigold', 'Onions'],
      nonCompanions: ['Potatoes', 'Fennel'],
      rotationCrops: ['Beans', 'Maize'],
      stageTitles: ['Nursery', 'Transplant', 'Flowering', 'Harvest'],
    ),
    MockCropDefinition(
      name: 'Maize',
      summary:
          'Staple cereal for food security and fodder. Plant at onset of rains for best establishment.',
      imageUrl: '$_imageBase-maize/400/300',
      complexity: CropComplexity.BEGINNER,
      cropType: CropType.SINGLE,
      profitability: LoHi.MEDIUM,
      setupCost: LoHi.LOW,
      waterRequirement: LoHi.MEDIUM,
      soilTypes: ['Loam', 'Clay loam'],
      companions: ['Beans', 'Pumpkin'],
      nonCompanions: ['Tomatoes'],
      rotationCrops: ['Beans', 'Cowpeas'],
      stageTitles: ['Land prep', 'Planting', 'Tasseling', 'Dry down'],
    ),
    MockCropDefinition(
      name: 'Kale (Sukuma Wiki)',
      summary:
          'Fast-growing leafy green for continuous harvest. Tolerates cooler highland conditions.',
      imageUrl: '$_imageBase-kale/400/300',
      complexity: CropComplexity.BEGINNER,
      cropType: CropType.SINGLE,
      profitability: LoHi.MEDIUM,
      setupCost: LoHi.LOW,
      waterRequirement: LoHi.MEDIUM,
      soilTypes: ['Fertile loam', 'Compost-rich beds'],
      companions: ['Onions', 'Herbs'],
      nonCompanions: ['Strawberries'],
      rotationCrops: ['Beans', 'Tomatoes'],
      stageTitles: ['Bed prep', 'Transplant', 'Leaf harvest', 'Regrowth'],
    ),
    MockCropDefinition(
      name: 'Cowpeas',
      summary:
          'Drought-tolerant legume that improves soil nitrogen. Leaves and grain both marketable.',
      imageUrl: '$_imageBase-cowpeas/400/300',
      complexity: CropComplexity.BEGINNER,
      cropType: CropType.SINGLE,
      profitability: LoHi.MEDIUM,
      setupCost: LoHi.LOW,
      waterRequirement: LoHi.LOW,
      soilTypes: ['Sandy loam', 'Well-drained soils'],
      companions: ['Maize', 'Sorghum'],
      nonCompanions: ['Onions'],
      rotationCrops: ['Maize', 'Sorghum'],
      stageTitles: ['Sowing', 'Vegetative', 'Pod fill', 'Harvest'],
    ),
    MockCropDefinition(
      name: 'Chillies',
      summary:
          'Spice crop with strong export and local market potential. Needs consistent moisture at flowering.',
      imageUrl: '$_imageBase-chillies/400/300',
      complexity: CropComplexity.INTERMEDIATE,
      cropType: CropType.SINGLE,
      profitability: LoHi.HIGH,
      setupCost: LoHi.MEDIUM,
      waterRequirement: LoHi.MEDIUM,
      soilTypes: ['Loam', 'Raised beds'],
      companions: ['Tomatoes', 'Basil'],
      nonCompanions: ['Beans'],
      rotationCrops: ['Maize', 'Onions'],
      stageTitles: ['Nursery', 'Field establishment', 'Fruit set', 'Drying'],
    ),
    MockCropDefinition(
      name: 'Beetroot',
      summary:
          'Root vegetable for fresh markets and processing. Cool-season crop with 8–12 week cycles.',
      imageUrl: '$_imageBase-beetroot/400/300',
      complexity: CropComplexity.BEGINNER,
      cropType: CropType.SINGLE,
      profitability: LoHi.MEDIUM,
      setupCost: LoHi.LOW,
      waterRequirement: LoHi.MEDIUM,
      soilTypes: ['Deep loam', 'Stone-free beds'],
      companions: ['Onions', 'Lettuce'],
      nonCompanions: ['Beans'],
      rotationCrops: ['Maize', 'Kale (Sukuma Wiki)'],
      stageTitles: ['Direct sow', 'Thinning', 'Bulking', 'Lift'],
    ),
    MockCropDefinition(
      name: 'Sorghum',
      summary:
          'Climate-resilient grain for arid and semi-arid zones. Dual use for food and livestock feed.',
      imageUrl: '$_imageBase-sorghum/400/300',
      complexity: CropComplexity.BEGINNER,
      cropType: CropType.SINGLE,
      profitability: LoHi.MEDIUM,
      setupCost: LoHi.LOW,
      waterRequirement: LoHi.LOW,
      soilTypes: ['Sandy loam', 'Red soils'],
      companions: ['Cowpeas', 'Pigeon pea'],
      nonCompanions: ['Tomatoes'],
      rotationCrops: ['Cowpeas', 'Maize'],
      stageTitles: ['Planting', 'Tillering', 'Heading', 'Threshing'],
    ),
    MockCropDefinition(
      name: 'Cucumber',
      summary:
          'Quick-return vegetable for salads and pickling. Performs well on trellises with drip irrigation.',
      imageUrl: '$_imageBase-cucumber/400/300',
      complexity: CropComplexity.INTERMEDIATE,
      cropType: CropType.SINGLE,
      profitability: LoHi.HIGH,
      setupCost: LoHi.MEDIUM,
      waterRequirement: LoHi.HIGH,
      soilTypes: ['Rich loam', 'Raised beds'],
      companions: ['Beans', 'Radish'],
      nonCompanions: ['Potatoes'],
      rotationCrops: ['Maize', 'Beans'],
      stageTitles: ['Germination', 'Vine growth', 'Flowering', 'Pick'],
    ),
    MockCropDefinition(
      name: 'Onions',
      summary:
          'Bulb crop with steady domestic demand. Requires weed control and balanced fertility.',
      imageUrl: '$_imageBase-onions/400/300',
      complexity: CropComplexity.INTERMEDIATE,
      cropType: CropType.SINGLE,
      profitability: LoHi.MEDIUM,
      setupCost: LoHi.MEDIUM,
      waterRequirement: LoHi.MEDIUM,
      soilTypes: ['Sandy loam', 'Well-drained loam'],
      companions: ['Carrots', 'Tomatoes'],
      nonCompanions: ['Beans', 'Peas'],
      rotationCrops: ['Maize', 'Kale (Sukuma Wiki)'],
      stageTitles: ['Seedbed', 'Transplant', 'Bulbing', 'Curing'],
    ),
    MockCropDefinition(
      name: 'Beans',
      summary:
          'Common beans for household nutrition and cash sales. Fixes nitrogen when rotated with cereals.',
      imageUrl: '$_imageBase-beans/400/300',
      complexity: CropComplexity.BEGINNER,
      cropType: CropType.SINGLE,
      profitability: LoHi.MEDIUM,
      setupCost: LoHi.LOW,
      waterRequirement: LoHi.MEDIUM,
      soilTypes: ['Loam', 'Volcanic soils'],
      companions: ['Maize', 'Potatoes'],
      nonCompanions: ['Onions', 'Garlic'],
      rotationCrops: ['Maize', 'Sorghum'],
      stageTitles: ['Sowing', 'Vegetative', 'Pod development', 'Dry harvest'],
    ),
    MockCropDefinition(
      name: 'Sweet Potato',
      summary:
          'Nutritious root crop tolerant of poor soils. Vines provide ground cover and erosion control.',
      imageUrl: '$_imageBase-sweetpotato/400/300',
      complexity: CropComplexity.BEGINNER,
      cropType: CropType.SINGLE,
      profitability: LoHi.MEDIUM,
      setupCost: LoHi.LOW,
      waterRequirement: LoHi.LOW,
      soilTypes: ['Sandy loam', 'Light volcanic soils'],
      companions: ['Beans', 'Maize'],
      nonCompanions: ['Squash'],
      rotationCrops: ['Maize', 'Beans'],
      stageTitles: ['Vine cuttings', 'Rooting', 'Tuber bulking', 'Cure & store'],
    ),
  ];

  static MockCropDefinition? findByName(String name) {
    for (final crop in all) {
      if (crop.name == name) {
        return crop;
      }
    }
    return null;
  }

  static List<String> get names => all.map((c) => c.name).toList();
}
