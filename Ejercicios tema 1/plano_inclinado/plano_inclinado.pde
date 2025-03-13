// Ejercicio 6: Simulación de un plano inclinado
// Autor: Sergi Sanz Sancho

// Variables globales, declaradas como en tu código original
float angle = -PI / 4;
PVector position = new PVector();
PVector velocity = new PVector();
PVector acceleration = new PVector();
float timeStep = 0.01;
float gravity = 9.801;
float frictionCoefficient = -0.5;
float mass = 5;
color groundColor;
float totalTime;

void setup() {
  size(600, 600);
  groundColor = color(112, 128, 144);
  calculateInitialPosition();
  resetMotion();  // Asegura que la simulación comience en estado inicial
}

void draw() {
  background(255);
  addText();
  drawTerrain();
  updateMotion();
  fill(0, 0, 255);
  drawBall();
  totalTime += timeStep;
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    resetMotion();  // Reinicia la simulación cuando la tecla 'r' es presionada
  }
}
void updateMotion() {
  acceleration = calculateAcceleration(position, velocity);
  position.add(PVector.mult(velocity, timeStep));  // Actualiza la posición basada en la velocidad
  velocity.add(PVector.mult(acceleration, timeStep));  // Actualiza la velocidad basada en la aceleración
}

PVector calculateAcceleration(PVector pos, PVector vel) {
  float gravX = mass * gravity * sin(-angle - PI / 2);  // Componente X de la gravedad
  float gravY = mass * gravity * cos(-angle - PI / 2);  // Componente Y de la gravedad

  float friction = frictionCoefficient * vel.mag();  // Fricción basada en la magnitud de la velocidad
  if (vel.x > 0) {
    friction *= -1;  // La fricción actúa en dirección opuesta al movimiento
  }
  
  float accX = (gravX - friction) / mass;  // Componente X de la aceleración
  float accY = (gravY + friction) / mass;  // Componente Y de la aceleración
  
  return new PVector(accX, accY);  // Retorna el vector de aceleración
}
void resetMotion() {
  // Reinicia la posición y velocidad de la pelota
  calculateInitialPosition();
  velocity.set(0, 0);  // Restablece la velocidad a cero
  totalTime = 0.0;
}

void calculateInitialPosition() {
  float widthAnchor, heightAnchor;
  // Cálculos para establecer la posición inicial basada en el ángulo
  if (angle < radians(-45)) {
    float x = (height / tan(-angle) / 2);
    float y = tan(-angle) * x;
    widthAnchor = x;
    heightAnchor = y;
  } else if (angle > radians(-45)) {
    float x = width / 2;
    float y = height - (tan(-angle) * x);
    widthAnchor = x;
    heightAnchor = y;
  } else {
    widthAnchor = width / 2;
    heightAnchor = height / 2;
  }
  position.set(widthAnchor, heightAnchor - 19); // Ajusta la posición inicial
}

void drawTerrain() {
  // Código para dibujar el terreno como en tu ejemplo
  float x1 = 0;
  float y1 = height;
  float x2 = width;
  float h = tan(angle) * width + height;
  stroke(0);
  fill(groundColor);
  beginShape();
  vertex(x1, y1);
  vertex(x2, h);
  vertex(x2, height);
  vertex(x1, height);
  endShape(CLOSE);
}

void drawBall() {
  // Dibuja la pelota en su posición actual
  strokeWeight(3);
  stroke(0);
  ellipse(position.x, position.y, 30, 30);
}

void addText() {
  // Agrega texto en la pantalla
  fill(0);
  textSize(20);
  text("Fuerzas que actúan: gravedad y fricción", 20, 30);
  text("Tiempo total de simulación: " + totalTime, 20, 50);
  text("Paso de simulación: " + timeStep, 20, 70);
}
