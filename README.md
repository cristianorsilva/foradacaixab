# foradacaixab

Projeto com Integration Testing

Fora da Caixa é um app desenvolvido para auxiliar no treinamento de Analistas de testes;
O app simula um aplicativo bancário com algumas funcionalidades 'implementadas';
Os dados são salvos localmente numa base de dados, e toda vez que o app é removido a base é removida também;
Projeto roda em Android e iOS;
Projeto não possui Integration Testing nessa versão;


## Comandos para verificar versões

    detalhes gerais: flutter doctor -v
    verificar versão do flutter: flutter --version
    local de instalação do flutter: where flutter 
    verificar versão do dart: dart --version
    local de instalação do dart: where dart

## Getting Started

    Users para logar:
        CPF: 929.035.400-39
        CPF: 050.209.090-17
        CPF: 971.147.000-40

    Users para transferir pix: 
        Os mesmos acima. 
        Dica 1: cadastre chaves pix para os usuários e use elas;
        Dica 2: os CPFs em si já estão cadastrados como chave pix por default;
    
    Senha para logar com os users: 
        172839
    Token válido para cadastrar chave pix: 
        123456 (qualquer outro é considerado inválido)    
    Pin válido: 
        1234

## O que esse app faz?

    App simula um aplicativo financeiro, com as seguintes funcionalidades:
        Login:
            Valida usuários válidos e inválidos e informa ao usuário;
            Durante o primeiro login solicita ao usuário permissão de Localização;
        Transferência pix:
            Processo completo de transferência com debito em conta;
            Agendamento de transferência pix;
            Comprovante de transferência pix;
        Cadastro de alguns tipos de chaves pix:
            Algumas chaves podem ser cadastradas, outra não;
        Histórico de transferências e recebimentos:
            Ao tocar no saldo do usuário é possível visualizar o histórico;
        Diversos bugs e pontos de melhorias:
            Este é um app de treinamento para QAs, nada melhor que alguns bugs para cadastrar :)


## Para gerar apk de debug

    flutter build apk --debug

## Para rodar o projeto em modo release (útil quando rodar em device físico iOS)

    flutter run --release

## Integration Testing (configurações úteis para rodar a automação)

    Fontes abaixo mostram as configurações necessárias: 
        https://docs.flutter.dev/testing/integration-tests
        https://docs.flutter.dev/cookbook/testing/integration/introduction
        https://github.com/flutter/flutter/tree/main/packages/integration_test#integration_test
        
    Antes de tudo, é preciso criar os diretórios 'integration_test e 'test_driver'
    Em 'test_driver' criar o arquivo integration_test.dart
    Em 'integration_test' criar o diretório 'screens'
        No diretório 'screens' haverão arquivos estilo 'page_object' (todos com sufixo _screen)
    Em 'integration_test criar o diretório 'tests'
        No diretório 'tests' haverão arquivos de testes propriamente ditos

    login_test.dart é o modo mais simples de montar testes (sem coleta de evidências)
    login_test.dart não tem tratamento para a tela nativa de solicitação de localização (causando a falha do teste)
    login_test.dart necessita que o arquivo integration_test.dart tenha somente as linhas de código abaixo:
        import 'package:integration_test/integration_test_driver.dart';
        Future<void> main() => integrationDriver();

    pix_test.dart é mais complexo pois tem coleta de prints e evidências
    pix_test.dart utiliza os arquivos do diretório 'integration_test\share'
    evidências do pix_test.dart não conseguem capturar telas nativas (solicitação de localização)
    pix_test.dart não tem tratamento para a tela nativa de solicitação de localização (causando a falha do teste)

# Desabilitando a solicitação de Localização (útil para testar automação)
    
    Basta comentar o trecho de código abaixo na classe lib/presenters/login_not_remembered_view.dart:
        No método _elevatedButtonLogin, comentar a chamada ao método (linha 179 - await _requestLocationPermission();)

## Firebase TestLab (Configurações Android)

    Necessita que o app Android tenha o 'instrumentation test' habilitado/configurado
        sessão 'Android Device Testing' explica: https://github.com/flutter/flutter/tree/main/packages/integration_test
        É preciso criar um arquivo no diretório android/app/src/androidTest/java/com/example/myapp/
        Nesse projeto o diretório será android/app/src/androidTest/java/ + o applicationId que consta no arquivo build.gradle
            Juntando os dois tem-se: android/app/src/androidTest/java/b/foradacaixa/foradacaixab
            Dentro desse diretório cria-se o arquivo MainActivityTest.java (vide sessão 'Android Device Testing' citada anteriormente)
            Ajustar a linha de código do package para 'package b.foradacaixa.foradacaixab;'
        É preciso ajustar o arquivo myapp/android/app/build.gradle onde algumas linhas de código são adicionadas;
    Para testar se a configuração acima do 'instrumentation test' está correta, basta executar o comando abaixo:
        Ele deve apontar para 'login_test.dart' e selecionar um device ou emulador Android;
        O terminal a ser executado deve partir da raiz do diretório android
        ./gradlew app:connectedAndroidTest -Ptarget=`pwd`/../integration_test/tests/login_test.dart
    Se rodar os testes do arquivo 'login_test.dart' então está tudo correto
    Dica: após rodar os comandos acima, um relatório é gerado no caminho '/build/app/reports/androidTests/connected/index.html'

    Arquivo 'android_integration.sh' é o responsável por criar os executáveis que serão colocados no Firebase para rodar os testes
        Dentro do arquivo é definido qual arquivo de teste será executado
        O comando para executar é ./android_integration.sh e ao final irá gerar apks no diretórios abaixo:
            /build/app/outputs/apk/androidTest/debug
            /build/app/outputs/apk/debug
        Em caso de erro de permissão de arquivo .sh, basta executar o comando abaixo antes para dar permissão:
            chmod +x android_integration.sh

