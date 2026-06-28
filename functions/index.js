const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');
const { onDocumentCreated } = require('firebase-functions/v2/firestore');

initializeApp();

// fix #5: module-level so warm instances reuse the connection
const db = getFirestore();

const MAX_BODY_LENGTH = 200;

exports.onNewMessage = onDocumentCreated(
  'conversations/{conversationId}/messages/{messageId}',
  async (event) => {
    const msg = event.data.data();
    const { conversationId } = event.params;

    // fix #4: guard missing fields
    if (!msg.receiverId || !msg.senderId || msg.receiverId === msg.senderId) return;

    const [receiverSnap, senderSnap] = await Promise.all([
      db.collection('usersMetaData').doc(msg.receiverId).get(),
      db.collection('usersMetaData').doc(msg.senderId).get(),
    ]);

    const fcmToken = receiverSnap.data()?.fcmToken;
    if (!fcmToken) return; // receiver hasn't granted notifications or is logged out

    const senderName = senderSnap.data()?.name ?? 'Someone';

    // fix #6: truncate body to stay within FCM 4KB payload limit
    const body = (msg.text ?? '').slice(0, MAX_BODY_LENGTH);

    try {
      await getMessaging().send({
        token: fcmToken,
        notification: { title: senderName, body },
        data: { type: 'message', conversationId },
      });
    } catch (e) {
      if (e.code === 'messaging/registration-token-not-registered') {
        await db.collection('usersMetaData').doc(msg.receiverId).update({
          fcmToken: null,
          notificationsEnabled: false,
        });
      } else {
        throw e;
      }
    }
  },
);
