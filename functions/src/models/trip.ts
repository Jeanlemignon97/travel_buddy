export interface Trip {
  id: string;
  title: string;
  destination: string;
  date: unknown; // Firestore Timestamp
  userId: string;
  createdAt?: unknown;
}
