// Ejercicio 2: Splash
// Autor: Sergi Sanz Sancho

Ice ice;
ParticleSystem ps;

void setup() {
  size(800, 400);
  ice = new Ice(width / 2, 50, 30); // Comienza un poco más alto para que descienda
  ps = new ParticleSystem(new PVector(width / 2, height / 2));
}

void draw() {
  background(255); // Fondo blanco
  fill(0, 0, 255); // Color azul para el agua
  noStroke();
  rect(0, ice.waterLine, width, height - ice.waterLine); // Dibuja el agua

  ice.updateSimulation(ps); // Actualiza el iceberg
  ice.render(); // Dibuja el iceberg si no ha explotado
  addText();
  ps.run(); // Ejecuta y renderiza el sistema de partículas
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    setup(); // Reiniciar la simulación
  }
}

void addText() {
  textSize(20);
  fill(0);
  text("Pulsa R o r para reiniciar el sistema", 20, 30);
}
