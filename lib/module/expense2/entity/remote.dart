import 'package:json_annotation/json_annotation.dart';

part 'remote.g.dart';

/// The analysis of expense tracker is [here](https://github.com/SIT-kite/expense-tracker).
@JsonSerializable()
class DatapackRaw {
  DatapackRaw();
  int retcode = 0;
  int retcount = 0;
  List<TransactionRaw> retdata = [];
  String retmsg = "";
  factory DatapackRaw.fromJson(Map<String, dynamic> json) => _$DatapackRawFromJson(json);

  Map<String, dynamic> toJson() => _$DatapackRawToJson(this);
}

@JsonSerializable()
class TransactionRaw {
  TransactionRaw();
  /// example: "20221102"
  /// transaction data
  /// format: yyyymmdd
  String transdate = "";

  /// transaction time
  /// example: "114745"
  /// format: hhmmss
  String transtime = "";

  /// customer id
  /// example: 11045158
  int custid = 0;

  /// card before balance
  /// example: 100
  int transflag = 0;

  /// card after balance
  /// example: 76
  int cardbefbal = 0;

  /// device name
  /// example: "奉贤一食堂一楼汇多pos4（新）", "多媒体-3-4号楼", "上海应用技术学院"
  String? devicename = "";

  /// transaction name
  /// example: "pos消费", "支付宝充值", "补助领取", "批量销户" or "卡冻结", "下发补助" or "补助撤销"
  String transname = "";

  factory TransactionRaw.fromJson(Map<String, dynamic> json) => _$TransactionRawFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionRawToJson(this);
}
