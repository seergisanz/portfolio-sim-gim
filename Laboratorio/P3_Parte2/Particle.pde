// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
   ArrayList neighbours;
      
   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c)
   {
      _ps = ps;
      _id = id;
      _m = m;
      
      _s = s;
      _v = v;
      _radius = radius;
      _color = c;
      _F = new PVector(0.0, 0.0);
      _a = new PVector(0.0, 0.0);
       neighbours = new ArrayList<Particle>();
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

   float getRadius()
   {
      return _radius;
   }

   float getColor()
   {
      return _color;
   }

   void update(float timeStep)
   {
     updateForce();
     PVector f = _F.copy();

    _a = PVector.div(f, _m);
    _v.add(PVector.mult(_a, timeStep));
    _s.add(PVector.mult(_v, timeStep));
   }

   void updateForce()
   {   
      PVector Fr = PVector.mult(_v, -KD);
      PVector Fg = PVector.mult(GV, _m);
      _F = PVector.add(Fr, Fg);
      
   }

   void planeCollision(ArrayList<PlaneSection> planes)
   {
      for (int i=0; i<planes.size(); i++){
       PlaneSection pln = planes.get(i);
       
       float delta_s = pln.getDistance(_s);
       
       //deteccion
       if(delta_s<_radius){

         //restitucion
         PVector new_pos= PVector.add(_s , PVector.mult(pln.getNormal(),_radius-delta_s));
         _s=new_pos;
         //v salida (invertir normal)
         float normal_mag= PVector.dot(_v,pln.getNormal());
         PVector Vnormal = PVector.mult(pln.getNormal(),normal_mag);
         PVector Vtang = PVector.sub(_v,Vnormal);
         PVector Vtang_roz = PVector.mult(Vtang,CR1);
         PVector salida=  PVector.sub(Vtang_roz,Vnormal);
         _v= salida;
       }
       
      }
   }


   void particleCollision(float timeStep)
   {
     ArrayList<Particle> system = new ArrayList<Particle>();
    int totalParticle = 0;
    switch (_ps._collisionDataType){
      case NONE:
        totalParticle = _ps.getNumParticles();
        system = _ps.getParticleArray();
        break;
      case HASH:
        updateNeighborsHash(_ps._hashTable);
        totalParticle = neighbours.size();
        system = neighbours;
        break;
      case GRID:
        updateNeighborsGrid(_ps._grid);
        totalParticle = neighbours.size();
        system = neighbours;
        break;
    }
    
    for (int i = 0 ; i < totalParticle; i++)
    {
      if(_id != i)
      {
        Particle p = system.get(i);
        
        PVector vcol = PVector.sub(p._s, _s);
        float distance = vcol.mag();
        
        if(distance < DM)
        {
          float angle = atan2(vcol.y, vcol.x);
        
        float targetX = _s.x + cos(angle) * L0;
        float targetY = _s.y + sin(angle) * L0;
        
        float ax = (targetX - p._s.x) * AMORTIGUACION + KE*_v.x;
        float ay = (targetY - p._s.y) * AMORTIGUACION + KE*_v.y;
        
        _v.x -= ax;
        _v.y -= ay;
        p._v.x += ax;
        p._v.y += ay;
        
        p._v.mult(AMORTIGUACION);
        _v.mult(AMORTIGUACION);
        }
      }
    }
    
   }

   void updateNeighborsGrid(Grid grid)
   {
      PVector a, b, c, d;
      int cellA, cellB, cellC, cellD;
      neighbours.clear();
      
      a = new PVector(_s.x - _radius, _s.y - _radius);
      b = new PVector(_s.x + _radius, _s.y - _radius);
      c = new PVector(_s.x + _radius, _s.y + _radius);
      d = new PVector(_s.x - _radius, _s.y + _radius);
      
      cellA = grid.getCelda(a);
      cellB = grid.getCelda(b);
      cellC = grid.getCelda(c);
      cellD = grid.getCelda(d);
      
      
      for(int i=0; i< grid._cells.get(cellA).size(); i++){
        Particle part = grid._cells.get(cellA).get(i);
        neighbours.add(part);
    } 
    if(cellB != cellA){
      for(int i=0; i< grid._cells.get(cellB).size(); i++){
        Particle part = grid._cells.get(cellB).get(i);
        neighbours.add(part);
    }  
    }
    if(cellC != cellA && cellC != cellB){
      for(int i=0; i< grid._cells.get(cellC).size(); i++){
        Particle part = grid._cells.get(cellC).get(i);
        neighbours.add(part);
    } 
    }
    if(cellD != cellA && cellD != cellB && cellD != cellC){
      for(int i=0; i< grid._cells.get(cellD).size(); i++){
          Particle part = grid._cells.get(cellD).get(i);
          neighbours.add(part);
      }
    }

   }

   void updateNeighborsHash(HashTable hashTable)
   {
      PVector a, b, c, d;
      int cellA, cellB, cellC, cellD;
      neighbours.clear();
      
      a = new PVector(_s.x - _radius, _s.y - _radius);
      b = new PVector(_s.x + _radius, _s.y - _radius);
      c = new PVector(_s.x + _radius, _s.y + _radius);
      d = new PVector(_s.x - _radius, _s.y + _radius);
      
      cellA = hashTable.hash(a);
      cellB = hashTable.hash(b);
      cellC = hashTable.hash(c);
      cellD = hashTable.hash(d);
      
      for(int i = 0; i < hashTable._table.get(cellA).size(); i++)
      {
        Particle p = hashTable._table.get(cellA).get(i);
        neighbours.add(p);
      }
      
      if(cellB != cellA)
      {
        for(int i = 0; i < hashTable._table.get(cellB).size(); i++)
        {
          Particle p = hashTable._table.get(cellB).get(i);
          neighbours.add(p);
        }
      }
      
      if(cellC != cellA && cellC != cellB)
      {
        for(int i = 0; i < hashTable._table.get(cellC).size(); i++)
        {
          Particle p = hashTable._table.get(cellC).get(i);
          neighbours.add(p);
        }
      }
      
      if(cellD != cellA && cellD != cellB && cellD != cellC)
      {
        for(int i = 0; i < hashTable._table.get(cellD).size(); i++)
        {
          Particle p = hashTable._table.get(cellD).get(i);
          neighbours.add(p);
        }
      }
    }

   void render(color c) {
    fill(c);
    stroke(0);
    strokeWeight(1);
    ellipse(_s.x, _s.y, 2 * _radius, 2 * _radius);
    
   }
}
