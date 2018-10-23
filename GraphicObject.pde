abstract class GraphicObject {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  color fillColor = color (255);
  color strokeColor = color (255);
  float strokeWeight = 1;
  
  abstract void update(float deltaTime);
  
  abstract void display();

  color getFillColor(){
    return fillColor;
  }

  void setFillColor(color c) {
      fillColor = c;
  }

  PVector getLocation() {
    return location;
  }
  
  void setLocation(float x, float y, float z) {
      location.x = x;
      location.y = y;
      location.z = z;
  }
}
