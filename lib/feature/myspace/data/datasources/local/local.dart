/// Local data source interface
/// For caching data locally (SharedPreferences, Hive, etc.)
abstract class ConsultationLocalDataSource {
  Future<void> cacheConsultations(List data);
  Future<List?> getCachedConsultations();
  Future<void> clearCache();
}

/// Local data source implementation
class ConsultationLocalDataSourceImpl implements ConsultationLocalDataSource {
  // TODO: Add SharedPreferences or Hive for caching

  @override
  Future<void> cacheConsultations(List data) async {
    // TODO: Implement caching
    // final jsonString = json.encode(data);
    // await sharedPreferences.setString('cached_consultations', jsonString);
  }

  @override
  Future<List?> getCachedConsultations() async {
    // TODO: Implement getting cached data
    // final jsonString = sharedPreferences.getString('cached_consultations');
    // if (jsonString != null) {
    //   return json.decode(jsonString) as List;
    // }
    return null;
  }

  @override
  Future<void> clearCache() async {
    // TODO: Implement clearing cache
    // await sharedPreferences.remove('cached_consultations');
  }
}