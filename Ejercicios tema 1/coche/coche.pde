// Ejercicio 7: Simulación de un coche con acelerador
// Autor: Sergi Sanz Sancho

Car car;

void setup() {
  size(1000, 800);
  car = new Car();
  car.kineticEnergy = 0.5 * car.mass * car.velocity * car.velocity; // Calcular la energía cinética inicial
}

void draw() {
  background(255);  // Limpiar el lienzo
  drawRoad();       // Dibujar la carretera

  car.update();
  
  // Dibujar la gráfica de velocidad
  car.recordVelocity();
  
  // Dibujar el coche
  car.drawCar();
  
  addText();        // Añadir texto informativo
  
  // Incrementar el tiempo total
  car.totalTime += car.deltaTime;
}

void drawRoad() {
  fill(80); // Color gris para la carretera
  rect(0, height - 100, width, 100); // Dibuja la carretera en la parte inferior de la pantalla
  
  stroke(255); // Color blanco para las líneas de la carretera
  strokeWeight(2); // Grosor de las líneas
  
  // Dibuja líneas discontinuas para los carriles
  int lineLength = 50;
  int lineSpace = 50;
  for (int i = 0; i < width; i += lineLength + lineSpace) {
    line(i, height - 50, i + lineLength, height - 50);
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') {
    car.isPowerOn = true;
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A') {
    car.isPowerOn = false;
  }
}

void addText() {
  fill(0); // Color del texto (negro)
  textSize(25); // Tamaño del texto
  // Ajustar la posición y para que el texto aparezca en la parte superior
  text("Visualizando la trayectoria de la velocidad de un coche con acelerador.", 20, 30); // Texto de descripción
  text("Pulsa la tecla 'a' o 'A' para acelerar.", 20, 60); // Instrucciones
}
