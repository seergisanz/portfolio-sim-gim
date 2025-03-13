// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _v_initial;  // Stored initial velocity for resets
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
   //
   //
   //
      
   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c)
   {
      _ps = ps;
      _id = id;
      _m = m;
      
      _s = s;
      _v = v;
      _v_initial = v.copy();  // Store the initial velocity v0
      _radius = radius;
      _color = c;
      _F = new PVector(0.0, 0.0);
      _a = new PVector(0.0, 0.0);
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
    if(!_atrac)
       _F = PVector.mult(_v, -KD);
    else{
       PVector Fr = PVector.mult(_v, -KD);
       PVector Fg = new PVector(5, 5);
       _F = PVector.add(Fr, Fg);
    }
      
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
     ArrayList<Particle> particulas = _ps.getParticleArray();
     for(int i=0; i< particulas.size(); i++){
       Particle p = particulas.get(i);
       if(p._id != _id){
         
         PVector dist = PVector.sub(p._s,_s);
         float distmag = dist.copy().mag();
         PVector dist2 = PVector.sub(_s, p._s);
         
         //Deteccion (bn)
         if(distmag < (_radius+p._radius)){
              //Restitucion
              float L= _radius + p._radius - distmag;
              
              //Descomposicion de la v inicial
              float Vn_p1_escalar = PVector.dot(_v, dist.copy().normalize());
              PVector Vn = PVector.mult(dist.copy().normalize(), Vn_p1_escalar);
              PVector Vt_roz_p1 = PVector.mult(PVector.sub(_v, Vn), CR2);
             
              float Vn_p2_escalar = PVector.dot(p._v, dist2.copy().normalize());
              PVector Vn_p2 = PVector.mult(dist2.normalize(), Vn_p2_escalar);
              PVector Vt_roz_p2 = PVector.mult(PVector.sub(_v, Vn_p2), CR2);
              
              //Vrel
              float vrel_mag = PVector.sub(Vn, Vn_p2).mag();
              PVector nuevapos_p1 = PVector.add(_s, PVector.mult(Vn, -L/vrel_mag));
              PVector nuevapos_p2 = PVector.add(p._s, PVector.mult(Vn_p2, -L/vrel_mag));
              
              //Velocidades de salida
              float u1 = PVector.dot(Vn, dist.copy().normalize());
              float u2 = PVector.dot(Vn_p2, dist2.copy().normalize());
              
              float v1 = (((_m -p._m)*u1 + 2*u2*p._m)/(_m + p._m));
              float v2 = (((p._m - _m)*u2 + 2*u1*_m)/(p._m + _m));
              
              Vn = PVector.mult(Vn.copy().normalize(), v1);
              Vn_p2 = PVector.mult(Vn_p2.copy().normalize(), v2);
              
              PVector Vsal_p1 = PVector.sub(Vt_roz_p1, Vn);
              PVector Vsal_p2 = PVector.sub(Vt_roz_p2, Vn_p2);
              
              //Asignamos nuevas posiciones y velocidades
              _s = nuevapos_p1;
              p._s = nuevapos_p2;
              
              _v = Vsal_p1;
              p._v = Vsal_p2;
                    
         }
              
       }
         
     }
   }

   void updateNeighborsGrid(Grid grid)
   {
      //
      //
      //
   }

   void updateNeighborsHash(HashTable hashTable)
   {
      //
      //
      //
   }

   void render() {
    fill(_color);
    stroke(0);
    strokeWeight(1); // Ajusta este valor para un trazo más o menos sutil
    ellipse(_s.x, _s.y, 2 * _radius, 2 * _radius);
    
   }


}
