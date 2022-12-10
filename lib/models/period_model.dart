class Period {
  final int nr;
  final int firmnr;
  final String begdate;
  final String enddate;
  final int active;

  Period(
      {required this.nr,
      required this.firmnr,
      required this.begdate,
      required this.enddate,
      required this.active});

  Map<String, dynamic> toJson() => {
        PeriodFields.nr: nr,
        PeriodFields.firmNr: firmnr,
        PeriodFields.begDate: begdate,
        PeriodFields.endDate: enddate,
        PeriodFields.active: active
      };

  static Period fromJson(Map<String, dynamic> json) {
    return Period(
        nr: json[PeriodFields.nr] as int,
        firmnr: json[PeriodFields.firmNr] as int,
        begdate: json[PeriodFields.begDate] as String,
        enddate: json[PeriodFields.endDate] as String,
        active: json[PeriodFields.active] as int);
  }
}

final String periodTable = 'periods';

class PeriodFields {
  static final String nr = 'nr';
  static final String firmNr = 'firmnr';
  static final String begDate = 'begdate';
  static final String endDate = 'enddate';
  static final String active = 'active';
}
