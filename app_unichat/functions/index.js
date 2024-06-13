const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myFunction = functions.firestore
  .document("salas-participantes/{idDocumento}/mensagens/{idMensagem}")
  .onCreate((snapshot, context) => {
    const { idDocumento } = context.params;
    const { email, conteudo } = snapshot.data();

    const message = {
      notification: {
        title: email,
        body: conteudo,
      },
      topic: idDocumento,
    };

    return admin.messaging().send(message);
  });
