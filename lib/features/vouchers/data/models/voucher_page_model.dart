import 'package:akar/features/vouchers/data/models/voucher_json_utils.dart';
import 'package:akar/features/vouchers/data/models/voucher_model.dart';
import 'package:akar/features/vouchers/data/models/voucher_summary_model.dart';
import 'package:akar/features/vouchers/domain/entities/voucher_page_entity.dart';

/// Model DTO untuk response halaman voucher terpaginasi.
class VoucherPageModel extends VoucherPageEntity {
  const VoucherPageModel({
    required super.items,
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.summary,
  });

  factory VoucherPageModel.fromJson(Map<String, dynamic> body) {
    final rawData = body['data'];
    final List<VoucherModel> items = [];
    if (rawData is List) {
      for (final raw in rawData) {
        if (raw is Map) {
          items.add(VoucherModel.fromJson(voucherAsMap(raw)));
        }
      }
    }

    final meta = voucherAsMap(body['meta']);
    final summaryMap = voucherAsMap(body['summary']);

    final currentPage = voucherAsInt(meta['current_page'], fallback: 1);
    final lastPage = voucherAsInt(meta['last_page'], fallback: 1);
    final perPage = voucherAsInt(meta['per_page'], fallback: 20);
    final total = voucherAsInt(meta['total'], fallback: items.length);

    return VoucherPageModel(
      items: items,
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      total: total,
      summary: VoucherSummaryModel.fromJson(summaryMap),
    );
  }
}
