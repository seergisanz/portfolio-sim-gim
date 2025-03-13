// Ejercicio 3: Simulación del movimiento de una 
// partícula sobre dos funciones osciladoras
// Autor: Sergi Sanz Sancho

// Global variables
ArrayList<PVector> trajectory;
float x = 0;  // Posición en x del objeto desde el inicio del eje en la pantalla
float y;      // Valor calculado de y basado en la función
float vel = 0.1;  // Velocidad de incremento en x
float dt = 1;  // Delta de tiempo para la simulación
boolean simple = true;  // Indica si se utiliza la función simple
boolean combined = false;  // Indica si se utiliza la función combinada
float axisY;  // Posición y del eje x
String functionText;  // Texto que describe la función actual

void setup() {
  size(800, 400);
  axisY = height / 2;  // Centrar el eje X verticalmente
  trajectory = new ArrayList<PVector>();
  initializeFunctionText();
}

void draw() {
  background(255);
  drawAxes();
  calculatePosition();
  drawTrajectory();
  drawBall();
  drawFunctionText();
}

void drawAxes() {
  stroke(0);
  strokeWeight(2);
  // Dibuja el eje X en el centro vertical
  line(0, axisY, width, axisY);
  text("X", width - 20, axisY + 20);
  // Dibuja el eje Y desde la esquina izquierda
  line(0, 0, 0, height);
  text("Y", 10, 20);
}

void calculatePosition() {
  if (simple || combined) {
    x += vel * dt;
    if (simple) {
      y = calculateSimpleFunction(x);
    } else if (combined) {
      y = calculateCombinedFunction(x);
    }
    trajectory.add(new PVector(x, y));
  }
}

void drawTrajectory() {
  stroke(0);
  noFill();
  beginShape();
  for (PVector v : trajectory) {
    vertex(v.x, axisY - v.y);  // Ajusta la posición y para que sea relativa al eje X
  }
  endShape();
}

void drawFunctionText() {
  fill(0);
  textSize(20);
  text(functionText, width/3, 20);
}

void drawBall() {
  fill(0, 0, 255);
  ellipse(x, axisY - y, 30, 30);  // Ajusta la posición y para que sea relativa al eje X
}

float calculateSimpleFunction(float x) {
  return 120 * sin(x / 3) * exp(-0.01 * x);
}

float calculateCombinedFunction(float x) {
  return (75 * sin(x / 2) + 75 * sin(x / 2.5));
}

void initializeFunctionText() {
  if (simple) {
    functionText = "Función simple: y = 120 * sin(x/3) * exp(-0.01*x)\nPulsa C para cambiar a la función combinada";
  } else if (combined) {
    functionText = "Función combinada: y = 75 * sin(x / 2) + 75 * sin(x / 2.5)\nPulsa S para cambiar a la función simple";
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    simple = true;
    combined = false;
    trajectory.clear();
    x = 0;  // Reinicia x para comenzar desde el inicio del eje X
    initializeFunctionText();
  } else if (key == 'c' || key == 'C') {
    combined = true;
    simple = false;
    trajectory.clear();
    x = 0;  // Reinicia x para comenzar desde el inicio del eje X
    initializeFunctionText();
  }
}
