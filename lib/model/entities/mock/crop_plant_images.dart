/// Stable Wikimedia Commons URLs — actual plant photography per crop.
class CropPlantImages {
  CropPlantImages._();

  static const _wiki = 'https://upload.wikimedia.org/wikipedia/commons/thumb';

  static final Map<String, String> byCropName = {
    'Tomatoes':
        '$_wiki/8/89/Tomato_je.jpg/440px-Tomato_je.jpg',
    'Maize':
        '$_wiki/5/56/Maize_plants.jpg/440px-Maize_plants.jpg',
    'Kale (Sukuma Wiki)':
        '$_wiki/2/26/Kale-Bundle.jpg/440px-Kale-Bundle.jpg',
    'Cowpeas':
        '$_wiki/0/07/Black-eyed_peas.jpg/440px-Black-eyed_peas.jpg',
    'Chillies':
        '$_wiki/3/3a/Capsicum_annuum_fruits.jpg/440px-Capsicum_annuum_fruits.jpg',
    'Beetroot':
        '$_wiki/8/88/Beetroot_jm26647.jpg/440px-Beetroot_jm26647.jpg',
    'Sorghum':
        '$_wiki/1/1a/Sorghum_bicolor.jpg/440px-Sorghum_bicolor.jpg',
    'Cucumber':
        '$_wiki/9/89/Cucumis_sativus.jpg/440px-Cucumis_sativus.jpg',
    'Onions':
        '$_wiki/2/25/Onion_on_white.jpg/440px-Onion_on_white.jpg',
    'Beans':
        '$_wiki/9/92/Phaseolus_vulgaris_Bean_plants.jpg/440px-Phaseolus_vulgaris_Bean_plants.jpg',
    'Sweet Potato':
        '$_wiki/4/4b/Ipomoea_batatas_006.JPG/440px-Ipomoea_batatas_006.JPG',
  };

  static String forCrop(String name) {
    return byCropName[name] ??
        '$_wiki/3/3f/Plants_in_a_field.jpg/440px-Plants_in_a_field.jpg';
  }
}
