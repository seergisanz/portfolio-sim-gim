// Ejercicio 1: Particula flotante 
// Autor: Sergi Sanz Sancho

Ice ice;
float initialX, initialY, initialRadius;

void setup() {
  size(800, 400);
  initialX = width / 2;
  initialY = height - 400;
  initialRadius = 30;
  initializeSimulation();
}

void draw() {
  background(255);
  
  fill(0, 0, 255);
  noStroke();
  rect(0, ice.waterLine, width, height - ice.waterLine);
  
  ice.updateSimulation();
  ice.render();

  fill(0);
  textSize(16);
  text("Pulsa R o r para reiniciar el sistema", 20, 30);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    initializeSimulation(); // Reiniciar la simulación
  }
}

void initializeSimulation() {
  ice = new Ice(initialX, initialY, initialRadius);
}
