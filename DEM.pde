class DEM {
  
  int w;
  int h;
  
  float offsetX = 0f;
  float offsetY = 0f;
  
  float [][] values;
   
  DEM (int sizeX, int sizeY) {
    w = sizeX;
    h = sizeY;
    values = new float[w][h];

    init();
  }
  
  void init() {
    for (int j = 0; j < h; j++) {
      for (int i = 0; i < w; i++) {
        values[i][j] = noise(offsetX, offsetY);
        offsetX+=.01f;
        
      }
      offsetY += 0.01f;
      offsetX = 0f;
    }
    
  }
  

  float getAt(int i, int j) {
    return values[i][j];
  }
}
