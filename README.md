# KeyPod &mdash; Simple Key Value Store

KeyPod is a simple key value data store app to serve as a template and
to demonstrate a [Flutter](https://flutter.dev) app utilising data
stored in [Solid Pods](https://solidcommunity.au).

The app is a simple tool for displaying a table of pairs of keys and
values.  You can add new pairs, edit the pairs, and delete the pairs,
and have the changes saved to your Solid Pod.

On starting the app you will be presented with the
[solidpod](https://pub.dev/packages/solidpod) login screen (using
`SolidLogin()` from solidpod).

<div align="center">
	<img
	src="https://raw.githubusercontent.com/anusii/solidpod/dev/images/keypod_login.png"
	alt="KeyPod Login" width="600">
</div>

Here you have the option to **Login** to your Solid Pod before you use
the functionality of the app. Alternatively you can **Continue** to
the app without a log in. Many apps will provide some functionality
without access to your actual data, and when access is needed the app
can call `solidLoginPopup()` from the `solidpod` package to login in
to your solid pod.

If you don't have a Solid Pod yet then you can **Register** for one
on a Solid server. The **Info** button can be tapped to browse
more information about the app.

## Getting Started with Flutter

This project is a starting point for a Flutter application utilising
Solid Pods.

A few resources to get you started if this is your first Flutter
project using Solid Pods:

- [Lab: Write your first Flutter
  app](https://docs.flutter.dev/get-started/codelab)

- [Cookbook: Useful Flutter
  samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online
documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Acknowledgements

Images were generated using Bing Image Creator from Designer, powered
by DALL-E3.

The app was developed by the Software Innovation Institute of the
Australian National University.

Authors: Graham Williams, Anushka Vidanage, Jess Moore, Zheyuan Xu,
Kevin Wang, Ninad Bhat, Dawei Chen.
