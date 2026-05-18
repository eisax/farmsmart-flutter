import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/bloc/Transformer.dart';

import '../../FlamelinkMeta.dart';

class _Fields {
  static const createdBy = "createdBy";
  static const createdDate = "createdDate";
  static const modified = "lastModifiedDate";
  static const locale = "locale";
  static const docId = "docId";
  static const env = "env";
}

class FlamelinkMetaTransformer
    extends ObjectTransformer<DocumentSnapshot<Map<String, dynamic>>, FlamelinkMeta> {
  @override
  FlamelinkMeta transform({DocumentSnapshot<Map<String, dynamic>>? from}) {
    if (from == null) {
      throw ArgumentError.notNull('from');
    }
    final data = from.data();
    final metaData = data?[FlamelinkMeta.metaFieldName];
    if (metaData == null) {
      throw StateError('Document has no flamelink metadata');
    }
    final createdBy = castOrNull<String>(metaData[_Fields.createdBy]);
    final created = castOrNull<Timestamp>(metaData[_Fields.createdDate]);
    final modified = castOrNull<Timestamp>(metaData[_Fields.modified]);
    final locale = castOrNull<String>(metaData[_Fields.locale]);
    final docId = castOrNull<String>(metaData[_Fields.docId]);
    final env = castOrNull<String>(metaData[_Fields.env]);
    return FlamelinkMeta(
        createdBy: createdBy,
        createdDate: created,
        modified: modified,
        locale: locale,
        docId: docId,
        env: env);
  }
}
