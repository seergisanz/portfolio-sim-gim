// Class for a particle system controller
class ParticleSystem
{
   PVector _location;
   ArrayList<Particle> _particles;
   int _nextId;

   Grid _grid;
   HashTable _hashTable;
   CollisionDataType _collisionDataType;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      _nextId = 0;

      _grid = new Grid(SC_GRID);
      _hashTable = new HashTable(SC_HASH, NC_HASH);
      _collisionDataType = CollisionDataType.NONE;
   }

   void addParticle(float mass, PVector initPos, PVector initVel, float radius, color c)
   {
      PVector s = PVector.add(_location, initPos);
      _particles.add(new Particle(this, _nextId, mass, s, initVel, radius, c));
      _nextId++;
   }

   void restart()
   {
      _particles.clear();
   }

   void setCollisionDataType(CollisionDataType collisionDataType)
   {
      _collisionDataType = collisionDataType;
   }

   int getNumParticles()
   {
      return _particles.size();
   }

   ArrayList<Particle> getParticleArray()
   {
      return _particles;
   }

   void updateCollisionData()
   {
      //
      //
      //  
   }

   void updateGrid()
   {
      //
      //
      //  
   }

   void updateHashTable()
   {
      //
      //
      // 
   }

   void computePlanesCollisions(ArrayList<PlaneSection> planes) {
       for (int i = 0; i < _particles.size(); i++)  //Para cada partícula
       {
          Particle p = _particles.get(i);
          p.planeCollision(planes);
       }
   }


   void computeParticleCollisions(float timeStep)
    {
      for (int i = 0; i < _particles.size(); i++)  //Para cada partícula
       {
          Particle p = _particles.get(i);
          p.particleCollision(timeStep);
       } 
   }

   void update(float timeStep)
   {
      for (int i = 0; i < _particles.size(); i++)
      {
         Particle p = _particles.get(i);
         p.update(timeStep);
      }
   }

   void render()
   {
      for (int i = 0; i < _particles.size(); i++) 
      {
        Particle p = _particles.get(i);      
        p.render();
    }
   }
}
