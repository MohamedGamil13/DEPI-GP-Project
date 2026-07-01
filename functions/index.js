const { initializeApp } = require('firebase-admin/app');
const { FieldValue, getFirestore } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');
const { onDocumentCreated } = require('firebase-functions/v2/firestore');

initializeApp();

const db = getFirestore();

const MAX_BODY_LENGTH = 200;
const INVALID_TOKEN_CODES = new Set([
  'messaging/invalid-registration-token',
  'messaging/registration-token-not-registered',
]);

exports.onNewMessage = onDocumentCreated(
  'conversations/{conversationId}/messages/{messageId}',
  async (event) => {
    const msg = event.data.data();
    const { conversationId } = event.params;

    if (!msg.receiverId || !msg.senderId || msg.receiverId === msg.senderId) return;

    const [receiverSnap, senderSnap] = await Promise.all([
      db.collection('usersMetaData').doc(msg.receiverId).get(),
      db.collection('usersMetaData').doc(msg.senderId).get(),
    ]);

    const receiverData = receiverSnap.data() ?? {};
    const tokens = [
      ...(Array.isArray(receiverData.fcmTokens) ? receiverData.fcmTokens : []),
      receiverData.fcmToken,
    ].filter((token, index, all) => token && all.indexOf(token) === index);
    if (tokens.length === 0) return;

    const senderName = senderSnap.data()?.name ?? 'Someone';
    const body = (msg.text ?? '').slice(0, MAX_BODY_LENGTH);

    const response = await getMessaging().sendEachForMulticast({
      tokens,
      notification: { title: senderName, body },
      data: { type: 'message', conversationId },
    });

    const invalidTokens = response.responses
      .map((result, index) =>
        result.error && INVALID_TOKEN_CODES.has(result.error.code)
          ? tokens[index]
          : null,
      )
      .filter(Boolean);

    if (invalidTokens.length > 0) {
      const updates = {
        fcmTokens: FieldValue.arrayRemove(...invalidTokens),
      };
      if (invalidTokens.includes(receiverData.fcmToken)) {
        updates.fcmToken = FieldValue.delete();
      }
      await db.collection('usersMetaData').doc(msg.receiverId).update(updates);
    }
  },
);
