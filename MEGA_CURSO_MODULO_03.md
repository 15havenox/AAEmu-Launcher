# 🎮 **MEGA CURSO: CRIANDO UM LAUNCHER DE JOGO DO ZERO**
## **MÓDULO 3: DESENVOLVENDO A INTERFACE GRÁFICA PROFISSIONAL**
### *"Transformando nossa janela simples em um launcher de aparência profissional!"*

---

## 📖 **ÍNDICE DO MÓDULO**
- [Revisão do Módulo Anterior](#-revisão-do-módulo-anterior)
- [Introdução ao Designer Visual](#-introdução-ao-designer-visual)
- [Planejando Nossa Interface](#-planejando-nossa-interface)
- [Criando o Layout Base](#-criando-o-layout-base)
- [Adicionando Recursos Visuais](#-adicionando-recursos-visuais)
- [Criando Controles Customizados](#-criando-controles-customizados)
- [Implementando a Interface de Login](#-implementando-a-interface-de-login)
- [Finalizando o Design](#-finalizando-o-design)
- [Exercícios Práticos](#-exercícios-práticos)
- [Resumo e Próximos Passos](#-resumo-do-módulo-3)

---

## 🔄 **REVISÃO DO MÓDULO ANTERIOR**

### ✅ **O QUE JÁ CONQUISTAMOS:**
- 🚀 Projeto Windows Forms criado e funcionando
- 📁 Estrutura de pastas organizada profissionalmente
- 📦 Dependências configuradas (Newtonsoft.Json)
- 💻 Primeiro código C# funcionando
- 🧩 Exercícios práticos realizados

### 🎯 **O QUE VAMOS FAZER HOJE:**
Hoje vamos **transformar visualmente** nosso launcher! Vamos:
1. ✅ Descobrir o poder do Designer Visual do Visual Studio
2. ✅ Planejar uma interface profissional
3. ✅ Criar layouts responsivos e bonitos
4. ✅ Adicionar imagens e recursos visuais
5. ✅ Implementar controles customizados
6. ✅ Construir a tela de login completa

---

## 🎨 **INTRODUÇÃO AO DESIGNER VISUAL**

### 🔷 **O QUE É O DESIGNER VISUAL?**

O Designer Visual é como um **"Photoshop para programadores"**! É uma ferramenta que permite:
- 🖱️ **Arrastar e soltar** elementos na janela
- 🎨 **Configurar propriedades** visualmente
- 📐 **Alinhar elementos** com precisão
- 👀 **Ver resultado em tempo real**
- 🔄 **Gerar código automaticamente**

### 🔷 **ABRINDO O DESIGNER**

1. **No Solution Explorer**, localize **Forms/LauncherForm.cs**
2. **Clique duas vezes** no arquivo
3. **MAGIC!** O designer visual deve abrir automaticamente

Se não abrir:
- **Clique com botão direito** em LauncherForm.cs
- **View Designer** ou **Open With → Windows Forms Designer**

### 🔷 **INTERFACE DO DESIGNER**

Você verá **3 áreas principais**:

```
┌─────────────────────────────────────────────────┐
│ 🧰 TOOLBOX        │ 🎨 DESIGN AREA    │ 📊 PROPS │
│ (Componentes)     │ (Sua janela)      │ (Config) │
│                   │                   │          │
│ □ Label           │ ┌─────────────┐   │ Name:    │
│ □ Button          │ │             │   │ Text:    │
│ □ TextBox         │ │    FORM     │   │ Size:    │
│ □ PictureBox      │ │             │   │ Location:│
│ □ Panel           │ └─────────────┘   │ Color:   │
│ ...               │                   │ ...      │
└─────────────────────────────────────────────────┘
```

### 🔷 **CONCEITOS FUNDAMENTAIS**

**Toolbox** = "Caixa de ferramentas" com todos os componentes disponíveis
**Properties** = "Painel de configurações" para o elemento selecionado
**Design Area** = "Tela de pintura" onde você monta sua interface

---

## 🗺 **PLANEJANDO NOSSA INTERFACE**

### 🔷 **INSPIRAÇÃO: LAUNCHERS PROFISSIONAIS**

Vamos criar um launcher inspirado nos melhores da indústria:

```
┌──────────────────────────────────────────────────────────────┐
│ AAEmu Launcher v1.0                              [_][□][X]  │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  🖼️ [LOGO AAEMU]                     🌐 [IDIOMA] 🔧 [CONFIG] │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │                                                        │  │
│  │           🎮 ÁREA DE NOTÍCIAS/IMAGEM                   │  │
│  │                                                        │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  👤 USUÁRIO:     [____________________]                      │
│                                                              │
│  🔒 SENHA:       [____________________] ☑️ Lembrar          │
│                                                              │
│  🌍 SERVIDOR:    [127.0.0.1:1237     ▼]                     │
│                                                              │
│  🎮 CLIENTE:     [Trion 1.2           ▼]                     │
│                                                              │
│             [    🚀 JOGAR AGORA    ] [⚙️ CONFIGURAR]        │
│                                                              │
│  [🌐 SITE] [💬 DISCORD] [📰 NOTÍCIAS]     [❌ SAIR]         │
└──────────────────────────────────────────────────────────────┘
```

### 🔷 **CORES E TEMA**

Vamos usar um **tema escuro moderno**:

```css
🎨 PALETA DE CORES:
- Fundo Principal: #2d2d30 (Cinza escuro)
- Fundo Secundário: #383838 (Cinza médio)
- Bordas: #007acc (Azul VS Code)
- Texto Principal: #ffffff (Branco)
- Texto Secundário: #cccccc (Cinza claro)
- Botão Principal: #0e639c (Azul botão)
- Botão Hover: #1177bb (Azul claro)
- Sucesso: #008000 (Verde)
- Erro: #ff0000 (Vermelho)
```

### 🔷 **DIMENSÕES E LAYOUT**

```
📐 ESPECIFICAÇÕES TÉCNICAS:
- Tamanho da janela: 900x700 pixels
- Não redimensionável
- Centralizada na tela
- Sem botão de maximizar
- Com ícone personalizado
```

---

## 🏗 **CRIANDO O LAYOUT BASE**

### 🔷 **PASSO 1: CONFIGURANDO A JANELA PRINCIPAL**

1. **Abra o Designer** da LauncherForm
2. **Clique na janela** (fundo cinza)
3. **No Properties panel**, configure:

```
📝 PROPRIEDADES DA JANELA:
Name: LauncherForm
Text: AAEmu Launcher v1.0
Size: 900, 700
StartPosition: CenterScreen
FormBorderStyle: FixedSingle
MaximizeBox: False
BackColor: 45, 45, 48 (Custom)
Icon: (vamos adicionar depois)
```

### 🔷 **PASSO 2: CRIANDO PANEL DE CABEÇALHO**

1. **Da Toolbox**, arraste um **Panel** para o topo da janela
2. **Configure as propriedades**:

```
📝 PROPRIEDADES DO PANEL CABEÇALHO:
Name: panelHeader
Size: 900, 80
Location: 0, 0
Anchor: Top, Left, Right
BackColor: 56, 56, 56
BorderStyle: None
```

### 🔷 **PASSO 3: CRIANDO ÁREA DE CONTEÚDO PRINCIPAL**

1. **Arraste outro Panel** para o meio da janela
2. **Configure**:

```
📝 PROPRIEDADES DO PANEL PRINCIPAL:
Name: panelMain
Size: 900, 520
Location: 0, 80
Anchor: Top, Left, Right, Bottom
BackColor: 45, 45, 48
BorderStyle: None
```

### 🔷 **PASSO 4: CRIANDO PANEL DE RODAPÉ**

1. **Arraste um terceiro Panel** para a parte inferior
2. **Configure**:

```
📝 PROPRIEDADES DO PANEL RODAPÉ:
Name: panelFooter
Size: 900, 100
Location: 0, 600
Anchor: Bottom, Left, Right
BackColor: 35, 35, 38
BorderStyle: None
```

### 🎯 **RESULTADO ESPERADO**

Agora você deve ter uma janela com **3 seções bem definidas**:
- 🔝 **Cabeçalho** (cinza médio) - Logo e botões de idioma/config
- 🏠 **Área principal** (cinza escuro) - Formulário de login
- 🔽 **Rodapé** (cinza mais escuro) - Botões de ação e links

---

## 🖼 **ADICIONANDO RECURSOS VISUAIS**

### 🔷 **PREPARANDO IMAGENS**

Primeiro, vamos criar algumas imagens básicas. Crie essas pastas em **Resources/Images**:

1. **Clique com botão direito** na pasta Resources/Images
2. **Add → Existing Item** (ou crie arquivos temporários)

**Imagens que precisamos:**
- `logo_aaemu.png` (200x60) - Logo principal
- `bg_main.png` (900x300) - Imagem de fundo da área de notícias
- `icon_config.png` (32x32) - Ícone de configurações
- `icon_lang.png` (32x32) - Ícone de idioma
- `flag_br.png` (24x16) - Bandeira do Brasil
- `flag_us.png` (24x16) - Bandeira dos EUA

### 🔷 **ADICIONANDO LOGO NO CABEÇALHO**

1. **Selecione o panelHeader** no designer
2. **Da Toolbox**, arraste um **PictureBox**
3. **Configure**:

```
📝 PROPRIEDADES DO LOGO:
Name: pictureBoxLogo
Size: 200, 60
Location: 20, 10
SizeMode: StretchImage
Image: logo_aaemu.png (através do Properties)
BackColor: Transparent
```

### 🔷 **ADICIONANDO ÁREA DE NOTÍCIAS**

1. **Selecione o panelMain**
2. **Arraste um PictureBox** para a parte superior
3. **Configure**:

```
📝 PROPRIEDADES DA ÁREA DE NOTÍCIAS:
Name: pictureBoxNews
Size: 860, 200
Location: 20, 20
SizeMode: StretchImage
Image: bg_main.png
BorderStyle: FixedSingle
```

### 🔷 **ADICIONANDO BOTÕES DO CABEÇALHO**

**Botão de Idioma:**
1. **No panelHeader**, arraste um **Button**
2. **Configure**:

```
📝 PROPRIEDADES BOTÃO IDIOMA:
Name: btnLanguage
Size: 80, 30
Location: 720, 25
Text: 🇧🇷 PT
BackColor: 14, 99, 156
ForeColor: White
FlatStyle: Flat
Font: Arial, 9pt, Bold
```

**Botão de Configurações:**
1. **Arraste outro Button**
2. **Configure**:

```
📝 PROPRIEDADES BOTÃO CONFIG:
Name: btnSettings
Size: 80, 30
Location: 810, 25
Text: ⚙️ Config
BackColor: 14, 99, 156
ForeColor: White
FlatStyle: Flat
Font: Arial, 9pt, Bold
```

---

## 🎮 **IMPLEMENTANDO A INTERFACE DE LOGIN**

### 🔷 **CRIANDO LABELS INFORMATIVOS**

**Label "Usuário":**
1. **No panelMain**, arraste um **Label**
2. **Configure**:

```
📝 PROPRIEDADES LABEL USUÁRIO:
Name: lblUsuario
Text: 👤 USUÁRIO:
Location: 50, 250
AutoSize: True
ForeColor: White
Font: Arial, 10pt, Bold
BackColor: Transparent
```

**Label "Senha":**
```
📝 PROPRIEDADES LABEL SENHA:
Name: lblSenha
Text: 🔒 SENHA:
Location: 50, 290
AutoSize: True
ForeColor: White
Font: Arial, 10pt, Bold
BackColor: Transparent
```

**Label "Servidor":**
```
📝 PROPRIEDADES LABEL SERVIDOR:
Name: lblServidor
Text: 🌍 SERVIDOR:
Location: 50, 330
AutoSize: True
ForeColor: White
Font: Arial, 10pt, Bold
BackColor: Transparent
```

**Label "Cliente":**
```
📝 PROPRIEDADES LABEL CLIENTE:
Name: lblCliente
Text: 🎮 CLIENTE:
Location: 50, 370
AutoSize: True
ForeColor: White
Font: Arial, 10pt, Bold
BackColor: Transparent
```

### 🔷 **CRIANDO CAMPOS DE ENTRADA**

**Campo Usuário:**
1. **Arraste um TextBox**
2. **Configure**:

```
📝 PROPRIEDADES TEXTBOX USUÁRIO:
Name: txtUsuario
Size: 300, 25
Location: 200, 248
Font: Arial, 10pt
BackColor: 60, 60, 60
ForeColor: White
BorderStyle: FixedSingle
Text: (vazio)
```

**Campo Senha:**
```
📝 PROPRIEDADES TEXTBOX SENHA:
Name: txtSenha
Size: 300, 25
Location: 200, 288
Font: Arial, 10pt
BackColor: 60, 60, 60
ForeColor: White
BorderStyle: FixedSingle
PasswordChar: *
Text: (vazio)
```

**ComboBox Servidor:**
1. **Arraste um ComboBox**
2. **Configure**:

```
📝 PROPRIEDADES COMBOBOX SERVIDOR:
Name: cmbServidor
Size: 300, 25
Location: 200, 328
Font: Arial, 10pt
BackColor: 60, 60, 60
ForeColor: White
DropDownStyle: DropDownList
```

**ComboBox Cliente:**
```
📝 PROPRIEDADES COMBOBOX CLIENTE:
Name: cmbCliente
Size: 300, 25
Location: 200, 368
Font: Arial, 10pt
BackColor: 60, 60, 60
ForeColor: White
DropDownStyle: DropDownList
```

### 🔷 **CHECKBOX "LEMBRAR LOGIN"**

1. **Arraste um CheckBox**
2. **Configure**:

```
📝 PROPRIEDADES CHECKBOX:
Name: chkLembrarLogin
Text: ☑️ Lembrar login
Location: 520, 290
AutoSize: True
ForeColor: White
Font: Arial, 9pt
BackColor: Transparent
```

---

## 🚀 **CRIANDO BOTÕES DE AÇÃO**

### 🔷 **BOTÃO PRINCIPAL "JOGAR AGORA"**

1. **No panelMain**, arraste um **Button**
2. **Configure**:

```
📝 PROPRIEDADES BOTÃO JOGAR:
Name: btnJogar
Size: 200, 50
Location: 200, 420
Text: 🚀 JOGAR AGORA
BackColor: 0, 120, 215
ForeColor: White
Font: Arial, 12pt, Bold
FlatStyle: Flat
FlatButtonAppearance.BorderSize: 0
```

### 🔷 **BOTÃO "CONFIGURAR"**

```
📝 PROPRIEDADES BOTÃO CONFIGURAR:
Name: btnConfigurar
Size: 120, 50
Location: 420, 420
Text: ⚙️ CONFIGURAR
BackColor: 85, 85, 85
ForeColor: White
Font: Arial, 10pt, Bold
FlatStyle: Flat
FlatButtonAppearance.BorderSize: 0
```

### 🔷 **BOTÕES DO RODAPÉ**

**Botão Site:**
```
📝 PROPRIEDADES BOTÃO SITE:
Name: btnSite
Size: 100, 35
Location: 50, 30
Text: 🌐 SITE
BackColor: 40, 40, 40
ForeColor: White
Font: Arial, 9pt, Bold
FlatStyle: Flat
```

**Botão Discord:**
```
📝 PROPRIEDADES BOTÃO DISCORD:
Name: btnDiscord
Size: 100, 35
Location: 160, 30
Text: 💬 DISCORD
BackColor: 114, 137, 218
ForeColor: White
Font: Arial, 9pt, Bold
FlatStyle: Flat
```

**Botão Notícias:**
```
📝 PROPRIEDADES BOTÃO NOTÍCIAS:
Name: btnNoticias
Size: 100, 35
Location: 270, 30
Text: 📰 NOTÍCIAS
BackColor: 40, 40, 40
ForeColor: White
Font: Arial, 9pt, Bold
FlatStyle: Flat
```

**Botão Sair:**
```
📝 PROPRIEDADES BOTÃO SAIR:
Name: btnSair
Size: 80, 35
Location: 750, 30
Text: ❌ SAIR
BackColor: 180, 50, 50
ForeColor: White
Font: Arial, 9pt, Bold
FlatStyle: Flat
```

---

## ⚡ **ADICIONANDO FUNCIONALIDADE BÁSICA**

### 🔷 **POPULANDO OS COMBOBOXES**

1. **Clique duas vezes na LauncherForm** (área vazia)
2. **Isso criará o evento Form_Load**
3. **Adicione este código**:

```csharp
private void LauncherForm_Load(object sender, EventArgs e)
{
    // Popular ComboBox Servidor
    cmbServidor.Items.Clear();
    cmbServidor.Items.Add("127.0.0.1:1237 (Local)");
    cmbServidor.Items.Add("servidor1.aaemu.com:1237");
    cmbServidor.Items.Add("servidor2.aaemu.com:1237");
    cmbServidor.SelectedIndex = 0;

    // Popular ComboBox Cliente
    cmbCliente.Items.Clear();
    cmbCliente.Items.Add("Trion 1.2 (Recomendado)");
    cmbCliente.Items.Add("Mail.Ru 1.0");
    cmbCliente.Items.Add("Kakao 8.0");
    cmbCliente.Items.Add("XLGames 1.0");
    cmbCliente.SelectedIndex = 0;
}
```

### 🔷 **ADICIONANDO EVENTOS DOS BOTÕES**

**Evento do Botão Jogar:**
1. **Clique duas vezes no btnJogar**
2. **Adicione**:

```csharp
private void btnJogar_Click(object sender, EventArgs e)
{
    // Validações básicas
    if (string.IsNullOrWhiteSpace(txtUsuario.Text))
    {
        MessageBox.Show("Por favor, insira seu nome de usuário!", "Erro", 
            MessageBoxButtons.OK, MessageBoxIcon.Warning);
        txtUsuario.Focus();
        return;
    }

    if (string.IsNullOrWhiteSpace(txtSenha.Text))
    {
        MessageBox.Show("Por favor, insira sua senha!", "Erro", 
            MessageBoxButtons.OK, MessageBoxIcon.Warning);
        txtSenha.Focus();
        return;
    }

    // Simular processo de login
    btnJogar.Text = "🔄 CONECTANDO...";
    btnJogar.Enabled = false;
    
    // TODO: Implementar lógica real de conexão
    MessageBox.Show($"Conectando como {txtUsuario.Text}\nServidor: {cmbServidor.Text}\nCliente: {cmbCliente.Text}", 
        "Conectando", MessageBoxButtons.OK, MessageBoxIcon.Information);
    
    btnJogar.Text = "🚀 JOGAR AGORA";
    btnJogar.Enabled = true;
}
```

**Evento do Botão Sair:**
```csharp
private void btnSair_Click(object sender, EventArgs e)
{
    if (MessageBox.Show("Tem certeza que deseja sair?", "Confirmar", 
        MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
    {
        Application.Exit();
    }
}
```

---

## 🧩 **EXERCÍCIOS PRÁTICOS**

### 🔷 **EXERCÍCIO 1: EFEITOS HOVER NOS BOTÕES**

Adicione efeitos quando o mouse passar sobre os botões:

```csharp
// Adicionar esses eventos para o btnJogar
private void btnJogar_MouseEnter(object sender, EventArgs e)
{
    btnJogar.BackColor = Color.FromArgb(0, 140, 250);
}

private void btnJogar_MouseLeave(object sender, EventArgs e)
{
    btnJogar.BackColor = Color.FromArgb(0, 120, 215);
}
```

### 🔷 **EXERCÍCIO 2: VALIDAÇÃO EM TEMPO REAL**

Adicione validação conforme o usuário digita:

```csharp
private void txtUsuario_TextChanged(object sender, EventArgs e)
{
    if (txtUsuario.Text.Length < 3)
    {
        txtUsuario.BackColor = Color.FromArgb(80, 40, 40); // Vermelho escuro
    }
    else
    {
        txtUsuario.BackColor = Color.FromArgb(40, 80, 40); // Verde escuro
    }
}
```

### 🔷 **EXERCÍCIO 3: ATALHOS DE TECLADO**

```csharp
private void LauncherForm_KeyDown(object sender, KeyEventArgs e)
{
    if (e.KeyCode == Keys.Enter)
    {
        btnJogar_Click(sender, e);
    }
    else if (e.KeyCode == Keys.Escape)
    {
        btnSair_Click(sender, e);
    }
}

// No construtor da form, adicionar:
// this.KeyPreview = true;
```

### 🔷 **EXERCÍCIO 4: PLACEHOLDER NOS TEXTBOXES**

```csharp
private void txtUsuario_Enter(object sender, EventArgs e)
{
    if (txtUsuario.Text == "Digite seu usuário...")
    {
        txtUsuario.Text = "";
        txtUsuario.ForeColor = Color.White;
    }
}

private void txtUsuario_Leave(object sender, EventArgs e)
{
    if (string.IsNullOrWhiteSpace(txtUsuario.Text))
    {
        txtUsuario.Text = "Digite seu usuário...";
        txtUsuario.ForeColor = Color.Gray;
    }
}
```

---

## 🎯 **RESUMO DO MÓDULO 3**

### ✅ **O QUE VOCÊ CONQUISTOU HOJE:**

1. **🎨 Dominou o Designer Visual do Visual Studio**
   - Aprendeu a usar Toolbox, Properties e Design Area
   - Entendeu o conceito de arrastar e soltar componentes
   - Configurou propriedades visualmente

2. **🏗 Criou uma interface profissional completa**
   - Layout de 3 painéis (cabeçalho, principal, rodapé)
   - Cores e tema consistentes
   - Organização visual hierárquica

3. **🖼 Trabalhou com recursos visuais**
   - Adicionou imagens e ícones
   - Configurou PictureBoxes
   - Organizou recursos em pastas

4. **🎮 Implementou interface de login funcional**
   - Campos de usuário e senha
   - ComboBoxes para servidor e cliente
   - Checkbox para lembrar login
   - Validações básicas

5. **🚀 Criou botões de ação interativos**
   - Botão principal "Jogar Agora"
   - Botões de navegação (Site, Discord, etc.)
   - Eventos de clique funcionais
   - Feedback visual ao usuário

6. **💫 Adicionou funcionalidades extras**
   - Efeitos hover
   - Validação em tempo real
   - Atalhos de teclado
   - Placeholders nos campos

### 🎯 **CONCEITOS TÉCNICOS DOMINADOS:**

- ✅ **Windows Forms Designer** - ferramenta visual
- ✅ **Layout Management** - organização de componentes
- ✅ **Properties e Events** - configuração e interação
- ✅ **Panels** - organização estrutural
- ✅ **Controls básicos** - Label, TextBox, Button, ComboBox
- ✅ **Event Handlers** - resposta a ações do usuário
- ✅ **Validation** - verificação de dados
- ✅ **Resource Management** - gestão de imagens e recursos

### 🚀 **METAS PARA O PRÓXIMO MÓDULO:**

No **MÓDULO 4**, vamos implementar um sistema robusto de configurações:
- ✅ Leitura e escrita de arquivos JSON
- ✅ Sistema de configurações persistentes
- ✅ Múltiplos perfis de usuário
- ✅ Configurações avançadas do launcher
- ✅ Migração de configurações antigas
- ✅ Validação e recuperação de erros

---

## 🏆 **PARABÉNS PELA EVOLUÇÃO VISUAL!**

### 📈 **PROGRESSO NO CURSO:**
```
[███████████████░░░░░░░░░░░░░░░░░░░░░] 25% Completo

✅ MÓDULO 1 - Fundamentos (Concluído)
✅ MÓDULO 2 - Estrutura Base (Concluído) 
✅ MÓDULO 3 - Interface Gráfica (Concluído)
→  MÓDULO 4 - Sistema de Configurações (Próximo)
```

### 🎮 **MOTIVAÇÃO:**
Você acabou de criar uma interface que **compete com launchers profissionais**! Sua aplicação agora tem:
- ✨ **Visual moderno e atrativo**
- 🎯 **Interface intuitiva e funcional**
- 🚀 **Interações responsivas**
- 💫 **Experiência de usuário polida**

Isso é **incrível**! Você saiu de uma janela cinza simples para um launcher com aparência totalmente profissional!

### 📋 **CHECKLIST ANTES DO PRÓXIMO MÓDULO:**

- [ ] Interface visual completa e funcionando
- [ ] Todos os botões com eventos configurados
- [ ] ComboBoxes populados corretamente
- [ ] Validações básicas implementadas
- [ ] Efeitos visuais funcionando
- [ ] Layout responsivo testado

### 🔥 **PREPARADO PARA O MÓDULO 4?**

No próximo módulo, vamos dar **"cérebro"** ao nosso launcher! Vamos implementar um sistema de configurações que permite:
- 💾 **Salvar preferências do usuário**
- 🔄 **Carregar configurações automaticamente**
- 👥 **Múltiplos perfis de usuários**
- ⚙️ **Configurações avançadas**

**Digite "CONTINUAR MÓDULO 4" quando estiver pronto para adicionar inteligência ao seu launcher!** 🧠✨

---

**© 2024 Mega Curso Launcher ArcheAge - Todos os direitos reservados**
*Curso elaborado com ❤️ para a comunidade brasileira de desenvolvedores*