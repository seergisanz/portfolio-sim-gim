// Class Particle
class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.1); // Aceleración hacia abajo para simular gravedad
    float angle = random(-PI / 10, PI / 10); // Angulo aleatorio hacia arriba
    float speed = random(5, 10); // Velocidad inicial más fuerte para alcanzar altura
    velocity = new PVector(speed * sin(angle), -speed * cos(angle)); // Velocidad inicial
    position = l.copy();
    lifespan = 255;
  }

  void run() {
    update();
    display();
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 2; // Disminuye el lifespan más rápido
  }

  void display() {
    stroke(255, lifespan);
    fill(0,0,255, lifespan);
    ellipse(position.x, position.y, 10, 10);
  }

  boolean isDead() {
    return lifespan < 0;
  }
}
