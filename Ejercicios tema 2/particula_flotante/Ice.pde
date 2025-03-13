// Class Ice
class Ice {
  PVector loc, vel, accel;
  float rad;
  float mass = 1000;
  float density = 0.1;
  float gravity = 9.801;
  float timeStep = 0.1;
  PVector gravityVec = new PVector(0.0, gravity);
  float waterLine = height / 2;
  float dragCoeff = 200;
  boolean isAboveWater = true;

  Ice(float x, float y, float radius) {
    loc = new PVector(x, y);
    vel = new PVector(0, 0);
    accel = new PVector(0, 0);
    rad = radius;
  }

  void updateSimulation() {
    calculateForces();
    integrate();
  }

  void calculateForces() {
    accel.set(0, 0);
    applyForce(computeGravityForce());
    applyForce(computeBuoyancy());
    if (!isAboveWater) {
      applyForce(computeDrag());
    }
  }

  PVector computeGravityForce() {
    return PVector.mult(gravityVec, mass);
  }

  PVector computeBuoyancy() {
    float volume = calculateSubmergedVolume();
    float buoyancyForce = density * gravity * volume;
    return new PVector(0, -buoyancyForce);
  }

  PVector computeDrag() {
    return new PVector(0, -dragCoeff * vel.y);
  }

  float calculateSubmergedVolume() {
    float depth = loc.y + rad - waterLine;
    if (depth <= 0) {
      isAboveWater = true;
      return 0;
    }
    isAboveWater = false;
    if (depth >= 2 * rad) {
      return (4/3) * PI * pow(rad, 3); // Fully submerged
    }
    float a = sqrt(2 * depth * rad - pow(depth, 2));
    return (3 * pow(a, 2) + pow(depth, 2)) * PI * depth / 6;
  }

  void applyForce(PVector force) {
    PVector accelerationIncrement = PVector.div(force, mass);
    accel.add(accelerationIncrement);
  }

  void integrate() {
    vel.add(PVector.mult(accel, timeStep));
    loc.add(PVector.mult(vel, timeStep));
  }

  void render() {
    fill(0, 180, 180);
    noStroke();
    rect(loc.x, loc.y, 2 * rad, 2 * rad);
  }
}
