// Class Car
class Car {
  ArrayList<PVector> velocityTrajectory; // Trayectoria de la velocidad del coche
  float mass = 10; // Masa del coche (en kg)
  float dragCoefficient = 0.1; // Coeficiente de rozamiento
  float velocity = 0; // Velocidad inicial
  float kineticEnergy = 0; // Energía cinética inicial
  float deltaTime = 0.1; // Paso de tiempo
  float totalTime = 0; // Tiempo total
  boolean isPowerOn = false; // Estado del motor (encendido/apagado)
  float initialX = 50; 

  Car() {
    velocityTrajectory = new ArrayList<PVector>();
  }

  void update() {
    updateVelocity();
    updatePosition();
    checkBoundaries();
    recordVelocity();
  }

  void updateVelocity() {
    float power = isPowerOn ? 1000 : 0; // 1000 W si el motor está encendido, sino 0
    float frictionForce = -dragCoefficient * velocity * velocity; // Fuerza de fricción
    power += frictionForce * velocity; // Potencia neta después de considerar la fricción
    
    // Calcula el cambio de energía cinética y actualiza la velocidad
    float energyChange = power * deltaTime;
    kineticEnergy += energyChange;
    velocity = sqrt(2 * kineticEnergy / mass);
  }

  void updatePosition() {
    initialX += velocity * deltaTime; // Actualiza la posición del coche
  }

  void checkBoundaries() {
    // Reinicia la posición del coche si se sale de la pantalla
    if (initialX > width + 50) {
      initialX = -50;
      totalTime = 0;
      velocityTrajectory.clear();
    }
  }

  void recordVelocity() {
    // Añade la velocidad actual a la trayectoria
    float x = totalTime * width / (deltaTime * 1000);
    float y = height - (velocity / 100 * height) - 300;
    velocityTrajectory.add(new PVector(x, y));

    if (x > width) {
      velocityTrajectory.clear();
      x = 0;
      totalTime = 0;
    }

    // Dibuja la trayectoria de la velocidad
    stroke(0);
    for (int i = 1; i < velocityTrajectory.size(); i++) {
      line(velocityTrajectory.get(i - 1).x, velocityTrajectory.get(i - 1).y, velocityTrajectory.get(i).x, velocityTrajectory.get(i).y);
    }

    totalTime += deltaTime;
  }

  void drawCar() {
    fill(0, 120, 280); // Color del coche
    noStroke();
    rect(initialX, height - 60, 50, 30); // Dibuja el coche
  }
}
