part of 'demografi_bloc.dart';

enum DemografiSortOption {
  terbaru('Terbaru', Icons.schedule_rounded),
  namaAz('Nama (A - Z)', Icons.sort_by_alpha_rounded),
  namaZa('Nama (Z - A)', Icons.sort_by_alpha_rounded);

  final String label;
  final IconData icon;

  const DemografiSortOption(this.label, this.icon);
}

abstract class DemografiState extends Equatable {
  const DemografiState();

  int get activeTabIndex => 0;
  String get searchQuery => '';
  bool get hasActiveFilter => false;
  DemografiSortOption get selectedSortOption => DemografiSortOption.terbaru;
  String? get selectedProfesiFilter => null;
  String? get selectedScopeFilter => null;
  String? get selectedAfiliasiFilter => null;
  String? get selectedInstitusiKategoriFilter => null;
  String? get selectedInstitusiScopeFilter => null;

  bool get isSubmitting => false;
  String? get actionSuccessMessage => null;
  String? get errorMessage => null;

  List<TokohEntity> get tokohList => const [];
  List<InstitusiEntity> get institusiList => const [];
  List<TokohEntity> get filteredTokohList => const [];
  List<InstitusiEntity> get filteredInstitusiList => const [];

  @override
  List<Object?> get props => [];
}

class DemografiInitialState extends DemografiState {
  const DemografiInitialState();
}

class DemografiLoadingState extends DemografiState {
  const DemografiLoadingState();
}

class DemografiFailureState extends DemografiState {
  final String message;

  const DemografiFailureState(this.message);

  @override
  String? get errorMessage => message;

  @override
  List<Object?> get props => [message];
}

class DemografiLoadedState extends DemografiState {
  @override
  final List<TokohEntity> tokohList;
  @override
  final List<InstitusiEntity> institusiList;

  @override
  final int activeTabIndex;
  @override
  final String searchQuery;

  @override
  final String? selectedProfesiFilter;
  @override
  final String? selectedScopeFilter;
  @override
  final String? selectedAfiliasiFilter;
  @override
  final String? selectedInstitusiKategoriFilter;
  @override
  final String? selectedInstitusiScopeFilter;
  @override
  final DemografiSortOption selectedSortOption;

  @override
  final bool isSubmitting;
  @override
  final String? actionSuccessMessage;
  @override
  final String? errorMessage;

  const DemografiLoadedState({
    this.tokohList = const [],
    this.institusiList = const [],
    this.activeTabIndex = 0,
    this.searchQuery = '',
    this.selectedProfesiFilter,
    this.selectedScopeFilter,
    this.selectedAfiliasiFilter,
    this.selectedInstitusiKategoriFilter,
    this.selectedInstitusiScopeFilter,
    this.selectedSortOption = DemografiSortOption.terbaru,
    this.isSubmitting = false,
    this.actionSuccessMessage,
    this.errorMessage,
  });

  @override
  bool get hasActiveFilter {
    if (activeTabIndex == 0) {
      return selectedProfesiFilter != null ||
          selectedScopeFilter != null ||
          selectedAfiliasiFilter != null ||
          selectedSortOption != DemografiSortOption.terbaru;
    } else {
      return selectedInstitusiKategoriFilter != null ||
          selectedInstitusiScopeFilter != null ||
          selectedSortOption != DemografiSortOption.terbaru;
    }
  }

  @override
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

  @override
  List<InstitusiEntity> get filteredInstitusiList {
    List<InstitusiEntity> list = List.from(institusiList);

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((ins) {
        return ins.nama.toLowerCase().contains(q);
      }).toList();
    }

    if (selectedInstitusiKategoriFilter != null) {
      list = list
          .where((i) => i.kategori == selectedInstitusiKategoriFilter)
          .toList();
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

  DemografiLoadedState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    String? actionSuccessMessage,
    int? activeTabIndex,
    List<TokohEntity>? tokohList,
    List<InstitusiEntity>? institusiList,
    String? searchQuery,
    String? selectedProfesiFilter,
    bool clearProfesi = false,
    String? selectedScopeFilter,
    bool clearScope = false,
    String? selectedAfiliasiFilter,
    bool clearAfiliasi = false,
    String? selectedInstitusiKategoriFilter,
    bool clearInstitusiKategori = false,
    String? selectedInstitusiScopeFilter,
    bool clearInstitusiScope = false,
    DemografiSortOption? selectedSortOption,
  }) {
    return DemografiLoadedState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      actionSuccessMessage: actionSuccessMessage,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      tokohList: tokohList ?? this.tokohList,
      institusiList: institusiList ?? this.institusiList,
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
      selectedInstitusiKategoriFilter: clearInstitusiKategori
          ? null
          : (selectedInstitusiKategoriFilter ??
                this.selectedInstitusiKategoriFilter),
      selectedInstitusiScopeFilter: clearInstitusiScope
          ? null
          : (selectedInstitusiScopeFilter ?? this.selectedInstitusiScopeFilter),
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
    );
  }

  @override
  List<Object?> get props => [
    isSubmitting,
    errorMessage,
    actionSuccessMessage,
    activeTabIndex,
    tokohList,
    institusiList,
    searchQuery,
    selectedProfesiFilter,
    selectedScopeFilter,
    selectedAfiliasiFilter,
    selectedInstitusiKategoriFilter,
    selectedInstitusiScopeFilter,
    selectedSortOption,
  ];
}
