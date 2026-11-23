/// Status voucher pada aplikasi dan backend API.
enum VoucherStatus {
  active('active', 'Aktif'),
  used('used', 'Terpakai'),
  expired('expired', 'Kedaluwarsa');

  final String apiValue;
  final String label;

  const VoucherStatus(this.apiValue, this.label);

  static VoucherStatus fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'used':
        return VoucherStatus.used;
      case 'expired':
        return VoucherStatus.expired;
      case 'active':
      default:
        return VoucherStatus.active;
    }
  }
}
