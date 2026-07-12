# 👓 VisionFlow App

> Uma tecnologia assistiva de baixo custo projetada para devolver autonomia, segurança e mobilidade urbana para pessoas com deficiência visual.

![Versão do App](https://img.shields.io/badge/versão-0.2.0--alpha-blueviolet?style=for-the-badge)
![Status do Projeto](https://img.shields.io/badge/status-em%20desenvolvimento-orange?style=for-the-badge)
![Plataforma](https://img.shields.io/badge/plataforma-Android-green?style=for-the-badge)
![Framework](https://img.shields.io/badge/framework-Flutter%20%7C%20Dart-02569B?style=for-the-badge)
![Acessibilidade](https://img.shields.io/badge/acessibilidade-alto%20contraste-yellow?style=for-the-badge)

## 📝 Sobre o Projeto

O **VisionFlow** é um ecossistema inteligente composto por uma armação de óculos física e este aplicativo mobile nativo. O objetivo principal é atuar como os "olhos cognitivos" do usuário, identificando obstáculos e elementos do ambiente urbano em tempo real e transformando essas informações em alertas sonoros discretos via condução óssea.

Este repositório contém exclusivamente o código-fonte do **aplicativo mobile**, desenvolvido em Flutter e Dart, responsável pelo gerenciamento da conexão BLE com o hardware e futuramente pelo processamento de Inteligência Artificial.

## 🔄 Fluxo de Execução em 5 Fases

O aplicativo opera em um ciclo contínuo e otimizado estruturado em cinco etapas fundamentais:

1. **Fase de Setup (Conexão):** Interface de alto contraste e acessível. O app realiza uma varredura Bluetooth Low Energy (BLE) para se conectar automaticamente ao hardware do óculos.
2. **Fase de Captura e Redução:** O celular recebe o fluxo de vídeo sem fio gerado pela *ESP32-CAM* e redimensiona os frames em tempo real para 640×640 pixels, economizando processamento e bateria.
3. **Fase de Inferência (IA):** Um modelo de visão computacional **YOLOv8 nano** roda localmente no smartphone (via TensorFlow Lite) para detectar objetos como pedestres, veículos e obstáculos.
4. **Fase de Filtragem (Cooldown):** Um algoritmo inteligente filtra detecções repetidas em curto espaço de tempo, evitando poluição sonora e fadiga auditiva para o usuário.
5. **Fase de Transmissão:** A inteligência processada é convertida em strings leves e enviada de volta via BLE para o óculos disparar a resposta física.

## 🚀 Histórico de Versões

### `v0.2.0-alpha` — Reformulação Visual e de Acessibilidade *(atual)*

Esta versão representa uma **reformulação completa da interface visual**, com foco exclusivo em acessibilidade (alto contraste, alvos de toque ≥ 56 dp, contraste de cor ≥ 4.5:1) e suporte total a modo claro/escuro.

**Novas funcionalidades:**
- [x] Navegação em **4 abas** (Início, Óculos, Atividades, Perfil) com `BottomNavigationBar` e animações shimmer.
- [x] **HomePage** redesenhada: cabeçalho com gradiente premium, imagem hero dos óculos e grid de funções rápidas acessíveis.
- [x] **ConnectedDevicePage**: painel completo de status do dispositivo conectado com métricas em tempo real (bateria, sinal, memória).
- [x] **ActivitiesPage**: gráfico de atividades semanal (via `fl_chart`) e histórico de detecções.
- [x] **ProfilePage**: configurações de acessibilidade com toggles, controle de volume de alerta e informações do dispositivo.
- [x] Sistema de temas dark/light com paleta de cores de alto contraste (`AppColors`, `AppTheme`, `AppDecorations`).
- [x] Assets visuais dos óculos (`glasses_hero.png`, `glasses_device.png`) integrados.
- [x] `BleRepositoryImpl` convertido para **Singleton** para consistência de estado de conexão.
- [x] `flutter analyze` sem nenhum issue.
- [x] Testes de widget (`flutter test`) com **+2 passed**.

**Pendente:**
- [ ] Integração com modelo YOLOv8 local.
- [ ] Integração com stream de vídeo da ESP32-CAM.
- [ ] Persistência de configurações de usuário (SharedPreferences).
- [ ] Testes de integração BLE em dispositivo físico.

### `v0.1.0-alpha` — Fundação Estrutural *(legado)*

Primeira versão oficial de desenvolvimento, focada em estabelecer as bases estruturais do sistema.

- [x] Estrutura de pastas modular criada no padrão de engenharia (Clean Architecture).
- [x] Configuração inicial das dependências no `pubspec.yaml` (BLE, permissões, acessibilidade).
- [x] Interface visual de alto contraste para acessibilidade.
- [x] Implementação da camada de conexão BLE (scan, conexão, envio de dados).

## 📂 Organização do Código (`lib/`)

O projeto segue a arquitetura **Clean Architecture** com separação de responsabilidades por feature:

```text
lib/
├── main.dart                                        # Ponto de entrada do app
├── app/
│   ├── app.dart                                     # Widget principal (MaterialApp + ThemeCubit)
│   └── theme/
│       ├── app_theme.dart                           # Tema de alto contraste (light/dark)
│       ├── app_colors.dart                          # Paleta de cores central
│       ├── app_decorations.dart                     # Decorações Soft UI (cards, botões)
│       └── theme_cubit.dart                         # Cubit de controle de tema
├── core/
│   ├── constants/
│   │   ├── app_constants.dart                       # Constantes gerais do app
│   │   └── ble_constants.dart                       # UUIDs e configurações BLE
│   ├── mock/
│   │   └── app_mock_data.dart                       # Dados mock para desenvolvimento
│   └── utils/
│       └── logger.dart                              # Sistema de logs estruturado
└── features/
    ├── navigation/                                  # Módulo de navegação principal
    │   └── presentation/
    │       └── pages/
    │           └── main_navigation.dart             # BottomNavigationBar com 4 abas
    ├── home/                                        # Módulo da tela inicial
    │   └── presentation/
    │       └── pages/
    │           └── home_page.dart                   # Dashboard com funções rápidas
    ├── connection/                                  # Módulo de conexão BLE
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── esp32_device.dart                # Entidade de dispositivo
    │   │   ├── repositories/
    │   │   │   └── ble_repository.dart              # Interface do repositório
    │   │   └── usecases/
    │   │       ├── scan_devices.dart                # Caso de uso: scan
    │   │       ├── connect_device.dart              # Caso de uso: conexão
    │   │       └── send_data.dart                   # Caso de uso: envio
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── esp32_device_model.dart          # Modelo de dados
    │   │   └── repositories/
    │   │       └── ble_repository_impl.dart         # Implementação BLE (Singleton)
    │   └── presentation/
    │       ├── pages/
    │       │   ├── connection_page.dart             # Tela de scan e conexão BLE
    │       │   └── connected_device_page.dart       # Painel do dispositivo conectado
    │       └── widgets/
    │           ├── device_card.dart                 # Card de dispositivo descoberto
    │           └── connection_status.dart           # Indicador de status de conexão
    ├── activities/                                  # Módulo de histórico e gráficos
    │   └── presentation/
    │       └── pages/
    │           └── activities_page.dart             # Gráfico semanal e log de detecções
    └── profile/                                     # Módulo de perfil e configurações
        └── presentation/
            └── pages/
                └── profile_page.dart               # Configurações de acessibilidade
```

## 🎨 Design System v0.2.0

A v0.2.0 introduz um sistema de design completo focado em **acessibilidade máxima**:

| Token | Valor | Descrição |
|---|---|---|
| `buttonMinHeight` | `56 dp` | Alvos de toque mínimos (WCAG 2.1 AA) |
| Contraste de cor | `≥ 4.5:1` | Contraste mínimo para texto normal |
| `primaryColor` | `#2E3A46` | Cor principal (modo claro) |
| `darkBackground` | `#0F172A` | Fundo do modo escuro |
| Fonte | **Inter / Outfit** | Google Fonts para legibilidade |
| Sombras | Dupla (highlight + shadow) | Soft UI neumorphism |

---

## 🛠️ Tecnologias Utilizadas

| Pacote | Versão | Finalidade |
|---|---|---|
| `flutter` | ^3.5.0 | Framework principal |
| `flutter_blue_plus` | ^1.32.0 | Comunicação Bluetooth Low Energy |
| `flutter_bloc` | ^8.1.6 | Gerenciamento de estado (Bloc/Cubit) |
| `equatable` | ^2.0.5 | Comparação de objetos de estado |
| `flutter_animate` | ^4.5.0 | Animações declarativas e shimmer |
| `fl_chart` | ^0.69.0 | Gráficos de atividade semanal |
| `google_fonts` | ^6.2.1 | Fontes acessíveis (Inter, Outfit) |
| `flutter_screenutil` | ^5.9.3 | Layouts responsivos |
| `permission_handler` | ^11.3.1 | Permissões de sistema (BLE, localização) |
| `get_it` | ^7.7.0 | Injeção de dependência |
| `shared_preferences` | ^2.3.3 | Persistência local de configurações |
| `logger` | ^2.4.0 | Sistema de logs estruturado |

## 📋 Pré-requisitos

Para executar este projeto, você precisa de:

- **Flutter SDK** ^3.5.0
- **Android Studio** ou **VS Code** com extensão Flutter
- **Dispositivo Android físico** (BLE não funciona em emuladores)
- **ESP32** com firmware carregado (para testes de conexão real)

> ⚠️ O `flutter_blue_plus` requer Android 5.0+ (API 21) e permissão de localização habilitada no dispositivo.

## 🔧 Como Executar

1. **Clone o repositório:**

   ```bash
   git clone https://github.com/evertonrafaelumbelino/visionflow-app.git
   cd visionflow-app/visionflow_app
   ```

2. **Instale as dependências:**

   ```bash
   flutter pub get
   ```

3. **Conecte um dispositivo Android** com depuração USB ativada.

4. **Execute o aplicativo:**

   ```bash
   flutter run
   ```

5. **Para verificar a integridade do código:**

   ```bash
   flutter analyze   # Deve retornar: No issues found!
   flutter test      # Deve retornar: +2 All tests passed!
   ```

## 🧪 Status de Testes

| Teste | Ferramenta | Status |
|---|---|---|
| Análise estática de código | `flutter analyze` | ✅ **No issues found** |
| Smoke test (UI inicializa) | `flutter test` | ✅ **Passed** |
| Navegação entre abas | `flutter test` | ✅ **Passed** |
| Conexão BLE real | Dispositivo físico | ⏳ Pendente |
| Stream de vídeo ESP32-CAM | Dispositivo físico | ⏳ Pendente |
| Inferência YOLOv8 | Dispositivo físico | ⏳ Pendente |
| Transmissão completa (E2E) | Dispositivo físico | ⏳ Pendente |

## 📄 Licença

Este projeto é um trabalho acadêmico desenvolvido no âmbito da Robótica do **Colégio Estadual David Carneiro**, distribuído sob a licença [MIT](LICENSE).

## 👥 Equipe e Contexto Acadêmico

Este projeto está em desenvolvimento para apresentação na **GeniusCon 2026** por uma equipe de robótica do Colégio Estadual David Carneiro (Guapirama - PR). O grupo é composto por quatro estudantes do Ensino Médio e conta com a coordenação e orientação do corpo docente da instituição.

**Estudantes:**
- [Everton Rafael Umbelino dos Santos](https://github.com/evertonrafaelumbelino)
- Karolaine Ribeiro de Brito
- Gabriel Rodrigues Silva de Souza
- Ana Clara do Prado Eggeia

**Professora orientadora:**
- [Ana Crispim de Sousa Castro](https://github.com/AnaCrispim)