import 'dart:convert';
import 'dart:io';

import 'package:akar/features/linmas/activation/data/models/pending_activation_report_model.dart';
import 'package:path_provider/path_provider.dart';

/// Laporan gagal terkirim. Berkas disalin ke folder aplikasi agar tidak dihapus OS.
class ActivationPendingReportLocalDatasource {
  ActivationPendingReportLocalDatasource({
    Future<Directory> Function()? rootDirectory,
  }) : _rootDirectory = rootDirectory ?? getApplicationSupportDirectory;

  static const String _folderName = 'pending_activation_reports';
  static const String _indexName = 'index.json';

  final Future<Directory> Function() _rootDirectory;

  Future<List<PendingActivationReportModel>> getPending() async {
    final all = await _read();
    final valid = <PendingActivationReportModel>[];
    for (final report in all) {
      final intact =
          report.attachmentPaths.isNotEmpty &&
          report.attachmentPaths.every((path) => File(path).existsSync());
      if (intact) {
        valid.add(report);
      } else {
        await _deleteFolder(report.id);
      }
    }
    if (valid.length != all.length) {
      await _write(valid);
    }
    return valid;
  }

  Future<PendingActivationReportModel> enqueue({
    required String userId,
    required String participantId,
    required String activityTitle,
    required List<File> attachments,
    String? notes,
    String? receiverNik,
    String? receiverName,
  }) async {
    final dir = await _dir();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final reportDir = Directory('${dir.path}/$id');
    await reportDir.create(recursive: true);

    final attachmentPaths = <String>[];
    for (var i = 0; i < attachments.length; i++) {
      final source = attachments[i];
      final target = File(
        '${reportDir.path}/${i}_${source.path.split('/').last}',
      );
      await source.copy(target.path);
      attachmentPaths.add(target.path);
    }

    final report = PendingActivationReportModel(
      id: id,
      userId: userId,
      participantId: participantId,
      activityTitle: activityTitle,
      attachmentPaths: attachmentPaths,
      createdAt: DateTime.now(),
      notes: notes,
      receiverNik: receiverNik,
      receiverName: receiverName,
    );

    final reports = await _read();
    reports.add(report);
    await _write(reports);
    return report;
  }

  Future<void> remove(String id) async {
    await _deleteFolder(id);
    final reports = await _read();
    reports.removeWhere((report) => report.id == id);
    await _write(reports);
  }

  Future<void> _deleteFolder(String id) async {
    final dir = Directory('${(await _dir()).path}/$id');
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  }

  Future<void> markError(String id, String message) async {
    final reports = await _read();
    final index = reports.indexWhere((report) => report.id == id);
    if (index == -1) return;
    reports[index] = reports[index].copyWith(lastError: message);
    await _write(reports);
  }

  Future<List<PendingActivationReportModel>> _read() async {
    final indexFile = File('${(await _dir()).path}/$_indexName');
    if (!indexFile.existsSync()) return [];
    try {
      final decoded = jsonDecode(await indexFile.readAsString());
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map(
            (json) => PendingActivationReportModel.fromJson(
              Map<String, dynamic>.from(json),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _write(List<PendingActivationReportModel> reports) async {
    final indexFile = File('${(await _dir()).path}/$_indexName');
    await indexFile.writeAsString(
      jsonEncode(reports.map((report) => report.toJson()).toList()),
    );
  }

  Future<Directory> _dir() async {
    final base = await _rootDirectory();
    final dir = Directory('${base.path}/$_folderName');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}
