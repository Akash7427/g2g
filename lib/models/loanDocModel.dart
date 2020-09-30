class LoanDocModel{
 final String docName,docFileName;
 final String docPk;
 final DateTime docDate;

  LoanDocModel(this.docName, this.docFileName,this.docPk,this.docDate);

  LoanDocModel.fromJson(Map<String, dynamic> json)
      : docName = json['DocName'],
        docFileName = json['DocFileName'],
        docDate = DateTime.parse(json['DocDate']),
        docPk = json['DocPk']
        ;

  Map<String, dynamic> toJson() =>
    {
      'DocName': docName,
      'DocFileName': docFileName,
      'DocDate':docDate,
      'DocPk': docPk
      
    };


}