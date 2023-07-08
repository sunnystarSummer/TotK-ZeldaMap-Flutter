enum MapType {
  sky('2102'),
  surface('2101'),
  depths('2103'),
  ;
  const MapType(this.mapId);
  final String mapId;
}

extension ExtensionMapType on MapType {

  String getAssets() {
    String basePath = 'assets/TotK/map/Hyrule';
    //String basePath = 'https://zeldamaps.com/tiles/totk/hyrule/sky';
    switch (this) {
      case MapType.sky:
        return '$basePath/sky';
      case MapType.surface:
        return '$basePath/ground';
      case MapType.depths:
        return '$basePath/underground';
    }
  }

  String getUrlTemplate(String baseUrlTemplate) {
    return urlTemplate(this, baseUrlTemplate);
  }

  static String urlTemplate(MapType type,String baseUrlTemplate) {
    switch (type) {
      case MapType.sky:
        return '$baseUrlTemplate/sky_after/{z}_{x}_{y}.png';
      case MapType.surface:
        return '$baseUrlTemplate/ground/{z}_{x}_{y}.png';
      case MapType.depths:
        return '$baseUrlTemplate/underground/{z}_{x}_{y}.png';
    }
  }
}
