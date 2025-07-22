# 🤖 Diagramas del Sistema de Asignación Automática de Tickets

## 📊 Diagrama de Arquitectura General

```mermaid
graph TB
    subgraph "🌐 GLPI System"
        GLPI[GLPI Web Interface]
        TICKETS[Tickets Database]
    end
    
    subgraph "🤖 Sistema de Asignación"
        SELENIUM[Selenium WebDriver]
        CONTROLLER[System Controller]
        DETECTOR[Ticket Detector]
        ASSIGNER[Ticket Assigner]
        INTELLIGENT[Intelligent Assigner]
    end
    
    subgraph "🧠 IA & APIs"
        GEMINI[Gemini AI API]
        WHATSAPP[WhatsApp API]
    end
    
    subgraph "🗄️ Base de Datos"
        DB[(MySQL Database)]
        ASSIGNMENTS[Assignments Table]
        TICKET_LOG[Tickets Log]
        STATS[Statistics]
    end
    
    subgraph "📱 Interfaz de Usuario"
        USER[👤 Usuario/Técnico]
        COMMANDS[Comandos WhatsApp]
        NOTIFICATIONS[Notificaciones]
    end
    
    %% Conexiones principales
    GLPI --> SELENIUM
    SELENIUM --> CONTROLLER
    CONTROLLER --> DETECTOR
    CONTROLLER --> ASSIGNER
    CONTROLLER --> INTELLIGENT
    
    INTELLIGENT --> GEMINI
    ASSIGNER --> GLPI
    
    CONTROLLER --> DB
    DB --> ASSIGNMENTS
    DB --> TICKET_LOG
    DB --> STATS
    
    USER --> COMMANDS
    COMMANDS --> WHATSAPP
    WHATSAPP --> CONTROLLER
    CONTROLLER --> NOTIFICATIONS
    NOTIFICATIONS --> WHATSAPP
    WHATSAPP --> USER
    
    %% Estilos
    classDef glpi fill:#e1f5fe
    classDef system fill:#f3e5f5
    classDef ai fill:#e8f5e8
    classDef db fill:#fff3e0
    classDef ui fill:#fce4ec
    
    class GLPI,TICKETS glpi
    class SELENIUM,CONTROLLER,DETECTOR,ASSIGNER,INTELLIGENT system
    class GEMINI,WHATSAPP ai
    class DB,ASSIGNMENTS,TICKET_LOG,STATS db
    class USER,COMMANDS,NOTIFICATIONS ui
```

## 🔄 Diagrama de Flujo de Asignación Inteligente

