class DroppedBomb {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String locationName;
  final DateTime createdDate;

  DroppedBomb(this.id, this.title, this.description, this.latitude,
      this.longitude, this.locationName, this.createdDate);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is DroppedBomb) {
      return hashCode == other.hashCode;
    }
    return false;
  }
}
