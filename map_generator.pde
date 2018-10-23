int currentTime;
int previousTime;
int deltaTime;


Terrain terrain;

void setup () {
  size (800, 600, P2D);
  currentTime = millis();
  previousTime = millis();
  
  terrain = new Terrain(width, height);
}

void draw () {
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
void update(int delta) {
  terrain.update(delta);
}

/***
  The rendering should go here
*/
void display () {
  background(255);
  terrain.display();
}

int moveSpeed = 10;

int zoomDelay = 50;
int zoomAcc = 0;

void inputManager(float delta) {
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
