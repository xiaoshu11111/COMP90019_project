const firebase = require("firebase");


var firebaseConfig = {
  apiKey: "AIzaSyD3DBS3AkptssKP-PX7F9YNZhphYKPIgg0",
  authDomain: "graffiti-project.firebaseapp.com",
  databaseURL: "https://graffiti-project.firebaseio.com",
  projectId: "graffiti-project",
  storageBucket: "graffiti-project.appspot.com",
  messagingSenderId: "151236276387",
  appId: "1:151236276387:web:841f0616cace235f138f16",
  measurementId: "G-R2SZ25TH3F"
};

firebase.initializeApp(firebaseConfig);
const databaseRef = firebase.database().ref('images');
const storage = firebase.storage();
const storageRef = storage.ref('images');

export const dbRef = databaseRef;
export const imagesRef = storageRef;
export const images = databaseRef.child("images");
export default firebase;
