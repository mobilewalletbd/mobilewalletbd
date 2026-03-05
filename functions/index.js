const {setGlobalOptions} = require("firebase-functions");
const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");

admin.initializeApp();

setGlobalOptions({ maxInstances: 10 });

exports.onTeamMemberAdded = onDocumentUpdated("teams/{teamId}", async (event) => {
  const beforeData = event.data.before.data();
  const afterData = event.data.after.data();

  if (!beforeData || !afterData) return null;

  const beforeMemberIds = beforeData.memberIds || [];
  const afterMemberIds = afterData.memberIds || [];

  // Find users who are in 'after' but not in 'before'
  const newMemberIds = afterMemberIds.filter((id) => !beforeMemberIds.includes(id));

  if (newMemberIds.length === 0) {
    return null;
  }

  const teamName = afterData.name || "A team";
  const db = admin.firestore();
  const batch = db.batch();

  let count = 0;
  for (const userId of newMemberIds) {
    if (userId.startsWith("pending_")) continue; // Skip pending email invites
    
    const notificationId = `${userId}_${event.params.teamId}_joined`;
    const notificationRef = db.collection("notifications").doc(notificationId);
    
    batch.set(notificationRef, {
      notificationId: notificationId,
      userId: userId,
      type: "team_invite",
      title: "Added to Team",
      message: `You have been added to the team "${teamName}".`,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    count++;
  }

  if (count > 0) {
    await batch.commit();
    logger.info(`Sent ${count} notifications for team ${event.params.teamId}`);
  }
  
  return null;
});
