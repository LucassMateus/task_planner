# TaskPlanner

TaskPlanner é um aplicativo de gerenciamento de tarefas projetado para ajudar os usuários a organizar suas atividades de forma eficiente. Ele permite criar, editar, organizar e receber notificações sobre suas tarefas, tudo em um design intuitivo e funcional.

---

## 📱 **Recursos Principais**
- **Criação de Tarefas:** Adicione tarefas com detalhes personalizados, como título, descrição e prazos.
- **Organização:** Agrupe tarefas por categorias, como "A Fazer", "Em Progresso" e "Concluído".
- **Notificações Locais:** Receba lembretes sobre as tarefas.
- **Persistência de Dados:** Todas as tarefas são armazenadas localmente no dispositivo, garantindo acesso offline.

---

## 🛠️ **Tecnologias e Arquitetura**

### **Arquitetura**
- **MVVM (Model-View-ViewModel):** Utilizamos o padrão MVVM combinado com o Repository Pattern para separar responsabilidades e manter o código escalável e testável.
  - **Model:** Representa os dados e a lógica do negócio.
  - **ViewModel:** Contém toda a lógica e manipulação de dados para a UI.
  - **View:** Exibe os dados ao usuário e delega as interações para o ViewModel.

---

### **Principais Tecnologias**

**Sqflite:**  
Persistência de dados local utilizando SQLite.

**SharedPreferences:**  
Armazenamento local de configurações simples.

**flutter_local_notifications:**  
Implementação de notificações locais para alertar sobre tarefas.

**Provider:**  
Injeção de dependências.

**ChangeNotifier:**  
Gerenciamento de estado.

---

## ⚙️ **Configuração e Execução**

### 1. **Pré-requisitos**
- Flutter SDK (versão mais recente recomendada)
- Ambiente configurado para desenvolvimento Flutter (Android Studio, VSCode, etc.)

### 2. **Instale as Dependências**
Execute o seguinte comando no terminal para instalar todas as dependências:

```bash
flutter pub get
```
### 3. **Conecte um emulador ou dispositivo físico e use o comando:**
```bash
flutter run
```