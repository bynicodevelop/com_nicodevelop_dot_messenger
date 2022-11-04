import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import {
  sendCodeVerification,
  sendConfirmationDeleteAccount,
} from "./utils/mails/send_mail";

import {
  generateCodeVerification,
} from "./utils/mails/generate_code_verification";

const {info} = functions.logger;

admin.initializeApp();

export const onUserCreated = functions.auth.user().onCreate(
    async ({uid, email}): Promise<void> => {
      if (email) {
        const displayName = email?.split("@")[0];

        const code = await generateCodeVerification(
            uid,
        );

        await sendCodeVerification(email, code);

        await admin.auth().updateUser(uid, {
          displayName,
        });

        await admin.firestore().collection("users").doc(uid).set({
          displayName: displayName.toLowerCase(),
        });

        info("User created", {uid, email, displayName});
      }
    }
);

export const onUserDeleted = functions
    .auth
    .user()
    .onDelete(async ({uid, email}): Promise<void> => {
      info("User deleted", {uid});

      if (!email) return;

      await sendConfirmationDeleteAccount(email);
    });

export const onCheckCodesUpdated = functions
    .firestore
    .document("check_codes/{uid}")
    .onUpdate(async (change, context): Promise<void> => {
      const {uid} = context.params;
      const {validated} = change.after.data();

      if (validated) {
        await admin.auth().updateUser(uid, {
          emailVerified: true,
        });

        await admin.firestore().collection("check_codes").doc(uid).delete();

        info("User validated", {uid});
      }
    });

export const onTransactionalMail = functions
    .firestore
    .document("transactional_mails/{transactionalMailId}")
    .onCreate(async (snap, context): Promise<void> => {
      const {transactionalMailId} = context.params;
      const {userId: uid, sendAt} = snap.data();

      const {email} = await admin.auth().getUser(uid);

      if (email && !sendAt) {
        const code = await generateCodeVerification(
            uid,
        );

        await sendCodeVerification(
            email,
            code
        );

        info("Email sent", {uid, email});

        await admin
            .firestore()
            .collection("transactional_mails")
            .doc(transactionalMailId)
            .update({
              sentAt: admin.firestore.FieldValue.serverTimestamp(),
            });
      }
    });

export const onGroupCreated = functions
    .firestore
    .document("groups/{groupId}")
    .onCreate(async (snap, context): Promise<void> => {
      const {groupId} = context.params;

      const createdAt = admin.firestore.FieldValue.serverTimestamp();

      await admin
          .firestore()
          .collection("groups")
          .doc(groupId)
          .update({
            createdAt,
            updatedAt: createdAt,
          });
    });

export const onMessageCreated = functions
    .firestore
    .document("groups/{groupId}/messages/{messageId}")
    .onCreate(async (snap, context): Promise<void> => {
      const {groupId, messageId} = context.params;
      const {message} = snap.data();

      const createdAt = admin.firestore.FieldValue.serverTimestamp();

      await admin
          .firestore()
          .collection("groups")
          .doc(groupId)
          .collection("messages")
          .doc(messageId).update({
            createdAt,
            updatedAt: createdAt,
          });

      await admin
          .firestore()
          .collection("groups")
          .doc(groupId)
          .update({
            lastMessage: message,
            lastMessageTime: createdAt,
          });
    });
