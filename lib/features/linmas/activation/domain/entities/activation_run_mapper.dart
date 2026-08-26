import 'package:akar/features/linmas/activation/data/models/activation_run_model.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_run_entity.dart';

export 'package:akar/features/linmas/activation/domain/entities/activation_run_entity.dart';

extension ActivationRunModelMapper on ActivationRunModel {
  ActivationRunEntity toDomain() {
    return ActivationRunEntity(
      id: id,
      provinceId: provinceId,
      province: province,
      regencyId: regencyId,
      regency: regency,
      districtId: districtId,
      district: district,
      villageId: villageId,
      village: village,
      title: title,
      description: description,
      owner: owner,
      sourcePriority: sourcePriority,
      sourceCategory: sourceCategory,
      sourceApproach: sourceApproach,
      startDate: startDate != null ? DateTime.tryParse(startDate!) : null,
      dueDate: dueDate != null ? DateTime.tryParse(dueDate!) : null,
      completedAt: completedAt != null ? DateTime.tryParse(completedAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      status: status,
      progressPct: progressPct,
      targetParticipants: targetParticipants,
      targetQuota: targetQuota,
      participantsCount: participantsCount,
      budget: budget,
      budgetPlan: budgetPlan,
      notes: notes,
      daysUntilDue: daysUntilDue,
      isOverdue: isOverdue,
      isWarning: isWarning,
      isActive: isActive,
      warningLevel: warningLevel,
    );
  }
}

extension ActivationRunEntityMapper on ActivationRunEntity {
  ActivationActivity toActivity() {
    final catStr = (sourceCategory ?? '').toLowerCase();
    ActivationCategory category = ActivationCategory.keamananDanSosial;
    if (catStr.contains('pemasangan') || catStr.contains('apk')) {
      category = ActivationCategory.pemasanganApk;
    } else if (catStr.contains('door')) {
      category = ActivationCategory.doorToDoor;
    } else if (catStr.contains('lingkungan')) {
      category = ActivationCategory.lingkungan;
    } else if (catStr.contains('bencana')) {
      category = ActivationCategory.bencanaAlam;
    }

    final stStr = (status ?? '').toLowerCase();
    ActivationStatus actStatus = ActivationStatus.sedangBerjalan;
    if (stStr == 'completed' || stStr == 'selesai') {
      actStatus = ActivationStatus.selesai;
    } else if (stStr == 'cancelled' || stStr == 'dibatalkan') {
      actStatus = ActivationStatus.dibatalkan;
    } else if (stStr == 'scheduled' || stStr == 'terjadwal') {
      actStatus = ActivationStatus.terjadwal;
    }

    final locParts = <String>[];
    if (village != null && village!.isNotEmpty) locParts.add(village!);
    if (district != null && district!.isNotEmpty) locParts.add(district!);
    final locationName = locParts.isNotEmpty ? locParts.join(', ') : 'Wilayah';

    final fullAddrParts = <String>[];
    if (village != null && village!.isNotEmpty) fullAddrParts.add(village!);
    if (district != null && district!.isNotEmpty) fullAddrParts.add(district!);
    if (regency != null && regency!.isNotEmpty) fullAddrParts.add(regency!);
    if (province != null && province!.isNotEmpty) fullAddrParts.add(province!);
    final fullAddress = fullAddrParts.isNotEmpty
        ? fullAddrParts.join(', ')
        : 'Alamat Penugasan';

    final total = targetQuota ?? 1;
    final pct = (progressPct / 100.0).clamp(0.0, 1.0);
    final completed = (pct * total).round();

    return ActivationActivity(
      id: id.toString(),
      title: title,
      category: category,
      location: locationName,
      address: fullAddress,
      ownerName: owner ?? 'Penanggung Jawab',
      status: actStatus,
      startDate: startDate ?? DateTime.now(),
      endDate: dueDate ?? DateTime.now().add(const Duration(days: 7)),
      completedSteps: completed,
      totalSteps: total,
      description: description,
      notes: notes,
    );
  }
}
