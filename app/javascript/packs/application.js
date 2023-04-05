// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDXYs_UpPCeQ0W30PQ4POj1Ka1WhpQB8ek",
  authDomain: "fighter-fighter.firebaseapp.com",
  projectId: "fighter-fighter",
  storageBucket: "fighter-fighter.appspot.com",
  messagingSenderId: "245986132908",
  appId: "1:245986132908:web:4f5f99df5a7e5947947009",
  measurementId: "G-VYXN5YTTG7"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// External imports
import "bootstrap";
