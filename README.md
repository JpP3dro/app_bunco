# Bunco

**Bunco - A lógica por trás das grandes ideias**  

> Um aplicativo para ensinar Python de forma simples, rápida e prática.

## Índice

- [Sobre](#sobre)  
- [Funcionalidades](#funcionalidades)  
- [Tecnologias Utilizadas](#tecnologias-utilizadas)  
- [Instalação e Início](#instalação-e-início)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Autores](#autores)

## Sobre

Meu nome é João Pedro, e esse é o aplicativo do meu TCC para a obtenção do título em técnico em Desenvolvimento de Sistemas na ETEC de Mauá. Esse projeto foi feito em conjunto com meus colegas de curso e amigos: Gabriel Linhares (responsável pela prototipagem do design) e Matheus Cordeiro (responsável pelo site, que está em outro repositório).  
O Bunco surgiu da soma entre querer fazer um produto voltado a educação, o nosso conhecimento de tecnologia e a didática do Duolingo, e assim, surgiu um aplicativo que ensina Python de forma interativa.  
O aplicativo para Android e o site está disponível no [nosso site](https://bunco.alwaysdata.net)!

## Funcionalidades

As principais funcionalidades do aplicativo são:

- Login e cadastro.
- Exibição de módulos, mostrando se ele está completo, bloqueado ou em progresso.
- Ranking com a ordem de usuários com mais XP.  
- Terminal de Python interativo, por meio de API.
- Perfil com opção de trocar foto de perfil e cor de fundo.
- Configurações
- Aulas de diversos tipos, como teórica e prática.

## Tecnologias Utilizadas

- Flutter
- Dart  
- PHP

## Instalação e início

Antes de começar, certifique-se de ter instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) (já vem com o Flutter)
- [Android Studio](https://developer.android.com/studio) **ou** [Visual Studio Code](https://code.visualstudio.com/) com o plugin Flutter
- Um **emulador Android/iOS** ou um **dispositivo físico** conectado via USB

Para verificar se o ambiente está pronto, rode o comando abaixo no terminal:

```bash
flutter doctor
```

Em seguida, clone o repositório do projeto executando o comando `git clone https://github.com/BuncoTCC/app_bunco.git`. Depois que o repositório for clonado, acesse a pasta do projeto usando o comando `cd app_bunco`.

Com o projeto aberto, instale as dependências necessárias executando `flutter pub get`. Esse comando irá baixar todas as bibliotecas e pacotes definidos no arquivo `pubspec.yaml`, garantindo que o projeto possa ser compilado corretamente.

Após isso, você já pode rodar o aplicativo. Para executá-lo em modo de desenvolvimento (debug), use o comando `flutter run`. Caso tenha mais de um dispositivo conectado, é possível escolher o destino, como por exemplo, `flutter run -d chrome` para rodar no navegador ou `flutter run -d emulator-5554` para abrir em um emulador Android.

Se desejar gerar o arquivo APK para testar o aplicativo diretamente em um celular sem usar o emulador, basta rodar o comando `flutter build apk --release`. Quando o processo for concluído, o APK gerado estará localizado na pasta `build/app/outputs/flutter-apk/app-release.apk`. Esse arquivo pode ser transferido para um dispositivo Android e instalado manualmente.

Seguindo essas etapas, o projeto estará pronto para ser executado, testado e modificado conforme necessário, garantindo um ambiente de desenvolvimento funcional e organizado.

## Estrutura do Projeto

```bash

lib/
├─ main.dart # Ponto de entrada do aplicativo
│
├─ screens/ # Telas principais da aplicação
│   ├─ alteraremail.dart 
│   ├─ alterarlinks.dart 
│   ├─ alterarnome.dart 
│   ├─ alterarsenha.dart 
│   ├─ alterarusername.dart 
│   ├─ aula.dart 
│   ├─ cadastro.dart 
│   ├─ configuracoes.dart 
│   ├─ curso.dart 
│   ├─ login.dart 
│   ├─ meuperfil.dart 
│   ├─ modulo.dart 
│   ├─ outroperfil.dart 
│   ├─ ranking.dart 
│   ├─ telainicial.dart 
│   └─ terminal.dart
├─ uteis/ # Aplicações utéis para o funcionamento do app
│   ├─ alterar_url.dart
│   ├─ controle_login.dart
│   ├─ dialogo.dart
│   ├─ escolhercor.dart
│   ├─ escolherfoto.dart
│   ├─ popup_vidas.dart
│   ├─ tipo_dialogo.dart
│   └─ url.dart
```

## Autores

- João Pedro - mobile e APIs - [JpP3dro](https://github.com/JpP3dro)
- Matheus Cordeiro - site - [Matheus](https://github.com/CordeiroMatheus)
- Gabriel Linhares - design e prototipação - [Gabriel](https://github.com/Linhares-Gab)
