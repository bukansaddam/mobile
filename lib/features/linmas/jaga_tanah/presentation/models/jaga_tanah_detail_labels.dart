import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_detail_entity.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_report_entity.dart';
import 'package:intl/intl.dart';

/// Helper label, format waktu, dan konversi fallback tampilan Detail Jaga Tanah.
class JagaTanahDetailLabels {
  JagaTanahDetailLabels._();

  static const Map<String, String> _statusLabels = {
    'submitted': 'Diajukan',
    'verification_assigned': 'Verifikasi Ditugaskan',
    'verified': 'Terverifikasi',
    'mediation': 'Mediasi',
    'fifty_fifty': 'Mediasi 50:50',
    'bpn_forwarded': 'Diteruskan ke BPN',
    'completed': 'Selesai',
    'rejected': 'Ditolak',
  };

  static const Map<String, String> _verificationMethodLabels = {
    'contacted_reporter': 'Hubungi Pelapor',
    'field_check': 'Cek Lapangan',
    'both': 'Hubungi Pelapor & Cek Lapangan',
  };

  static const Map<String, String> _followUpLabels = {
    'mediation': 'Mediasi',
    'fifty_fifty': 'Mediasi 50:50',
    'bpn': 'Diteruskan ke BPN',
  };

  static const Map<String, String> _bpnActionLabels = {
    'cek_status_hak': 'Cek Status Hak',
    'pencabutan_hak': 'Pencabutan Hak',
    'langkah_hukum_perdata': 'Langkah Hukum Perdata',
    'langkah_hukum_pidana': 'Langkah Hukum Pidana',
    'lainnya': 'Lainnya',
  };

  static const Map<String, String> _bpnFeedbackStatusLabels = {
    'in_review': 'Dalam Penelaahan',
    'certificate_checked': 'Sertifikat / Hak Dicek',
    'revocation_process': 'Proses Pencabutan Hak',
    'legal_action_civil': 'Proses Hukum Perdata',
    'legal_action_criminal': 'Proses Hukum Pidana',
    'resolved': 'Selesai Ditindaklanjuti',
  };

  static String resolveStatusLabel(String status, String serverLabel) {
    final trimmedServer = serverLabel.trim();
    if (trimmedServer.isNotEmpty) return trimmedServer;
    final normalized = status.trim().toLowerCase();
    return _statusLabels[normalized] ??
        complaintStatusFromCode(normalized).label;
  }

  static String translateVerificationMethod(String? raw) =>
      _translate(raw, _verificationMethodLabels);

  static String translateFollowUpDecision(String? raw) =>
      _translate(raw, _followUpLabels);

  static String translateBpnAction(String? raw) =>
      _translate(raw, _bpnActionLabels);

  static String translateBpnFeedbackStatus(String? raw) =>
      _translate(raw, _bpnFeedbackStatusLabels);

  static String _translate(String? raw, Map<String, String> lookup) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return '-';
    return lookup[text.toLowerCase()] ?? text;
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    try {
      return '${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dateTime)} WIB';
    } catch (_) {
      return '${DateFormat('dd MMM yyyy, HH:mm').format(dateTime)} WIB';
    }
  }

  static String formatDate(DateTime dateTime) {
    try {
      return DateFormat('dd MMM yyyy', 'id_ID').format(dateTime);
    } catch (_) {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }

  static String formatTime(DateTime dateTime) =>
      '${DateFormat('HH:mm').format(dateTime)} WIB';

  static JagaTanahDetailEntity fromComplaintItem(ComplaintItem item) {
    return JagaTanahDetailEntity(
      id: item.reportId ?? '',
      ticketNumber: item.id,
      title: item.title,
      description: item.description,
      status: complaintStatusCode(item.status),
      statusLabel: item.statusLabel,
      category: item.category,
      reportedAt: item.dateTime,
      address: item.location,
      attachments: item.attachments
          .map(
            (url) => ComplaintAttachmentEntity(
              mimeType: item.isVideoAttachment(url)
                  ? 'video/mp4'
                  : 'image/jpeg',
              url: url,
            ),
          )
          .toList(),
    );
  }
}