## Firebase TestLab (Subindo os apks para testar Android)

    Acesse e logue em https://console.firebase.google.com/ com uma conta google.
    Adicione um novo projeto e acesso o item de menu Test Lab e clique no botão 'Executar um teste'
    Selecione a opção 'Instrumentação' Suba os 2 apks nos locais correspondentes
    Selecione o device desejado e confirme
    Inicie o teste e aguarde o resultado

## Integrando Testlab e Google Cloud (Para testar Android)

    Acesse e faça cadastro em https://cloud.google.com/
    Acesse Console e em seguida Cloud Storage
    É preciso configurar o gcloud CLI na máquina, para isso acesse https://cloud.google.com/sdk/docs/install
    Abaixo alguns comandos úteis:
        Para visualizar a versão instalada: gcloud -v
        Para visualizar todos os devices android disponíveis no gcloud: gcloud firebase test android models list 
    É preciso estar com o gcloud CLI corretamente configurado na máquina para poder prosseguir
    Para utilizar o Firebase Test Lab e o Cloud Storage integrados, utilize o arquivo android_integration_gcloud.sh
    Antes de executar o arquivo, é preciso configurá-lo para apontar para seu bucket, além de informar o device desejado
    O comando para executar no terminal é ./android_integration_gcloud.sh
    Em caso de erro de permissão de arquivo .sh, basta executar o comando abaixo antes para dar permissão:
            chmod +x android_integration_gcloud.sh
    Se nenhum erro ocorrer:
        apks serão gerados e subidos automaticamente no firebase test lab
        os testes desse apk serão executados
        o resultado da execução do teste será visível no bucket informado no arquivo bem como no terminal

## Firebase TestLab (Configurações iOS - requer plataforma macOS)
    
    Necessita que o app iOS seja configurado para executar os testes.
        sessão 'iOS Device Testing' explica: https://github.com/flutter/flutter/tree/main/packages/integration_test
    No diretório /ios do projeto tem o arquivo 'Runner.xcworkspace'. 
    Esse arquivo 'Runner.xcworkspace' precisa ser aberto no Xcode
    No Xcode, com o arquivo 'Runner.xcworkspace' aberto, fazer os seguintes ajustes:
        Adicionar o arquivo do tipo Unit Testing Bundle conforme solicitado na sessão 'iOS Device Testing'
        Adicionar no ios/Podfile o trecho de código necessário conforme solicitado na sessão 'iOS Device Testing'
    No Android Studio:
        Execute o comando flutter build ios --config-only integration_test/tests/login_test.dart
    No Xcode:
        Adicionar o arquivo RunnerTests.m com o código necessário conforme solicitado na sessão 'iOS Device Testing'
        Acessar menu Product > Test e aguardar a execução (deve rodar os casos de teste no device iOS selecionado)

    Arquivo 'ios_integration.sh' é o responsável por criar os executáveis que serão colocados no Firebase para rodar os testes
        Dentro do arquivo é definido qual arquivo de teste será executado
        O comando para executar é ./ios_integration.sh (device físico) ou ./ios_integration_sim.sh (simulador)
            (pode dar erro de sign in - basta abrir no Xcode o projeto e setar o Signing)
            Atenção ao dev_target informado nos arquivos (deve ser uma versão iOS presente no mac que está rodando o comando)
    Em caso de erro de permissão de arquivo .sh, basta executar o comando abaixo antes para dar permissão:
        chmod +x ios_integration.sh
        chmod +x ios_integration_sim.sh
    Após a execução dos comandos acima com sucesso (é preciso escolher um dos .sh):
        Acesse o diretório build/ios_integ/Build/Products e copie o .zip (é esse .zip que será subido no Test Lab)


## Firebase TestLab (Subindo o .zip para testar iOS)

    Acesse e logue em https://console.firebase.google.com/ com uma conta google.
    Adicione um novo projeto e acesso o item de menu Test Lab e clique no botão 'Executar um teste'
    Selecione a opção 'XCTest' Suba o .zip e selecione a versão do Xcode correspondente (deve ser a mesma instalada no mac)
    Selecione o device desejado e confirme
    Inicie o teste e aguarde o resultado 


## Integrando Testlab e Google Cloud (Para testar iOS)

    TestLab possui somente devices físicos, então o foco será mostrar as configurações de .sh para device físico
    Executar o comando ./ios_integration_gcloud.sh
    Em caso de erro de permissão de arquivo .sh, basta executar o comando abaixo antes para dar permissão:
            chmod +x ios_integration_gcloud.sh
    Se nenhum erro ocorrer:
        .zip será gerado e subido automaticamente no firebase test lab
        os testes desse .zip serão executados
        o resultado da execução do teste será visível no bucket informado no arquivo bem como no terminal

