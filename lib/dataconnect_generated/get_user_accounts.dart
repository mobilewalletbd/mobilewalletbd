part of 'generated.dart';

class GetUserAccountsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetUserAccountsVariablesBuilder(this._dataConnect, );
  Deserializer<GetUserAccountsData> dataDeserializer = (dynamic json)  => GetUserAccountsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetUserAccountsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetUserAccountsData, void> ref() {
    
    return _dataConnect.query("GetUserAccounts", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetUserAccountsAccounts {
  final String id;
  final String name;
  final double balance;
  final String currency;
  GetUserAccountsAccounts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  balance = nativeFromJson<double>(json['balance']),
  currency = nativeFromJson<String>(json['currency']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserAccountsAccounts otherTyped = other as GetUserAccountsAccounts;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    balance == otherTyped.balance && 
    currency == otherTyped.currency;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, balance.hashCode, currency.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['balance'] = nativeToJson<double>(balance);
    json['currency'] = nativeToJson<String>(currency);
    return json;
  }

  const GetUserAccountsAccounts({
    required this.id,
    required this.name,
    required this.balance,
    required this.currency,
  });
}

@immutable
class GetUserAccountsData {
  final List<GetUserAccountsAccounts> accounts;
  GetUserAccountsData.fromJson(dynamic json):
  
  accounts = (json['accounts'] as List<dynamic>)
        .map((e) => GetUserAccountsAccounts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserAccountsData otherTyped = other as GetUserAccountsData;
    return accounts == otherTyped.accounts;
    
  }
  @override
  int get hashCode => accounts.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['accounts'] = accounts.map((e) => e.toJson()).toList();
    return json;
  }

  const GetUserAccountsData({
    required this.accounts,
  });
}

