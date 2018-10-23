class DEM {
  
  int w;
  int h;
  
  float offsetX = 0f;
  float offsetY = 0f;
  int x, y;
  
  float [][] values;
  int [][] valuesToDisplay;

  PGraphics pg;
  boolean cached = false;
   
  DEM (int sizeX, int sizeY) {
    w = sizeX;
    h = sizeY;
    values = new float[w][h];
    valuesToDisplay = new int[w][h];

    pg = createGraphics(w, h, P2D);

    init();
  }
  
  void init() {

    
    for (int j = 0; j < h; j++) {
      for (int i = 0; i < w; i++) {
        values[i][j] = noise(offsetX, offsetY);
        valuesToDisplay[i][j] = (int)map(values[i][j], 0, 1, 0, 255);
        offsetX+=.01f;
        
      }
      offsetY += 0.01f;
      offsetX = 0f;
    }
    
  }
  
  void display() {
    
    if (!cached) {
      pg.beginDraw();
      for (int j = 0; j < h; j++) {
        for (int i = 0; i < w; i++) {
          pg.stroke(valuesToDisplay[i][j]);
          pg.point (i, j); 
        }
      }
      pg.endDraw();
      cached = true;
    } else {
      image(pg, 0, 0, w, h);
    }   
  }

  float getAt(int i, int j) {
    return values[i][j];
  }
}