```mermaid
flowchart TD
    START([Inicio del Sistema]) --> INIT[Inicializar Componentes]
    INIT --> MONITOR{Monitorear GLPI}
    
    MONITOR --> DETECT[Detectar Nuevos Tickets]
    DETECT --> TICKET_FOUND{Tickets Nuevos?}
    
    TICKET_FOUND -->|No| WAIT[Esperar 30s]
    WAIT --> MONITOR
    
    TICKET_FOUND -->|Sí| AUTO_MODE{Modo Auto IA?}
    
    AUTO_MODE -->|No| ROTATION[Asignación por Rotación]
    AUTO_MODE -->|Sí| AI_ANALYSIS[Análisis con Gemini AI]
    
    AI_ANALYSIS --> GEMINI_API[Llamar Gemini API]
    GEMINI_API --> PROMPT[Crear Prompt de Análisis]
    PROMPT --> CONTENT[Analizar Contenido del Ticket]
    CONTENT --> CRITERIA[Aplicar Criterios de Asignación]
    
    CRITERIA --> N1{N1/Soporte Básico?}
    N1 -->|Sí| ASSIGN_N1[Asignar a Kenyo/Juan Daniel]
    N1 -->|No| NETWORK{Redes/Equipos?}
    
    NETWORK -->|Sí| ASSIGN_NET[Asignar a Luis Alberto]
    NETWORK -->|No| HARDWARE{Hardware/Mantenimiento?}
    
    HARDWARE -->|Sí| ASSIGN_HW[Asignar a Alexander]
    HARDWARE -->|No| ASSIGN_OTHER[Asignar a Jonathan]
    
    ASSIGN_N1 --> SELENIUM_ASSIGN[Asignar via Selenium]
    ASSIGN_NET --> SELENIUM_ASSIGN
    ASSIGN_HW --> SELENIUM_ASSIGN
    ASSIGN_OTHER --> SELENIUM_ASSIGN
    ROTATION --> SELENIUM_ASSIGN
    
    SELENIUM_ASSIGN --> SUCCESS{Asignación Exitosa?}
    SUCCESS -->|No| ERROR[Registrar Error]
    SUCCESS -->|Sí| DB_LOG[Registrar en Base de Datos]
    
    DB_LOG --> NOTIFY[Enviar Notificación WhatsApp]
    NOTIFY --> AI_FLAG{Modo IA Activo?}
    
    AI_FLAG -->|Sí| AI_MSG[Enviar Mensaje con IA]
    AI_FLAG -->|No| NORMAL_MSG[Enviar Mensaje Normal]
    
    AI_MSG --> CONTINUE[Continuar Monitoreo]
    NORMAL_MSG --> CONTINUE
    ERROR --> CONTINUE
    
    CONTINUE --> MONITOR
    
    %% Estilos
    classDef startEnd fill:#ffcdd2
    classDef process fill:#c8e6c9
    classDef decision fill:#fff9c4
    classDef ai fill:#e1bee7
    classDef error fill:#ffcc02
    
    class START startEnd
    class INIT,DETECT,ROTATION,SELENIUM_ASSIGN,DB_LOG,NOTIFY,CONTINUE process
    class TICKET_FOUND,AUTO_MODE,N1,NETWORK,HARDWARE,SUCCESS,AI_FLAG decision
    class AI_ANALYSIS,GEMINI_API,PROMPT,CONTENT,CRITERIA,AI_MSG ai
    class ERROR error
```

## 📱 Diagrama de Comandos WhatsApp

```mermaid
sequenceDiagram
    participant U as 👤 Usuario
    participant W as 📱 WhatsApp API
    participant H as 🔧 WhatsApp Handler
    participant SC as 🎮 System Controller
    participant IA as 🤖 Intelligent Assigner
    participant G as 🧠 Gemini API
    participant DB as 🗄️ Database
    participant S as 🌐 Selenium/GLPI
    
    Note over U,S: Comando /auto on
    U->>W: /auto on
    W->>H: Procesar comando
    H->>SC: Activar modo automático
    SC->>DB: Verificar técnicos activos
    DB-->>SC: Lista de técnicos activos
    
    alt Técnicos activos encontrados
        SC->>S: Inicializar GLPI
        S-->>SC: GLPI iniciado
        SC->>SC: Activar monitoreo
        SC-->>H: Modo automático activado
        H-->>W: Confirmación con IA
        W-->>U: ✅ Modo IA activado
    else No hay técnicos activos
        SC-->>H: Error - No hay técnicos
        H-->>W: Mensaje de error
        W-->>U: ❌ Activar técnicos primero
    end
    
    Note over U,S: Proceso de Asignación IA
    S->>SC: Nuevo ticket detectado
    SC->>IA: Analizar ticket
    IA->>G: Enviar prompt de análisis
    G-->>IA: Recomendación de técnico
    IA-->>SC: Técnico recomendado
    SC->>S: Asignar ticket
    S-->>SC: Asignación exitosa
    SC->>DB: Registrar asignación
    SC->>H: Enviar notificación IA
    H-->>W: Mensaje con IA
    W-->>U: 🎫 Ticket asignado por IA
```

## 🎯 Diagrama de Criterios de Asignación

