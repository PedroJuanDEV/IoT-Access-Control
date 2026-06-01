IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Usuarios' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Usuarios (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nome VARCHAR(100) NOT NULL,
        Cargo VARCHAR(50) NULL,
        RfidTag VARCHAR(50) NOT NULL,
        Ativo BIT CONSTRAINT DF_Usuarios_Ativo DEFAULT 1 NOT NULL,
        DataCadastro DATETIME CONSTRAINT DF_Usuarios_DataCadastro DEFAULT GETDATE() NOT NULL,
        
        CONSTRAINT UQ_Usuarios_RfidTag UNIQUE (RfidTag) 
    );
    PRINT 'Tabela [Usuarios] criada com sucesso.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Aparelhos' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Aparelhos (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        TokenDispositivo VARCHAR(100) NOT NULL, 
        Nome VARCHAR(50) NOT NULL,
        LocalInstalacao VARCHAR(100) NOT NULL,  
        Ativo BIT CONSTRAINT DF_Aparelhos_Ativo DEFAULT 1 NOT NULL,
        StatusOnline BIT CONSTRAINT DF_Aparelhos_Online DEFAULT 0 NOT NULL,
        UltimoPing DATETIME NULL,
        IpRede VARCHAR(15) NULL,
        DataCadastro DATETIME CONSTRAINT DF_Aparelhos_DataCadastro DEFAULT GETDATE() NOT NULL,
        
        CONSTRAINT UQ_Aparelhos_Token UNIQUE (TokenDispositivo)
    );
    PRINT 'Tabela [Aparelhos] criada com sucesso.';
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LogsAcesso' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.LogsAcesso (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        RfidTag VARCHAR(50) NOT NULL,
        UsuarioId INT NULL,      
        AparelhoId INT NULL,     
        DistanciaCm DECIMAL(5,2) NOT NULL,
        StatusAcesso VARCHAR(20) NOT NULL,
        DataHora DATETIME CONSTRAINT DF_LogsAcesso_DataHora DEFAULT GETDATE() NOT NULL,
        Motivo VARCHAR(100) NULL,
        
        CONSTRAINT FK_LogsAcesso_Usuarios FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuarios(Id),
        CONSTRAINT FK_LogsAcesso_Aparelhos FOREIGN KEY (AparelhoId) REFERENCES dbo.Aparelhos(Id)
    );

    CREATE NONCLUSTERED INDEX IX_LogsAcesso_RfidTag ON dbo.LogsAcesso(RfidTag);
    
    PRINT 'Tabela [LogsAcesso] criada com sucesso.';
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Usuarios)
BEGIN
    INSERT INTO dbo.Usuarios (Nome, Cargo, RfidTag, Ativo) 
    VALUES 
        ('Diogo Nascimento', 'Desenvolvedor', 'A1B2C3D4', 1),
        ('Carlos Machado', 'DevOps', 'FF3A91C0', 1), 
        ('Miguel Veloso', 'Documentação', 'B377F211', 0);
        
    PRINT 'Usuários de teste inseridos com sucesso.';
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Aparelhos)
BEGIN
    INSERT INTO dbo.Aparelhos (TokenDispositivo, Nome, LocalInstalacao, Ativo, StatusOnline, UltimoPing, IpRede)
    VALUES
        ('ESP32-001', 'Entrada Principal', 'Térreo - Portão A', 1, 1, GETDATE(), '192.168.1.101'),
        ('ESP32-002', 'Lab IoT', '2º Andar - Sala 214', 1, 1, GETDATE(), '192.168.1.102');

    PRINT 'Aparelhos de teste inseridos com sucesso.';
END
GO
