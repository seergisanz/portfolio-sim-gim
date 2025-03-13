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
      _collisionDataType = CollisionDataType.GRID;
   }
   

   void addParticle(float mass, PVector initPos, PVector initVel, float radius, color c)
   {
      PVector s = PVector.add(_location, initPos);
      _particles.add(new Particle(this, _nextId, mass, s, initVel, radius, c));
      _nextId++;
   }
   
   void addParticleGroup(int x, int y){
    int posx = x;
    int posy = y;
    int _n = getNumParticles();
  
    for(int i = 0; i < 10; i++){
      for (int j = 0; j < 10; j++){
          PVector pos = new PVector(posx,posy);
          PVector vel = new PVector(0,0);
          addParticle(M, pos, vel, R, color(0,0,255));
          posx += 1.2*10;
      }
      posx = x;
      posy += 1.2*10;
    }
    _n += 100;
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
    switch(_collisionDataType)
    {
      case NONE:
        break;
      case GRID:
        updateGrid();
        break;
      
      case HASH:
        updateHashTable();
        
        break;
    }
    

   }
   void updateGrid()
   {
      _grid.restart();
       for(Particle _part : _particles){
            _grid.insertar(_part);
          }    
   }

   void updateHashTable()
   {
     _hashTable.restart();
     for(Particle _part : _particles) {
         _hashTable.insertar(_part);
     }
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
    for (int i = _particles.size() - 1; i >= 0; i--) 
    {
      Particle p = _particles.get(i);   
      color c = color(0, 136, 255, 155);
      int celda;
      
      //Dependiendo de la estructura utilizada, los colores de las partículas serán diferentes
      switch(_collisionDataType){
        case NONE:
        c = color(0, 0, 255);
        break;
        
        case GRID:
          celda = _grid.getCelda(p._s);
          c = _grid._colors[celda];
        break;
        
        case HASH:
          celda = _hashTable.hash(p._s);
          c = _hashTable._colors[celda];
        break;
      }
      
      p.render(c);
    }
  }  

}