```mermaid
mindmap
  root((Criterios de Asignación))
    N1
      Problemas básicos
      Consultas generales
      Soporte nivel 1
      Técnicos: Kenyo (26586), Juan Daniel (29298)
    Redes/Equipos
      Configuración de redes
      Switches y routers
      Infraestructura de red
      Asignación de equipos
      Nuevo ingreso
      Cese
      Técnico: Luis Alberto (27401)
    Hardware/Mantenimiento
      Reparación de equipos
      Mantenimiento de equipos
      Problemas de hardware
      Equipamiento
      Técnico: Alexander (24935)
    Otros
      Casos especiales
      Tickets sin categoría
      Misceláneos
      Técnico: Jonathan (12429)
    Fallback
      Rotación simple
      Palabras clave
      Técnico disponible
```

## 🔗 Diagrama de Conexiones de APIs

```mermaid
graph LR
    subgraph "🌐 APIs Externas"
        GEMINI_API[Gemini AI API]
        WHATSAPP_API[WhatsApp API]
        GLPI_API[GLPI Web Interface]
    end
    
    subgraph "🤖 Sistema Local"
        MAIN[Main Application]
        INTELLIGENT[Intelligent Assigner]
        HANDLER[WhatsApp Handler]
        CONTROLLER[System Controller]
        SELENIUM[Selenium WebDriver]
    end
    
    subgraph "🗄️ Almacenamiento"
        MYSQL[(MySQL Database)]
        LOGS[Log Files]
        SCREENSHOTS[Screenshots]
    end
    
    %% Conexiones de APIs
    INTELLIGENT -.->|HTTP POST| GEMINI_API
    GEMINI_API -.->|JSON Response| INTELLIGENT
    
    HANDLER -.->|HTTP POST| WHATSAPP_API
    WHATSAPP_API -.->|Webhook/Response| HANDLER
    
    SELENIUM -.->|Web Automation| GLPI_API
    GLPI_API -.->|HTML Response| SELENIUM
    
    %% Conexiones internas
    MAIN --> INTELLIGENT
    MAIN --> HANDLER
    MAIN --> CONTROLLER
    CONTROLLER --> SELENIUM
    
    %% Conexiones de base de datos
    MAIN --> MYSQL
    CONTROLLER --> MYSQL
    HANDLER --> MYSQL
    
    %% Conexiones de archivos
    SELENIUM --> SCREENSHOTS
    MAIN --> LOGS
    
    %% Estilos
    classDef api fill:#e3f2fd
    classDef system fill:#f3e5f5
    classDef storage fill:#fff3e0
    
    class GEMINI_API,WHATSAPP_API,GLPI_API api
    class MAIN,INTELLIGENT,HANDLER,CONTROLLER,SELENIUM system
    class MYSQL,LOGS,SCREENSHOTS storage
```

## ⚡ Diagrama de Estados del Sistema

```mermaid
stateDiagram-v2
    [*] --> Inactivo
    
    Inactivo --> Inicializando: /start [ID_TECNICO]
    Inicializando --> ConectandoGLPI: Técnico activado
    ConectandoGLPI --> Monitoreando: GLPI conectado
    ConectandoGLPI --> Error: Fallo de conexión
    Error --> Inactivo: Reintentar
    
    Monitoreando --> AsignandoTicket: Ticket detectado
    AsignandoTicket --> AnalizandoIA: Modo IA activo
    AsignandoTicket --> AsignandoRotacion: Modo rotación
    
    AnalizandoIA --> LlamandoGemini: Enviar a Gemini
    LlamandoGemini --> ProcesandoRespuesta: Respuesta recibida
    ProcesandoRespuesta --> AsignandoTecnico: Técnico seleccionado
    
    AsignandoRotacion --> AsignandoTecnico: Técnico por rotación
    AsignandoTecnico --> EnviandoNotificacion: Ticket asignado
    EnviandoNotificacion --> Monitoreando: Notificación enviada
    
    Monitoreando --> Desactivando: /stop [ID_TECNICO]
    Desactivando --> Inactivo: Sistema detenido
    
    Monitoreando --> ModoIA: /auto on
    ModoIA --> Monitoreando: Modo IA activado
    
    ModoIA --> ModoRotacion: /auto off
    ModoRotacion --> Monitoreando: Modo rotación activado
```

