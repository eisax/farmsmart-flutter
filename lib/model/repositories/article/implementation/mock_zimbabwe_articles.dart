import 'package:farmsmart_flutter/model/entities/article_entity.dart';
import 'package:farmsmart_flutter/model/entities/enums.dart';
/// Readable mock articles for Discover and Community tabs (Zimbabwe).
class MockZimbabweArticles {
  MockZimbabweArticles._();

  static final discover = [
    _article(
      'maize-nr2',
      'Maize tips for Natural Region II',
      'Plant with the first reliable rains. Use certified seed and aim for 52,000 plants per hectare on well-drained red soils.',
      'https://en.wikipedia.org/wiki/Agriculture_in_Zimbabwe',
    ),
    _article(
      'armyworm',
      'Spotting fall armyworm early',
      'Check whorls twice a week in January–March. Scout at dawn and combine cultural control with approved pesticides when thresholds are met.',
      'https://www.fao.org/fall-armyworm/en/',
    ),
    _article(
      'drip-budget',
      'Low-cost drip irrigation',
      'Split lines by crop block, mulch beds, and irrigate at night to cut evaporation. Start with tomatoes and leafy greens near Harare.',
      'https://en.wikipedia.org/wiki/Drip_irrigation',
    ),
    _article(
      'sukuma-markets',
      'Selling leafy greens in Harare',
      'Harvest at cool hours, bunch uniformly, and deliver to Mbare Musika before 8 a.m. for the best farm-gate prices.',
      'https://en.wikipedia.org/wiki/Harare',
    ),
    _article(
      'soil-health',
      'Building soil organic matter',
      'Rotate with legumes, return crop residues, and compost kraal manure. Target 3% organic matter on sandy loams.',
      'https://en.wikipedia.org/wiki/Conservation_agriculture',
    ),
    _article(
      'dry-season',
      'Dry-season vegetable planning',
      'Prioritise heat-tolerant crops: rape, covo, and okra. Shade-net extends shelf life for nursery seedlings.',
      '',
    ),
  ];

  static final community = [
    _article(
      'grp-harare',
      'Harare Urban Farmers Network',
      'Weekly tips on backyard plots, composting, and water rationing. Open to growers in Borrowdale, Mbare, and Chitungwiza.',
      'https://chat.whatsapp.com/example-harare-farmers',
    ),
    _article(
      'grp-mash-west',
      'Mashonaland West Maize Growers',
      'Share planting dates, hybrid varieties, and combine-hire contacts for Chinhoyi and Karoi districts.',
      'https://chat.whatsapp.com/example-mash-west',
    ),
    _article(
      'grp-gweru',
      'Gweru Horticulture Exchange',
      'Coordinate bulk seed orders and transport to Mkoba and Ascot markets. Focus on tomatoes, peppers, and onions.',
      'https://chat.whatsapp.com/example-gweru-hort',
    ),
    _article(
      'grp-bulawayo',
      'Bulawayo Market Day Tips',
      'Discuss Renkini and downtown market prices, packaging, and cold-chain options for high-value crops.',
      'https://chat.whatsapp.com/example-bulawayo',
    ),
    _article(
      'grp-zim-small',
      'Zimbabwe Smallholders Hub',
      'National group for input suppliers, extension alerts, and rainfall reports across all natural regions.',
      'https://chat.whatsapp.com/example-zw-smallholders',
    ),
  ];

  static ArticleEntity _article(
    String uri,
    String title,
    String summary, [
    String externalLink = '',
  ]) {
    return ArticleEntity(
      uri: uri,
      title: title,
      summary: summary,
      content: '<p>$summary</p>',
      status: Status.PUBLISHED,
      published: DateTime.now().subtract(const Duration(days: 14)),
      externalLink: externalLink.isEmpty ? null : externalLink,
      images: null,
    );
  }
}
