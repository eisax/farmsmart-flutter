import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:farmsmart_flutter/chat/model/form/form_entity.dart';
import 'package:farmsmart_flutter/chat/model/form/form_item_entity.dart';

import 'package:farmsmart_flutter/chat/repository/form/ChatRepository.dart';
import 'package:farmsmart_flutter/chat/repository/form/datasource/JSONDatasource.dart';

class MockFormRepository implements ChatRepository {
  static const int DEFAULT_LIMIT = 0;

  final Future<FormEntity> _formEntity;

  MockFormRepository({
    required BuildContext context,
    required File file,
  }) : this._formEntity =
            JSONDataSource(context: context, file: file).getDataFromJSON();

  @override
  Future<FormEntity> getForm() {
    return _formEntity;
  }

  @override
  Future<List<FormItemEntity>> getFormItems() {
    return _formEntity.then((formEntity) {
      return formEntity.items ?? <FormItemEntity>[];
    });
  }

  @override
  Future<FormItemEntity> getFormItem(int position) {
    return _formEntity.then((formEntity) {
      final items = formEntity.items ?? <FormItemEntity>[];
      if (position < 0 || position >= items.length) {
        return Future.error(StateError('Form item index out of range'));
      }
      return items[position];
    });
  }
}
