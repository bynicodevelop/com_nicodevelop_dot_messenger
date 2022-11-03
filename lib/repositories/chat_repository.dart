import "dart:async";

import "package:com_nicodevelop_dotmessenger/config/data_mock.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";

class ChatRepository {
  final StreamController<List<Map<String, dynamic>>> _messagesController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get messages => _messagesController.stream;

  Future<void> load(Map<String, dynamic> data) async {
    if (!data.containsKey("groupId")) {
      throw ArgumentError("groupId is required");
    }

    info(
      "Loading messages for group",
      data: data,
    );

    for (var group in groupsList) {
      if (group["uid"] == data["groupId"]) {
        _messagesController.add(group["messages"]);
      }
    }
  }
}
