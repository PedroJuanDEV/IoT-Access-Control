IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Usuarios' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Usuarios (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nome VARCHAR(100) NOT NULL,
        RfidTag VARCHAR(50) NOT NULL,
        Ativo BIT CONSTRAINT DF_Usuarios_Ativo DEFAULT 1 NOT NULL,
        DataCadastro DATETIME CONSTRAINT DF_Usuarios_DataCadastro DEFAULT GETDATE() NOT NULL,
        
       
        CONSTRAINT UQ_Usuarios_RfidTag UNIQUE (RfidTag) 
    );
    PRINT 'Tabela [Usuarios] criada com sucesso.';
END
GO


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LogsAcesso' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.LogsAcesso (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        RfidTag VARCHAR(50) NOT NULL,
        UsuarioId INT NULL,
        DistanciaCm DECIMAL(5,2) NOT NULL,
        Autorizado BIT NOT NULL,
        DataHora DATETIME CONSTRAINT DF_LogsAcesso_DataHora DEFAULT GETDATE() NOT NULL,
        Motivo VARCHAR(100) NULL,
        
        
        CONSTRAINT FK_LogsAcesso_Usuarios FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuarios(Id)
    );

   
    CREATE NONCLUSTERED INDEX IX_LogsAcesso_RfidTag ON dbo.LogsAcesso(RfidTag);
    
    PRINT 'Tabela [LogsAcesso] criada com sucesso.';
END
GO


IF NOT EXISTS (SELECT 1 FROM dbo.Usuarios)
BEGIN
    INSERT INTO dbo.Usuarios (Nome, RfidTag, Ativo) 
    VALUES 
        ('Aluno', '29a08159', 1),
        ('Professor', 'd9be345a', 1), 
        ('Visitante Bloqueado', '592375a', 0);
        
    PRINT 'Usuários de teste inseridos com sucesso.';
END
ELSE
BEGIN
    PRINT 'Os usuários já existem no banco de dados. Nenhuma nova inserção foi feita.';
END
GO
