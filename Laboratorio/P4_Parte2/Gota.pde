public class Gota extends Particle
{
   float _r;       // Radius (m)
   color _color;   // Color (RGB)


   Gota(PVector s, PVector v, float m, float r, color c)
   {
      super(s, v, m, false, false);

      _r = r;
      _color = c;
   }

   float getRadius()
   {
      return _r;
   }

   void render() {
        pushMatrix();
        {
            translate(_s.x, _s.y, _s.z);
            stroke(_color);
            strokeWeight(5); // Grosor de la línea

            // Dibuja una línea vertical desde la posición actual hacia abajo
            line(0, 0, 0, 0, _r*2, 0);
        }
        popMatrix();
    }
    
    public void setPosition(float x,float y,float z){
      _s.x=x;
      _s.y=y;
      _s.z=z;
    }
}
