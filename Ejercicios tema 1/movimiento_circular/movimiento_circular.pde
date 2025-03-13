// Ejercicio 2: Simulación de un movimiento circular
// Autor: Sergi Sanz Sancho

PVector centro;
int r, radio_trayectoria, periodo;
float dt, t, frecuencia, vel; 

void setup() {
  size(800, 800); 
  initVariables();  // Inicializar variables
}

void draw() {
  background(220, 255, 200); // Color de fondo
  stroke(0); // Color de las líneas de los ejes
  addText();

  // Dibuja ejes que se cruzan en el centro
  line(0, height / 2, width, height / 2); // Eje horizontal
  line(width / 2, 0, width / 2, height); // Eje vertical
  
  t += dt;

  // Cálculo de la nueva posición de la pelota
  float x = centro.x + radio_trayectoria * cos(vel * t);
  float y = centro.y + radio_trayectoria * sin(vel * t);

  // Dibujar la pelota
  fill(135, 206, 235); // Color de la pelota
  ellipse(x, y, 2*r, 2*r); // Dibuja la pelota
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    initVariables();  // Reiniciar todas las variables relevantes
  }
}

void initVariables() {
  centro = new PVector(width / 2, height / 2); 
  r = 20; 
  radio_trayectoria = 150; 
  periodo = 1; 
  frecuencia = 1.0 / periodo; 
  vel = TWO_PI * frecuencia; 
  dt = 0.05; 
  t = 0.0;
}

void addText() {
  fill(0);
  textSize(20);
  text("Periodo: " + periodo, 20, 30);
  text("Frecuencia: " + frecuencia, 20, 50);
  text("Tiempo total de simulación: " + t, 20, 70);
  text("Paso de tiempo de simulación: " + dt, 20, 90);
}
