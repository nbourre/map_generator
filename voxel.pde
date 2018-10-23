public class Voxel extends GraphicObject {

    public Voxel () {
        location = new PVector();
    }

    void update(float deltaTime) {

    }

    void display() {
        pushMatrix();
        
        translate(location.x, location.y, location.z);
        fill(fillColor);
        box(2, 2, 2);
        popMatrix();
    }





    
}
