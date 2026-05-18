import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';
import 'package:farmsmart_flutter/model/repositories/ratingEngine/RatingEngineRepositoryInterface.dart';

class _Fields {
  static const scores = "scores";
  static const factor = "factor";
  static const weight = "weight";
  static const values = "values";
  static const subject = "crop";
  static const factorKey = "key";
  static const factorValue = "rating";
  static const name = "name";
}

class FirebaseToRatingInfoTransformer extends ObjectTransformer<
    QuerySnapshot<Map<String, dynamic>>, Map<String, RatingInfo>> {
  @override
  Map<String, RatingInfo> transform(
      {QuerySnapshot<Map<String, dynamic>>? from}) {
    if (from == null) {
      throw ArgumentError.notNull('from');
    }
    Map<String, RatingInfo> ratingData = {};
    final documents = from.docs;
    for (final ratingEntry in documents) {
      final entryData = ratingEntry.data();
      final subjectData = entryData[_Fields.subject];
      final subject = (subjectData is Map)
          ? castOrNull<String>(subjectData[_Fields.name])
          : null;
      if (subject != null) {
        final scores = castListOrNull<Map<dynamic, dynamic>>(
            entryData[_Fields.scores]);
        Map<String, double> outputWeights = {};
        Map<String, Map<String, double>> outputFactors = {};
        for (final score in scores) {
          final factorName = castOrNull<String>(score[_Fields.factor]);
          final weight = score[_Fields.weight];
          final factorValues =
              castListOrNull<Map<dynamic, dynamic>>(score[_Fields.values]);
          if (factorName == null) {
            continue;
          }
          for (final factor in factorValues) {
            final factorKey = castOrNull<String>(factor[_Fields.factorKey]);
            final factorValue = factor[_Fields.factorValue];
            if (factorKey == null) {
              continue;
            }
            outputFactors.putIfAbsent(factorName, () => {});
            outputFactors[factorName]![factorKey] =
                (factorValue as num).toDouble();
          }
          if (weight is num) {
            outputWeights[factorName] = weight.toDouble();
          }
        }
        ratingData[subject] = RatingInfo(outputWeights, outputFactors);
      }
    }
    return ratingData;
  }
}
