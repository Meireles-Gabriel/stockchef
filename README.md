# StockChef

**Gerenciamento de Estoque de Restaurantes**

Este aplicativo é uma solução completa para o gerenciamento de estoque, vendas e preparações de ingredientes em restaurantes. Desenvolvido com Flutter, oferece uma interface intuitiva e recursos robustos para otimizar a operação de negócios de alimentos.

## Funcionalidades

*   **Controle de Estoque**: Adicione, edite e monitore seus ingredientes com facilidade.
*   **Preparações de Ingredientes**: Crie e gerencie receitas e preparações, facilitando o controle de insumos.
*   **Relatórios Detalhados**: Visualize gráficos e relatórios para uma análise aprofundada do seu negócio.
*   **Autenticação de Usuário**: Login seguro com Firebase.
*   **Integração de Pagamentos**: Suporte a pagamentos via Stripe.

## Tecnologias Utilizadas

*   **Flutter**: Framework UI para construção de aplicativos móveis, web e desktop a partir de um único código-base.
*   **Firebase**: Plataforma de desenvolvimento de aplicativos do Google, utilizada para autenticação (Firebase Auth) e banco de dados (Cloud Firestore).
*   **Stripe**: Plataforma de processamento de pagamentos.
*   **Riverpod**: Gerenciamento de estado reativo e eficiente.
*   **`google_fonts`**: Para tipografia personalizada.
*   **`animate_do`**: Para animações no UI.
*   **`smooth_page_indicator`**: Para indicadores de página em introduções.
*   **`shared_preferences`**: Para persistência de dados simples.
*   **`http`**: Para requisições HTTP.
*   **`pdf` e `printing`**: Para geração e impressão de relatórios em PDF.
*   **`url_launcher`**: Para abrir URLs externas.
*   **`flutter_launcher_icons` e `flutter_native_splash`**: Para customização de ícones e tela de splash.
*   **`flutter_hooks`**: Para usar Hooks no Flutter.
*   **`syncfusion_flutter_charts`**: Para gráficos e visualização de dados.

## Instalação

Para configurar o projeto localmente, siga os passos abaixo:

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/seu-usuario/stockchef.git
    cd stockchef
    ```

2.  **Obtenha as dependências:**
    ```bash
    flutter pub get
    ```

3.  **Configuração do Firebase:**
    *   Crie um projeto no Firebase Console.
    *   Adicione um aplicativo Android e iOS ao seu projeto Firebase.
    *   Baixe os arquivos de configuração (`google-services.json` para Android e `GoogleService-Info.plist` para iOS) e coloque-os nos diretórios apropriados (`android/app/` e `ios/Runner/` respectivamente).
    *   Certifique-se de ter o Firebase CLI instalado e faça login:
        ```bash
        firebase login
        ```
    *   Associe seu projeto local ao projeto Firebase:
        ```bash
        firebase use --add SEU_PROJETO_FIREBASE
        ```

4.  **Configuração do Stripe:**
    *   Crie uma conta no Stripe e obtenha suas chaves API públicas e secretas.
    *   Adicione suas chaves Stripe ao seu projeto (geralmente em variáveis de ambiente ou em um arquivo de configuração seguro).

5.  **Rodar o aplicativo:**
    ```bash
    flutter run
    ```

## Uso

Após a instalação, você pode usar o aplicativo para:

*   Registrar novos usuários e fazer login.
*   Adicionar, remover e atualizar itens de estoque.
*   Gerenciar preparações e receitas.
*   Registrar vendas e visualizar relatórios.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.

## Licença

Este projeto está licenciado sob a licença MIT.
