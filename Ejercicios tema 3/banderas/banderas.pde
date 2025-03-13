//Simulación de banderas
//Autor: Sergi Sanz Sancho

// Camera 3D
import peasy.*;
PeasyCam cam;

// Generamos tres mallas 
Malla m1, m2, m3;

// Tipos de estructura
final int STRUCTURED = 1;
final int BEND = 2;
final int SHEAR = 3;

// Tamaño de la malla
int puntosX;
int puntosY;

// Valor del paso de simulación
float dt = 0.1;

// Parámetros
PVector g = new PVector (0,0,0); //gravedad
PVector wind = new PVector (0,0,0); //wind

// Variables booleanas
boolean viento_activo = false;
boolean gravedad_activa = false;


void setup()
{
  size (1000, 700, P3D);
  smooth();
  
  // Camara
  cam = new PeasyCam(this, 500, 0, 0, 600);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(1000);
  
  // Mallas rectangulares
  puntosX = 70;
  puntosY = 40;
  
  // Creación de las mallas
  m1 = new Malla (STRUCTURED, puntosX, puntosY);
  m2 = new Malla (BEND, puntosX, puntosY);
  m3 = new Malla (SHEAR, puntosX, puntosY);
}

void draw()
{
  background(255);
  translate(100, 0, 0);
  
  // Viento
  if (viento_activo)
  {
    wind.x = 0.5 - random(10, 40) * 0.1;
    wind.y = 0.1 - random(0, 0.2);
    wind.z = 0.5 + random(10, 60) * 0.1;

  }
  else
  {
    wind.x = 0; 
    wind.y = 0;
    wind.z = 0;
  }
  
  // Gravedad
  if (gravedad_activa)
    g.y = 4.9;
  else
    g.y = 0;
  
  // Bandera tipo STRUCTURED
  line(0, 0, 0, 255);
  color c = color(275, 150, 180);
  
  m1.update();
  m1.display(c);
  
  // Bandera tipo BEND
  color c2 = color(200, 275, 100);
  
  m2.update();
  pushMatrix();
  translate(300, 0, 0);
  line(0, 0, 0, 255);
  
  m2.display(c2);
  popMatrix();
  
  // Bandera tipo SHEAR
  color c3 = color(100, 100, 100);
  
  m3.update();
  pushMatrix();
  translate(600, 0, 0);
  line(0, 0, 0, 255);
  
  m3.display(c3);
  popMatrix();
  
  drawStaticEnvironment();
}

void drawStaticEnvironment()
{
  //Dibuja el texto con los datos
  fill (0);
  textSize(20);
  
  text("Presiona W para activar/desactivar el viento", 0, -300, 0);
  text("Presiona G para activar/desactivar la gravedad", 0, -275, 0);
  
  text("Viento: " + viento_activo, 600, -300, 0);
  text("Gravedad: " + gravedad_activa, 600, -275, 0);
    
  text("Tipo STRUCTURED", 0, -200, 0);
  text("K: " + m1.k, 0, -175, 0);
  text("Damping: " + m1.damping, 0, -150, 0);
  
  text("Tipo BEND", 300, -200, 0);
  text("K: " + m2.k, 300, -175, 0);
  text("Damping: " + m2.damping, 300, -150, 0);
  
  text("Tipo SHEAR", 600, -200, 0);
  text("K: " + m3.k, 600, -175, 0);
  text ("Damping: " + m3.damping, 600, -150, 0);
  
  line(-100, 255, width, 255);
}

void keyPressed()
{
  if (key == 'w' || key == 'W')
  {
    viento_activo = !viento_activo;
  }
  
  if (key == 'g' || key == 'G')
  {
    gravedad_activa = !gravedad_activa;
  }
}
