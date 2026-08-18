part of 'demografi_bloc.dart';

enum DemografiStatus { initial, loading, success, failure }

enum DemografiSortOption {
  terbaru('Terbaru', Icons.schedule_rounded),
  namaAz('Nama (A - Z)', Icons.sort_by_alpha_rounded),
  namaZa('Nama (Z - A)', Icons.sort_by_alpha_rounded);

  final String label;
  final IconData icon;

  const DemografiSortOption(this.label, this.icon);
}

class DemografiState extends Equatable {
  final DemografiStatus status;
  final bool isSubmitting;
  final String? errorMessage;
  final String? actionSuccessMessage;
  final int activeTabIndex;

  final List<TokohEntity> tokohList;
  final List<InstitusiEntity> institusiList;
  final List<OrganisasiEntity> organisasiList;

  final String searchQuery;
  final String? selectedProfesiFilter;
  final String? selectedScopeFilter;
  final String? selectedAfiliasiFilter;
  final String? selectedInstitusiScopeFilter;
  final String? selectedOrganisasiBidangFilter;
  final DemografiSortOption selectedSortOption;

  const DemografiState({
    this.status = DemografiStatus.initial,
    this.isSubmitting = false,
    this.errorMessage,
    this.actionSuccessMessage,
    this.activeTabIndex = 0,
    this.tokohList = const [],
    this.institusiList = const [],
    this.organisasiList = const [],
    this.searchQuery = '',
    this.selectedProfesiFilter,
    this.selectedScopeFilter,
    this.selectedAfiliasiFilter,
    this.selectedInstitusiScopeFilter,
    this.selectedOrganisasiBidangFilter,
    this.selectedSortOption = DemografiSortOption.terbaru,
  });

  bool get hasActiveFilter {
    if (activeTabIndex == 0) {
      return selectedProfesiFilter != null ||
          selectedScopeFilter != null ||
          selectedAfiliasiFilter != null ||
          selectedSortOption != DemografiSortOption.terbaru;
    } else if (activeTabIndex == 1) {
      return selectedInstitusiScopeFilter != null ||
          selectedSortOption != DemografiSortOption.terbaru;
    } else {
      return selectedOrganisasiBidangFilter != null ||
          selectedSortOption != DemografiSortOption.terbaru;
    }
  }

  List<TokohEntity> get filteredTokohList {
    List<TokohEntity> list = List.from(tokohList);

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((tokoh) {
        return tokoh.nama.toLowerCase().contains(q);
      }).toList();
    }

    if (selectedProfesiFilter != null) {
      list = list.where((t) => t.profesi == selectedProfesiFilter).toList();
    }
    if (selectedScopeFilter != null) {
      list = list.where((t) => t.wilayah == selectedScopeFilter).toList();
    }
    if (selectedAfiliasiFilter != null) {
      list = list.where((t) => t.afiliasi == selectedAfiliasiFilter).toList();
    }

    switch (selectedSortOption) {
      case DemografiSortOption.terbaru:
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case DemografiSortOption.namaAz:
        list.sort(
          (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
        );
        break;
      case DemografiSortOption.namaZa:
        list.sort(
          (a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()),
        );
        break;
    }

    return list;
  }

  List<InstitusiEntity> get filteredInstitusiList {
    List<InstitusiEntity> list = List.from(institusiList);

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((ins) {
        return ins.nama.toLowerCase().contains(q);
      }).toList();
    }

    if (selectedInstitusiScopeFilter != null) {
      list = list
          .where((i) => i.scope == selectedInstitusiScopeFilter)
          .toList();
    }

    switch (selectedSortOption) {
      case DemografiSortOption.terbaru:
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case DemografiSortOption.namaAz:
        list.sort(
          (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
        );
        break;
      case DemografiSortOption.namaZa:
        list.sort(
          (a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()),
        );
        break;
    }

    return list;
  }

  List<OrganisasiEntity> get filteredOrganisasiList {
    List<OrganisasiEntity> list = List.from(organisasiList);

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((org) {
        return org.nama.toLowerCase().contains(q);
      }).toList();
    }

    if (selectedOrganisasiBidangFilter != null) {
      list = list
          .where((o) => o.bidang == selectedOrganisasiBidangFilter)
          .toList();
    }

    switch (selectedSortOption) {
      case DemografiSortOption.terbaru:
        list.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case DemografiSortOption.namaAz:
        list.sort(
          (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
        );
        break;
      case DemografiSortOption.namaZa:
        list.sort(
          (a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()),
        );
        break;
    }

    return list;
  }

  DemografiState copyWith({
    DemografiStatus? status,
    bool? isSubmitting,
    String? errorMessage,
    String? actionSuccessMessage,
    int? activeTabIndex,
    List<TokohEntity>? tokohList,
    List<InstitusiEntity>? institusiList,
    List<OrganisasiEntity>? organisasiList,
    String? searchQuery,
    String? selectedProfesiFilter,
    bool clearProfesi = false,
    String? selectedScopeFilter,
    bool clearScope = false,
    String? selectedAfiliasiFilter,
    bool clearAfiliasi = false,
    String? selectedInstitusiScopeFilter,
    bool clearInstitusiScope = false,
    String? selectedOrganisasiBidangFilter,
    bool clearOrganisasiBidang = false,
    DemografiSortOption? selectedSortOption,
  }) {
    return DemografiState(
      status: status ?? this.status,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      actionSuccessMessage: actionSuccessMessage,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      tokohList: tokohList ?? this.tokohList,
      institusiList: institusiList ?? this.institusiList,
      organisasiList: organisasiList ?? this.organisasiList,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedProfesiFilter: clearProfesi
          ? null
          : (selectedProfesiFilter ?? this.selectedProfesiFilter),
      selectedScopeFilter: clearScope
          ? null
          : (selectedScopeFilter ?? this.selectedScopeFilter),
      selectedAfiliasiFilter: clearAfiliasi
          ? null
          : (selectedAfiliasiFilter ?? this.selectedAfiliasiFilter),
      selectedInstitusiScopeFilter: clearInstitusiScope
          ? null
          : (selectedInstitusiScopeFilter ?? this.selectedInstitusiScopeFilter),
      selectedOrganisasiBidangFilter: clearOrganisasiBidang
          ? null
          : (selectedOrganisasiBidangFilter ??
                this.selectedOrganisasiBidangFilter),
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isSubmitting,
    errorMessage,
    actionSuccessMessage,
    activeTabIndex,
    tokohList,
    institusiList,
    organisasiList,
    searchQuery,
    selectedProfesiFilter,
    selectedScopeFilter,
    selectedAfiliasiFilter,
    selectedInstitusiScopeFilter,
    selectedOrganisasiBidangFilter,
    selectedSortOption,
  ];
}
