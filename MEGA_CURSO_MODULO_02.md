# 🎮 **MEGA CURSO: CRIANDO UM LAUNCHER DE JOGO DO ZERO**
## **MÓDULO 2: CRIANDO A ESTRUTURA BASE DO PROJETO**
### *"Finalmente vamos botar a mão na massa e criar nosso primeiro código!"*

---

## 📖 **ÍNDICE DO MÓDULO**
- [Revisão do Módulo Anterior](#-revisão-do-módulo-anterior)
- [Criando o Projeto no Visual Studio](#-criando-o-projeto-no-visual-studio)
- [Entendendo a Estrutura de Arquivos](#-entendendo-a-estrutura-de-arquivos)
- [Configurando as Dependências](#-configurando-as-dependências)
- [Criando a Estrutura de Pastas](#-criando-a-estrutura-de-pastas)
- [Nosso Primeiro Código](#-nosso-primeiro-código)
- [Exercícios Práticos](#-exercícios-práticos)
- [Resumo e Próximos Passos](#-resumo-do-módulo-2)

---

## 🔄 **REVISÃO DO MÓDULO ANTERIOR**

### ✅ **O QUE JÁ SABEMOS:**
- 🎯 O que é um launcher e sua importância
- 🛠 Que tecnologias vamos usar (C#, Windows Forms, .NET Framework 4.8)
- 🏗 A arquitetura do nosso projeto (4 projetos principais)
- 📋 Como preparar o ambiente de desenvolvimento

### 🎯 **O QUE VAMOS FAZER HOJE:**
Hoje vamos **sair da teoria** e partir para a **prática**! Vamos:
1. ✅ Criar nosso primeiro projeto no Visual Studio
2. ✅ Entender como funciona a estrutura de arquivos
3. ✅ Configurar todas as dependências necessárias
4. ✅ Ver nossa primeira janela funcionando
5. ✅ Preparar a base para todos os próximos módulos

---

## 🚀 **CRIANDO O PROJETO NO VISUAL STUDIO**

### 🔷 **PASSO 1: ABRINDO O VISUAL STUDIO**

1. **Abra o Visual Studio Community**
2. **Clique em "Create a new project"** (Criar um novo projeto)
3. Se já tem projetos abertos, vá em **File → New → Project**

### 🔷 **PASSO 2: ESCOLHENDO O TIPO DE PROJETO**

Na tela de criação de projeto:

1. **Procure por "Windows Forms"** na barra de pesquisa
2. **Selecione "Windows Forms App (.NET Framework)"**
   - ⚠️ **IMPORTANTE:** Não escolha a versão ".NET Core" ou ".NET 5/6/7"
   - ⚠️ Precisamos da versão **.NET Framework** para compatibilidade
3. **Clique em "Next"**

### 🔷 **PASSO 3: CONFIGURANDO O PROJETO**

Preencha os campos:

```
📝 Project name: AAEmu.Launcher
📁 Location: C:\Dev\AAEmu-Launcher (ou onde preferir)
📁 Solution name: AAEmu-Launcher
✅ Place solution and project in the same directory
```

**Explicação para iniciantes:**
- **Project name** = Nome do nosso programa
- **Location** = Pasta onde o Visual Studio vai salvar os arquivos
- **Solution** = É como uma "pasta mestre" que pode conter vários projetos

### 🔷 **PASSO 4: ESCOLHENDO A VERSÃO DO .NET**

Na próxima tela:
- **Selecione ".NET Framework 4.8"**
- **Clique em "Create"**

### 🎉 **PARABÉNS! SEU PRIMEIRO PROJETO FOI CRIADO!**

O Visual Studio vai criar automaticamente uma estrutura básica. Você deve ver algo assim:

```
📁 AAEmu.Launcher
├── 📄 Form1.cs (nossa primeira janela!)
├── 📄 Form1.Designer.cs (código gerado automaticamente)
├── 📄 Form1.resx (recursos da janela)
├── 📄 Program.cs (ponto de entrada do programa)
├── 📁 Properties
│   └── 📄 AssemblyInfo.cs (informações do programa)
└── 📄 AAEmu.Launcher.csproj (arquivo de configuração do projeto)
```

---

## 🗂 **ENTENDENDO A ESTRUTURA DE ARQUIVOS**

Vamos entender **cada arquivo** que o Visual Studio criou:

### 🔷 **Program.cs - O "Portal de Entrada"**

Este é o **primeiro arquivo** que roda quando alguém clica no seu programa:

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AAEmu.Launcher
{
    static class Program
    {
        /// <summary>
        /// Ponto de entrada principal para a aplicação.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}
```

**Explicação linha por linha:**
- **using** = "Importar bibliotecas" (como incluir ferramentas na nossa caixa)
- **namespace** = "Endereço" do nosso código (como CEP de uma casa)
- **static void Main()** = A função que roda primeiro (como apertar o botão de ligar)
- **Application.Run(new Form1())** = "Mostrar a janela Form1 na tela"

### 🔷 **Form1.cs - Nossa Primeira Janela**

Este arquivo contém o **comportamento** da nossa janela:

```csharp
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AAEmu.Launcher
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
    }
}
```

**Explicação:**
- **public partial class Form1 : Form** = "Criar uma nova janela baseada no modelo padrão"
- **Form1()** = "Construtor" - código que roda quando a janela é criada
- **InitializeComponent()** = "Configurar todos os botões e elementos visuais"

### 🔷 **Form1.Designer.cs - O "Arquiteto Visual"**

Este arquivo é **gerado automaticamente** pelo Visual Studio. Contém o código que:
- Cria botões, caixas de texto, imagens, etc.
- Define posições na tela
- Configura cores, tamanhos, fontes

⚠️ **IMPORTANTE:** Nunca edite este arquivo manualmente! Use o designer visual.

### 🔷 **AAEmu.Launcher.csproj - As "Receitas" do Projeto**

Este arquivo XML diz ao Visual Studio:
- Que versão do .NET usar
- Quais bibliotecas baixar
- Como compilar o programa
- Configurações especiais

---

## 📦 **CONFIGURANDO AS DEPENDÊNCIAS**

Nosso launcher precisa de algumas **bibliotecas extras**. Vamos instalá-las:

### 🔷 **PASSO 1: ABRINDO O NUGET PACKAGE MANAGER**

1. **Clique com botão direito** no projeto "AAEmu.Launcher" (no Solution Explorer)
2. **Selecione "Manage NuGet Packages..."**

### 🔷 **PASSO 2: INSTALANDO O NEWTONSOFT.JSON**

Esta biblioteca nos ajuda a trabalhar com arquivos de configuração:

1. **Clique na aba "Browse"**
2. **Procure por "Newtonsoft.Json"**
3. **Selecione o primeiro resultado** (by James Newton-King)
4. **Clique em "Install"**
5. **Aceite** todas as confirmações

### 🔷 **PASSO 3: VERIFICANDO A INSTALAÇÃO**

Na aba **"Installed"**, você deve ver:
- ✅ **Newtonsoft.Json** (versão 13.x ou superior)

### 🎯 **POR QUE PRECISAMOS DESSAS BIBLIOTECAS?**

**Newtonsoft.Json** é como um "tradutor" que:
- 🔄 Converte nossas configurações em arquivos salvos
- 📖 Lê arquivos de configuração salvos
- 🌐 Trabalha com dados que vêm da internet
- ⚙️ Organiza informações de forma estruturada

---

## 📁 **CRIANDO A ESTRUTURA DE PASTAS**

Vamos organizar nosso projeto criando pastas para diferentes tipos de arquivos:

### 🔷 **CRIANDO PASTAS NO VISUAL STUDIO**

1. **Clique com botão direito** no projeto "AAEmu.Launcher"
2. **Add → New Folder**
3. **Digite o nome da pasta**

### 🔷 **ESTRUTURA DE PASTAS RECOMENDADA**

Crie essas pastas:

```
📁 AAEmu.Launcher
├── 📁 Forms (nossas janelas)
├── 📁 Helpers (funções auxiliares)
├── 📁 Models (estruturas de dados)
├── 📁 Resources (imagens, ícones, etc.)
│   ├── 📁 Images
│   ├── 📁 Icons
│   └── 📁 Flags
├── 📁 Languages (arquivos de idiomas)
└── 📁 Config (configurações)
```

### 🔷 **ORGANIZANDO ARQUIVOS EXISTENTES**

Vamos mover alguns arquivos para ficarem mais organizados:

1. **Arraste Form1.cs** para a pasta **Forms**
2. **Arraste Form1.Designer.cs** para a pasta **Forms**
3. **Arraste Form1.resx** para a pasta **Forms**

⚠️ **ATENÇÃO:** O Visual Studio pode reclamar sobre namespaces. Por enquanto é normal!

---

## 💻 **NOSSO PRIMEIRO CÓDIGO**

Vamos fazer nossa primeira modificação! Vamos **renomear** nossa janela e adicionar um **título**.

### 🔷 **RENOMEANDO A JANELA**

1. **Clique com botão direito** em **Form1.cs** (na pasta Forms)
2. **Rename** → Digite **"LauncherForm.cs"**
3. **Enter** → **Yes** para renomear tudo

### 🔷 **EDITANDO O PROGRAM.CS**

Abra **Program.cs** e **substitua** todo o conteúdo por:

```csharp
using System;
using System.Windows.Forms;

namespace AAEmu.Launcher
{
    static class Program
    {
        /// <summary>
        /// Ponto de entrada principal para a aplicação AAEmu Launcher.
        /// </summary>
        [STAThread]
        static void Main()
        {
            // Configurações visuais do Windows
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            
            // Inicia nosso launcher
            Application.Run(new LauncherForm());
        }
    }
}
```

### 🔷 **EDITANDO A LAUNCHERFORM.CS**

Abra **Forms/LauncherForm.cs** e **substitua** por:

```csharp
using System;
using System.Drawing;
using System.Windows.Forms;

namespace AAEmu.Launcher
{
    public partial class LauncherForm : Form
    {
        public LauncherForm()
        {
            InitializeComponent();
            ConfigurarJanela();
        }
        
        private void ConfigurarJanela()
        {
            // Configurações básicas da janela
            this.Text = "AAEmu Launcher - v1.0";
            this.Size = new Size(800, 600);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.BackColor = Color.FromArgb(45, 45, 48);
            
            // Adicionar um label de boas-vindas
            CriarLabelBoasVindas();
        }
        
        private void CriarLabelBoasVindas()
        {
            Label lblBoasVindas = new Label();
            lblBoasVindas.Text = "Bem-vindo ao AAEmu Launcher!";
            lblBoasVindas.Font = new Font("Arial", 16, FontStyle.Bold);
            lblBoasVindas.ForeColor = Color.White;
            lblBoasVindas.AutoSize = true;
            
            // Centralizar o texto
            lblBoasVindas.Left = (this.Width - lblBoasVindas.Width) / 2;
            lblBoasVindas.Top = 50;
            
            // Adicionar à janela
            this.Controls.Add(lblBoasVindas);
        }
    }
}
```

### 🔷 **TESTANDO NOSSO CÓDIGO**

Agora vamos **rodar** nosso programa pela primeira vez!

1. **Pressione F5** ou clique no botão **"Start"** (▶️)
2. **Aguarde** o Visual Studio compilar
3. **SUCESSO!** Sua primeira janela deve aparecer!

### 🎉 **PARABÉNS! VOCÊ CRIOU SEU PRIMEIRO PROGRAMA!**

Se tudo deu certo, você deve ver:
- ✅ Uma janela cinza escura de 800x600 pixels
- ✅ Título "AAEmu Launcher - v1.0" na barra superior
- ✅ Texto "Bem-vindo ao AAEmu Launcher!" centralizado
- ✅ A janela aparece no centro da tela

---

## 🧩 **EXERCÍCIOS PRÁTICOS**

Vamos praticar o que aprendemos! Tente fazer essas modificações:

### 🔷 **EXERCÍCIO 1: PERSONALIZANDO CORES**

Mude a cor de fundo da janela:
```csharp
// Dentro do método ConfigurarJanela()
this.BackColor = Color.FromArgb(25, 25, 112); // Azul escuro
// OU
this.BackColor = Color.DarkSlateGray; // Verde acinzentado
```

### 🔷 **EXERCÍCIO 2: ADICIONANDO UM BOTÃO**

Adicione este código no final do método `ConfigurarJanela()`:

```csharp
// Criar um botão de teste
Button btnTeste = new Button();
btnTeste.Text = "Clique em mim!";
btnTeste.Size = new Size(120, 40);
btnTeste.Location = new Point(340, 150);
btnTeste.BackColor = Color.RoyalBlue;
btnTeste.ForeColor = Color.White;
btnTeste.Font = new Font("Arial", 10, FontStyle.Bold);

// Adicionar evento de clique
btnTeste.Click += (sender, e) => {
    MessageBox.Show("Olá! Você criou seu primeiro botão!", "Sucesso!");
};

// Adicionar à janela
this.Controls.Add(btnTeste);
```

### 🔷 **EXERCÍCIO 3: ADICIONANDO UM CAMPO DE TEXTO**

Adicione também:

```csharp
// Criar um campo de texto
TextBox txtNome = new TextBox();
txtNome.Size = new Size(200, 25);
txtNome.Location = new Point(300, 250);
txtNome.Font = new Font("Arial", 10);
txtNome.Text = "Digite seu nome aqui...";

// Limpar texto quando o usuário clicar
txtNome.GotFocus += (sender, e) => {
    if (txtNome.Text == "Digite seu nome aqui...")
        txtNome.Text = "";
};

this.Controls.Add(txtNome);
```

### 🔷 **EXERCÍCIO 4: TESTANDO AS MODIFICAÇÕES**

1. **Salve** todos os arquivos (Ctrl+S)
2. **Execute** o programa (F5)
3. **Teste** o botão e o campo de texto
4. **Experimente** cores diferentes

---

## 🔧 **PREPARANDO PARA OS PRÓXIMOS MÓDULOS**

### 🔷 **CRIANDO ARQUIVO DE CONFIGURAÇÃO**

Vamos criar um arquivo básico para salvar configurações. Na pasta **Config**:

1. **Add → New Item → Text File**
2. **Nome:** `settings.json`
3. **Conteúdo:**

```json
{
    "version": "1.0.0",
    "language": "pt-BR",
    "serverIP": "127.0.0.1",
    "serverPort": 1237,
    "rememberLogin": false,
    "gameInstallPath": "",
    "lastUser": ""
}
```

### 🔷 **CRIANDO CLASSE DE CONFIGURAÇÕES**

Na pasta **Models**, crie um arquivo **"AppConfig.cs"**:

```csharp
using Newtonsoft.Json;

namespace AAEmu.Launcher.Models
{
    public class AppConfig
    {
        [JsonProperty("version")]
        public string Version { get; set; } = "1.0.0";
        
        [JsonProperty("language")]
        public string Language { get; set; } = "pt-BR";
        
        [JsonProperty("serverIP")]
        public string ServerIP { get; set; } = "127.0.0.1";
        
        [JsonProperty("serverPort")]
        public int ServerPort { get; set; } = 1237;
        
        [JsonProperty("rememberLogin")]
        public bool RememberLogin { get; set; } = false;
        
        [JsonProperty("gameInstallPath")]
        public string GameInstallPath { get; set; } = "";
        
        [JsonProperty("lastUser")]
        public string LastUser { get; set; } = "";
    }
}
```

---

## 🎯 **RESUMO DO MÓDULO 2**

### ✅ **O QUE VOCÊ CONQUISTOU HOJE:**

1. **🚀 Criou seu primeiro projeto Windows Forms**
   - Aprendeu a navegar no Visual Studio
   - Entendeu a diferença entre .NET Framework e .NET Core
   - Configurou o projeto corretamente

2. **🗂 Compreendeu a estrutura de arquivos**
   - Program.cs (ponto de entrada)
   - Form.cs (comportamento da janela)
   - Form.Designer.cs (elementos visuais)
   - .csproj (configurações do projeto)

3. **📦 Configurou dependências externas**
   - Instalou Newtonsoft.Json via NuGet
   - Aprendeu o que são e para que servem bibliotecas

4. **📁 Organizou o projeto profissionalmente**
   - Criou estrutura de pastas lógica
   - Separou diferentes tipos de arquivos
   - Preparou base para crescimento futuro

5. **💻 Escreveu código real funcionando**
   - Modificou a janela principal
   - Adicionou elementos visuais
   - Testou o programa rodando

6. **🧩 Praticou com exercícios**
   - Personalizou cores e estilos
   - Adicionou botões e campos de texto
   - Criou interações básicas

### 🎯 **CONCEITOS TÉCNICOS DOMINADOS:**

- ✅ **Namespace** - organização de código
- ✅ **Classes e Objetos** - base da POO
- ✅ **Métodos** - funções que fazem coisas
- ✅ **Propriedades** - características dos objetos
- ✅ **Event Handlers** - resposta a ações do usuário
- ✅ **Windows Forms Controls** - elementos visuais
- ✅ **JSON** - formato de dados estruturados

### 🚀 **METAS PARA O PRÓXIMO MÓDULO:**

No **MÓDULO 3**, vamos criar uma interface gráfica **profissional**:
- ✅ Designer visual do Visual Studio
- ✅ Layout responsivo e bonito
- ✅ Imagens e recursos visuais
- ✅ Botões customizados
- ✅ Campos de login estilizados
- ✅ Primeira versão funcional da interface

---

## 🏆 **PARABÉNS PELA EVOLUÇÃO!**

### 📈 **PROGRESSO NO CURSO:**
```
[██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 16% Completo

✅ MÓDULO 1 - Fundamentos (Concluído)
✅ MÓDULO 2 - Estrutura Base (Concluído) 
→  MÓDULO 3 - Interface Gráfica (Próximo)
```

### 🎮 **MOTIVAÇÃO:**
Você acabou de dar o **primeiro passo real** no mundo da programação! Saiu do zero e já tem um programa **funcionando** criado pelas suas próprias mãos. Isso é **incrível**!

No próximo módulo, vamos tornar nossa janela **linda** e **profissional**, como os launchers que você já conhece.

### 📋 **CHECKLIST ANTES DO PRÓXIMO MÓDULO:**

- [ ] Projeto AAEmu.Launcher criado e funcionando
- [ ] Newtonsoft.Json instalado corretamente
- [ ] Estrutura de pastas organizada
- [ ] Código dos exercícios testado
- [ ] Arquivo settings.json criado
- [ ] Classe AppConfig implementada

### 🔥 **PREPARADO PARA O MÓDULO 3?**

Quando estiver pronto para criar uma interface **visualmente impressionante**, digite **"CONTINUAR MÓDULO 3"** e vamos transformar nossa janela simples em um launcher de aparência profissional!

---

**© 2024 Mega Curso Launcher ArcheAge - Todos os direitos reservados**
*Curso elaborado com ❤️ para a comunidade brasileira de desenvolvedores*