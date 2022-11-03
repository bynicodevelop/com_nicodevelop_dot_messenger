import "dart:async";

class GroupRepository {
  final StreamController<List<Map<String, dynamic>>> _groupsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get groups => _groupsController.stream;

  Future<void> load() async {
    // _groupsController.add(groupsList);
  }
}
