const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const { format } = require("date-fns");

admin.initializeApp();

const db = admin.firestore();

/**
 * @param {functions.https.CallableContext} context
 * @return {functions.https.CallableContext["auth"]}
 */
function assertAuth(context) {
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "Faça login para continuar.",
    );
  }
  return context.auth;
}

exports.listarNomesTurmas = functions.https.onCall(async () => {
  const snap = await db.collection("salas-participantes").get();
  const names = [...new Set(
      snap.docs.map((doc) => doc.get("nome")).filter(Boolean),
  )];
  names.sort((a, b) => String(a).localeCompare(String(b), "pt-BR"));
  return { names };
});

exports.entrarTurma = functions.https.onCall(async (data, context) => {
  const auth = assertAuth(context);
  const codigo = String(data?.codigo ?? "").trim().toUpperCase();
  if (!codigo) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Informe o código da turma.",
    );
  }
  const email = auth.token.email;
  if (!email) {
    throw new functions.https.HttpsError(
        "failed-precondition",
        "Conta sem e-mail.",
    );
  }
  const snap = await db.collection("salas-participantes")
      .where("codigo", "==", codigo)
      .limit(1)
      .get();
  if (snap.empty) {
    throw new functions.https.HttpsError("not-found", "Turma não encontrada.");
  }
  await snap.docs[0].ref.update({
    email: admin.firestore.FieldValue.arrayUnion(email),
  });
  return { salaId: snap.docs[0].id };
});

exports.criarContaEquipe = functions.https.onCall(async (data) => {
  const esperado = process.env.STAFF_INVITE_CODE || "";
  const convite = String(data?.convite ?? "");
  if (!esperado || convite !== esperado) {
    throw new functions.https.HttpsError(
        "permission-denied",
        "Convite inválido.",
    );
  }

  const email = String(data?.email ?? "").trim().toLowerCase();
  const password = String(data?.password ?? "");
  const nome = String(data?.nome ?? "").trim();
  const papel = String(data?.papel ?? "");

  if (!email.includes("unicv.edu.br")) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Use e-mail institucional.",
    );
  }
  if (password.length < 6 || !nome) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Dados incompletos.",
    );
  }
  if (!["professor", "coordenador"].includes(papel)) {
    throw new functions.https.HttpsError("invalid-argument", "Papel inválido.");
  }

  try {
    const user = await admin.auth().createUser({
      email,
      password,
      displayName: nome,
    });
    const isProfessor = papel === "professor";
    const isCoordenador = papel === "coordenador";
    await admin.auth().setCustomUserClaims(user.uid, { role: papel });
    await db.collection("usuarios").doc(user.uid).set({
      email,
      usuario: nome,
      isProfessor,
      isCoordenador,
      isAdmin: false,
    });
    return { uid: user.uid };
  } catch (err) {
    if (err.code === "auth/email-already-exists") {
      throw new functions.https.HttpsError(
          "already-exists",
          "Email já utilizado",
      );
    }
    throw new functions.https.HttpsError("internal", String(err.message || err));
  }
});

exports.notification = functions.firestore
    .document("salas-participantes/{salaId}/mensagens/{mensagemId}")
    .onCreate(async (snapshot, context) => {
      const { salaId } = context.params;
      const { timestamp, usuario } = snapshot.data();
      const nomeUsuario = await buscarNomeUsuario(usuario);
      const dataHora = format(timestamp.toDate(), "dd/MM/yyyy HH:mm");

      const message = {
        notification: {
          title: nomeUsuario,
          body: `Nova mensagem na turma · ${dataHora}`,
        },
        android: {
          notification: {
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        },
        topic: salaId,
      };

      return admin.messaging().send(message);
    });

/**
 * @param {string} emailUsuario
 * @return {Promise<string>}
 */
async function buscarNomeUsuario(emailUsuario) {
  const usuariosSnapshot = await db.collection("usuarios")
      .where("email", "==", emailUsuario)
      .limit(1)
      .get();

  if (!usuariosSnapshot.empty) {
    return usuariosSnapshot.docs[0].data().usuario;
  }

  return "Usuário Desconhecido";
}
