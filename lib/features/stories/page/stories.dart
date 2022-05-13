import 'package:flutter/material.dart';
import 'package:instagram_firebase/core/models/stories.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryPage extends StatelessWidget {
  StoryPage({Key? key,required this.storiesDetails}) : super(key: key);

  final controller = StoryController();
  List<StoriesModel> storiesDetails;

  @override
  Widget build(context) {

    // loop all stories and get .
    List<StoryItem> stories = [];
    for (var element in storiesDetails) {
      stories.add(StoryItem.pageImage(
          url: element.storyImageUrl!, controller: controller));
    } // your list of stories

    return StoryView(
      controller: controller,
      // pass controller here too
      repeat: false,
      // should the stories be slid forever
      onStoryShow: (s) {
        // notifyServer(s)
      },
      onComplete: () {
        Navigator.pop(context);
      },
      onVerticalSwipeComplete: (direction) {
        if (direction == Direction.down) {
          Navigator.pop(context);
        }
      },
      // items.
      storyItems: stories,
    );
  }
}