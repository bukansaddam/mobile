part of 'tokoh_bloc.dart';

abstract class TokohEvent extends Equatable {
  const TokohEvent();

  @override
  List<Object?> get props => [];
}

class GetTokohEvent extends TokohEvent {
  final String? search;
  final String? field;
  final String? label;
  final String? affiliations;
  final String? professions;
  final TokohSortOption? sort;

  const GetTokohEvent({
    this.search,
    this.field,
    this.label,
    this.affiliations,
    this.professions,
    this.sort,
  });

  @override
  List<Object?> get props => [
    search,
    field,
    label,
    affiliations,
    professions,
    sort,
  ];
}

class RefreshTokohEvent extends TokohEvent {
  final String? search;
  final String? field;
  final String? label;
  final String? affiliations;
  final String? professions;
  final TokohSortOption? sort;

  const RefreshTokohEvent({
    this.search,
    this.field,
    this.label,
    this.affiliations,
    this.professions,
    this.sort,
  });

  @override
  List<Object?> get props => [
    search,
    field,
    label,
    affiliations,
    professions,
    sort,
  ];
}

class SetTokohFilterEvent extends TokohEvent {
  final String? field;
  final bool hasField;
  final String? label;
  final bool hasLabel;
  final String? affiliations;
  final bool hasAffiliations;
  final String? professions;
  final bool hasProfessions;
  final TokohSortOption? sort;
  final String? search;

  const SetTokohFilterEvent({
    this.field,
    this.hasField = false,
    this.label,
    this.hasLabel = false,
    this.affiliations,
    this.hasAffiliations = false,
    this.professions,
    this.hasProfessions = false,
    this.sort,
    this.search,
  });

  const SetTokohFilterEvent.field(this.field)
    : hasField = true,
      label = null,
      hasLabel = false,
      affiliations = null,
      hasAffiliations = false,
      professions = null,
      hasProfessions = false,
      sort = null,
      search = null;

  const SetTokohFilterEvent.professions(this.professions)
    : field = null,
      hasField = false,
      label = null,
      hasLabel = false,
      affiliations = null,
      hasAffiliations = false,
      hasProfessions = true,
      sort = null,
      search = null;

  const SetTokohFilterEvent.label(this.label)
    : field = null,
      hasField = false,
      hasLabel = true,
      affiliations = null,
      hasAffiliations = false,
      professions = null,
      hasProfessions = false,
      sort = null,
      search = null;

  const SetTokohFilterEvent.affiliations(this.affiliations)
    : field = null,
      hasField = false,
      label = null,
      hasLabel = false,
      hasAffiliations = true,
      professions = null,
      hasProfessions = false,
      sort = null,
      search = null;

  const SetTokohFilterEvent.sort(this.sort)
    : field = null,
      hasField = false,
      label = null,
      hasLabel = false,
      affiliations = null,
      hasAffiliations = false,
      professions = null,
      hasProfessions = false,
      search = null;

  const SetTokohFilterEvent.search(this.search)
    : field = null,
      hasField = false,
      label = null,
      hasLabel = false,
      affiliations = null,
      hasAffiliations = false,
      professions = null,
      hasProfessions = false,
      sort = null;

  @override
  List<Object?> get props => [
    field,
    hasField,
    label,
    hasLabel,
    affiliations,
    hasAffiliations,
    professions,
    hasProfessions,
    sort,
    search,
  ];
}

class ResetTokohFilterEvent extends TokohEvent {
  const ResetTokohFilterEvent();
}

class CreateTokohEvent extends TokohEvent {
  final TokohEntity tokoh;

  const CreateTokohEvent(this.tokoh);

  @override
  List<Object?> get props => [tokoh];
}

class UpdateTokohEvent extends TokohEvent {
  final String id;
  final TokohEntity tokoh;

  const UpdateTokohEvent({required this.id, required this.tokoh});

  @override
  List<Object?> get props => [id, tokoh];
}
