# 👓 VisionFlow App

> Uma tecnologia assistiva de baixo custo projetada para devolver autonomia, segurança e mobilidade urbana para pessoas com deficiência visual.

![Versão do App](https://img.shields.io/badge/vers%C3%A3o-0.1.0--alpha-blue?style=for-the-badge)
![Status do Projeto](https://img.shields.io/badge/status-em%20desenvolvimento-orange?style=for-the-badge)
![Plataforma](https://img.shields.io/badge/plataforma-Android-green?style=for-the-badge)
![Framework](https://img.shields.io/badge/framework-Flutter%20%7C%20Dart-02569B?style=for-the-badge)

## 📝 Sobre o Projeto

O **VisionFlow** é um ecossistema inteligente composto por uma armação de óculos física e este aplicativo mobile nativo. O objetivo principal do projeto é atuar como os "olhos cognitivos" do usuário, identificando obstáculos e elementos do ambiente urbano em tempo real e transformando essas informações em alertas sonoros discretos via condução óssea.

Este repositório guarda exclusivamente o código-fonte do **aplicativo mobile**, desenvolvido em Flutter e Dart, responsável pelo processamento de Inteligência Artificial e gerenciamento de dados do ecossistema.

## 🔄 Fluxo de Execução em 5 Fases

O aplicativo opera em um ciclo contínuo e otimizado estruturado em cinco etapas fundamentais:

1. **Fase de Setup (Conexão):** Interface de alto contraste e acessível. O app realiza uma varredura Bluetooth Low Energy (BLE) para se conectar automaticamente ao hardware do óculos.
2. **Fase de Captura e Redução:** O celular recebe o fluxo de vídeo sem fio gerado pela *ESP32-CAM* e redimensiona os frames em tempo real para 640x640 pixels, economizando processamento e bateria.
3. **Fase de Inferência (IA):** Um modelo de visão computacional **YOLOv8 nano** roda localmente no smartphone (via TensorFlow Lite) para detectar objetos como pedestres, veículos e obstáculos calçados.
4. **Fase de Filtragem (Cooldown):** Um algoritmo inteligente filtra detecções repetidas em um curto espaço de tempo, evitando poluição sonora e fadiga auditiva para o usuário.
5. **Fase de Transmissão:** A inteligência processada é convertida em strings leves e enviada de volta via BLE para o óculos disparar a resposta física.

## 🚀 Status da Versão Atual (`v0.1.0-alpha`)

Esta é a primeira versão oficial de desenvolvimento do aplicativo. O foco atual foi estabelecer as bases estruturais do sistema:

* [x] Estrutura de pastas modular criada no padrão de engenharia (Clean Architecture).
* [x] Configuração inicial das dependências no `pubspec.yaml` (BLE, permissões, acessibilidade).
* [x] Interface visual de alto contraste para acessibilidade.
* [x] Implementação da camada de conexão BLE (scan, conexão, envio de dados).
* [ ] Integração com modelo YOLOv8 local.
* [ ] Integração com stream de vídeo da ESP32-CAM.

## 📂 Organização do Código (`lib/`)

O projeto segue a arquitetura **Clean Architecture** com separação de responsabilidades:

```text
lib/
├── main.dart                                    # Ponto de entrada do app
├── app/
│   ├── app.dart                                 # Widget principal (MaterialApp)
│   └── theme/
│       └── app_theme.dart                       # Tema de alto contraste
├── core/
│   ├── constants/
│   │   ├── app_constants.dart                   # Constantes gerais do app
│   │   └── ble_constants.dart                   # UUIDs e configurações BLE
│   └── utils/
│       └── logger.dart                          # Sistema de logs
└── features/
    └── connection/                              # Módulo de conexão BLE
        ├── domain/                              # Camada de domínio
        │   ├── entities/
        │   │   └── esp32_device.dart            # Entidade de dispositivo
        │   ├── repositories/
        │   │   └── ble_repository.dart          # Interface do repositório
        │   └── usecases/
        │       ├── scan_devices.dart            # Caso de uso: scan
        │       ├── connect_device.dart          # Caso de uso: conexão
        │       └── send_data.dart               # Caso de uso: envio
        ├── data/                                # Camada de dados
        │   ├── models/
        │   │   └── esp32_device_model.dart      # Modelo de dados
        │   └── repositories/
        │       └── ble_repository_impl.dart     # Implementação BLE
        └── presentation/                        # Camada de apresentação
            ├── pages/
            │   └── connection_page.dart         # Tela de conexão
            └── widgets/
                ├── device_card.dart             # Card de dispositivo
                └── connection_status.dart        # Indicador de status
```

## 🛠️ Tecnologias Utilizadas

- __Flutter__ ^3.5.0
- __Dart__ ^3.5.0
- __flutter_blue_plus__ ^1.32.0 (Bluetooth Low Energy)
- __flutter_bloc__ ^8.1.6 (Gerenciamento de estado)
- __permission_handler__ ^11.3.1 (Permissões)
- __google_fonts__ ^6.2.1 (Fontes acessíveis)
- __logger__ ^2.4.0 (Logs de debug)

## 📋 Pré-requisitos

Para executar este projeto, você precisa de:

- __Flutter SDK__ ^3.5.0
- __Android Studio__ ou __VS Code__ com extensão Flutter
- __Dispositivo Android físico__ (BLE não funciona em emuladores)
- __ESP32__ com firmware carregado (para testes de conexão)

## 🔧 Como Executar

1. __Clone o repositório:__

   ```bash
   git clone https://github.com/SEU_USUARIO/visionflow.git
   cd visionflow/visionflow_app
   ```

2. __Instale as dependências:__

   ```bash
   flutter pub get
   ```

3. __Conecte um dispositivo Android__ com depuração USB ativada

4. __Execute o aplicativo:__

   ```bash
   flutter run
   ```

## 🧪 Status de Testes

- __Etapa 1 (Conexão BLE):__ ✅ Implementado
- __Etapa 2 (Stream de Vídeo):__ ⏳ Pendente
- __Etapa 3 (Inferência YOLOv8):__ ⏳ Pendente
- __Etapa 4 (Filtro de Cooldown):__ ⏳ Pendente
- __Etapa 5 (Transmissão Completa):__ ⏳ Pendente

## 📄 Licença

Este projeto é um trabalho acadêmico desenvolvido no âmbito da Robótica do **Colégio Estadual David Carneiro**, distribuído sob a licença [MIT](LICENSE). Veja o arquivo para mais detalhes.

## 👥 Equipe e Contexto Acadêmico

Este projeto está em desenvolvimento para apresentação na GeniusCon 2026 por uma equipe de robótica do Colégio Estadual David Carneiro (Guapirama - PR). O grupo é composto por quatro estudantes do Ensino Médio e conta com a coordenação e orientação do corpo docente da instituição.

Estudantes:
- [Everton Rafael Umbelino dos Santos](https://github.com/evertonrafaelumbelino)
- Karolaine Ribeiro de Brito
- Gabriel Rodrigues Silva de Souza
- Ana Clara do Prado Eggeia

Professora orientadora:
- [Ana Crispim de Sousa Castro](https://github.com/AnaCrispim)