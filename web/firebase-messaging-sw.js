importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyCMFkCLE_s0-xgGIeOnTFw2bbY3Ha0DcpM",
  appId: "1:589232610494:web:cd3ae166b9df86deae52ef",
  messagingSenderId: "589232610494",
  projectId: "travel-buddy-a7cba",
  authDomain: "travel-buddy-a7cba.firebaseapp.com",
  storageBucket: "travel-buddy-a7cba.firebasestorage.app",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("[firebase-messaging-sw.js] Background message received ", payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/favicon.png",
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
