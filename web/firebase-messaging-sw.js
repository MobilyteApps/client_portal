importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCyRyZ_Ctef9TsDGh2b4MiTs5wbr5hU8es",
  authDomain: "https://mosby-client-portal.firebaseio.com",
  databaseURL:"https://mosby-client-portal.firebaseio.com",
  projectId: "mosby-client-portal",
  storageBucket: "mosby-client-portal.appspot.com",
  messagingSenderId: "927404267954",
  appId: "1:927404267954:web:371a8280580b70a41f2cab",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});