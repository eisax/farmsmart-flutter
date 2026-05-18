import 'package:farmsmart_flutter/model/entities/mock/MockString.dart';
import 'package:farmsmart_flutter/ui/common/ActionSheet.dart';
import 'package:farmsmart_flutter/ui/common/ActionSheetListItem.dart';

class MockActionSheetViewModel {
  static ActionSheetViewModel buildStandard() {
    List<ActionSheetListItemViewModel> list = [];
    for (var i = 0; i < 2; i++) {
      list.add(MockActionSheetListItemViewModel.buildStandard(i));
    }

    return ActionSheetViewModel(
      actions: list,
      cancelButtonTitle: "Cancel",
      confirmButtonTitle: "Confirm",
    );
  }

  static ActionSheetViewModel buildStandardBigger() {
    List<ActionSheetListItemViewModel> list = [];
    for (var i = 0; i < 3; i++) {
      list.add(MockActionSheetListItemViewModel.buildStandardBigger(i));
    }

    return ActionSheetViewModel(
      actions: list,
      cancelButtonTitle: "Cancel",
      confirmButtonTitle: "Confirm",
    );
  }

  static ActionSheetViewModel buildWithIcon() {
    List<ActionSheetListItemViewModel> list = [];
    for (var i = 0; i < 2; i++) {
      list.add(MockActionSheetListItemViewModel.buildWithIcon(i));
    }

    return ActionSheetViewModel(
      actions: list,
      cancelButtonTitle: "Cancel",
      confirmButtonTitle: "Confirm",
    );
  }

  static ActionSheetViewModel buildWithCheckBox() {
    List<ActionSheetListItemViewModel> list = [];
    for (var i = 0; i < 2; i++) {
      list.add(MockActionSheetListItemViewModel.buildWithCheckbox(i));
    }

    return ActionSheetViewModel(
      actions: list,
      cancelButtonTitle: "Cancel",
      confirmButtonTitle: _mockButtonTitle.random(),
    );
  }
}

class MockActionSheetListItemViewModel {
  static ActionSheetListItemViewModel buildStandard(index) {
    return ActionSheetListItemViewModel(
      title: _mockItemTitleStandard[index],
      icon: "assets/icons/radio_button_default.png",
      type: ActionType.simple,
      checkBoxIcon: "assets/icons/radio_button_default.png",
      onTap: () => actionTest("Tapped " + _mockItemTitleStandard[index]),
      isDestructive: _mockItemDestructive[index],
    );
  }

  static ActionSheetListItemViewModel buildStandardBigger(index) {
    return ActionSheetListItemViewModel(
      title: _mockItemTitleStandardBigger[index],
      icon: "assets/icons/radio_button_default.png",
      type: ActionType.simple,
      checkBoxIcon: "assets/icons/radio_button_default.png",
      onTap: () => actionTest("Tapped " + _mockItemTitleStandardBigger[index]),
      isDestructive: _mockItemDestructive[index],
    );
  }

  static ActionSheetListItemViewModel buildWithIcon(index) {
    return ActionSheetListItemViewModel(
      title: _mockItemTitleWithIcon[index],
      icon: _mockIcon[index],
      type: ActionType.withIcon,
      checkBoxIcon: "assets/icons/radio_button_default.png",
      onTap: () => actionTest("Tapped " + _mockItemTitleWithIcon[index]),
      isDestructive: _mockItemDestructive[index],
    );
  }

  static ActionSheetListItemViewModel buildWithCheckbox(index) {
    return ActionSheetListItemViewModel(
      title: _mockItemTitleSelectable[index],
      icon: _mockFlagIcon[index],
      type: ActionType.selectable,
      checkBoxIcon: _mockCheckBoxIcon[index],
      onTap: () => actionTest("Tapped " + _mockItemTitleSelectable[index]),
      isDestructive: _mockItemDestructive[index],
    );
  }

  static actionTest(String message) {
    print(message);
  }
}

List _mockItemTitleStandard = ["Rename Crop", "Delete Crop"];
List _mockItemDestructive = [false, false, true];
List _mockItemTitleStandardBigger = [
  "Take New Photo",
  "Choose from LIbrary",
  "Remove Current Photo"
];
List _mockItemTitleWithIcon = ["Record a New Sale", "Record a new Cost"];
List _mockItemTitleSelectable = ["English", "Swahili"];
List _mockIcon = [
  "assets/icons/detail_icon_cost.png",
  "assets/icons/detail_icon_sale.png"
];
List _mockFlagIcon = [
  "assets/icons/flag_usa.png",
  "assets/icons/flag_kenya.png"
];
List _mockCheckBoxIcon = [
  "assets/icons/radio_button_active.png",
  "assets/icons/radio_button_default.png"
];

MockString _mockButtonTitle = MockString(library: ["Confirm"]);
