/**
 * This mistake was encountered while messing around with cellular automata.
 *
 * While trying to achieve a "blur" effect by averaging the color of each cell
 * in a pixel's neighborhood, I averaged the colors directly using the Integer
 * representation of 'color' rather than extracting the RGB values and averaging
 * those.
 *
 * The results are unexpected.
 */

float noiseScale = 0.02;

void setup() {
    size(768,768);
    background(255);
    seed();
}

void draw() {
    loadPixels();
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            colorCells(x, y);
        }
    }
    updatePixels();

    // Uncomment to add more seed shapes
    // if (frameCount % 1800 == 0) {
    //     seed();
    // }
}

// random blotches using noise threshold (below = white, above = black)
void seed() {
    noiseSeed(millis());
    loadPixels();
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            float noiseVal = noise(x * noiseScale, y * noiseScale);
            if (noiseVal > 0.75) {
                pixels[y * width + x] = color(0);
            }
        }
    }
    updatePixels();
}

// color center the "average" color of neighborhood
void colorCells(int x, int y) {
    PixelValue[] neighborhood = getNeighborhood(x, y);

    int avg = 0;
    for(int i=0; i < neighborhood.length; i++) {
        color c = neighborhood[i].c;
        avg += c;
    }
    avg /= neighborhood.length;

    pixels[y * width + x] = avg;
}

// square (Moore) neighborhood
PixelValue[] getNeighborhood(int x, int y) {
    PixelValue[] neighborhood = new PixelValue[8];
    int up = Math.max(0, y-1);
    int down = Math.min(height-1, y+1);
    int left = Math.max(0, x-1);
    int right = Math.min(width-1, x+1);
    int[] ni = {
        up * width + left,   // up left
        up * width + x,      // up
        up * width + right,  // up right
        y * width + left,    // left
        y * width + right,   // right
        down * width + left, // down left
        down * width + x,    // down
        down * width + right // down right
    };

    for (int i = 0; i < ni.length; i++) {
        neighborhood[i] = new PixelValue(ni[i], pixels[ni[i]]);
    }
    return neighborhood;
}

class PixelValue {
    int i;
    color c;

    PixelValue(int i, color c) {
        this.i = i;
        this.c = c;
    }
}
