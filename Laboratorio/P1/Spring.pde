  // Authors: 
  // Sergi Sanz
  // Carlos Marques
  // Class for a simple spring with no damping
  public class Spring
  {
     PVector _pos1;   // First end of the spring (m)
     PVector _pos2;   // Second end of the spring (m)
     float _Ke;       // Elastic constant (N/m)
     float _l0;       // Rest length (m)
  
     float _energy;   // Energy (J)
     PVector _F;      // Force applied by the spring towards pos1 (the force towards pos2 is -_F) (N)
  
     Spring(PVector pos1, PVector pos2, float Ke, float l0)
     {
        _pos1 = pos1;
        _pos2 = pos2;
        _Ke = Ke;
        _l0 = l0;
        _energy = 0.0;
        _F = new PVector(0.0, 0.0);
        setRestLength(L0);
        setKe(KE);
     }
  
     void setV(PVector v)
     {
        _v = v;
     }
     
     void setPos1(PVector pos1)
     {
        _pos1 = pos1;
     }
  
     void setPos2(PVector pos2)
     {
        _pos2 = pos2;
     }
  
     void setKe(float Ke)
     {
        _Ke = Ke;
     }
  
     void setRestLength(float l0)
     {
        _l0 = l0;
     }
  
     //Calcula la fuerza elástica del muelle 
     void update()
     {
       //L-L0
       float elongation = PVector.dist(_pos2, _pos1) - _l0; 
       PVector direction = PVector.sub(_pos2, _pos1).normalize();
       
       //FE
       float fe = -_Ke*elongation;
       
       _F = direction.mult(fe);
     
       updateEnergy();
     }
  
     void updateEnergy()
     {
       //Energia potencial elastica: Ee = 1/2 * Ke*(l-l0)^2
       float Le = _pos2.copy().sub(_pos1).mag();  // l = s - C
       float res = Le - _l0;
       
       _energy = 0.5 * _Ke * (res*res);
     }
  
     float getEnergy()
     {
        return _energy;
     }
  
     PVector getForce()
     {
        return _F;
     }
  }