## 📊 Diagrama de Flujo de Datos

```mermaid
flowchart TD
    subgraph "📥 Entrada de Datos"
        GLPI_TICKETS[Tickets de GLPI]
        WHATSAPP_CMDS[Comandos WhatsApp]
        GEMINI_RESP[Respuestas Gemini]
    end
    
    subgraph "🔄 Procesamiento"
        TICKET_DETECTOR[Detector de Tickets]
        COMMAND_PROCESSOR[Procesador de Comandos]
        AI_ANALYZER[Analizador IA]
        ASSIGNMENT_LOGIC[Lógica de Asignación]
    end
    
    subgraph "📤 Salida de Datos"
        GLPI_ASSIGNMENTS[Asignaciones en GLPI]
        WHATSAPP_NOTIF[Notificaciones WhatsApp]
        DB_RECORDS[Registros en BD]
        LOG_ENTRIES[Entradas de Log]
    end
    
    subgraph "🗄️ Almacenamiento"
        MYSQL_DB[(MySQL Database)]
        LOG_FILES[Archivos de Log]
        SCREENSHOTS[Capturas de Pantalla]
    end
    
    %% Flujo de datos
    GLPI_TICKETS --> TICKET_DETECTOR
    WHATSAPP_CMDS --> COMMAND_PROCESSOR
    GEMINI_RESP --> AI_ANALYZER
    
    TICKET_DETECTOR --> ASSIGNMENT_LOGIC
    COMMAND_PROCESSOR --> ASSIGNMENT_LOGIC
    AI_ANALYZER --> ASSIGNMENT_LOGIC
    
    ASSIGNMENT_LOGIC --> GLPI_ASSIGNMENTS
    ASSIGNMENT_LOGIC --> WHATSAPP_NOTIF
    ASSIGNMENT_LOGIC --> DB_RECORDS
    ASSIGNMENT_LOGIC --> LOG_ENTRIES
    
    DB_RECORDS --> MYSQL_DB
    LOG_ENTRIES --> LOG_FILES
    GLPI_ASSIGNMENTS --> SCREENSHOTS
    
    %% Estilos
    classDef input fill:#e8f5e8
    classDef process fill:#e3f2fd
    classDef output fill:#fff3e0
    classDef storage fill:#fce4ec
    
    class GLPI_TICKETS,WHATSAPP_CMDS,GEMINI_RESP input
    class TICKET_DETECTOR,COMMAND_PROCESSOR,AI_ANALYZER,ASSIGNMENT_LOGIC process
    class GLPI_ASSIGNMENTS,WHATSAPP_NOTIF,DB_RECORDS,LOG_ENTRIES output
    class MYSQL_DB,LOG_FILES,SCREENSHOTS storage
```

---

## 📋 Resumen de Componentes

### 🔧 **Componentes Principales:**
- **Selenium WebDriver**: Automatización de GLPI
- **WhatsApp API**: Comunicación con usuarios
- **Gemini AI API**: Análisis inteligente de tickets
- **MySQL Database**: Almacenamiento de configuraciones y estadísticas

### 🔄 **Flujos Principales:**
1. **Detección**: Selenium monitorea GLPI cada 30 segundos
2. **Análisis**: Gemini AI analiza contenido del ticket
3. **Asignación**: Sistema asigna basándose en criterios y IA
4. **Notificación**: WhatsApp envía confirmación al usuario
5. **Registro**: Base de datos guarda estadísticas y logs

### 🎯 **Criterios de Asignación:**
- **N1**: Kenyo Alfonso (26586) y Juan Daniel (29298)
- **Redes/Equipos**: Luis Alberto (27401)
- **Hardware/Mantenimiento**: Alexander Antonio (24935)
- **Otros**: Jonathan Deaves (12429) 
