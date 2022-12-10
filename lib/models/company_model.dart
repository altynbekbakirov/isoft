class Company {
  final int id;
  final int perNr;
  final int nr;
  final int currency;
  final String title;
  final String name;

  Company(
      {required this.id,
      required this.perNr,
      required this.nr,
      required this.currency,
      required this.title,
      required this.name});

  Map<String, dynamic> toJson() => {
        CompanyFields.id: id,
        CompanyFields.perNr: perNr,
        CompanyFields.nr: nr,
        CompanyFields.currency: currency,
        CompanyFields.title: title,
        CompanyFields.name: name
      };

  static Company fromJson(Map<String, dynamic> json) {
    return Company(
        id: json[CompanyFields.id],
        perNr: json[CompanyFields.perNr],
        nr: json[CompanyFields.nr],
        currency: json[CompanyFields.currency],
        title: json[CompanyFields.title],
        name: json[CompanyFields.name]);
  }

  @override
  String toString() {
    return 'Company{id: $id, pernr: $perNr, nr: $nr, title: $title, name: $name}';
  }
}

final String companyTable = 'company';

class CompanyFields {
  static final String id = 'id';
  static final String perNr = 'pernr';
  static final String nr = 'nr';
  static final String title = 'title';
  static final String name = 'name';
  static final String currency = 'currency';
}
