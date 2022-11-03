import * as admin from "firebase-admin";

export const generateCodeVerification = async (
    uid: string
): Promise<string> => {
  const code = Math.floor(1000 + Math.random() * 9000).toString();

  const ref = admin.firestore().collection("check_codes").doc(uid);

  await ref.set({
    code,
    created_at: admin.firestore.FieldValue.serverTimestamp(),
  });

  return code;
};
