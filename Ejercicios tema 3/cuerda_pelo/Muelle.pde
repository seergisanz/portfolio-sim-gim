//Clase muelle --> actualiza las variables correspondientes al muelle (fuerza elástica y de amortiguación, elongación...)
//Declara algunas constantes importantes como la constante elástica o de amortiguación

class Muelle
{
  PVector ancho, fA, fB;
  
  float len;
  float k = 80, Epe;
  float am = 10;
  float el;
  
  Extremo a;
  Extremo b;
  
  Muelle (Extremo a_, Extremo b_, float l)
  {
    a = a_;
    b = b_;
    len = l;
    ancho = new PVector(b.p.x - a.p.x, b.p.y - a.p.y);
    fA = new PVector();
    fB = new PVector();
  }
  
  //Función que actualiza las fuerzas del muelle en distintos sentidos
  void update()
  {
    ancho.x = b.p.x - a.p.x;
    ancho.y = b.p.y - a.p.y;
    el = ancho.mag() - len; //obtenemos la elongación actual
    ancho.normalize();
    
    //Suma de fuerzas que se ejercen sobre los muelles:
    fA.x = k* ancho.x* el - (a.v.x - b.v.x)*am; //Fuerza elástica - Fuerza damping o de amortiguamiento
    fA.y = k* ancho.y* el - (a.v.y - b.v.y)*am; //Fuerza elástica - Fuerza damping o de amortiguamiento
    a.applyForce(fA);  //Esta fuerza se debe aplicar a los dos extremos
    
    fB.x = -k* ancho.x* el - (b.v.x - a.v.x)*am;
    fB.y = -k* ancho.y* el - (b.v.y - a.v.y)*am;
    b.applyForce(fB);
  }
  void display()
  {
    strokeWeight(2);
    stroke(0);
    line(a.p.x, a.p.y, b.p.x, b.p.y);
  }
}
