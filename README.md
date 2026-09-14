# 📱 UniChat

Este projeto foi desenvolvido como parte do trabalho semestral na faculdade. Criamos um aplicativo de mensagens voltado para o ambiente acadêmico, com funcionalidades específicas para alunos, professores e coordenadores. Utilizamos o framework Flutter para o desenvolvimento do app e o Firebase para a autenticação e armazenamento em tempo real.

## Objetivos do Projeto
- Desenvolver um aplicativo de mensagens que atenda às necessidades da comunidade acadêmica.
- Criar interfaces intuitivas e amigáveis para diferentes tipos de usuários (alunos, professores e coordenadores).
- Integrar funcionalidades modernas, como modo escuro e notificações push.

## Funcionalidades
- **Cadastro de Usuários:** Registro de alunos, professores e coordenadores.
- **Envio de Mensagens:** Professores e coordenadores podem enviar mensagens; alunos apenas recebem.
- **Visualização de Perfil:** Permite que os usuários vejam seus perfis.
- **Modo Escuro:** Opção de tema escuro para melhorar a experiência do usuário.
- **Notificações Push:** Alerta os usuários sobre novas mensagens.

## Tecnologias Utilizadas
- **Figma:** Ferramenta para design e prototipagem das telas.
- **Flutter:** Framework utilizado para o desenvolvimento do aplicativo.
- **Firebase:** Utilizado para autenticação, banco de dados em tempo real e envio de notificações.

## Estrutura do Projeto
1. **Design e Prototipagem:**
   - Criação dos wireframes e mockups no Figma.
   - Definição do fluxo de navegação e interações do usuário.

2. **Desenvolvimento:**
   - Implementação das telas e navegação com Flutter.
   - Integração com Firebase para autenticação e banco de dados em tempo real.
   - Implementação do modo escuro e notificações push.
   - Testes e depuração do aplicativo.

---

### 👨‍🏫 Professores Orientadores
- **Gustavo**
- **Renata**

### 👨‍💻 Participantes do Projeto
- [👩‍💻 Gabriella Freitas](https://github.com/gsfgabi)
- [👩‍💻 Geovanna Cardoso](https://github.com/GiihCardoso)
- [👩‍💻 Kethellin Pereira](https://github.com/Kethellin)
- [👨‍💻 Wendel Vinicius](https://github.com/Wendel-Vinicius)

---

<div align="center">
  <img style="height:48px; margin: 0 10px;" src="https://img.icons8.com/color/48/flutter.png" alt="Flutter"/>
  <img style="height:48px; margin: 0 10px;" src="https://img.icons8.com/color/48/figma--v1.png" alt="Figma"/>
  <img style="height:48px; margin: 0 10px;" src="https://img.icons8.com/office/80/prototype.png" alt="Prototipagem"/>
  <img style="height:48px; margin: 0 10px;" src="https://img.icons8.com/color/48/firebase.png" alt="firebase"/>
</div>

---

## 🚀 Como Executar o Projeto
1. Clone este repositório:
   ```bash
   git clone https://github.com/SeuUsuario/ProjetoAppDeMensagens.git
   ```
2. Navegue até o diretório do projeto:
   ```bash
   cd app_unichat
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Execute o aplicativo:
   ```bash
   flutter run
   ```
5. Acesse com a conta que a coordenação criou. Contas de teste **não ficam** neste README.

Para cadastrar docente ou coordenador, use o **código de convite** definido em `STAFF_INVITE_CODE` (Functions → variáveis de ambiente). Sem isso, o cadastro de equipe é recusado.

Depois de puxar este commit, publique regras e functions:

```bash
cd app_unichat
firebase deploy --only functions,firestore:rules,storage
```

Rotacione no Firebase Auth qualquer senha que já tenha aparecido em versão antiga deste README.

## 📜 Licença
Este projeto está licenciado sob a Licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

