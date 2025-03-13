// Class Ice
class Ice {
  PVector loc, vel, accel;
  float rad;
  float mass = 1000; // Masa
  float density = 0.1; // Densidad
  float gravity = 9.801; // Constante gravitatoria
  float timeStep = 0.1;
  PVector gravityVec = new PVector(0.0, gravity);
  float waterLine = height / 2;
  float dragCoeff = 200; // Coeficiente de arrastre
  boolean hasExploded = false; // Controla si ya explotó

  Ice(float x, float y, float radius) {
    loc = new PVector(x, y);
    vel = new PVector(0, 0);
    accel = new PVector(0, 0);
    rad = radius;
  }

  void updateSimulation(ParticleSystem ps) {
    if (!hasExploded) {
      applyForce(computeGravityForce()); // Aplicar gravedad constantemente
      integrate();

      // Checkea si el iceberg alcanza la línea de agua
      if (loc.y + rad >= waterLine) {
        loc.y = waterLine - rad; // Posicionar exactamente en la línea de agua
        explode(ps);
      }
    }
  }

  void explode(ParticleSystem ps) {
    hasExploded = true; // Marcar que ya explotó
    ps.addSplashParticles(loc, 50); // Crear una gran explosión
  }

  PVector computeGravityForce() {
    return PVector.mult(gravityVec, mass);
  }

  void applyForce(PVector force) {
    PVector accelerationIncrement = PVector.div(force, mass);
    accel.add(accelerationIncrement);
  }

  void integrate() {
    vel.add(PVector.mult(accel, timeStep));
    loc.add(PVector.mult(vel, timeStep));
    accel.set(0, 0); // Resetear la aceleración después de cada integración
  }

  void render() {
    if (!hasExploded) {
      fill(0, 180, 180); // Color cyan
      noStroke();
      rect(loc.x - rad, loc.y - rad, 2 * rad, 2 * rad);
    }
  }
}
