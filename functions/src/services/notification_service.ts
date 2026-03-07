import * as admin from "firebase-admin";

/**
 * Service pour gérer l'envoi des notifications push via FCM.
 */
export class NotificationService {
  /**
   * Envoie une notification à un topic spécifique.
   * @param {string} topic Le nom du topic (ex: 'travel_updates')
   * @param {string} title Le titre de la notification
   * @param {string} body Le corps du message
   */
  static async sendToTopic(
    topic: string,
    title: string,
    body: string
  ): Promise<void> {
    const message: admin.messaging.Message = {
      notification: {
        title: title,
        body: body,
      },
      topic: topic,
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        type: "new_trip",
      },
    };

    try {
      const response = await admin.messaging().send(message);
      console.log(`[NotificationService] Succès: ${response}`);
    } catch (error) {
      console.error("[NotificationService] Erreur:", error);
      throw error;
    }
  }
}
