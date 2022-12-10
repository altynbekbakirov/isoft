class Ware {
  final int id;
  final String name;
  final int nr;
  final int firmNr;

  Ware(
      {required this.id,
      required this.name,
      required this.nr,
      required this.firmNr});

  Map<String, dynamic> toJson() => {
        WareFields.id: id,
        WareFields.name: name,
        WareFields.nr: nr,
        WareFields.firmNr: firmNr
      };

  static Ware fromJson(Map<String, dynamic> json) => Ware(
      id: json[WareFields.id] as int,
      name: json[WareFields.name] as String,
      nr: json[WareFields.nr] as int,
      firmNr: json[WareFields.firmNr] as int);
}

final String wareTable = 'wares';

class WareFields {
  static final String id = 'id';
  static final String name = 'name';
  static final String nr = 'nr';
  static final String firmNr = 'firmnr';
}
