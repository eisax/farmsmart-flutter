import 'dart:convert';

import 'package:farmsmart_flutter/chat/model/form/form_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String formItemMockData =
      '{"text": "Will users create a profile?", "sender":"sender test",'
      '"sentiment":"happy","inputRequest": '
      '{"type": "com.wearemobilefirst.MultiChoice","uri": "%WillUsersCreateProfile",'
      '"title": "","validationRegex": "",'
      '"inline": true,"localStore": false,"responseText": "","optional": false,'
      '"args": {"maxSelection": 1,"options": [{"id": "OptionKey1","title": "Yes",'
      '"description": "","responseText": "Yes"},{"id": "OptionKey2","title": "No",'
      '"description": "","responseText": "No"}]}},'
      '"media":{"uri":"media uri test", "mimeType":"mimeType test"},'
      '"senderMedia":{"uri":"sender media uri test", "mimeType":"sender mimeType test"}}';

  group('FormItem', (){
    var formItem = FormItemEntity.fromJson(jsonDecode(formItemMockData));

    test('fromJson() should parse json to the object correctly', () {
      final inputRequest = formItem.inputRequest!;
      final options = inputRequest.args!.options!;
      final media = formItem.media!;
      final senderMedia = formItem.senderMedia!;

      expect(formItem.text, 'Will users create a profile?');
      expect(formItem.sender, 'sender test');
      expect(formItem.sentiment, 'happy');
      expect(inputRequest.type, 'com.wearemobilefirst.MultiChoice');
      expect(inputRequest.uri, '%WillUsersCreateProfile');
      expect(inputRequest.title, '');
      expect(inputRequest.optional, false);
      expect(inputRequest.responseText, '');
      expect(inputRequest.localStore, false);
      expect(inputRequest.inline, true);
      expect(options[0].id, 'OptionKey1');
      expect(options[0].title, 'Yes');
      expect(options[0].description, '');
      expect(options[0].responseText, 'Yes');
      expect(media.uri, 'media uri test');
      expect(media.mimeType, 'mimeType test');
      expect(senderMedia.uri, 'sender media uri test');
      expect(senderMedia.mimeType, 'sender mimeType test');
    });

    
    
    
    test('toJson() should parse the object to json correctly', () {
      var jsonMap = formItem.toJson();

      expect(jsonMap['text'], formItem.text);
      expect(jsonMap['media'], formItem.media);
      expect(jsonMap['inputRequest'], formItem.inputRequest);
      expect(jsonMap['sentiment'], formItem.sentiment);
      expect(jsonMap['sender'], formItem.sender);
      expect(jsonMap['senderMedia'], formItem.senderMedia);
    });
  });
}
