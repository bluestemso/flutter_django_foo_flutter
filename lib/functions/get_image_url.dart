String getImageUrl(String type) {
  switch (type.toLowerCase()) {
    case 'fire':
      return 'images/fire.png';
    case 'water':
      return 'images/water.png';
    case 'grass':
      return 'images/grass.png';
    case 'bug':
      return 'images/bug.png';
  }
}