// Class ParticleSystem
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  void addSplashParticles(PVector location, int count) {
    for (int i = 0; i < count; i++) {
      // Crear un ángulo que simule una salpicadura más realista
      float angle = random(PI/4, 3*PI/4); // Limitar el ángulo para una dispersión hacia arriba
      float speed = random(1, 3); // Velocidades moderadas
      PVector vel = new PVector(cos(angle) * speed, -sin(angle) * speed); // Dirección principalmente hacia arriba
      particles.add(new Particle(location, vel)); // Creación de partículas con velocidad
    }
  }

  void run() {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
