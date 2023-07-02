float[][] field;
float[][] prevField;
float damping = 0.99;
float velocityScale = 10;

void setup() {
  size(800, 600);
  field = new float[width][height];
  prevField = new float[width][height];
}

void draw() {
  background(255);
  
  // マウスドラッグでマーブルを追加
  if (mousePressed && mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height) {
    field[mouseX][mouseY] = 255;
  }
  
  // 流体シミュレーションの更新
  updateFluid();
  
  // マーブル模様の描画
  drawMarble();
}

void updateFluid() {
  loadPixels();
  
  for (int x = 1; x < width - 1; x++) {
    for (int y = 1; y < height - 1; y++) {
      float newValue = (prevField[x-1][y] + prevField[x+1][y] + prevField[x][y-1] + prevField[x][y+1]) / 2 - field[x][y];
      newValue *= damping;
      
      field[x][y] = newValue;
      float value = map(newValue, -255, 255, 0, 1);
      int pixel = color(value * 255);
      pixels[y * width + x] = pixel;
    }
  }
  
  updatePixels();
  
  // フィールドの値を保持
  float[][] temp = prevField;
  prevField = field;
  field = temp;
  
  // マウス位置に速度を追加
  if (mousePressed && mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height) {
    int x = mouseX;
    int y = mouseY;
    prevField[x][y] = mouseX - pmouseX;
    field[x][y] = mouseX - pmouseX;
  }
}

void drawMarble() {
  loadPixels();
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float value = map(field[x][y], -255, 255, 0, 1);
      int pixel = color(value * 255);
      pixels[y * width + x] = pixel;
    }
  }
  
  updatePixels();
}
