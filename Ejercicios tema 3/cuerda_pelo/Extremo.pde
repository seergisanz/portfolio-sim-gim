//Clase extremo --> contiene variables relacionadas con posición, aceleración, velocidad, fuerza... 
//y algunas constantes como el paso de simulación, la masa, la gravedad...

class Extremo
{
  PVector p;
  PVector v;
  PVector a;
  float mass = 5, dt = 0.1;
  PVector gravity;
  float Ec, Ep;
  PVector peso;
  int mode;
  
  //Estas variables servirán para indicar si está siendo modificado 
  PVector drag;
  boolean dragging = false;
  
  Extremo(float x, float y)
  {
    p = new PVector(x,y);
    v = new PVector();
    a = new PVector();
    drag = new PVector();
    gravity = new PVector(0, 9.8);
    peso = new PVector();
  }
  
  void update()
  {
    v.x += a.x * dt;
    v.y += a.y * dt;
    
    p.x += v.x * dt;
    p.y += v.y * dt;
    
    a.x = 0;
    a.y = 0;
    
    peso.y = gravity.y * mass;
    applyForce(peso);
  }
  
  //Función que actualiza la aceleración mediante la fuerza que se le pasa como parámetro y la masa
  
  void applyForce(PVector force)
  {
    PVector f = force.get();
    f.div(mass);
    a.add(f);
  }
  
  void display()
  {
    stroke(0);
    strokeWeight(2);
    fill(175, 120);
    
    if (dragging)
    {
      fill(50);
    }
  }
  
  //Determina si un extremo ha sido pulsado o no
  void clicked(int x, int y)
  {
    float d = dist(x,y,p.x, p.y);
    float umbral = 5;
    
    if(d < umbral)
    {
      dragging =true;
      drag.x = p.x - x;
      drag.y = p.y - y;
    }
  }
  
  void stopDragging()
  {
    dragging = false;
    
  }
  
  //Cambia la posición del extremo según la posición del ratón
  void drag(int mx, int my)
  {
    if(dragging)
    {
      p.x = mx + drag.x;
      p.y = my + drag.y;
    }
  }
  
}
  
