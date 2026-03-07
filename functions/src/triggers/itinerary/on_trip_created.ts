import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {NotificationService} from "../../services/notification_service";
import {Trip} from "../../models/trip";

/**
 * Déclencheur qui s'active à la création d'un nouveau voyage.
 */
export const onTripCreated = onDocumentCreated(
  "trips/{tripId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      console.log("Aucune donnée trouvée dans l'événement.");
      return;
    }

    const trip = snapshot.data() as Trip;
    const tripTitle = trip.title || "Inconnu";

    console.log(`[onTripCreated] Nouveau voyage: ${tripTitle}`);

    try {
      await NotificationService.sendToTopic(
        "travel_updates",
        "Nouveau voyage !",
        `Un nouveau voyage est prévu : ${tripTitle}`
      );
    } catch (error) {
      console.error(
        `[onTripCreated] Erreur pour ${event.params.tripId}:`,
        error
      );
    }
  }
);
