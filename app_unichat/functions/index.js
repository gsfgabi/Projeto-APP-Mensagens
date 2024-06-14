const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { format } = require('date-fns');

admin.initializeApp();

exports.notification = functions.firestore
  .document("salas-participantes/{salaId}/mensagens/{mensagemId}")
  .onCreate(async (snapshot, context) => {
    const { salaId } = context.params;
    const { texto, timestamp, usuario } = snapshot.data();

    // Buscar o nome do usuário a partir do email
    const nomeUsuario = await buscarNomeUsuario(usuario);

    // Formatar a data e hora da mensagem para o padrão brasileiro
    const dataHora = format(timestamp.toDate(), "dd/MM/yyyy HH:mm");

    // Construir a mensagem de notificação com link para o chat
    const message = {
      notification: {
        title: nomeUsuario,
        body: `${texto}\n${dataHora}`, // Quebra de linha entre texto e data/hora
        //style: 'inbox', // Define o estilo da notificação
        //collapseKey: 'new_message', // Define a chave para agrupar notificações semelhantes
        //priority: 'high', // Define a prioridade da notificação
      },
      android: {
        notification: {
          clickAction: "FLUTTER_NOTIFICATION_CLICK", // Define a ação do clique
        },
      },
      topic: salaId,
    };

    // Enviar a notificação
    return admin.messaging().send(message);
  });

// Função para buscar o nome do usuário a partir do email
async function buscarNomeUsuario(emailUsuario) {
  const usuariosSnapshot = await admin.firestore().collection('usuarios').where('email', '==', emailUsuario).limit(1).get();

  if (!usuariosSnapshot.empty) {
    return usuariosSnapshot.docs[0].data().usuario; // Alterado para buscar o campo 'usuario'
  }

  return 'Usuário Desconhecido';
}