// Mocks generated by Mockito 5.3.2 from annotations
// in com_nicodevelop_dotmessenger/test/services/chat/load_messages_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [ChatRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockChatRepository extends _i1.Mock implements _i2.ChatRepository {
  @override
  _i3.Stream<List<Map<String, dynamic>>> get messages => (super.noSuchMethod(
        Invocation.getter(#messages),
        returnValue: _i3.Stream<List<Map<String, dynamic>>>.empty(),
        returnValueForMissingStub:
            _i3.Stream<List<Map<String, dynamic>>>.empty(),
      ) as _i3.Stream<List<Map<String, dynamic>>>);
  @override
  _i3.Future<void> load(Map<String, dynamic>? data) => (super.noSuchMethod(
        Invocation.method(
          #load,
          [data],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<Map<String, dynamic>> post(Map<String, dynamic>? data) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [data],
        ),
        returnValue:
            _i3.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
        returnValueForMissingStub:
            _i3.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i3.Future<Map<String, dynamic>>);
}
