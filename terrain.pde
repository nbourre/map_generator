class Terrain {

    int w, h;
    DEM dem;

    float levelSea = 0.25;
    float levelBeach = 0.50;
    float levelForest = 0.75;
    float levelSnow = 1.0;
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

    void initVoxels(){
        for (int j = 0; j < h; j++) {
            for (int i = 0; i < w; i++) {
                Voxel v = new Voxel();
                voxels.add(v);
            }
        }
    }

    void setOffsets(int x, int y) {

        offsetX = (int)constrain (x, 0, (w * maxZoom) - (w * zoomLevel));
        offsetY = (int)constrain (y, 0, (h * maxZoom) - (h * zoomLevel));
        dirty = true;
    }

    int getOffsetX() {
        return offsetX;
    }

    int getOffsetY() {
        return offsetY;
    }

    void setZoomlevel(float z) {
        zoomLevel = z > maxZoom ? maxZoom : (z < zoomIncrement ? zoomIncrement : z);

        
        setOffsets(offsetX, offsetY);
        dirty = true;
    }

    void increaseZoom(){
        float zl = zoomLevel - zoomIncrement;
        setZoomlevel(zl);
    }

    void decreaseZoom() {
        float zl = zoomLevel + zoomIncrement;
        setZoomlevel(zl);
    }

    void update(float deltatime) {
        if (dirty) {
            int idx_i, idx_j;
            
            pg.beginDraw();
            pg.loadPixels();
            for (int j = 0; j < h; j++) {

                idx_j = int((j * zoomLevel) + offsetY);

                for (int i = 0; i < w; i++) {

                    idx_i = int((i * zoomLevel) + offsetX);

                    value = dem.getAt(idx_i, idx_j);

                    color c = 0;

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

    void display() {
        for (int j = 0; j < h; j++) {
            for (int i = 0; i < w; i++) {
                
                int index = i + (j * w);
                Voxel v = voxels.get(index);

                pushMatrix();

                translate(i, j, v.getLocation().z);

                fill(v.getFillColor());
                box(1, 1, 1);

                popMatrix();
            }
        }
    }
    
}