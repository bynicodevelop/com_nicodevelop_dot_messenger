// Mocks generated by Mockito 5.3.2 from annotations
// in com_nicodevelop_dotmessenger/test/components/chat_message_component_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart'
    as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
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

class _FakeFirebaseFirestore_0 extends _i1.SmartFake
    implements _i2.FirebaseFirestore {
  _FakeFirebaseFirestore_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseAuth_1 extends _i1.SmartFake implements _i3.FirebaseAuth {
  _FakeFirebaseAuth_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ChatRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockChatRepository extends _i1.Mock implements _i4.ChatRepository {
  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
        returnValueForMissingStub: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);
  @override
  _i3.FirebaseAuth get auth => (super.noSuchMethod(
        Invocation.getter(#auth),
        returnValue: _FakeFirebaseAuth_1(
          this,
          Invocation.getter(#auth),
        ),
        returnValueForMissingStub: _FakeFirebaseAuth_1(
          this,
          Invocation.getter(#auth),
        ),
      ) as _i3.FirebaseAuth);
  @override
  _i5.Stream<List<Map<String, dynamic>>> get messages => (super.noSuchMethod(
        Invocation.getter(#messages),
        returnValue: _i5.Stream<List<Map<String, dynamic>>>.empty(),
        returnValueForMissingStub:
            _i5.Stream<List<Map<String, dynamic>>>.empty(),
      ) as _i5.Stream<List<Map<String, dynamic>>>);
  @override
  _i5.Future<void> load(Map<String, dynamic>? data) => (super.noSuchMethod(
        Invocation.method(
          #load,
          [data],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<Map<String, dynamic>> post(Map<String, dynamic>? data) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [data],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
        returnValueForMissingStub:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
}
