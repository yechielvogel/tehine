/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// eslint-disable-next-line no-unused-vars
const {onRequest} = require("firebase-functions/v2/https");
// eslint-disable-next-line no-unused-vars
const logger = require("firebase-functions/logger");
const functions = require("firebase-functions");
const express = require("express");
const bodyParser = require("body-parser");
const app = express();
// Automatically parse JSON request bodies
app.use(bodyParser.json());
// Handle POST requests to '/webhook'
app.post("/webhook_for_attending", (req, res) => {
  // Remove unused variable webhookData
  // const webhookData = req.body;
  // Process the webhook data (e.g., store it in a database)
  // Send a response
  res.status(200).send("Webhook received successfully");
});
// Export the Express app as a Cloud Function
exports.webhook = functions.https.onRequest(app);
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
