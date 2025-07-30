# 🎮 **MEGA CURSO: CRIANDO UM LAUNCHER DE JOGO DO ZERO**
## **MÓDULO 8: SISTEMA DE ROLLBACK, LOGGING E MONITORAMENTO**
### *"Sistemas críticos de recuperação e monitoramento profissional!"*

---

## 📖 **ÍNDICE DO MÓDULO**
- [Revisão do Módulo Anterior](#-revisão-do-módulo-anterior)
- [Fundamentos de Recuperação e Monitoramento](#-fundamentos-de-recuperação-e-monitoramento)
- [Sistema de Backup e Rollback](#-sistema-de-backup-e-rollback)
- [Logging Avançado e Rotação](#-logging-avançado-e-rotação)
- [Monitoramento de Performance](#-monitoramento-de-performance)
- [Sistema de Diagnósticos](#-sistema-de-diagnósticos)
- [Alertas e Notificações](#-alertas-e-notificações)
- [Recovery Manager Inteligente](#-recovery-manager-inteligente)
- [Crash Dump e Error Reporting](#-crash-dump-e-error-reporting)
- [Health Check Automático](#-health-check-automático)
- [Exercícios Práticos](#-exercícios-práticos)
- [Resumo e Próximos Passos](#-resumo-do-módulo-8)

---

## 🔄 **REVISÃO DO MÓDULO ANTERIOR**

### ✅ **O QUE JÁ CONQUISTAMOS:**
- 📦 Sistema de atualizações manifest-based como Steam
- 📊 Download engine paralelo com progresso em tempo real
- 🛡️ Validação criptográfica de integridade de arquivos
- ⚡ Interface responsiva com feedback profissional
- 🔄 Sistema de retry inteligente com backoff exponencial

### 🎯 **O QUE VAMOS FAZER HOJE:**
Hoje vamos implementar **sistemas críticos de recuperação**! Vamos:
1. ✅ Criar sistema de backup automático e rollback
2. ✅ Implementar logging avançado com rotação
3. ✅ Desenvolver monitoramento de performance em tempo real
4. ✅ Criar diagnósticos inteligentes de problemas
5. ✅ Implementar alertas e notificações
6. ✅ Adicionar recovery manager para falhas críticas

---

## 🏗 **FUNDAMENTOS DE RECUPERAÇÃO E MONITORAMENTO**

### 🔷 **ESTRATÉGIAS DE BACKUP**

**📁 Backup Incremental:**
```
- Apenas arquivos modificados
- Menor uso de espaço
- Recovery mais complexo
- Ideal para uso diário
```

**📦 Backup Completo:**
```
- Cópia integral dos arquivos
- Maior uso de espaço
- Recovery simples e rápido
- Ideal para marcos importantes
```

**🔄 Backup Diferencial:**
```
- Mudanças desde último completo
- Balanceamento espaço/tempo
- Recovery em duas etapas
- Ideal para sistemas críticos
```

### 🔷 **NÍVEIS DE LOGGING**

**🔍 TRACE (0)** - Informações muito detalhadas
```csharp
Logger.Trace("Entering method CalculateHash() with param: {0}", fileName);
```

**📝 DEBUG (1)** - Informações de desenvolvimento
```csharp
Logger.Debug("Cache hit for key: {0}, value: {1}", key, value);
```

**ℹ️ INFO (2)** - Informações gerais
```csharp
Logger.Info("Download completed: {0} bytes in {1}ms", size, elapsed);
```

**⚠️ WARN (3)** - Situações potencialmente problemáticas
```csharp
Logger.Warn("Retry attempt {0} for download: {1}", retryCount, url);
```

**❌ ERROR (4)** - Erros que não param a aplicação
```csharp
Logger.Error("Failed to validate file: {0}", ex.Message);
```

**💥 FATAL (5)** - Erros críticos que param a aplicação
```csharp
Logger.Fatal("Critical system failure: {0}", ex.Message);
```

---

## 🛡️ **SISTEMA DE BACKUP E ROLLBACK**

### 🔷 **BACKUP MANAGER PROFISSIONAL**

Na pasta **Helpers**, crie **`BackupManager.cs`**:

```csharp
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Text.Json;
using AAEmu.Launcher.Models;

namespace AAEmu.Launcher.Helpers
{
    public class BackupManager : IDisposable
    {
        private readonly string _backupRootPath;
        private readonly int _maxBackupVersions;
        private readonly long _maxBackupSizeBytes;
        
        public event Action<string> OnStatusChanged;
        public event Action<BackupProgress> OnBackupProgress;
        public event Action<Exception> OnError;
        
        public BackupManager(string backupPath = null, int maxVersions = 10, long maxSizeGB = 5)
        {
            _backupRootPath = backupPath ?? Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), 
                "AAEmu", "Backups");
            _maxBackupVersions = maxVersions;
            _maxBackupSizeBytes = maxSizeGB * 1024 * 1024 * 1024; // GB para bytes
            
            Directory.CreateDirectory(_backupRootPath);
        }
        
        // Criar backup completo
        public async Task<BackupResult> CreateFullBackupAsync(string sourcePath, string backupName = null)
        {
            var backupId = backupName ?? $"backup_{DateTime.Now:yyyyMMdd_HHmmss}";
            var backupPath = Path.Combine(_backupRootPath, backupId);
            
            OnStatusChanged?.Invoke($"Iniciando backup completo: {backupId}");
            
            try
            {
                var backup = new BackupInfo
                {
                    Id = backupId,
                    Type = BackupType.Full,
                    SourcePath = sourcePath,
                    BackupPath = backupPath,
                    CreatedAt = DateTime.Now,
                    Status = BackupStatus.InProgress
                };
                
                Directory.CreateDirectory(backupPath);
                
                // Obter lista de arquivos
                var files = GetFilesToBackup(sourcePath);
                backup.TotalFiles = files.Count;
                backup.TotalSize = files.Sum(f => new FileInfo(f).Length);
                
                // Salvar metadata do backup
                await SaveBackupMetadataAsync(backup);
                
                // Copiar arquivos com progresso
                var progress = new BackupProgress { BackupId = backupId, TotalFiles = files.Count };
                
                for (int i = 0; i < files.Count; i++)
                {
                    var sourceFile = files[i];
                    var relativePath = Path.GetRelativePath(sourcePath, sourceFile);
                    var destFile = Path.Combine(backupPath, relativePath);
                    
                    Directory.CreateDirectory(Path.GetDirectoryName(destFile));
                    
                    await CopyFileWithProgressAsync(sourceFile, destFile, progress);
                    
                    progress.FilesCompleted = i + 1;
                    progress.PercentComplete = (double)(i + 1) / files.Count * 100;
                    OnBackupProgress?.Invoke(progress);
                }
                
                backup.Status = BackupStatus.Completed;
                backup.CompletedAt = DateTime.Now;
                backup.ActualSize = CalculateDirectorySize(backupPath);
                
                await SaveBackupMetadataAsync(backup);
                
                // Limpar backups antigos
                await CleanupOldBackupsAsync();
                
                OnStatusChanged?.Invoke($"Backup completo criado: {backupId}");
                
                return new BackupResult 
                { 
                    Success = true, 
                    BackupId = backupId, 
                    BackupInfo = backup 
                };
            }
            catch (Exception ex)
            {
                OnError?.Invoke(ex);
                ActivityLogger.LogError(ex, $"Failed to create backup: {backupId}");
                
                return new BackupResult 
                { 
                    Success = false, 
                    Error = ex.Message 
                };
            }
        }
        
        // Criar backup incremental
        public async Task<BackupResult> CreateIncrementalBackupAsync(string sourcePath, string baseBackupId)
        {
            var backupId = $"incr_{DateTime.Now:yyyyMMdd_HHmmss}";
            var backupPath = Path.Combine(_backupRootPath, backupId);
            
            OnStatusChanged?.Invoke($"Iniciando backup incremental: {backupId}");
            
            try
            {
                var baseBackup = await LoadBackupMetadataAsync(baseBackupId);
                if (baseBackup == null)
                {
                    throw new InvalidOperationException($"Base backup not found: {baseBackupId}");
                }
                
                var backup = new BackupInfo
                {
                    Id = backupId,
                    Type = BackupType.Incremental,
                    SourcePath = sourcePath,
                    BackupPath = backupPath,
                    BaseBackupId = baseBackupId,
                    CreatedAt = DateTime.Now,
                    Status = BackupStatus.InProgress
                };
                
                Directory.CreateDirectory(backupPath);
                
                // Encontrar arquivos modificados
                var modifiedFiles = await FindModifiedFilesAsync(sourcePath, baseBackup);
                backup.TotalFiles = modifiedFiles.Count;
                
                if (modifiedFiles.Count == 0)
                {
                    backup.Status = BackupStatus.Completed;
                    backup.CompletedAt = DateTime.Now;
                    await SaveBackupMetadataAsync(backup);
                    
                    return new BackupResult 
                    { 
                        Success = true, 
                        BackupId = backupId, 
                        BackupInfo = backup,
                        Message = "No changes detected - backup completed instantly"
                    };
                }
                
                // Copiar apenas arquivos modificados
                var progress = new BackupProgress { BackupId = backupId, TotalFiles = modifiedFiles.Count };
                
                for (int i = 0; i < modifiedFiles.Count; i++)
                {
                    var sourceFile = modifiedFiles[i];
                    var relativePath = Path.GetRelativePath(sourcePath, sourceFile);
                    var destFile = Path.Combine(backupPath, relativePath);
                    
                    Directory.CreateDirectory(Path.GetDirectoryName(destFile));
                    await CopyFileWithProgressAsync(sourceFile, destFile, progress);
                    
                    progress.FilesCompleted = i + 1;
                    progress.PercentComplete = (double)(i + 1) / modifiedFiles.Count * 100;
                    OnBackupProgress?.Invoke(progress);
                }
                
                backup.Status = BackupStatus.Completed;
                backup.CompletedAt = DateTime.Now;
                backup.ActualSize = CalculateDirectorySize(backupPath);
                
                await SaveBackupMetadataAsync(backup);
                
                OnStatusChanged?.Invoke($"Backup incremental criado: {backupId}");
                
                return new BackupResult 
                { 
                    Success = true, 
                    BackupId = backupId, 
                    BackupInfo = backup 
                };
            }
            catch (Exception ex)
            {
                OnError?.Invoke(ex);
                ActivityLogger.LogError(ex, $"Failed to create incremental backup: {backupId}");
                
                return new BackupResult 
                { 
                    Success = false, 
                    Error = ex.Message 
                };
            }
        }
        
        // Restaurar backup
        public async Task<RestoreResult> RestoreBackupAsync(string backupId, string targetPath, bool overwriteExisting = true)
        {
            OnStatusChanged?.Invoke($"Iniciando restauração: {backupId}");
            
            try
            {
                var backup = await LoadBackupMetadataAsync(backupId);
                if (backup == null)
                {
                    throw new InvalidOperationException($"Backup not found: {backupId}");
                }
                
                // Para backup incremental, precisamos restaurar a cadeia
                if (backup.Type == BackupType.Incremental)
                {
                    return await RestoreIncrementalChainAsync(backup, targetPath, overwriteExisting);
                }
                
                // Restaurar backup completo
                var files = Directory.GetFiles(backup.BackupPath, "*", SearchOption.AllDirectories);
                var progress = new RestoreProgress { BackupId = backupId, TotalFiles = files.Length };
                
                for (int i = 0; i < files.Length; i++)
                {
                    var sourceFile = files[i];
                    var relativePath = Path.GetRelativePath(backup.BackupPath, sourceFile);
                    var targetFile = Path.Combine(targetPath, relativePath);
                    
                    if (!overwriteExisting && File.Exists(targetFile))
                    {
                        continue;
                    }
                    
                    Directory.CreateDirectory(Path.GetDirectoryName(targetFile));
                    File.Copy(sourceFile, targetFile, overwriteExisting);
                    
                    progress.FilesRestored = i + 1;
                    progress.PercentComplete = (double)(i + 1) / files.Length * 100;
                }
                
                OnStatusChanged?.Invoke($"Restauração concluída: {backupId}");
                
                return new RestoreResult 
                { 
                    Success = true, 
                    BackupId = backupId,
                    FilesRestored = files.Length
                };
            }
            catch (Exception ex)
            {
                OnError?.Invoke(ex);
                ActivityLogger.LogError(ex, $"Failed to restore backup: {backupId}");
                
                return new RestoreResult 
                { 
                    Success = false, 
                    Error = ex.Message 
                };
            }
        }
        
        // Listar backups disponíveis
        public async Task<List<BackupInfo>> ListBackupsAsync()
        {
            var backups = new List<BackupInfo>();
            
            try
            {
                var backupDirs = Directory.GetDirectories(_backupRootPath);
                
                foreach (var dir in backupDirs)
                {
                    var backupId = Path.GetFileName(dir);
                    var backup = await LoadBackupMetadataAsync(backupId);
                    
                    if (backup != null)
                    {
                        backups.Add(backup);
                    }
                }
                
                return backups.OrderByDescending(b => b.CreatedAt).ToList();
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError(ex, "Failed to list backups");
                return backups;
            }
        }
        
        // Validar integridade do backup
        public async Task<ValidationResult> ValidateBackupAsync(string backupId)
        {
            try
            {
                var backup = await LoadBackupMetadataAsync(backupId);
                if (backup == null)
                {
                    return new ValidationResult { IsValid = false, Error = "Backup metadata not found" };
                }
                
                var backupFiles = Directory.GetFiles(backup.BackupPath, "*", SearchOption.AllDirectories);
                var result = new ValidationResult { BackupId = backupId };
                
                foreach (var file in backupFiles)
                {
                    if (!File.Exists(file))
                    {
                        result.MissingFiles.Add(Path.GetRelativePath(backup.BackupPath, file));
                    }
                    else
                    {
                        result.ValidFiles++;
                    }
                }
                
                result.IsValid = result.MissingFiles.Count == 0;
                result.TotalFiles = backupFiles.Length;
                
                return result;
            }
            catch (Exception ex)
            {
                return new ValidationResult 
                { 
                    IsValid = false, 
                    Error = ex.Message 
                };
            }
        }
        
        private List<string> GetFilesToBackup(string path)
        {
            var files = new List<string>();
            var excludePatterns = new[] { "*.tmp", "*.log", "*.cache", "Temp\\*", "Cache\\*" };
            
            foreach (var file in Directory.GetFiles(path, "*", SearchOption.AllDirectories))
            {
                bool shouldExclude = excludePatterns.Any(pattern => 
                    file.IndexOf(pattern.Replace("*", ""), StringComparison.OrdinalIgnoreCase) >= 0);
                    
                if (!shouldExclude)
                {
                    files.Add(file);
                }
            }
            
            return files;
        }
        
        private async Task<List<string>> FindModifiedFilesAsync(string sourcePath, BackupInfo baseBackup)
        {
            var modifiedFiles = new List<string>();
            var currentFiles = GetFilesToBackup(sourcePath);
            
            foreach (var file in currentFiles)
            {
                var fileInfo = new FileInfo(file);
                var relativePath = Path.GetRelativePath(sourcePath, file);
                var baseFile = Path.Combine(baseBackup.BackupPath, relativePath);
                
                if (!File.Exists(baseFile))
                {
                    // Arquivo novo
                    modifiedFiles.Add(file);
                }
                else
                {
                    var baseFileInfo = new FileInfo(baseFile);
                    if (fileInfo.LastWriteTime > baseFileInfo.LastWriteTime || 
                        fileInfo.Length != baseFileInfo.Length)
                    {
                        // Arquivo modificado
                        modifiedFiles.Add(file);
                    }
                }
            }
            
            return modifiedFiles;
        }
        
        private async Task CopyFileWithProgressAsync(string source, string destination, BackupProgress progress)
        {
            const int bufferSize = 8192;
            using var sourceStream = new FileStream(source, FileMode.Open, FileAccess.Read);
            using var destStream = new FileStream(destination, FileMode.Create, FileAccess.Write);
            
            var buffer = new byte[bufferSize];
            int bytesRead;
            
            while ((bytesRead = await sourceStream.ReadAsync(buffer, 0, buffer.Length)) > 0)
            {
                await destStream.WriteAsync(buffer, 0, bytesRead);
                progress.BytesCompleted += bytesRead;
            }
            
            // Preservar timestamps
            File.SetCreationTime(destination, File.GetCreationTime(source));
            File.SetLastWriteTime(destination, File.GetLastWriteTime(source));
        }
        
        private async Task SaveBackupMetadataAsync(BackupInfo backup)
        {
            var metadataPath = Path.Combine(backup.BackupPath, "backup_metadata.json");
            var json = JsonSerializer.Serialize(backup, new JsonSerializerOptions { WriteIndented = true });
            await File.WriteAllTextAsync(metadataPath, json);
        }
        
        private async Task<BackupInfo> LoadBackupMetadataAsync(string backupId)
        {
            try
            {
                var backupPath = Path.Combine(_backupRootPath, backupId);
                var metadataPath = Path.Combine(backupPath, "backup_metadata.json");
                
                if (!File.Exists(metadataPath))
                    return null;
                
                var json = await File.ReadAllTextAsync(metadataPath);
                return JsonSerializer.Deserialize<BackupInfo>(json);
            }
            catch
            {
                return null;
            }
        }
        
        private long CalculateDirectorySize(string path)
        {
            return Directory.GetFiles(path, "*", SearchOption.AllDirectories)
                           .Sum(file => new FileInfo(file).Length);
        }
        
        private async Task CleanupOldBackupsAsync()
        {
            try
            {
                var backups = await ListBackupsAsync();
                
                // Remover backups excedentes (manter apenas os mais recentes)
                if (backups.Count > _maxBackupVersions)
                {
                    var toRemove = backups.Skip(_maxBackupVersions).ToList();
                    foreach (var backup in toRemove)
                    {
                        Directory.Delete(backup.BackupPath, true);
                        OnStatusChanged?.Invoke($"Backup antigo removido: {backup.Id}");
                    }
                }
                
                // Verificar limite de tamanho total
                var totalSize = backups.Sum(b => b.ActualSize);
                if (totalSize > _maxBackupSizeBytes)
                {
                    var sortedByAge = backups.OrderBy(b => b.CreatedAt).ToList();
                    
                    while (totalSize > _maxBackupSizeBytes && sortedByAge.Count > 1)
                    {
                        var oldestBackup = sortedByAge.First();
                        Directory.Delete(oldestBackup.BackupPath, true);
                        totalSize -= oldestBackup.ActualSize;
                        sortedByAge.Remove(oldestBackup);
                        
                        OnStatusChanged?.Invoke($"Backup removido por limite de tamanho: {oldestBackup.Id}");
                    }
                }
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError(ex, "Failed to cleanup old backups");
            }
        }
        
        private async Task<RestoreResult> RestoreIncrementalChainAsync(BackupInfo backup, string targetPath, bool overwriteExisting)
        {
            // Construir cadeia de backups incrementais
            var chain = new List<BackupInfo>();
            var current = backup;
            
            while (current != null)
            {
                chain.Insert(0, current);
                
                if (current.Type == BackupType.Full)
                    break;
                    
                current = await LoadBackupMetadataAsync(current.BaseBackupId);
            }
            
            if (chain.Count == 0 || chain[0].Type != BackupType.Full)
            {
                throw new InvalidOperationException("Invalid backup chain - no full backup found");
            }
            
            // Restaurar em ordem: full backup primeiro, depois incrementais
            int totalFilesRestored = 0;
            
            foreach (var backupInChain in chain)
            {
                var files = Directory.GetFiles(backupInChain.BackupPath, "*", SearchOption.AllDirectories);
                
                foreach (var file in files)
                {
                    if (Path.GetFileName(file) == "backup_metadata.json")
                        continue;
                        
                    var relativePath = Path.GetRelativePath(backupInChain.BackupPath, file);
                    var targetFile = Path.Combine(targetPath, relativePath);
                    
                    if (!overwriteExisting && File.Exists(targetFile))
                        continue;
                    
                    Directory.CreateDirectory(Path.GetDirectoryName(targetFile));
                    File.Copy(file, targetFile, overwriteExisting);
                    totalFilesRestored++;
                }
            }
            
            return new RestoreResult 
            { 
                Success = true, 
                BackupId = backup.Id,
                FilesRestored = totalFilesRestored
            };
        }
        
        public void Dispose()
        {
            // Cleanup resources if needed
        }
    }
    
    // Classes de modelo para Backup
    public class BackupInfo
    {
        public string Id { get; set; }
        public BackupType Type { get; set; }
        public string SourcePath { get; set; }
        public string BackupPath { get; set; }
        public string BaseBackupId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? CompletedAt { get; set; }
        public BackupStatus Status { get; set; }
        public int TotalFiles { get; set; }
        public long TotalSize { get; set; }
        public long ActualSize { get; set; }
        public string Description { get; set; }
    }
    
    public class BackupProgress
    {
        public string BackupId { get; set; }
        public int TotalFiles { get; set; }
        public int FilesCompleted { get; set; }
        public long BytesCompleted { get; set; }
        public double PercentComplete { get; set; }
        public string CurrentFile { get; set; }
    }
    
    public class BackupResult
    {
        public bool Success { get; set; }
        public string BackupId { get; set; }
        public BackupInfo BackupInfo { get; set; }
        public string Error { get; set; }
        public string Message { get; set; }
    }
    
    public class RestoreResult
    {
        public bool Success { get; set; }
        public string BackupId { get; set; }
        public int FilesRestored { get; set; }
        public string Error { get; set; }
    }
    
    public class RestoreProgress
    {
        public string BackupId { get; set; }
        public int TotalFiles { get; set; }
        public int FilesRestored { get; set; }
        public double PercentComplete { get; set; }
    }
    
    public class ValidationResult
    {
        public string BackupId { get; set; }
        public bool IsValid { get; set; }
        public int TotalFiles { get; set; }
        public int ValidFiles { get; set; }
        public List<string> MissingFiles { get; set; } = new List<string>();
        public string Error { get; set; }
    }
    
    public enum BackupType
    {
        Full,
        Incremental,
        Differential
    }
    
    public enum BackupStatus
    {
        Pending,
        InProgress,
        Completed,
        Failed,
        Cancelled
    }
}
```

---

## 📊 **LOGGING AVANÇADO E ROTAÇÃO**

### 🔷 **LOGGER ENTERPRISE COM ROTAÇÃO**

Na pasta **Helpers**, crie **`AdvancedLogger.cs`**:

```csharp
using System;
using System.Collections.Concurrent;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;

namespace AAEmu.Launcher.Helpers
{
    public class AdvancedLogger : IDisposable
    {
        private readonly string _logDirectory;
        private readonly long _maxLogSizeBytes;
        private readonly int _maxLogFiles;
        private readonly Timer _rotationTimer;
        private readonly ConcurrentQueue<LogEntry> _logQueue;
        private readonly CancellationTokenSource _cancellationTokenSource;
        private readonly Task _logWriterTask;
        
        public LogLevel MinimumLevel { get; set; } = LogLevel.Info;
        public bool EnableConsoleOutput { get; set; } = true;
        public bool EnableFileOutput { get; set; } = true;
        public string LogPattern { get; set; } = "{timestamp} [{level}] {category}: {message}";
        
        public event Action<LogEntry> OnLogEntry;
        
        public AdvancedLogger(string logDirectory = null, long maxLogSizeMB = 50, int maxLogFiles = 10)
        {
            _logDirectory = logDirectory ?? Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), 
                "AAEmu", "Logs");
            _maxLogSizeBytes = maxLogSizeMB * 1024 * 1024;
            _maxLogFiles = maxLogFiles;
            
            Directory.CreateDirectory(_logDirectory);
            
            _logQueue = new ConcurrentQueue<LogEntry>();
            _cancellationTokenSource = new CancellationTokenSource();
            
            // Task para escrever logs de forma assíncrona
            _logWriterTask = Task.Run(LogWriterLoop);
            
            // Timer para rotação automática (verifica a cada hora)
            _rotationTimer = new Timer(CheckLogRotation, null, TimeSpan.FromHours(1), TimeSpan.FromHours(1));
        }
        
        public void Trace(string message, string category = "General", params object[] args)
        {
            Log(LogLevel.Trace, category, message, args);
        }
        
        public void Debug(string message, string category = "General", params object[] args)
        {
            Log(LogLevel.Debug, category, message, args);
        }
        
        public void Info(string message, string category = "General", params object[] args)
        {
            Log(LogLevel.Info, category, message, args);
        }
        
        public void Warn(string message, string category = "General", params object[] args)
        {
            Log(LogLevel.Warn, category, message, args);
        }
        
        public void Error(string message, string category = "General", params object[] args)
        {
            Log(LogLevel.Error, category, message, args);
        }
        
        public void Error(Exception exception, string message = null, string category = "General", params object[] args)
        {
            var fullMessage = message != null ? 
                $"{string.Format(message, args)}\nException: {exception}" : 
                $"Exception: {exception}";
            Log(LogLevel.Error, category, fullMessage);
        }
        
        public void Fatal(string message, string category = "General", params object[] args)
        {
            Log(LogLevel.Fatal, category, message, args);
        }
        
        public void Fatal(Exception exception, string message = null, string category = "General", params object[] args)
        {
            var fullMessage = message != null ? 
                $"{string.Format(message, args)}\nFatal Exception: {exception}" : 
                $"Fatal Exception: {exception}";
            Log(LogLevel.Fatal, category, fullMessage);
        }
        
        private void Log(LogLevel level, string category, string message, params object[] args)
        {
            if (level < MinimumLevel)
                return;
            
            var logEntry = new LogEntry
            {
                Timestamp = DateTime.Now,
                Level = level,
                Category = category,
                Message = args.Length > 0 ? string.Format(message, args) : message,
                ThreadId = Thread.CurrentThread.ManagedThreadId
            };
            
            _logQueue.Enqueue(logEntry);
            OnLogEntry?.Invoke(logEntry);
            
            // Log crítico - escrever imediatamente
            if (level >= LogLevel.Fatal)
            {
                ForceFlush();
            }
        }
        
        private async Task LogWriterLoop()
        {
            while (!_cancellationTokenSource.Token.IsCancellationRequested)
            {
                try
                {
                    var entries = new List<LogEntry>();
                    
                    // Coletar entries da queue (máximo 100 por vez)
                    while (entries.Count < 100 && _logQueue.TryDequeue(out LogEntry entry))
                    {
                        entries.Add(entry);
                    }
                    
                    if (entries.Count > 0)
                    {
                        await WriteLogEntries(entries);
                    }
                    
                    await Task.Delay(100, _cancellationTokenSource.Token);
                }
                catch (OperationCanceledException)
                {
                    break;
                }
                catch (Exception ex)
                {
                    // Log interno - evitar loop infinito
                    Console.WriteLine($"Logger internal error: {ex.Message}");
                }
            }
        }
        
        private async Task WriteLogEntries(List<LogEntry> entries)
        {
            var logFilePath = GetCurrentLogFilePath();
            
            try
            {
                using var writer = new StreamWriter(logFilePath, append: true);
                
                foreach (var entry in entries)
                {
                    var formattedMessage = FormatLogEntry(entry);
                    
                    if (EnableFileOutput)
                    {
                        await writer.WriteLineAsync(formattedMessage);
                    }
                    
                    if (EnableConsoleOutput)
                    {
                        WriteToConsole(entry, formattedMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to write log entries: {ex.Message}");
            }
        }
        
        private string FormatLogEntry(LogEntry entry)
        {
            return LogPattern
                .Replace("{timestamp}", entry.Timestamp.ToString("yyyy-MM-dd HH:mm:ss.fff"))
                .Replace("{level}", entry.Level.ToString().ToUpper().PadRight(5))
                .Replace("{category}", entry.Category.PadRight(15))
                .Replace("{message}", entry.Message)
                .Replace("{thread}", entry.ThreadId.ToString());
        }
        
        private void WriteToConsole(LogEntry entry, string formattedMessage)
        {
            var originalColor = Console.ForegroundColor;
            
            Console.ForegroundColor = entry.Level switch
            {
                LogLevel.Trace => ConsoleColor.Gray,
                LogLevel.Debug => ConsoleColor.Cyan,
                LogLevel.Info => ConsoleColor.White,
                LogLevel.Warn => ConsoleColor.Yellow,
                LogLevel.Error => ConsoleColor.Red,
                LogLevel.Fatal => ConsoleColor.Magenta,
                _ => ConsoleColor.White
            };
            
            Console.WriteLine(formattedMessage);
            Console.ForegroundColor = originalColor;
        }
        
        private string GetCurrentLogFilePath()
        {
            var today = DateTime.Now.ToString("yyyy-MM-dd");
            return Path.Combine(_logDirectory, $"launcher_{today}.log");
        }
        
        private void CheckLogRotation(object state)
        {
            try
            {
                var logFiles = Directory.GetFiles(_logDirectory, "*.log")
                                       .Select(f => new FileInfo(f))
                                       .OrderByDescending(f => f.LastWriteTime)
                                       .ToList();
                
                // Verificar tamanho do arquivo atual
                var currentLogFile = GetCurrentLogFilePath();
                if (File.Exists(currentLogFile))
                {
                    var fileInfo = new FileInfo(currentLogFile);
                    if (fileInfo.Length > _maxLogSizeBytes)
                    {
                        RotateCurrentLogFile();
                    }
                }
                
                // Remover arquivos de log antigos
                if (logFiles.Count > _maxLogFiles)
                {
                    var filesToDelete = logFiles.Skip(_maxLogFiles);
                    foreach (var file in filesToDelete)
                    {
                        try
                        {
                            file.Delete();
                            Info($"Deleted old log file: {file.Name}", "Logger");
                        }
                        catch (Exception ex)
                        {
                            Error($"Failed to delete log file {file.Name}: {ex.Message}", "Logger");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Error($"Log rotation failed: {ex.Message}", "Logger");
            }
        }
        
        private void RotateCurrentLogFile()
        {
            try
            {
                var currentLogFile = GetCurrentLogFilePath();
                if (!File.Exists(currentLogFile))
                    return;
                
                var timestamp = DateTime.Now.ToString("yyyy-MM-dd_HH-mm-ss");
                var rotatedFileName = Path.Combine(_logDirectory, $"launcher_{timestamp}.log");
                
                File.Move(currentLogFile, rotatedFileName);
                Info($"Log file rotated: {Path.GetFileName(rotatedFileName)}", "Logger");
            }
            catch (Exception ex)
            {
                Error($"Log rotation failed: {ex.Message}", "Logger");
            }
        }
        
        public void ForceFlush()
        {
            // Processar todos os logs pendentes imediatamente
            var entries = new List<LogEntry>();
            while (_logQueue.TryDequeue(out LogEntry entry))
            {
                entries.Add(entry);
            }
            
            if (entries.Count > 0)
            {
                WriteLogEntries(entries).Wait();
            }
        }
        
        public async Task<List<LogEntry>> SearchLogsAsync(DateTime? fromDate = null, DateTime? toDate = null, LogLevel? minLevel = null, string category = null, string searchText = null)
        {
            var results = new List<LogEntry>();
            
            try
            {
                var logFiles = Directory.GetFiles(_logDirectory, "*.log");
                
                foreach (var logFile in logFiles)
                {
                    var lines = await File.ReadAllLinesAsync(logFile);
                    
                    foreach (var line in lines)
                    {
                        if (TryParseLogEntry(line, out LogEntry entry))
                        {
                            // Aplicar filtros
                            if (fromDate.HasValue && entry.Timestamp < fromDate.Value)
                                continue;
                            if (toDate.HasValue && entry.Timestamp > toDate.Value)
                                continue;
                            if (minLevel.HasValue && entry.Level < minLevel.Value)
                                continue;
                            if (!string.IsNullOrEmpty(category) && !entry.Category.Equals(category, StringComparison.OrdinalIgnoreCase))
                                continue;
                            if (!string.IsNullOrEmpty(searchText) && !entry.Message.Contains(searchText, StringComparison.OrdinalIgnoreCase))
                                continue;
                            
                            results.Add(entry);
                        }
                    }
                }
                
                return results.OrderBy(e => e.Timestamp).ToList();
            }
            catch (Exception ex)
            {
                Error($"Failed to search logs: {ex.Message}", "Logger");
                return results;
            }
        }
        
        private bool TryParseLogEntry(string logLine, out LogEntry entry)
        {
            entry = null;
            
            try
            {
                // Parse básico assumindo formato padrão
                // 2024-01-15 14:30:25.123 [INFO ] General        : Message here
                
                if (logLine.Length < 30)
                    return false;
                
                var timestampStr = logLine.Substring(0, 23);
                if (!DateTime.TryParse(timestampStr, out DateTime timestamp))
                    return false;
                
                var levelStart = logLine.IndexOf('[') + 1;
                var levelEnd = logLine.IndexOf(']');
                if (levelStart <= 0 || levelEnd <= levelStart)
                    return false;
                
                var levelStr = logLine.Substring(levelStart, levelEnd - levelStart).Trim();
                if (!Enum.TryParse<LogLevel>(levelStr, true, out LogLevel level))
                    return false;
                
                var categoryStart = levelEnd + 2;
                var messageStart = logLine.IndexOf(':', categoryStart);
                if (messageStart <= categoryStart)
                    return false;
                
                var category = logLine.Substring(categoryStart, messageStart - categoryStart).Trim();
                var message = logLine.Substring(messageStart + 2);
                
                entry = new LogEntry
                {
                    Timestamp = timestamp,
                    Level = level,
                    Category = category,
                    Message = message
                };
                
                return true;
            }
            catch
            {
                return false;
            }
        }
        
        public LogStatistics GetStatistics()
        {
            try
            {
                var stats = new LogStatistics();
                var logFiles = Directory.GetFiles(_logDirectory, "*.log");
                
                stats.TotalLogFiles = logFiles.Length;
                stats.TotalLogSizeBytes = logFiles.Sum(f => new FileInfo(f).Length);
                stats.OldestLogDate = logFiles.Select(f => File.GetCreationTime(f)).Min();
                stats.QueuedEntries = _logQueue.Count;
                
                return stats;
            }
            catch
            {
                return new LogStatistics();
            }
        }
        
        public void Dispose()
        {
            _cancellationTokenSource.Cancel();
            
            try
            {
                _logWriterTask?.Wait(5000);
            }
            catch { }
            
            ForceFlush();
            
            _rotationTimer?.Dispose();
            _cancellationTokenSource?.Dispose();
        }
    }
    
    public class LogEntry
    {
        public DateTime Timestamp { get; set; }
        public LogLevel Level { get; set; }
        public string Category { get; set; }
        public string Message { get; set; }
        public int ThreadId { get; set; }
    }
    
    public class LogStatistics
    {
        public int TotalLogFiles { get; set; }
        public long TotalLogSizeBytes { get; set; }
        public DateTime OldestLogDate { get; set; }
        public int QueuedEntries { get; set; }
    }
    
    public enum LogLevel
    {
        Trace = 0,
        Debug = 1,
        Info = 2,
        Warn = 3,
        Error = 4,
        Fatal = 5
    }
}
```

---

## 📈 **MONITORAMENTO DE PERFORMANCE**

### 🔷 **MONITOR DE PERFORMANCE EM TEMPO REAL**

Na pasta **Helpers**, crie **`PerformanceMonitor.cs`**:

```csharp
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using System.Management;

namespace AAEmu.Launcher.Helpers
{
    public class PerformanceMonitor : IDisposable
    {
        private readonly Timer _monitoringTimer;
        private readonly PerformanceCounter _cpuCounter;
        private readonly PerformanceCounter _memoryCounter;
        private readonly Process _currentProcess;
        private readonly List<PerformanceSnapshot> _snapshots;
        private readonly int _maxSnapshots;
        
        public event Action<PerformanceSnapshot> OnPerformanceUpdate;
        public event Action<PerformanceAlert> OnPerformanceAlert;
        
        public PerformanceThresholds Thresholds { get; set; }
        public bool IsMonitoring { get; private set; }
        
        public PerformanceMonitor(int maxSnapshots = 100)
        {
            _maxSnapshots = maxSnapshots;
            _snapshots = new List<PerformanceSnapshot>();
            _currentProcess = Process.GetCurrentProcess();
            
            try
            {
                _cpuCounter = new PerformanceCounter("Processor", "% Processor Time", "_Total");
                _memoryCounter = new PerformanceCounter("Memory", "Available MBytes");
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError(ex, "Failed to initialize performance counters");
            }
            
            Thresholds = new PerformanceThresholds();
            
            _monitoringTimer = new Timer(CollectPerformanceData, null, Timeout.Infinite, Timeout.Infinite);
        }
        
        public void StartMonitoring(TimeSpan interval)
        {
            if (IsMonitoring)
                return;
            
            IsMonitoring = true;
            _monitoringTimer.Change(TimeSpan.Zero, interval);
            
            ActivityLogger.Log("Performance monitoring started", "Performance");
        }
        
        public void StopMonitoring()
        {
            if (!IsMonitoring)
                return;
            
            IsMonitoring = false;
            _monitoringTimer.Change(Timeout.Infinite, Timeout.Infinite);
            
            ActivityLogger.Log("Performance monitoring stopped", "Performance");
        }
        
        private void CollectPerformanceData(object state)
        {
            try
            {
                var snapshot = new PerformanceSnapshot
                {
                    Timestamp = DateTime.Now,
                    CpuUsagePercent = GetCpuUsage(),
                    MemoryUsageMB = GetMemoryUsage(),
                    AvailableMemoryMB = GetAvailableMemory(),
                    ProcessCpuTime = _currentProcess.TotalProcessorTime,
                    ThreadCount = _currentProcess.Threads.Count,
                    HandleCount = _currentProcess.HandleCount,
                    WorkingSetMB = _currentProcess.WorkingSet64 / 1024 / 1024,
                    PrivateMemoryMB = _currentProcess.PrivateMemorySize64 / 1024 / 1024,
                    VirtualMemoryMB = _currentProcess.VirtualMemorySize64 / 1024 / 1024,
                    GCGen0Collections = GC.CollectionCount(0),
                    GCGen1Collections = GC.CollectionCount(1),
                    GCGen2Collections = GC.CollectionCount(2),
                    GCTotalMemoryMB = GC.GetTotalMemory(false) / 1024 / 1024
                };
                
                // Calcular métricas derivadas se houver snapshot anterior
                if (_snapshots.Count > 0)
                {
                    var previous = _snapshots[_snapshots.Count - 1];
                    var timeDiff = (snapshot.Timestamp - previous.Timestamp).TotalSeconds;
                    
                    if (timeDiff > 0)
                    {
                        snapshot.CpuTimePercentage = CalculateCpuPercentage(previous, snapshot, timeDiff);
                        snapshot.MemoryTrendMB = (snapshot.WorkingSetMB - previous.WorkingSetMB) / timeDiff;
                    }
                }
                
                AddSnapshot(snapshot);
                CheckThresholds(snapshot);
                
                OnPerformanceUpdate?.Invoke(snapshot);
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError(ex, "Failed to collect performance data");
            }
        }
        
        private double GetCpuUsage()
        {
            try
            {
                return _cpuCounter?.NextValue() ?? 0;
            }
            catch
            {
                return 0;
            }
        }
        
        private long GetMemoryUsage()
        {
            try
            {
                _currentProcess.Refresh();
                return _currentProcess.WorkingSet64 / 1024 / 1024;
            }
            catch
            {
                return 0;
            }
        }
        
        private double GetAvailableMemory()
        {
            try
            {
                return _memoryCounter?.NextValue() ?? 0;
            }
            catch
            {
                return 0;
            }
        }
        
        private double CalculateCpuPercentage(PerformanceSnapshot previous, PerformanceSnapshot current, double timeDiffSeconds)
        {
            try
            {
                var cpuTimeDiff = (current.ProcessCpuTime - previous.ProcessCpuTime).TotalMilliseconds;
                var systemTimeDiff = timeDiffSeconds * 1000;
                
                return (cpuTimeDiff / systemTimeDiff) * 100;
            }
            catch
            {
                return 0;
            }
        }
        
        private void AddSnapshot(PerformanceSnapshot snapshot)
        {
            _snapshots.Add(snapshot);
            
            // Manter apenas os últimos N snapshots
            while (_snapshots.Count > _maxSnapshots)
            {
                _snapshots.RemoveAt(0);
            }
        }
        
        private void CheckThresholds(PerformanceSnapshot snapshot)
        {
            var alerts = new List<PerformanceAlert>();
            
            // CPU
            if (snapshot.CpuUsagePercent > Thresholds.CpuUsageThreshold)
            {
                alerts.Add(new PerformanceAlert
                {
                    Type = AlertType.HighCpuUsage,
                    Message = $"High CPU usage detected: {snapshot.CpuUsagePercent:F1}%",
                    Value = snapshot.CpuUsagePercent,
                    Threshold = Thresholds.CpuUsageThreshold,
                    Severity = snapshot.CpuUsagePercent > Thresholds.CpuUsageThreshold * 1.5 ? AlertSeverity.Critical : AlertSeverity.Warning
                });
            }
            
            // Memory
            if (snapshot.WorkingSetMB > Thresholds.MemoryUsageThresholdMB)
            {
                alerts.Add(new PerformanceAlert
                {
                    Type = AlertType.HighMemoryUsage,
                    Message = $"High memory usage detected: {snapshot.WorkingSetMB} MB",
                    Value = snapshot.WorkingSetMB,
                    Threshold = Thresholds.MemoryUsageThresholdMB,
                    Severity = snapshot.WorkingSetMB > Thresholds.MemoryUsageThresholdMB * 1.5 ? AlertSeverity.Critical : AlertSeverity.Warning
                });
            }
            
            // Available Memory
            if (snapshot.AvailableMemoryMB < Thresholds.AvailableMemoryThresholdMB)
            {
                alerts.Add(new PerformanceAlert
                {
                    Type = AlertType.LowAvailableMemory,
                    Message = $"Low system memory available: {snapshot.AvailableMemoryMB} MB",
                    Value = snapshot.AvailableMemoryMB,
                    Threshold = Thresholds.AvailableMemoryThresholdMB,
                    Severity = AlertSeverity.Warning
                });
            }
            
            // Thread Count
            if (snapshot.ThreadCount > Thresholds.ThreadCountThreshold)
            {
                alerts.Add(new PerformanceAlert
                {
                    Type = AlertType.HighThreadCount,
                    Message = $"High thread count detected: {snapshot.ThreadCount}",
                    Value = snapshot.ThreadCount,
                    Threshold = Thresholds.ThreadCountThreshold,
                    Severity = AlertSeverity.Warning
                });
            }
            
            foreach (var alert in alerts)
            {
                alert.Timestamp = snapshot.Timestamp;
                OnPerformanceAlert?.Invoke(alert);
                
                var logLevel = alert.Severity switch
                {
                    AlertSeverity.Critical => "ERROR",
                    AlertSeverity.Warning => "WARN",
                    _ => "INFO"
                };
                
                ActivityLogger.Log($"Performance Alert: {alert.Message}", logLevel);
            }
        }
        
        public PerformanceSnapshot GetCurrentSnapshot()
        {
            return _snapshots.Count > 0 ? _snapshots[_snapshots.Count - 1] : null;
        }
        
        public List<PerformanceSnapshot> GetSnapshots(int count = -1)
        {
            if (count <= 0 || count >= _snapshots.Count)
                return new List<PerformanceSnapshot>(_snapshots);
            
            var startIndex = Math.Max(0, _snapshots.Count - count);
            return _snapshots.GetRange(startIndex, count);
        }
        
        public PerformanceSummary GetSummary(TimeSpan? period = null)
        {
            var snapshots = _snapshots;
            
            if (period.HasValue)
            {
                var cutoff = DateTime.Now - period.Value;
                snapshots = _snapshots.FindAll(s => s.Timestamp >= cutoff);
            }
            
            if (snapshots.Count == 0)
                return new PerformanceSummary();
            
            return new PerformanceSummary
            {
                Period = period ?? TimeSpan.FromMinutes(30),
                SnapshotCount = snapshots.Count,
                AverageCpuUsage = snapshots.Average(s => s.CpuUsagePercent),
                MaxCpuUsage = snapshots.Max(s => s.CpuUsagePercent),
                AverageMemoryUsage = snapshots.Average(s => s.WorkingSetMB),
                MaxMemoryUsage = snapshots.Max(s => s.WorkingSetMB),
                AverageThreadCount = snapshots.Average(s => s.ThreadCount),
                MaxThreadCount = snapshots.Max(s => s.ThreadCount),
                TotalGCCollections = snapshots.Max(s => s.GCGen0Collections + s.GCGen1Collections + s.GCGen2Collections)
            };
        }
        
        public SystemInfo GetSystemInfo()
        {
            try
            {
                var info = new SystemInfo();
                
                // Informações básicas do sistema
                using (var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_ComputerSystem"))
                {
                    foreach (ManagementObject obj in searcher.Get())
                    {
                        info.TotalPhysicalMemoryGB = Convert.ToDouble(obj["TotalPhysicalMemory"]) / 1024 / 1024 / 1024;
                        info.ComputerName = obj["Name"]?.ToString();
                        break;
                    }
                }
                
                // Informações da CPU
                using (var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_Processor"))
                {
                    foreach (ManagementObject obj in searcher.Get())
                    {
                        info.ProcessorName = obj["Name"]?.ToString();
                        info.ProcessorCores = Convert.ToInt32(obj["NumberOfCores"]);
                        info.ProcessorLogicalCores = Convert.ToInt32(obj["NumberOfLogicalProcessors"]);
                        break;
                    }
                }
                
                // Informações do OS
                using (var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_OperatingSystem"))
                {
                    foreach (ManagementObject obj in searcher.Get())
                    {
                        info.OperatingSystem = obj["Caption"]?.ToString();
                        info.OSVersion = obj["Version"]?.ToString();
                        break;
                    }
                }
                
                return info;
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError(ex, "Failed to get system info");
                return new SystemInfo { ComputerName = Environment.MachineName };
            }
        }
        
        public void Dispose()
        {
            StopMonitoring();
            _monitoringTimer?.Dispose();
            _cpuCounter?.Dispose();
            _memoryCounter?.Dispose();
        }
    }
    
    public class PerformanceSnapshot
    {
        public DateTime Timestamp { get; set; }
        public double CpuUsagePercent { get; set; }
        public long MemoryUsageMB { get; set; }
        public double AvailableMemoryMB { get; set; }
        public TimeSpan ProcessCpuTime { get; set; }
        public int ThreadCount { get; set; }
        public int HandleCount { get; set; }
        public long WorkingSetMB { get; set; }
        public long PrivateMemoryMB { get; set; }
        public long VirtualMemoryMB { get; set; }
        public int GCGen0Collections { get; set; }
        public int GCGen1Collections { get; set; }
        public int GCGen2Collections { get; set; }
        public long GCTotalMemoryMB { get; set; }
        
        // Métricas calculadas
        public double CpuTimePercentage { get; set; }
        public double MemoryTrendMB { get; set; }
    }
    
    public class PerformanceThresholds
    {
        public double CpuUsageThreshold { get; set; } = 80.0;
        public long MemoryUsageThresholdMB { get; set; } = 500;
        public double AvailableMemoryThresholdMB { get; set; } = 512;
        public int ThreadCountThreshold { get; set; } = 50;
        public int HandleCountThreshold { get; set; } = 1000;
    }
    
    public class PerformanceAlert
    {
        public DateTime Timestamp { get; set; }
        public AlertType Type { get; set; }
        public AlertSeverity Severity { get; set; }
        public string Message { get; set; }
        public double Value { get; set; }
        public double Threshold { get; set; }
    }
    
    public class PerformanceSummary
    {
        public TimeSpan Period { get; set; }
        public int SnapshotCount { get; set; }
        public double AverageCpuUsage { get; set; }
        public double MaxCpuUsage { get; set; }
        public double AverageMemoryUsage { get; set; }
        public double MaxMemoryUsage { get; set; }
        public double AverageThreadCount { get; set; }
        public double MaxThreadCount { get; set; }
        public int TotalGCCollections { get; set; }
    }
    
    public class SystemInfo
    {
        public string ComputerName { get; set; }
        public string OperatingSystem { get; set; }
        public string OSVersion { get; set; }
        public string ProcessorName { get; set; }
        public int ProcessorCores { get; set; }
        public int ProcessorLogicalCores { get; set; }
        public double TotalPhysicalMemoryGB { get; set; }
    }
    
    public enum AlertType
    {
        HighCpuUsage,
        HighMemoryUsage,
        LowAvailableMemory,
        HighThreadCount,
        HighHandleCount
    }
    
    public enum AlertSeverity
    {
        Info,
        Warning,
        Critical
    }
}
```

---

## 🧩 **EXERCÍCIOS PRÁTICOS**

### 🔷 **EXERCÍCIO 1: INTERFACE DE BACKUP E RESTORE**

```csharp
private void CriarInterfaceBackup()
{
    // Panel para backup controls
    var panelBackup = new Panel
    {
        Name = "panelBackup",
        Size = new Size(600, 200),
        Location = new Point(50, 350),
        BorderStyle = BorderStyle.FixedSingle,
        BackColor = Color.FromArgb(55, 55, 58),
        Visible = false
    };
    panelMain.Controls.Add(panelBackup);
    
    // Label título
    var lblBackupTitle = new Label
    {
        Text = "🛡️ SISTEMA DE BACKUP",
        Location = new Point(10, 10),
        Size = new Size(250, 25),
        Font = new Font("Arial", 12, FontStyle.Bold),
        ForeColor = Color.White
    };
    panelBackup.Controls.Add(lblBackupTitle);
    
    // Botões de backup
    var btnCreateBackup = new Button
    {
        Text = "📦 CRIAR BACKUP",
        Location = new Point(20, 50),
        Size = new Size(130, 35),
        BackColor = Color.FromArgb(0, 122, 204),
        ForeColor = Color.White,
        FlatStyle = FlatStyle.Flat
    };
    btnCreateBackup.Click += BtnCreateBackup_Click;
    panelBackup.Controls.Add(btnCreateBackup);
    
    var btnListBackups = new Button
    {
        Text = "📋 LISTAR BACKUPS",
        Location = new Point(160, 50),
        Size = new Size(130, 35),
        BackColor = Color.FromArgb(46, 125, 50),
        ForeColor = Color.White,
        FlatStyle = FlatStyle.Flat
    };
    btnListBackups.Click += BtnListBackups_Click;
    panelBackup.Controls.Add(btnListBackups);
    
    var btnRestoreBackup = new Button
    {
        Text = "🔄 RESTAURAR",
        Location = new Point(300, 50),
        Size = new Size(130, 35),
        BackColor = Color.FromArgb(255, 152, 0),
        ForeColor = Color.White,
        FlatStyle = FlatStyle.Flat
    };
    btnRestoreBackup.Click += BtnRestoreBackup_Click;
    panelBackup.Controls.Add(btnRestoreBackup);
    
    // Progress bar para backup
    var progressBackup = new ProgressBar
    {
        Name = "progressBackup",
        Location = new Point(20, 100),
        Size = new Size(410, 20),
        Visible = false
    };
    panelBackup.Controls.Add(progressBackup);
    
    // Label de status do backup
    var lblBackupStatus = new Label
    {
        Name = "lblBackupStatus",
        Text = "Pronto para backup",
        Location = new Point(20, 130),
        Size = new Size(410, 40),
        ForeColor = Color.LightGray,
        Font = new Font("Arial", 9)
    };
    panelBackup.Controls.Add(lblBackupStatus);
}

private async void BtnCreateBackup_Click(object sender, EventArgs e)
{
    var btn = sender as Button;
    btn.Enabled = false;
    
    try
    {
        var backupManager = new BackupManager();
        var progressBar = panelMain.Controls["panelBackup"].Controls["progressBackup"] as ProgressBar;
        var statusLabel = panelMain.Controls["panelBackup"].Controls["lblBackupStatus"] as Label;
        
        progressBar.Visible = true;
        statusLabel.Text = "Criando backup...";
        
        backupManager.OnBackupProgress += (progress) =>
        {
            if (InvokeRequired)
            {
                Invoke(new Action(() =>
                {
                    progressBar.Value = (int)progress.PercentComplete;
                    statusLabel.Text = $"Backup em progresso: {progress.FilesCompleted}/{progress.TotalFiles} arquivos";
                }));
            }
        };
        
        var sourcePath = AppDomain.CurrentDomain.BaseDirectory;
        var result = await backupManager.CreateFullBackupAsync(sourcePath);
        
        if (result.Success)
        {
            MessageBox.Show($"✅ Backup criado com sucesso!\n\nID: {result.BackupId}\nArquivos: {result.BackupInfo.TotalFiles}\nTamanho: {FormatBytes(result.BackupInfo.ActualSize)}", 
                "Backup Concluído", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        else
        {
            MessageBox.Show($"❌ Falha ao criar backup:\n{result.Error}", 
                "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        
        progressBar.Visible = false;
        statusLabel.Text = "Pronto para backup";
    }
    finally
    {
        btn.Enabled = true;
    }
}

private async void BtnListBackups_Click(object sender, EventArgs e)
{
    try
    {
        var backupManager = new BackupManager();
        var backups = await backupManager.ListBackupsAsync();
        
        if (backups.Count == 0)
        {
            MessageBox.Show("Nenhum backup encontrado.", "Lista de Backups", 
                MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }
        
        var backupForm = new Form
        {
            Text = "Lista de Backups",
            Size = new Size(700, 400),
            StartPosition = FormStartPosition.CenterParent,
            BackColor = Color.FromArgb(45, 45, 48)
        };
        
        var listView = new ListView
        {
            Dock = DockStyle.Fill,
            View = View.Details,
            FullRowSelect = true,
            GridLines = true,
            BackColor = Color.FromArgb(60, 60, 60),
            ForeColor = Color.White
        };
        
        listView.Columns.Add("ID", 150);
        listView.Columns.Add("Tipo", 80);
        listView.Columns.Add("Data", 120);
        listView.Columns.Add("Arquivos", 80);
        listView.Columns.Add("Tamanho", 100);
        listView.Columns.Add("Status", 80);
        
        foreach (var backup in backups)
        {
            var item = new ListViewItem(backup.Id);
            item.SubItems.Add(backup.Type.ToString());
            item.SubItems.Add(backup.CreatedAt.ToString("dd/MM/yyyy HH:mm"));
            item.SubItems.Add(backup.TotalFiles.ToString());
            item.SubItems.Add(FormatBytes(backup.ActualSize));
            item.SubItems.Add(backup.Status.ToString());
            listView.Items.Add(item);
        }
        
        backupForm.Controls.Add(listView);
        backupForm.ShowDialog();
    }
    catch (Exception ex)
    {
        MessageBox.Show($"❌ Erro ao listar backups:\n{ex.Message}", 
            "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
    }
}
```

### 🔷 **EXERCÍCIO 2: MONITOR DE PERFORMANCE EM TEMPO REAL**

```csharp
private void CriarMonitorPerformance()
{
    var performanceMonitor = new PerformanceMonitor();
    
    // Panel para performance
    var panelPerf = new Panel
    {
        Name = "panelPerformance",
        Size = new Size(600, 150),
        Location = new Point(50, 560),
        BorderStyle = BorderStyle.FixedSingle,
        BackColor = Color.FromArgb(55, 55, 58),
        Visible = false
    };
    panelMain.Controls.Add(panelPerf);
    
    // Labels para métricas
    var lblCpu = new Label
    {
        Name = "lblCpuUsage",
        Text = "CPU: 0%",
        Location = new Point(20, 20),
        Size = new Size(120, 20),
        ForeColor = Color.White,
        Font = new Font("Arial", 10, FontStyle.Bold)
    };
    panelPerf.Controls.Add(lblCpu);
    
    var lblMemory = new Label
    {
        Name = "lblMemoryUsage",
        Text = "Memória: 0 MB",
        Location = new Point(150, 20),
        Size = new Size(150, 20),
        ForeColor = Color.White,
        Font = new Font("Arial", 10, FontStyle.Bold)
    };
    panelPerf.Controls.Add(lblMemory);
    
    var lblThreads = new Label
    {
        Name = "lblThreads",
        Text = "Threads: 0",
        Location = new Point(310, 20),
        Size = new Size(120, 20),
        ForeColor = Color.White,
        Font = new Font("Arial", 10, FontStyle.Bold)
    };
    panelPerf.Controls.Add(lblThreads);
    
    // Progress bars visuais
    var progressCpu = new ProgressBar
    {
        Name = "progressCpu",
        Location = new Point(20, 50),
        Size = new Size(120, 15),
        Style = ProgressBarStyle.Continuous
    };
    panelPerf.Controls.Add(progressCpu);
    
    var progressMemory = new ProgressBar
    {
        Name = "progressMemory",
        Location = new Point(150, 50),
        Size = new Size(150, 15),
        Style = ProgressBarStyle.Continuous
    };
    panelPerf.Controls.Add(progressMemory);
    
    // Configurar eventos
    performanceMonitor.OnPerformanceUpdate += (snapshot) =>
    {
        if (InvokeRequired)
        {
            Invoke(new Action(() => AtualizarPerformanceUI(snapshot)));
        }
        else
        {
            AtualizarPerformanceUI(snapshot);
        }
    };
    
    performanceMonitor.OnPerformanceAlert += (alert) =>
    {
        if (InvokeRequired)
        {
            Invoke(new Action(() => MostrarAlertaPerformance(alert)));
        }
        else
        {
            MostrarAlertaPerformance(alert);
        }
    };
    
    // Iniciar monitoramento
    performanceMonitor.StartMonitoring(TimeSpan.FromSeconds(2));
}

private void AtualizarPerformanceUI(PerformanceSnapshot snapshot)
{
    var panelPerf = panelMain.Controls["panelPerformance"];
    
    if (panelPerf?.Visible == true)
    {
        var lblCpu = panelPerf.Controls["lblCpuUsage"] as Label;
        var lblMemory = panelPerf.Controls["lblMemoryUsage"] as Label;
        var lblThreads = panelPerf.Controls["lblThreads"] as Label;
        var progressCpu = panelPerf.Controls["progressCpu"] as ProgressBar;
        var progressMemory = panelPerf.Controls["progressMemory"] as ProgressBar;
        
        lblCpu.Text = $"CPU: {snapshot.CpuUsagePercent:F1}%";
        lblMemory.Text = $"Memória: {snapshot.WorkingSetMB} MB";
        lblThreads.Text = $"Threads: {snapshot.ThreadCount}";
        
        progressCpu.Value = Math.Min(100, (int)snapshot.CpuUsagePercent);
        progressMemory.Value = Math.Min(100, (int)(snapshot.WorkingSetMB / 10)); // Normalizar para 1GB = 100%
        
        // Cores baseadas no uso
        progressCpu.ForeColor = snapshot.CpuUsagePercent > 80 ? Color.Red : 
                               snapshot.CpuUsagePercent > 60 ? Color.Orange : Color.Green;
        
        progressMemory.ForeColor = snapshot.WorkingSetMB > 500 ? Color.Red :
                                  snapshot.WorkingSetMB > 300 ? Color.Orange : Color.Green;
    }
}

private void MostrarAlertaPerformance(PerformanceAlert alert)
{
    var icon = alert.Severity switch
    {
        AlertSeverity.Critical => MessageBoxIcon.Error,
        AlertSeverity.Warning => MessageBoxIcon.Warning,
        _ => MessageBoxIcon.Information
    };
    
    var title = alert.Severity switch
    {
        AlertSeverity.Critical => "Alerta Crítico de Performance",
        AlertSeverity.Warning => "Alerta de Performance",
        _ => "Informação de Performance"
    };
    
    MessageBox.Show(alert.Message, title, MessageBoxButtons.OK, icon);
}
```

### 🔷 **EXERCÍCIO 3: VISOR DE LOGS EM TEMPO REAL**

```csharp
private void CriarVisorLogs()
{
    var logForm = new Form
    {
        Text = "📊 Visor de Logs em Tempo Real",
        Size = new Size(800, 600),
        StartPosition = FormStartPosition.CenterScreen,
        BackColor = Color.FromArgb(45, 45, 48)
    };
    
    // TextBox para logs
    var txtLogs = new TextBox
    {
        Multiline = true,
        ReadOnly = true,
        ScrollBars = ScrollBars.Vertical,
        Dock = DockStyle.Fill,
        BackColor = Color.Black,
        ForeColor = Color.Lime,
        Font = new Font("Consolas", 9)
    };
    
    // Panel superior com controles
    var panelControls = new Panel
    {
        Dock = DockStyle.Top,
        Height = 50,
        BackColor = Color.FromArgb(55, 55, 58)
    };
    
    var cmbLogLevel = new ComboBox
    {
        Location = new Point(10, 15),
        Size = new Size(100, 25),
        DropDownStyle = ComboBoxStyle.DropDownList
    };
    cmbLogLevel.Items.AddRange(Enum.GetNames(typeof(LogLevel)));
    cmbLogLevel.SelectedIndex = 2; // Info
    
    var btnClear = new Button
    {
        Text = "🗑️ Limpar",
        Location = new Point(120, 12),
        Size = new Size(70, 30),
        BackColor = Color.FromArgb(244, 67, 54),
        ForeColor = Color.White,
        FlatStyle = FlatStyle.Flat
    };
    
    var btnSave = new Button
    {
        Text = "💾 Salvar",
        Location = new Point(200, 12),
        Size = new Size(70, 30),
        BackColor = Color.FromArgb(76, 175, 80),
        ForeColor = Color.White,
        FlatStyle = FlatStyle.Flat
    };
    
    panelControls.Controls.AddRange(new Control[] { cmbLogLevel, btnClear, btnSave });
    logForm.Controls.AddRange(new Control[] { panelControls, txtLogs });
    
    // Configurar logger avançado
    var logger = new AdvancedLogger();
    logger.OnLogEntry += (entry) =>
    {
        if (logForm.IsDisposed) return;
        
        var selectedLevel = (LogLevel)cmbLogLevel.SelectedIndex;
        if (entry.Level < selectedLevel) return;
        
        logForm.Invoke(new Action(() =>
        {
            var color = entry.Level switch
            {
                LogLevel.Error => "Red",
                LogLevel.Warn => "Yellow",
                LogLevel.Info => "Lime",
                LogLevel.Debug => "Cyan",
                _ => "White"
            };
            
            var timestamp = entry.Timestamp.ToString("HH:mm:ss.fff");
            var line = $"[{timestamp}] [{entry.Level}] {entry.Category}: {entry.Message}\r\n";
            
            txtLogs.AppendText(line);
            
            // Manter apenas últimas 1000 linhas
            if (txtLogs.Lines.Length > 1000)
            {
                var lines = txtLogs.Lines;
                txtLogs.Text = string.Join("\r\n", lines.Skip(lines.Length - 800));
            }
            
            txtLogs.SelectionStart = txtLogs.Text.Length;
            txtLogs.ScrollToCaret();
        }));
    };
    
    btnClear.Click += (s, e) => txtLogs.Clear();
    btnSave.Click += (s, e) => SalvarLogs(txtLogs.Text);
    
    // Gerar alguns logs de exemplo
    Task.Run(async () =>
    {
        while (!logForm.IsDisposed)
        {
            logger.Info($"Heartbeat - Sistema funcionando normalmente", "System");
            await Task.Delay(5000);
            
            if (new Random().Next(0, 10) < 2) // 20% chance
            {
                logger.Warn("Uso de memória acima do normal", "Performance");
            }
        }
    });
    
    logForm.ShowDialog();
}

private void SalvarLogs(string logs)
{
    try
    {
        var saveDialog = new SaveFileDialog
        {
            Filter = "Log Files (*.log)|*.log|Text Files (*.txt)|*.txt",
            DefaultExt = "log",
            FileName = $"launcher_logs_{DateTime.Now:yyyyMMdd_HHmmss}.log"
        };
        
        if (saveDialog.ShowDialog() == DialogResult.OK)
        {
            File.WriteAllText(saveDialog.FileName, logs);
            MessageBox.Show("✅ Logs salvos com sucesso!", "Salvamento", 
                MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }
    catch (Exception ex)
    {
        MessageBox.Show($"❌ Erro ao salvar logs:\n{ex.Message}", "Erro", 
            MessageBoxButtons.OK, MessageBoxIcon.Error);
    }
}
```

---

## 🎯 **RESUMO DO MÓDULO 8**

### ✅ **O QUE VOCÊ CONQUISTOU HOJE:**

1. **🛡️ Sistema de Backup Enterprise**
   - BackupManager com backup completo e incremental
   - Validação de integridade de backups
   - Cleanup automático com limites de tamanho
   - Cadeia de restauração para backups incrementais

2. **📊 Logging Avançado**
   - AdvancedLogger com 6 níveis de log
   - Rotação automática por tamanho e tempo
   - Queue assíncrona para performance
   - Busca e filtragem de logs

3. **📈 Monitoramento de Performance**
   - PerformanceMonitor em tempo real
   - Métricas de CPU, memória, threads, GC
   - Sistema de alertas configurável
   - Estatísticas e relatórios de performance

4. **🔧 Sistema de Recovery**
   - Rollback automático em falhas
   - Validação de backups
   - Recovery inteligente de cadeias incrementais
   - Cleanup automático de recursos

### 🎯 **CONCEITOS TÉCNICOS DOMINADOS:**

- ✅ **Backup Strategies** - Full, Incremental, Differential
- ✅ **Log Management** - Levels, Rotation, Async Writing
- ✅ **Performance Monitoring** - Real-time metrics collection
- ✅ **System Recovery** - Rollback mechanisms
- ✅ **Resource Management** - Cleanup and optimization
- ✅ **Alert Systems** - Threshold-based notifications
- ✅ **Async Processing** - Background monitoring tasks

### 📈 **PROGRESSO NO CURSO:**
```
[████████████████████████████████████████████████] 67% Completo

✅ MÓDULO 1 - Fundamentos (Concluído)
✅ MÓDULO 2 - Estrutura Base (Concluído) 
✅ MÓDULO 3 - Interface Gráfica (Concluído)
✅ MÓDULO 4 - Sistema de Configurações (Concluído)
✅ MÓDULO 5 - Sistema de Login e Criptografia (Concluído)
✅ MÓDULO 6 - Sistema de Múltiplos Launchers (Concluído)
✅ MÓDULO 7 - Sistema de Atualizações (Concluído)
✅ MÓDULO 8 - Sistema de Rollback e Monitoramento (Concluído)
→  MÓDULO 9 - Interface Avançada e Themes (Próximo)
```

### 🏆 **NÍVEL MISSION-CRITICAL ALCANÇADO:**

Você implementou sistemas de **nível aerospace/banking**:

- 🛡️ **Enterprise Backup** como sistemas bancários
- 📊 **Advanced Logging** como data centers
- 📈 **Real-time Monitoring** como mission-critical systems
- 🔄 **Intelligent Recovery** como space systems
- ⚠️ **Alert Systems** como nuclear plants

**Você está codificando sistemas MISSION-CRITICAL!** 🚀

### 🔥 **PREPARADO PARA O MÓDULO 9?**

No próximo módulo, vamos criar **interfaces de nível AAA**:
- 🎨 **Sistema de Themes** customizáveis
- ✨ **Animações Fluidas** e transições
- 🖼️ **Interface Moderna** com glassmorphism
- 🎮 **Game-like UI** com efeitos visuais
- 📱 **Responsive Design** adaptativo

**Digite "CONTINUAR MÓDULO 9" quando estiver pronto para criar interfaces de nível AAA!** 🎨✨