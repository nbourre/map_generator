import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class map_generator extends PApplet {

int currentTime;
int previousTime;
int deltaTime;


Terrain terrain;

public void setup () {
  
  currentTime = millis();
  previousTime = millis();
  
  terrain = new Terrain(width, height);
}

public void draw () {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  
  inputManager(deltaTime);
  update(deltaTime);
  display();
  
  previousTime = currentTime;
}

/***
  The calculations should go here
*/
public void update(int delta) {
  terrain.update(delta);
}

/***
  The rendering should go here
*/
public void display () {
  background(255);
  terrain.display();
}

int moveSpeed = 10;

int zoomDelay = 50;
int zoomAcc = 0;

public void inputManager(float delta) {
  if (keyPressed) {

    zoomAcc += delta;

    if (zoomAcc > zoomDelay) {
      zoomAcc = 0;

      if (key == '+') {
        terrain.increaseZoom();
      }
      
      if (key == '-') {
        terrain.decreaseZoom();
      }
    }

    if (key == CODED) {
      int x = terrain.getOffsetX();
      int y = terrain.getOffsetY();
      boolean camMove = false;

      if (keyCode == LEFT) {
        camMove = true;
        x -= moveSpeed; 
      }

      if (keyCode == RIGHT) {
        camMove = true;
        x += moveSpeed; 
      }

      if (keyCode == UP) {
        camMove = true;
        y -= moveSpeed; 
      }

      if (keyCode == DOWN) {
        camMove = true;
        y += moveSpeed; 
      }

      if (camMove) {
        terrain.setOffsets(x, y);
      }
    }
  }
}
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
  
  public void init() {
    for (int j = 0; j < h; j++) {
      for (int i = 0; i < w; i++) {
        values[i][j] = noise(offsetX, offsetY);
        offsetX+=.01f;
        
      }
      offsetY += 0.01f;
      offsetX = 0f;
    }
    
  }
  

  public float getAt(int i, int j) {
    return values[i][j];
  }
}
abstract class GraphicObject {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  int fillColor = color (255);
  int strokeColor = color (255);
  float strokeWeight = 1;
  
  public abstract void update(float deltaTime);
  
  public abstract void display();

  public int getFillColor(){
    return fillColor;
  }

  public void setFillColor(int c) {
      fillColor = c;
  }

  public PVector getLocation() {
    return location;
  }
  
  public void setLocation(float x, float y, float z) {
      location.x = x;
      location.y = y;
      location.z = z;
  }
}
class Terrain {

    int w, h;
    DEM dem;

    float levelSea = 0.25f;
    float levelBeach = 0.50f;
    float levelForest = 0.75f;
    float levelSnow = 1.0f;
    float value;
    PGraphics pg;
    boolean dirty = true;

    int ratio = 4;
    int offsetX = 0;
    int offsetY = 0;
    float zoomLevel = 1f;
    int maxZoom = 4;
    float zoomIncrement = .1f;
    ArrayList<Voxel> voxels = new ArrayList<Voxel>();

    Terrain(int sizeX, int sizeY) {
        w = sizeX;
        h = sizeY;

        dem = new DEM(w * maxZoom, h * maxZoom);
        pg = createGraphics(w, h, P2D);

        initVoxels();
    }

    public void initVoxels(){
        for (int j = 0; j < h; j++) {
            for (int i = 0; i < w; i++) {
                Voxel v = new Voxel();
                voxels.add(v);
            }
        }
    }

    public void setOffsets(int x, int y) {

        offsetX = (int)constrain (x, 0, (w * maxZoom) - (w * zoomLevel));
        offsetY = (int)constrain (y, 0, (h * maxZoom) - (h * zoomLevel));
        dirty = true;
    }

    public int getOffsetX() {
        return offsetX;
    }

    public int getOffsetY() {
        return offsetY;
    }

    public void setZoomlevel(float z) {
        zoomLevel = z > maxZoom ? maxZoom : (z < zoomIncrement ? zoomIncrement : z);

        
        setOffsets(offsetX, offsetY);
        dirty = true;
    }

    public void increaseZoom(){
        float zl = zoomLevel - zoomIncrement;
        setZoomlevel(zl);
    }

    public void decreaseZoom() {
        float zl = zoomLevel + zoomIncrement;
        setZoomlevel(zl);
    }

    public void update(float deltatime) {
        if (dirty) {
            int idx_i, idx_j;
            
            pg.beginDraw();
            pg.loadPixels();
            for (int j = 0; j < h; j++) {

                idx_j = PApplet.parseInt((j * zoomLevel) + offsetY);

                for (int i = 0; i < w; i++) {

                    idx_i = PApplet.parseInt((i * zoomLevel) + offsetX);

                    value = dem.getAt(idx_i, idx_j);

                    int c = 0;

                    if (value < levelSea) {
                        c = color(0, 9, 255);
                    } else if (value < levelBeach) {
                        c = color(227, 187, 54);
                    } else if (value < levelForest) {
                        c = color(85, 189, 47);
                    } else {
                        c = color(207, 207, 207);
                    }
                    
                    int index = i + (j * w);
                    pg.pixels[index] = c;

                    Voxel v = voxels.get(index);
                    v.setFillColor(c);
                    v.setLocation(i, j, map(value, 0, 1, 0, 255));


                }
            }
            pg.updatePixels();
            pg.endDraw();
            dirty = false;
        }
    }

    public void display() {
        for (int j = 0; j < h; j++) {
            for (int i = 0; i < w; i++) {
                
                int index = i + (j * w);
                Voxel v = voxels.get(index);

                v.display();
            }
        }
    }
    
}
public class Voxel extends GraphicObject {

    public Voxel () {
        location = new PVector();
    }

    public void update(float deltaTime) {

    }

    public void display() {
        pushMatrix();
        
        translate(location.x, location.y, location.z);
        fill(fillColor);
        box(2, 2, 2);
        popMatrix();
    }





    
}
  public void settings() {  size (800, 600, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "map_generator" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
