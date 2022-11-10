// Mocks generated by Mockito 5.3.2 from annotations
// in com_nicodevelop_dotmessenger/test/services/auth/profile_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:cloud_firestore/cloud_firestore.dart' as _i3;
import 'package:com_nicodevelop_dotmessenger/models/user_model.dart' as _i6;
import 'package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart'
    as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i2;
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

class _FakeFirebaseAuth_0 extends _i1.SmartFake implements _i2.FirebaseAuth {
  _FakeFirebaseAuth_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseFirestore_1 extends _i1.SmartFake
    implements _i3.FirebaseFirestore {
  _FakeFirebaseFirestore_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ProfileRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockProfileRepository extends _i1.Mock implements _i4.ProfileRepository {
  @override
  _i2.FirebaseAuth get auth => (super.noSuchMethod(
        Invocation.getter(#auth),
        returnValue: _FakeFirebaseAuth_0(
          this,
          Invocation.getter(#auth),
        ),
        returnValueForMissingStub: _FakeFirebaseAuth_0(
          this,
          Invocation.getter(#auth),
        ),
      ) as _i2.FirebaseAuth);
  @override
  _i3.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_1(
          this,
          Invocation.getter(#firestore),
        ),
        returnValueForMissingStub: _FakeFirebaseFirestore_1(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i3.FirebaseFirestore);
  @override
  _i5.Stream<_i6.UserModel?> get userModel => (super.noSuchMethod(
        Invocation.getter(#userModel),
        returnValue: _i5.Stream<_i6.UserModel?>.empty(),
        returnValueForMissingStub: _i5.Stream<_i6.UserModel?>.empty(),
      ) as _i5.Stream<_i6.UserModel?>);
  @override
  _i5.Future<_i6.UserModel?> get user => (super.noSuchMethod(
        Invocation.getter(#user),
        returnValue: _i5.Future<_i6.UserModel?>.value(),
        returnValueForMissingStub: _i5.Future<_i6.UserModel?>.value(),
      ) as _i5.Future<_i6.UserModel?>);
  @override
  _i5.Future<void> validateEmail(Map<String, dynamic>? data) =>
      (super.noSuchMethod(
        Invocation.method(
          #validateEmail,
          [data],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> login(Map<String, dynamic>? data) => (super.noSuchMethod(
        Invocation.method(
          #login,
          [data],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> register(Map<String, dynamic>? data) => (super.noSuchMethod(
        Invocation.method(
          #register,
          [data],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> update(Map<String, dynamic>? data) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [data],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> resendConfirmMail() => (super.noSuchMethod(
        Invocation.method(
          #resendConfirmMail,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> deleteAccount() => (super.noSuchMethod(
        Invocation.method(
          #deleteAccount,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}
