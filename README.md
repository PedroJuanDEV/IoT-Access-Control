# Sistema de Controle de Acesso IoT 🚪

Este repositório contém a estrutura de banco de dados e a documentação inicial para um sistema de controle de acesso inteligente utilizando Internet das Coisas (IoT). 

O projeto divide as responsabilidades em camadas: coleta de dados via hardware na ponta (Edge) e armazenamento relacional estruturado, preparado para integração com uma futura API RESTful (como C# / ASP.NET Core).

##  Hardware Utilizado
* **Microcontrolador:** ESP32-C3 Supermini (Cliente Wi-Fi HTTP)
* **Leitor RFID:** MFRC522 (Identificação via tags/cartões)
* **Sensor Ultrassônico:** (Detecção de proximidade para garantir que o usuário está em frente à porta)

##  Estrutura do Banco de Dados
O banco de dados foi modelado em **SQL Server**, focando em integridade, performance e boas práticas de mercado. Ele é composto por duas tabelas principais:

* `Usuarios`: Armazena os cadastros das pessoas e o código hexadecimal único de suas tags RFID.
* `LogsAcesso`: Tabela de auditoria que registra todas as tentativas de acesso, vinculando a tag lida, a distância aferida pelo sensor no momento, a data/hora e o status de autorização (Permitido/Negado).

**Destaques da Arquitetura Relacional:**
* Verificações de idempotência (`IF NOT EXISTS`) para rodar o script de forma segura múltiplas vezes.
* Chaves primárias, estrangeiras e restrições `UNIQUE` para garantir a integridade dos dados e evitar cartões duplicados.
* Índices não-clusterizados (`NONCLUSTERED INDEX`) otimizados para buscas rápidas de histórico.
* Carga inicial de dados (*Seed Data*) com cenários de teste pré-configurados para facilitar o desenvolvimento e os testes do back-end.

.

