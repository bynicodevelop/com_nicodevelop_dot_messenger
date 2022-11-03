import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("Doit vérifier que le paramètre groupId est bien présent", () async {
    // ARRANGE
    final ChatRepository chatRepository = ChatRepository();

    // ACT
    // ASSERT
    expect(
      () async => chatRepository.load(
        {},
      ),
      throwsA(
        isA<ArgumentError>(),
      ),
    );
  });
}
