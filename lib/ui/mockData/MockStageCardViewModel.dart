import 'package:farmsmart_flutter/model/entities/mock/MockString.dart';
import 'package:farmsmart_flutter/ui/common/stage_card.dart';

class MockStageCardViewModel {
  static StageCardViewModel buildUpcomingState() {
    return StageCardViewModel(
      subtitle: _mockStage.random(),
      title: _mockTitle.random(),
      action: () {},
      actionText: 'Begin Stage',
      statusTitle: 'Upcoming',
      dialogTitle: 'Confirm Stage',
      dialogDescription: 'Do you want to begin this stage?',
    );
  }

  static StageCardViewModel buildInProgressState() {
    return StageCardViewModel(
      subtitle: _mockStage.random(),
      title: _mockTitle.random(),
      action: () {},
      actionText: 'Mark as Complete',
      statusTitle: 'In Progress',
      dialogTitle: 'Confirm Completion',
      dialogDescription: 'Do you want to mark this stage as complete?',
    );
  }

  static StageCardViewModel buildCompleteState() {
    return StageCardViewModel(
      subtitle: _mockStage.random(),
      title: _mockTitle.random(),
      action: () {},
      actionText: 'Revert to In Progress',
      statusTitle: 'Complete',
      dialogTitle: 'Confirm Revert',
      dialogDescription: 'Do you want to revert this stage to in progress?',
    );
  }

  static StageCardViewModel buildRandom() {
    return StageCardViewModel(
      subtitle: _mockLargeStrings.random(),
      title: _mockLargeStrings.random(),
      action: () {},
      actionText: _mockActionButtonText.random(),
      statusTitle: _mockStageStatus.random(),
      dialogTitle: 'Confirm Action',
      dialogDescription: 'Do you want to continue with this action?',
    );
  }
}

MockString _mockTitle = MockString(library: [
  "Preparation ",
  "Planting with large text",
  "Maintenance med",
  "Harvesting with ultra large text that shouldn't be visible at all",
  "Next Step medium",
]);

MockString _mockStage = MockString(library: [
  "Stage 1 ",
  "Stage 2 ",
  "Stage 3 ",
  "Stage 4 ",
]);

MockString _mockLargeStrings = MockString(library: [
  "Very large text to test the limits  ",
  "Large text to test the limits limits limits limits ",
]);

MockString _mockStageStatus = MockString(library: [
  "Complete",
  "Upcoming",
  "In Progress",
]);

MockString _mockActionButtonText = MockString(library: [
  "Mark as Complete",
  "Begin Stage",
  "Revert to In Progress",
]);
