import 'package:farmsmart_flutter/model/entities/PlotEntity.dart';
import 'package:farmsmart_flutter/model/entities/mock/MockCrop.dart';
import 'package:farmsmart_flutter/model/entities/mock/MockPlot.dart';

/// Demo plots for mock mode so My Plot is populated on first launch.
class MockPlotSeed {
  MockPlotSeed._();

  static final _builder = MockPlotEntity(seed: 42);

  static List<PlotEntity> starterPlots() {
    return [
      _builder.buildSync(
        MockCrop.build(cropName: 'Tomatoes'),
        inProgress: true,
      ),
      _builder.buildSync(
        MockCrop.build(cropName: 'Kale (Sukuma Wiki)'),
        inProgress: true,
      ),
      _builder.buildSync(
        MockCrop.build(cropName: 'Cowpeas'),
        inProgress: false,
      ),
    ];
  }
}
