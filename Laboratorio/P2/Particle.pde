// Authors: 
// Sergi Sanz
// Carlos Marques

// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle (-)

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)
   float _energy;       // Energy (J)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
   float _lifeSpan;     // Total time the particle should live (s)
   float _timeToLive;   // Remaining time before the particle dies (s)
   float randomx = randomGaussian() * FACTORRANDOMX;
   float randomy = randomGaussian()* FACTORRANDOMY;
   PVector randv = new PVector(randomx, randomy);
   
   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c, float lifeSpan)
   {
      _ps = ps;
      _id = id;

      _m = m;
      _s = s;
      _v = v;

      _a = new PVector(0.0, 0.0);
      _F = new PVector(0.0, 0.0);
      _energy = 0.0;

      _radius = radius;
      _color = c;
      _lifeSpan = lifeSpan;
      _timeToLive = _lifeSpan;
   }

   void setPos(PVector s)
   {
      _s = s;
   }

   void setVel(PVector v)
   {
      _v = v;
   }

   PVector getForce()
   {
      return _F;
   }

   float getEnergy()
   {
      return _energy;
   }

   float getRadius()
   {
      return _radius;
   }

   float getColor()
   {
      return _color;
   }

   float getTimeToLive()
   {
      return _timeToLive;
   }

   boolean isDead()
   {
      return (_timeToLive <= 0.0);
   }

   void update(float timeStep)
   {
      _timeToLive -= timeStep;

      updateSimplecticEuler(timeStep);
      updateEnergy();
   }

   void updateSimplecticEuler(float timeStep)
   {
      updateForce();
      
      _a = PVector.div(_F, _m);
      _v.add(PVector.mult(_a, timeStep));
      _s.add(PVector.mult(_v, timeStep));
      _s.add(PVector.mult(randv, timeStep));

   }

   void updateForce() {
      // Fuerza peso (gravitatoria)
      PVector Fpeso = PVector.mult(GV, _m);

      // Fuerza de fricción
      float velocidadCuadrado = _v.magSq();
      PVector Froz = _v.copy(); // Crear una copia de _v para no modificar su valor original
      Froz.mult(-KD * velocidadCuadrado); // Multiplicar por el factor de fricción

      float dirViento = map(mouseX, 0, width, -0.2, 0.2);
      
      PVector viento = new PVector(dirViento, 0);
      
      // Fuerza total
      _F = PVector.add(Fpeso, Froz);
      _F = _F.add(viento);
  }

   void updateEnergy()
   {
      // Energía cinética: 1/2 * masa * v^2
      float EK = 0.5 * _m * _v.magSq();   
      // Energía gravitacional: masa * g * altura
      float EG = _m * GV.y * (_s.y - C.y);
    
      _energy = EK + EG;
   }

   void render(boolean useTexture)
   {
      if (useTexture)
      {
         imageMode(CENTER);
         tint(255, _lifeSpan * TINTA_TEXTURA);
         image(_ps._tex, _s.x, _s.y + randomy);  
      } 
      else
      {
         fill(255, _timeToLive*255);
         noStroke();
         ellipse(_s.x, _s.y + randomy, R, R);
      }
   }
}
