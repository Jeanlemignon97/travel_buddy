import * as admin from "firebase-admin";

// Initialisation de l'admin SDK
admin.initializeApp();

// Exportation des fonctions
export {onTripCreated} from "./triggers/itinerary/on_trip_created";
