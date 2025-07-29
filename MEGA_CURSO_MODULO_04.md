# 🎮 **MEGA CURSO: CRIANDO UM LAUNCHER DE JOGO DO ZERO**
## **MÓDULO 4: SISTEMA DE CONFIGURAÇÕES E JSON**
### *"Dando cérebro ao nosso launcher - Salvando e carregando configurações!"*

---

## 📖 **ÍNDICE DO MÓDULO**
- [Revisão do Módulo Anterior](#-revisão-do-módulo-anterior)
- [Introdução ao JSON](#-introdução-ao-json)
- [Criando o Sistema de Configurações](#-criando-o-sistema-de-configurações)
- [Implementando Persistência de Dados](#-implementando-persistência-de-dados)
- [Sistema de Múltiplos Perfis](#-sistema-de-múltiplos-perfis)
- [Configurações Avançadas](#-configurações-avançadas)
- [Migração e Validação](#-migração-e-validação)
- [Integrando com a Interface](#-integrando-com-a-interface)
- [Exercícios Práticos](#-exercícios-práticos)
- [Resumo e Próximos Passos](#-resumo-do-módulo-4)

---

## 🔄 **REVISÃO DO MÓDULO ANTERIOR**

### ✅ **O QUE JÁ CONQUISTAMOS:**
- 🎨 Interface gráfica profissional completa
- 🏗 Layout estruturado com 3 painéis
- 🎮 Formulário de login funcional
- 🚀 Botões com eventos e validações
- 💫 Efeitos visuais e interações

### 🎯 **O QUE VAMOS FAZER HOJE:**
Hoje vamos dar **inteligência** ao nosso launcher! Vamos:
1. ✅ Entender como funciona o formato JSON
2. ✅ Criar um sistema robusto de configurações
3. ✅ Implementar salvamento e carregamento automático
4. ✅ Criar sistema de múltiplos perfis de usuário
5. ✅ Adicionar configurações avançadas
6. ✅ Implementar migração e validação de dados

---

## 📋 **INTRODUÇÃO AO JSON**

### 🔷 **O QUE É JSON?**

**JSON** (JavaScript Object Notation) é como um "idioma universal" para organizar dados. Pense nele como uma **agenda super organizada** onde você pode guardar informações de forma estruturada.

### 🔷 **COMPARANDO FORMATOS:**

**Formato Antigo (INI):**
```ini
[Usuario]
Nome=JoaoGamer
Senha=123456
Servidor=127.0.0.1

[Configuracoes]
Lembrar=true
Idioma=pt-BR
```

**Formato Moderno (JSON):**
```json
{
    "usuario": {
        "nome": "JoaoGamer",
        "senha": "hash_seguro_da_senha",
        "servidor": "127.0.0.1"
    },
    "configuracoes": {
        "lembrar": true,
        "idioma": "pt-BR",
        "tema": "escuro"
    }
}
```

### 🔷 **VANTAGENS DO JSON:**

- ✅ **Legível** - Fácil de ler e entender
- ✅ **Estruturado** - Organiza dados em hierarquias
- ✅ **Flexível** - Aceita textos, números, listas, objetos
- ✅ **Padrão moderno** - Usado em toda a indústria
- ✅ **Suporte nativo** - C# trabalha muito bem com JSON

### 🔷 **CONCEITOS BÁSICOS DO JSON:**

```json
{
    "texto": "Olá mundo",           // String (texto)
    "numero": 42,                   // Number (número)
    "decimal": 3.14,               // Number com decimal
    "verdadeiro": true,            // Boolean (verdadeiro/falso)
    "nulo": null,                  // Valor nulo/vazio
    "lista": [1, 2, 3, 4],        // Array (lista de itens)
    "objeto": {                    // Object (grupo de propriedades)
        "propriedade": "valor",
        "outra": 123
    }
}
```

---

## 🏗 **CRIANDO O SISTEMA DE CONFIGURAÇÕES**

### 🔷 **ESTRUTURA DAS CONFIGURAÇÕES**

Vamos criar um sistema completo que guarda:

```json
{
    "versaoConfig": "1.0.0",
    "perfilAtivo": "default",
    "perfis": {
        "default": {
            "usuario": {
                "nome": "",
                "senha": "",
                "lembrarLogin": false,
                "ultimoLogin": "2024-01-01T00:00:00Z"
            },
            "servidor": {
                "endereco": "127.0.0.1",
                "porta": 1237,
                "timeout": 5000,
                "tipo": "aaemu"
            },
            "cliente": {
                "tipo": "trion12",
                "caminhoJogo": "",
                "argumentos": "",
                "hshieldAtivo": true
            },
            "interface": {
                "idioma": "pt-BR",
                "tema": "escuro",
                "lembrarPosicao": true,
                "posicaoX": -1,
                "posicaoY": -1
            },
            "avancado": {
                "debugMode": false,
                "logDetalhado": false,
                "verificarAtualizacoes": true,
                "atualizarAutomaticamente": false
            }
        }
    },
    "configuracaoGlobal": {
        "primeiraExecucao": true,
        "ultimaVersao": "1.0.0",
        "estatisticas": {
            "totalLogins": 0,
            "ultimoUso": "2024-01-01T00:00:00Z"
        }
    }
}
```

### 🔷 **CRIANDO A CLASSE DE CONFIGURAÇÃO**

Na pasta **Models**, crie o arquivo **`ConfigurationManager.cs`**:

```csharp
using System;
using System.Collections.Generic;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AAEmu.Launcher.Models
{
    // Classe principal que gerencia todas as configurações
    public class ConfigurationManager
    {
        private static ConfigurationManager _instance;
        private LauncherConfig _config;
        private readonly string _configPath;
        
        // Singleton - apenas uma instância da configuração
        public static ConfigurationManager Instance
        {
            get
            {
                if (_instance == null)
                    _instance = new ConfigurationManager();
                return _instance;
            }
        }
        
        private ConfigurationManager()
        {
            _configPath = Path.Combine(Environment.GetFolderPath(
                Environment.SpecialFolder.ApplicationData), "AAEmu", "launcher.json");
            CarregarConfiguracoes();
        }
        
        public LauncherConfig Config => _config;
        
        // Carregar configurações do arquivo
        public void CarregarConfiguracoes()
        {
            try
            {
                if (File.Exists(_configPath))
                {
                    string json = File.ReadAllText(_configPath);
                    _config = JsonConvert.DeserializeObject<LauncherConfig>(json);
                    
                    // Validar configuração carregada
                    ValidarConfiguracao();
                }
                else
                {
                    // Primeira execução - criar configuração padrão
                    CriarConfiguracaoPadrao();
                }
            }
            catch (Exception ex)
            {
                // Se houve erro, criar configuração padrão
                System.Windows.Forms.MessageBox.Show(
                    $"Erro ao carregar configurações: {ex.Message}\nCriando configuração padrão...", 
                    "Aviso", 
                    System.Windows.Forms.MessageBoxButtons.OK, 
                    System.Windows.Forms.MessageBoxIcon.Warning);
                    
                CriarConfiguracaoPadrao();
            }
        }
        
        // Salvar configurações no arquivo
        public void SalvarConfiguracoes()
        {
            try
            {
                // Criar diretório se não existir
                Directory.CreateDirectory(Path.GetDirectoryName(_configPath));
                
                // Serializar para JSON com formatação bonita
                string json = JsonConvert.SerializeObject(_config, Formatting.Indented);
                
                // Salvar no arquivo
                File.WriteAllText(_configPath, json);
            }
            catch (Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(
                    $"Erro ao salvar configurações: {ex.Message}", 
                    "Erro", 
                    System.Windows.Forms.MessageBoxButtons.OK, 
                    System.Windows.Forms.MessageBoxIcon.Error);
            }
        }
        
        private void CriarConfiguracaoPadrao()
        {
            _config = new LauncherConfig
            {
                VersaoConfig = "1.0.0",
                PerfilAtivo = "default",
                Perfis = new Dictionary<string, PerfilUsuario>
                {
                    ["default"] = new PerfilUsuario()
                },
                ConfiguracaoGlobal = new ConfiguracaoGlobal
                {
                    PrimeiraExecucao = true,
                    UltimaVersao = "1.0.0",
                    Estatisticas = new Estatisticas()
                }
            };
        }
        
        private void ValidarConfiguracao()
        {
            // Verificar se tem perfil ativo
            if (string.IsNullOrEmpty(_config.PerfilAtivo) || 
                !_config.Perfis.ContainsKey(_config.PerfilAtivo))
            {
                _config.PerfilAtivo = "default";
                if (!_config.Perfis.ContainsKey("default"))
                {
                    _config.Perfis["default"] = new PerfilUsuario();
                }
            }
            
            // Outras validações...
        }
        
        // Métodos de conveniência
        public PerfilUsuario GetPerfilAtivo()
        {
            return _config.Perfis[_config.PerfilAtivo];
        }
        
        public void SalvarPerfilAtivo()
        {
            SalvarConfiguracoes();
        }
    }
}
```

### 🔷 **CRIANDO AS CLASSES DE DADOS**

No mesmo arquivo **Models/ConfigurationManager.cs**, adicione:

```csharp
// Configuração principal do launcher
public class LauncherConfig
{
    [JsonProperty("versaoConfig")]
    public string VersaoConfig { get; set; } = "1.0.0";
    
    [JsonProperty("perfilAtivo")]
    public string PerfilAtivo { get; set; } = "default";
    
    [JsonProperty("perfis")]
    public Dictionary<string, PerfilUsuario> Perfis { get; set; } = new Dictionary<string, PerfilUsuario>();
    
    [JsonProperty("configuracaoGlobal")]
    public ConfiguracaoGlobal ConfiguracaoGlobal { get; set; } = new ConfiguracaoGlobal();
}

// Perfil de um usuário específico
public class PerfilUsuario
{
    [JsonProperty("usuario")]
    public DadosUsuario Usuario { get; set; } = new DadosUsuario();
    
    [JsonProperty("servidor")]
    public ConfiguracaoServidor Servidor { get; set; } = new ConfiguracaoServidor();
    
    [JsonProperty("cliente")]
    public ConfiguracaoCliente Cliente { get; set; } = new ConfiguracaoCliente();
    
    [JsonProperty("interface")]
    public ConfiguracaoInterface Interface { get; set; } = new ConfiguracaoInterface();
    
    [JsonProperty("avancado")]
    public ConfiguracaoAvancada Avancado { get; set; } = new ConfiguracaoAvancada();
}

// Dados do usuário
public class DadosUsuario
{
    [JsonProperty("nome")]
    public string Nome { get; set; } = "";
    
    [JsonProperty("senha")]
    public string Senha { get; set; } = "";  // Hash da senha, não a senha real
    
    [JsonProperty("lembrarLogin")]
    public bool LembrarLogin { get; set; } = false;
    
    [JsonProperty("ultimoLogin")]
    public DateTime UltimoLogin { get; set; } = DateTime.MinValue;
}

// Configurações do servidor
public class ConfiguracaoServidor
{
    [JsonProperty("endereco")]
    public string Endereco { get; set; } = "127.0.0.1";
    
    [JsonProperty("porta")]
    public int Porta { get; set; } = 1237;
    
    [JsonProperty("timeout")]
    public int Timeout { get; set; } = 5000;
    
    [JsonProperty("tipo")]
    public string Tipo { get; set; } = "aaemu";
}

// Configurações do cliente
public class ConfiguracaoCliente
{
    [JsonProperty("tipo")]
    public string Tipo { get; set; } = "trion12";
    
    [JsonProperty("caminhoJogo")]
    public string CaminhoJogo { get; set; } = "";
    
    [JsonProperty("argumentos")]
    public string Argumentos { get; set; } = "";
    
    [JsonProperty("hshieldAtivo")]
    public bool HShieldAtivo { get; set; } = true;
}

// Configurações da interface
public class ConfiguracaoInterface
{
    [JsonProperty("idioma")]
    public string Idioma { get; set; } = "pt-BR";
    
    [JsonProperty("tema")]
    public string Tema { get; set; } = "escuro";
    
    [JsonProperty("lembrarPosicao")]
    public bool LembrarPosicao { get; set; } = true;
    
    [JsonProperty("posicaoX")]
    public int PosicaoX { get; set; } = -1;
    
    [JsonProperty("posicaoY")]
    public int PosicaoY { get; set; } = -1;
}

// Configurações avançadas
public class ConfiguracaoAvancada
{
    [JsonProperty("debugMode")]
    public bool DebugMode { get; set; } = false;
    
    [JsonProperty("logDetalhado")]
    public bool LogDetalhado { get; set; } = false;
    
    [JsonProperty("verificarAtualizacoes")]
    public bool VerificarAtualizacoes { get; set; } = true;
    
    [JsonProperty("atualizarAutomaticamente")]
    public bool AtualizarAutomaticamente { get; set; } = false;
}

// Configurações globais
public class ConfiguracaoGlobal
{
    [JsonProperty("primeiraExecucao")]
    public bool PrimeiraExecucao { get; set; } = true;
    
    [JsonProperty("ultimaVersao")]
    public string UltimaVersao { get; set; } = "1.0.0";
    
    [JsonProperty("estatisticas")]
    public Estatisticas Estatisticas { get; set; } = new Estatisticas();
}

// Estatísticas de uso
public class Estatisticas
{
    [JsonProperty("totalLogins")]
    public int TotalLogins { get; set; } = 0;
    
    [JsonProperty("ultimoUso")]
    public DateTime UltimoUso { get; set; } = DateTime.Now;
}
```

---

## 💾 **IMPLEMENTANDO PERSISTÊNCIA DE DADOS**

### 🔷 **CLASSE HELPER PARA CRIPTOGRAFIA**

Na pasta **Helpers**, crie **`CryptographyHelper.cs`**:

```csharp
using System;
using System.Security.Cryptography;
using System.Text;

namespace AAEmu.Launcher.Helpers
{
    public static class CryptographyHelper
    {
        // Gerar hash SHA256 de uma senha
        public static string GerarHashSenha(string senha)
        {
            if (string.IsNullOrEmpty(senha))
                return string.Empty;
                
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(senha));
                return Convert.ToBase64String(hashedBytes);
            }
        }
        
        // Verificar se uma senha corresponde ao hash
        public static bool VerificarSenha(string senha, string hash)
        {
            if (string.IsNullOrEmpty(senha) || string.IsNullOrEmpty(hash))
                return false;
                
            string hashNovo = GerarHashSenha(senha);
            return hashNovo.Equals(hash);
        }
        
        // Criptografia simples para dados sensíveis (opcional)
        public static string CriptografarTexto(string texto, string chave = "AAEmuLauncher2024")
        {
            if (string.IsNullOrEmpty(texto))
                return string.Empty;
                
            byte[] data = Encoding.UTF8.GetBytes(texto);
            byte[] keyBytes = Encoding.UTF8.GetBytes(chave);
            
            // XOR simples (para dados não críticos)
            for (int i = 0; i < data.Length; i++)
            {
                data[i] ^= keyBytes[i % keyBytes.Length];
            }
            
            return Convert.ToBase64String(data);
        }
        
        public static string DescriptografarTexto(string textoCriptografado, string chave = "AAEmuLauncher2024")
        {
            if (string.IsNullOrEmpty(textoCriptografado))
                return string.Empty;
                
            try
            {
                byte[] data = Convert.FromBase64String(textoCriptografado);
                byte[] keyBytes = Encoding.UTF8.GetBytes(chave);
                
                // XOR simples (reverso)
                for (int i = 0; i < data.Length; i++)
                {
                    data[i] ^= keyBytes[i % keyBytes.Length];
                }
                
                return Encoding.UTF8.GetString(data);
            }
            catch
            {
                return string.Empty;
            }
        }
    }
}
```

### 🔷 **SISTEMA DE BACKUP AUTOMÁTICO**

Adicione ao **ConfigurationManager**:

```csharp
// Criar backup antes de salvar
private void CriarBackup()
{
    try
    {
        if (File.Exists(_configPath))
        {
            string backupPath = _configPath + ".backup";
            File.Copy(_configPath, backupPath, true);
        }
    }
    catch
    {
        // Backup falhou, mas não é crítico
    }
}

// Restaurar do backup se necessário
private bool RestaurarDoBackup()
{
    try
    {
        string backupPath = _configPath + ".backup";
        if (File.Exists(backupPath))
        {
            File.Copy(backupPath, _configPath, true);
            return true;
        }
    }
    catch
    {
        // Falhou ao restaurar
    }
    return false;
}

// Atualizar o método SalvarConfiguracoes()
public void SalvarConfiguracoes()
{
    try
    {
        // Criar backup antes de salvar
        CriarBackup();
        
        // Criar diretório se não existir
        Directory.CreateDirectory(Path.GetDirectoryName(_configPath));
        
        // Atualizar estatísticas
        _config.ConfiguracaoGlobal.Estatisticas.UltimoUso = DateTime.Now;
        
        // Serializar para JSON com formatação bonita
        string json = JsonConvert.SerializeObject(_config, Formatting.Indented);
        
        // Salvar no arquivo
        File.WriteAllText(_configPath, json);
    }
    catch (Exception ex)
    {
        // Tentar restaurar do backup
        if (RestaurarDoBackup())
        {
            System.Windows.Forms.MessageBox.Show(
                "Erro ao salvar configurações, mas backup foi restaurado.", 
                "Aviso", 
                System.Windows.Forms.MessageBoxButtons.OK, 
                System.Windows.Forms.MessageBoxIcon.Warning);
        }
        else
        {
            System.Windows.Forms.MessageBox.Show(
                $"Erro ao salvar configurações: {ex.Message}", 
                "Erro", 
                System.Windows.Forms.MessageBoxButtons.OK, 
                System.Windows.Forms.MessageBoxIcon.Error);
        }
    }
}
```

---

## 👥 **SISTEMA DE MÚLTIPLOS PERFIS**

### 🔷 **GERENCIADOR DE PERFIS**

Adicione estes métodos ao **ConfigurationManager**:

```csharp
// Criar novo perfil
public bool CriarPerfil(string nomePerfil)
{
    if (string.IsNullOrWhiteSpace(nomePerfil) || _config.Perfis.ContainsKey(nomePerfil))
        return false;
        
    _config.Perfis[nomePerfil] = new PerfilUsuario();
    return true;
}

// Excluir perfil
public bool ExcluirPerfil(string nomePerfil)
{
    if (nomePerfil == "default" || !_config.Perfis.ContainsKey(nomePerfil))
        return false;
        
    _config.Perfis.Remove(nomePerfil);
    
    // Se era o perfil ativo, voltar para default
    if (_config.PerfilAtivo == nomePerfil)
        _config.PerfilAtivo = "default";
        
    return true;
}

// Mudar perfil ativo
public bool MudarPerfilAtivo(string nomePerfil)
{
    if (!_config.Perfis.ContainsKey(nomePerfil))
        return false;
        
    _config.PerfilAtivo = nomePerfil;
    return true;
}

// Listar todos os perfis
public List<string> ListarPerfis()
{
    return new List<string>(_config.Perfis.Keys);
}

// Copiar perfil
public bool CopiarPerfil(string perfilOrigem, string perfilDestino)
{
    if (!_config.Perfis.ContainsKey(perfilOrigem) || 
        _config.Perfis.ContainsKey(perfilDestino))
        return false;
        
    // Serializar e deserializar para fazer cópia profunda
    string json = JsonConvert.SerializeObject(_config.Perfis[perfilOrigem]);
    _config.Perfis[perfilDestino] = JsonConvert.DeserializeObject<PerfilUsuario>(json);
    
    return true;
}
```

### 🔷 **FORM DE GERENCIAMENTO DE PERFIS**

Na pasta **Forms**, crie **`ProfileManagerForm.cs`**:

```csharp
using System;
using System.Linq;
using System.Windows.Forms;
using AAEmu.Launcher.Models;

namespace AAEmu.Launcher.Forms
{
    public partial class ProfileManagerForm : Form
    {
        private ConfigurationManager _configManager;
        
        public ProfileManagerForm()
        {
            InitializeComponent();
            _configManager = ConfigurationManager.Instance;
            ConfigurarInterface();
            CarregarPerfis();
        }
        
        private void ConfigurarInterface()
        {
            this.Text = "Gerenciar Perfis";
            this.Size = new System.Drawing.Size(400, 300);
            this.StartPosition = FormStartPosition.CenterParent;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.BackColor = System.Drawing.Color.FromArgb(45, 45, 48);
            
            // ListBox para perfis
            var listBoxPerfis = new ListBox
            {
                Name = "listBoxPerfis",
                Size = new System.Drawing.Size(200, 150),
                Location = new System.Drawing.Point(20, 20),
                BackColor = System.Drawing.Color.FromArgb(60, 60, 60),
                ForeColor = System.Drawing.Color.White,
                BorderStyle = BorderStyle.FixedSingle
            };
            this.Controls.Add(listBoxPerfis);
            
            // Botões
            var btnNovo = new Button
            {
                Text = "Novo",
                Size = new System.Drawing.Size(80, 30),
                Location = new System.Drawing.Point(240, 20),
                BackColor = System.Drawing.Color.FromArgb(0, 120, 215),
                ForeColor = System.Drawing.Color.White,
                FlatStyle = FlatStyle.Flat
            };
            btnNovo.Click += BtnNovo_Click;
            this.Controls.Add(btnNovo);
            
            var btnExcluir = new Button
            {
                Text = "Excluir",
                Size = new System.Drawing.Size(80, 30),
                Location = new System.Drawing.Point(240, 60),
                BackColor = System.Drawing.Color.FromArgb(180, 50, 50),
                ForeColor = System.Drawing.Color.White,
                FlatStyle = FlatStyle.Flat
            };
            btnExcluir.Click += BtnExcluir_Click;
            this.Controls.Add(btnExcluir);
            
            var btnCopiar = new Button
            {
                Text = "Copiar",
                Size = new System.Drawing.Size(80, 30),
                Location = new System.Drawing.Point(240, 100),
                BackColor = System.Drawing.Color.FromArgb(85, 85, 85),
                ForeColor = System.Drawing.Color.White,
                FlatStyle = FlatStyle.Flat
            };
            btnCopiar.Click += BtnCopiar_Click;
            this.Controls.Add(btnCopiar);
        }
        
        private void CarregarPerfis()
        {
            var listBox = this.Controls["listBoxPerfis"] as ListBox;
            listBox.Items.Clear();
            
            var perfis = _configManager.ListarPerfis();
            foreach (var perfil in perfis.OrderBy(p => p))
            {
                string texto = perfil;
                if (perfil == _configManager.Config.PerfilAtivo)
                    texto += " (Ativo)";
                    
                listBox.Items.Add(texto);
            }
        }
        
        private void BtnNovo_Click(object sender, EventArgs e)
        {
            string nome = Microsoft.VisualBasic.Interaction.InputBox(
                "Digite o nome do novo perfil:", "Novo Perfil", "");
                
            if (!string.IsNullOrWhiteSpace(nome))
            {
                if (_configManager.CriarPerfil(nome))
                {
                    CarregarPerfis();
                    MessageBox.Show($"Perfil '{nome}' criado com sucesso!", "Sucesso");
                }
                else
                {
                    MessageBox.Show("Erro ao criar perfil. Verifique se o nome não existe.", "Erro");
                }
            }
        }
        
        private void BtnExcluir_Click(object sender, EventArgs e)
        {
            var listBox = this.Controls["listBoxPerfis"] as ListBox;
            if (listBox.SelectedItem != null)
            {
                string itemSelecionado = listBox.SelectedItem.ToString();
                string nomePerfil = itemSelecionado.Replace(" (Ativo)", "");
                
                if (nomePerfil == "default")
                {
                    MessageBox.Show("O perfil 'default' não pode ser excluído.", "Erro");
                    return;
                }
                
                if (MessageBox.Show($"Tem certeza que deseja excluir o perfil '{nomePerfil}'?", 
                    "Confirmar", MessageBoxButtons.YesNo) == DialogResult.Yes)
                {
                    if (_configManager.ExcluirPerfil(nomePerfil))
                    {
                        CarregarPerfis();
                        MessageBox.Show($"Perfil '{nomePerfil}' excluído com sucesso!", "Sucesso");
                    }
                }
            }
        }
        
        private void BtnCopiar_Click(object sender, EventArgs e)
        {
            var listBox = this.Controls["listBoxPerfis"] as ListBox;
            if (listBox.SelectedItem != null)
            {
                string itemSelecionado = listBox.SelectedItem.ToString();
                string perfilOrigem = itemSelecionado.Replace(" (Ativo)", "");
                
                string perfilDestino = Microsoft.VisualBasic.Interaction.InputBox(
                    $"Digite o nome para a cópia do perfil '{perfilOrigem}':", 
                    "Copiar Perfil", perfilOrigem + "_copia");
                    
                if (!string.IsNullOrWhiteSpace(perfilDestino))
                {
                    if (_configManager.CopiarPerfil(perfilOrigem, perfilDestino))
                    {
                        CarregarPerfis();
                        MessageBox.Show($"Perfil copiado com sucesso!", "Sucesso");
                    }
                    else
                    {
                        MessageBox.Show("Erro ao copiar perfil.", "Erro");
                    }
                }
            }
        }
    }
}
```

---

## 🔧 **INTEGRANDO COM A INTERFACE**

### 🔷 **MODIFICANDO A LAUNCHERFORM**

Atualize **Forms/LauncherForm.cs** para usar as configurações:

```csharp
using AAEmu.Launcher.Models;
using AAEmu.Launcher.Helpers;

public partial class LauncherForm : Form
{
    private ConfigurationManager _configManager;
    
    public LauncherForm()
    {
        InitializeComponent();
        _configManager = ConfigurationManager.Instance;
        ConfigurarJanela();
        CarregarConfiguracoes();
    }
    
    private void CarregarConfiguracoes()
    {
        var perfil = _configManager.GetPerfilAtivo();
        
        // Carregar dados do usuário
        txtUsuario.Text = perfil.Usuario.Nome;
        chkLembrarLogin.Checked = perfil.Usuario.LembrarLogin;
        
        // Se lembrar login e tem senha salva
        if (perfil.Usuario.LembrarLogin && !string.IsNullOrEmpty(perfil.Usuario.Senha))
        {
            // Não carregar a senha real, apenas indicar que existe
            txtSenha.Text = "********";
            txtSenha.Tag = "senha_salva"; // Flag para indicar senha salva
        }
        
        // Carregar servidor
        cmbServidor.Items.Clear();
        cmbServidor.Items.Add($"{perfil.Servidor.Endereco}:{perfil.Servidor.Porta} (Configurado)");
        cmbServidor.Items.Add("127.0.0.1:1237 (Local)");
        cmbServidor.Items.Add("servidor1.aaemu.com:1237");
        cmbServidor.SelectedIndex = 0;
        
        // Carregar cliente
        cmbCliente.Items.Clear();
        switch (perfil.Cliente.Tipo.ToLower())
        {
            case "trion12":
                cmbCliente.Items.Add("Trion 1.2 (Recomendado)");
                break;
            case "mailru10":
                cmbCliente.Items.Add("Mail.Ru 1.0");
                break;
            default:
                cmbCliente.Items.Add("Trion 1.2 (Recomendado)");
                break;
        }
        cmbCliente.Items.Add("Mail.Ru 1.0");
        cmbCliente.Items.Add("Kakao 8.0");
        cmbCliente.Items.Add("XLGames 1.0");
        cmbCliente.SelectedIndex = 0;
        
        // Configurar posição da janela
        if (perfil.Interface.LembrarPosicao && 
            perfil.Interface.PosicaoX > 0 && 
            perfil.Interface.PosicaoY > 0)
        {
            this.StartPosition = FormStartPosition.Manual;
            this.Location = new Point(perfil.Interface.PosicaoX, perfil.Interface.PosicaoY);
        }
    }
    
    private void SalvarConfiguracoes()
    {
        var perfil = _configManager.GetPerfilAtivo();
        
        // Salvar dados do usuário
        perfil.Usuario.Nome = txtUsuario.Text;
        perfil.Usuario.LembrarLogin = chkLembrarLogin.Checked;
        
        // Salvar senha se necessário
        if (chkLembrarLogin.Checked && txtSenha.Tag?.ToString() != "senha_salva")
        {
            perfil.Usuario.Senha = CryptographyHelper.GerarHashSenha(txtSenha.Text);
        }
        else if (!chkLembrarLogin.Checked)
        {
            perfil.Usuario.Senha = "";
        }
        
        // Salvar servidor selecionado
        // ... implementar parsing do servidor selecionado
        
        // Salvar posição da janela
        if (perfil.Interface.LembrarPosicao)
        {
            perfil.Interface.PosicaoX = this.Location.X;
            perfil.Interface.PosicaoY = this.Location.Y;
        }
        
        // Atualizar estatísticas
        perfil.Usuario.UltimoLogin = DateTime.Now;
        _configManager.Config.ConfiguracaoGlobal.Estatisticas.TotalLogins++;
        
        // Salvar tudo
        _configManager.SalvarConfiguracoes();
    }
    
    private void btnJogar_Click(object sender, EventArgs e)
    {
        // Validações existentes...
        
        // Salvar configurações antes de jogar
        SalvarConfiguracoes();
        
        // Lógica de conexão...
    }
    
    // Salvar configurações ao fechar
    protected override void OnFormClosed(FormClosedEventArgs e)
    {
        SalvarConfiguracoes();
        base.OnFormClosed(e);
    }
    
    // Adicionar botão para gerenciar perfis
    private void btnConfigurar_Click(object sender, EventArgs e)
    {
        var profileForm = new Forms.ProfileManagerForm();
        profileForm.ShowDialog();
        
        // Recarregar configurações após fechar o gerenciador
        CarregarConfiguracoes();
    }
}
```

---

## 🧩 **EXERCÍCIOS PRÁTICOS**

### 🔷 **EXERCÍCIO 1: COMBOBOX DE PERFIS**

Adicione um ComboBox na interface para trocar perfis rapidamente:

```csharp
// No designer, adicionar ComboBox no cabeçalho
private void AdicionarComboBoxPerfis()
{
    var cmbPerfis = new ComboBox
    {
        Name = "cmbPerfis",
        Size = new Size(120, 25),
        Location = new Point(580, 25),
        DropDownStyle = ComboBoxStyle.DropDownList,
        BackColor = Color.FromArgb(60, 60, 60),
        ForeColor = Color.White
    };
    
    cmbPerfis.SelectedIndexChanged += CmbPerfis_SelectedIndexChanged;
    panelHeader.Controls.Add(cmbPerfis);
    
    AtualizarComboBoxPerfis();
}

private void AtualizarComboBoxPerfis()
{
    var cmbPerfis = panelHeader.Controls["cmbPerfis"] as ComboBox;
    cmbPerfis.Items.Clear();
    
    var perfis = _configManager.ListarPerfis();
    foreach (var perfil in perfis)
    {
        cmbPerfis.Items.Add(perfil);
    }
    
    cmbPerfis.SelectedItem = _configManager.Config.PerfilAtivo;
}

private void CmbPerfis_SelectedIndexChanged(object sender, EventArgs e)
{
    var cmbPerfis = sender as ComboBox;
    if (cmbPerfis.SelectedItem != null)
    {
        string perfilSelecionado = cmbPerfis.SelectedItem.ToString();
        if (_configManager.MudarPerfilAtivo(perfilSelecionado))
        {
            CarregarConfiguracoes();
        }
    }
}
```

### 🔷 **EXERCÍCIO 2: CONFIGURAÇÕES AVANÇADAS**

Crie uma janela de configurações avançadas:

```csharp
private void MostrarConfiguracaoAvancada()
{
    var formConfig = new Form
    {
        Text = "Configurações Avançadas",
        Size = new Size(450, 400),
        StartPosition = FormStartPosition.CenterParent,
        FormBorderStyle = FormBorderStyle.FixedDialog,
        BackColor = Color.FromArgb(45, 45, 48)
    };
    
    var perfil = _configManager.GetPerfilAtivo();
    
    // Checkbox Debug Mode
    var chkDebug = new CheckBox
    {
        Text = "Modo Debug",
        Location = new Point(20, 20),
        ForeColor = Color.White,
        Checked = perfil.Avancado.DebugMode
    };
    formConfig.Controls.Add(chkDebug);
    
    // Checkbox Log Detalhado
    var chkLogDetalhado = new CheckBox
    {
        Text = "Log Detalhado",
        Location = new Point(20, 50),
        ForeColor = Color.White,
        Checked = perfil.Avancado.LogDetalhado
    };
    formConfig.Controls.Add(chkLogDetalhado);
    
    // TextBox Caminho do Jogo
    var lblCaminho = new Label
    {
        Text = "Caminho do Jogo:",
        Location = new Point(20, 80),
        ForeColor = Color.White,
        AutoSize = true
    };
    formConfig.Controls.Add(lblCaminho);
    
    var txtCaminho = new TextBox
    {
        Location = new Point(20, 100),
        Size = new Size(300, 25),
        Text = perfil.Cliente.CaminhoJogo,
        BackColor = Color.FromArgb(60, 60, 60),
        ForeColor = Color.White
    };
    formConfig.Controls.Add(txtCaminho);
    
    var btnProcurar = new Button
    {
        Text = "...",
        Location = new Point(330, 100),
        Size = new Size(30, 25),
        BackColor = Color.FromArgb(85, 85, 85),
        ForeColor = Color.White
    };
    btnProcurar.Click += (s, e) => {
        var openDialog = new OpenFileDialog
        {
            Filter = "ArcheAge.exe|ArcheAge.exe|Todos os arquivos|*.*",
            Title = "Selecionar executável do ArcheAge"
        };
        
        if (openDialog.ShowDialog() == DialogResult.OK)
        {
            txtCaminho.Text = openDialog.FileName;
        }
    };
    formConfig.Controls.Add(btnProcurar);
    
    // Botão Salvar
    var btnSalvar = new Button
    {
        Text = "Salvar",
        Location = new Point(200, 320),
        Size = new Size(80, 30),
        BackColor = Color.FromArgb(0, 120, 215),
        ForeColor = Color.White
    };
    btnSalvar.Click += (s, e) => {
        perfil.Avancado.DebugMode = chkDebug.Checked;
        perfil.Avancado.LogDetalhado = chkLogDetalhado.Checked;
        perfil.Cliente.CaminhoJogo = txtCaminho.Text;
        
        _configManager.SalvarConfiguracoes();
        formConfig.Close();
    };
    formConfig.Controls.Add(btnSalvar);
    
    formConfig.ShowDialog();
}
```

### 🔷 **EXERCÍCIO 3: EXPORTAR/IMPORTAR CONFIGURAÇÕES**

```csharp
private void ExportarConfiguracao()
{
    var saveDialog = new SaveFileDialog
    {
        Filter = "Arquivo de Configuração|*.json",
        Title = "Exportar Configuração"
    };
    
    if (saveDialog.ShowDialog() == DialogResult.OK)
    {
        try
        {
            string json = JsonConvert.SerializeObject(_configManager.Config, Formatting.Indented);
            File.WriteAllText(saveDialog.FileName, json);
            MessageBox.Show("Configuração exportada com sucesso!", "Sucesso");
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Erro ao exportar: {ex.Message}", "Erro");
        }
    }
}

private void ImportarConfiguracao()
{
    var openDialog = new OpenFileDialog
    {
        Filter = "Arquivo de Configuração|*.json",
        Title = "Importar Configuração"
    };
    
    if (openDialog.ShowDialog() == DialogResult.OK)
    {
        try
        {
            string json = File.ReadAllText(openDialog.FileName);
            var configImportada = JsonConvert.DeserializeObject<LauncherConfig>(json);
            
            if (MessageBox.Show("Isso substituirá todas as configurações atuais. Continuar?", 
                "Confirmar", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                _configManager._config = configImportada;
                _configManager.SalvarConfiguracoes();
                CarregarConfiguracoes();
                MessageBox.Show("Configuração importada com sucesso!", "Sucesso");
            }
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Erro ao importar: {ex.Message}", "Erro");
        }
    }
}
```

---

## 🎯 **RESUMO DO MÓDULO 4**

### ✅ **O QUE VOCÊ CONQUISTOU HOJE:**

1. **📋 Dominou o formato JSON**
   - Entendeu a estrutura e sintaxe do JSON
   - Aprendeu as vantagens sobre formatos antigos
   - Implementou serialização/deserialização

2. **🏗 Criou sistema robusto de configurações**
   - ConfigurationManager com padrão Singleton
   - Classes de dados bem estruturadas
   - Validação e tratamento de erros

3. **💾 Implementou persistência de dados**
   - Salvamento automático de configurações
   - Sistema de backup e recuperação
   - Criptografia de senhas

4. **👥 Sistema de múltiplos perfis**
   - Criação, exclusão e cópia de perfis
   - Troca rápida entre perfis
   - Gerenciamento completo via interface

5. **🔧 Configurações avançadas**
   - Settings detalhadas por categoria
   - Interface para configuração
   - Exportar/importar configurações

6. **🔗 Integração com a interface**
   - Carregamento automático na inicialização
   - Salvamento ao fechar aplicação
   - Sincronização com elementos visuais

### 🎯 **CONCEITOS TÉCNICOS DOMINADOS:**

- ✅ **JSON Serialization** - Newtonsoft.Json
- ✅ **Design Patterns** - Singleton, Repository
- ✅ **File I/O** - Leitura e escrita de arquivos
- ✅ **Cryptography** - Hash SHA256, criptografia básica
- ✅ **Error Handling** - Try-catch, validações
- ✅ **Data Binding** - Sincronização dados/interface
- ✅ **User Experience** - Múltiplos perfis, backup automático

### 🚀 **METAS PARA O PRÓXIMO MÓDULO:**

No **MÓDULO 5**, vamos implementar o sistema real de login e criptografia:
- ✅ Sistema de autenticação robusto
- ✅ Criptografia avançada de senhas
- ✅ Comunicação segura com servidores
- ✅ Sistema de tokens e sessões
- ✅ Validação de credenciais em tempo real
- ✅ Recuperação de senhas e segurança

---

## 🏆 **PARABÉNS PELA EVOLUÇÃO TÉCNICA!**

### 📈 **PROGRESSO NO CURSO:**
```
[████████████████████████░░░░░░░░░░░░] 33% Completo

✅ MÓDULO 1 - Fundamentos (Concluído)
✅ MÓDULO 2 - Estrutura Base (Concluído) 
✅ MÓDULO 3 - Interface Gráfica (Concluído)
✅ MÓDULO 4 - Sistema de Configurações (Concluído)
→  MÓDULO 5 - Sistema de Login e Criptografia (Próximo)
```

### 🎮 **MOTIVAÇÃO:**
Você acabou de implementar um dos **sistemas mais complexos** de qualquer aplicação! Seu launcher agora tem:
- 🧠 **Inteligência** - Lembra preferências do usuário
- 💾 **Persistência** - Salva dados automaticamente  
- 🔒 **Segurança** - Protege informações sensíveis
- 👥 **Flexibilidade** - Múltiplos perfis de usuários
- 🛡️ **Confiabilidade** - Sistema de backup e recuperação

Isso é o que separa aplicações **amadoras** de **profissionais**!

### 📋 **CHECKLIST ANTES DO PRÓXIMO MÓDULO:**

- [ ] ConfigurationManager implementado e funcionando
- [ ] Sistema de perfis operacional
- [ ] Persistência de dados testada
- [ ] Backup/restore funcionando
- [ ] Interface integrada com configurações
- [ ] Criptografia básica implementada

### 🔥 **PREPARADO PARA O MÓDULO 5?**

No próximo módulo, vamos implementar o **coração** do launcher - o sistema de autenticação! Vamos aprender:
- 🔐 **Criptografia avançada** e protocolos de segurança
- 🌐 **Comunicação com servidores** em tempo real
- 🔑 **Sistemas de autenticação** modernos
- 🛡️ **Proteção contra ataques** comuns

**Digite "CONTINUAR MÓDULO 5" quando estiver pronto para implementar segurança de nível profissional!** 🔐✨

---

**© 2024 Mega Curso Launcher ArcheAge - Todos os direitos reservados**
*Curso elaborado com ❤️ para a comunidade brasileira de desenvolvedores*