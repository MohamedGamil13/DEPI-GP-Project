const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');
const { onDocumentCreated } = require('firebase-functions/v2/firestore');

initializeApp();

exports.onNewMessage = onDocumentCreated(
  'conversations/{conversationId}/messages/{messageId}',
  async (event) => {
    const msg = event.data.data();
    const { conversationId } = event.params;

    const db = getFirestore();

    const [receiverSnap, senderSnap] = await Promise.all([
      db.collection('usersMetaData').doc(msg.receiverId).get(),
      db.collection('usersMetaData').doc(msg.senderId).get(),
    ]);

    const fcmToken = receiverSnap.data()?.fcmToken;
    if (!fcmToken) return; // receiver hasn't granted notifications

    const senderName = senderSnap.data()?.name ?? 'Someone';

    try {
      await getMessaging().send({
        token: fcmToken,
        notification: {
          title: senderName,
          body: msg.text,
        },
        data: {
          type: 'message',
          conversationId,
        },
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
