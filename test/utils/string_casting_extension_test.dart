import "package:flutter_test/flutter_test.dart";
import "package:com_nicodevelop_dotmessenger/utils/string_casting_extension.dart";

void main() {
  group("StringCastingExtension", () {
    test("Doit mettre la première lettre en capital", () {
      // ARRANGE
      // ACT
      // ASSERT
      expect("nico".toTitleCase(), "Nico");
      expect("nico develop".toTitleCase(), "Nico Develop");
    });
  });
}
