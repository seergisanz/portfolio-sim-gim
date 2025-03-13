// Class Particle
class Particle {
  PVector loc;
  PVector vel;
  PVector accel;
  float lifespan; // Tiempo de vida de la partícula

  Particle(PVector location, PVector velocity) {
    loc = location.copy();
    vel = velocity;
    accel = new PVector(0, 0.05); // Ligera gravedad
    lifespan = 255;
  }

  void update() {
    vel.add(accel);
    loc.add(vel);
    lifespan -= 2.0;
  }

  void render() {
    stroke(0);
    fill(0, 180, 180, lifespan); // Color cyan con transparencia según el tiempo de vida
    ellipse(loc.x, loc.y, 8, 8);
  }

  boolean isDead() {
    return lifespan <= 0;
  }

  void run() {
    update();
    render();
  }
}
