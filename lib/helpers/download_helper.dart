import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:open_file_safe/open_file_safe.dart';
import 'package:bikesharemobile/data/provider/api.dart';
import 'package:permission_handler/permission_handler.dart';

class DonwloadHelper {
  _requestPermissions() async {
    if (await Permission.storage.request().isGranted) return true;
    return false;
  }

  download(String endPoint, String opcao, String nomeFicheiro) async {
    final isPermissionStatusGranted = await _requestPermissions();
    if (isPermissionStatusGranted) {
      nomeFicheiro = nomeFicheiro.replaceAll(' ', '').replaceAll('/', '-');
      final Directory directory = await getApplicationSupportDirectory();
      final savePath = path.join(directory.path, nomeFicheiro + '.pdf');
      await _startDownload(savePath, endPoint, opcao);
    } else {}
  }

  _startDownload(String savePath, String endPoint, String opcao) async {
    try {
      var ficheiro = await API().getData(endPoint);
      // print(ficheiro.body);
      if (ficheiro.statusCode == 200) {
        File file = File(savePath);
        await file.writeAsBytes(ficheiro.bodyBytes, flush: true);
        if (opcao == 'baixar')
          OpenFile.open(file.path);
        else
          Share.shareFiles([file.path]);

        Get.snackbar('Sucesso', 'Ficheiro descarregado com sucesso.',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar(
            'Atenção...', 'Houve um erro ao descarregar este ficheiro.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (ex) {
      //// printex);
    }
  }
}
