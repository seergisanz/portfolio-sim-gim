//Simulación de cuerda elástica / pelo
//Autor: Sergi Sanz Sancho

final int N_MUELLES = 20; //Variable que se puede modificar dependiendo del efecto más o menos realista que queramos 
int Lcuerda = 150;
float lmuelle = Lcuerda/N_MUELLES;

float [] vE = new float [700];
int t = 0;

int N_PELOS = 50; //Podemos modificar este valor para añadir más pelos a la simulación
Pelo pelo;
Pelo[] Pelos = new Pelo[N_PELOS];

void setup()
{
  size (1000, 700);
  //fullScreen();
  
  for (int np = 0; np < N_PELOS; np++)
  {
    PVector ini = new PVector (width * 0.3 + random(100), height * 0.3 + random(100)); //Se inicializarán en posiciones random 
    pelo = new Pelo (Lcuerda, N_MUELLES, ini);
    Pelos[np] = pelo;
  }
  
}

void draw()
{
  background(255);
  float Etotal = 0;
  fill(255,0,0);
  
  for (int np =0; np < N_PELOS; np++)
  {
    Pelos[np].update();
  }
}

//interfaz de usuario --> se modelará mediante una función que detecta cuándo se ha seleccionado (o soltado) un pelo y se está arrastrando
void mousePressed()
{
  for (int np = 0; np < N_PELOS; np++)
    Pelos[np].on_click();
}

void mouseReleased()
{
  for(int np = 0;np<N_PELOS;np++)
    Pelos[np].release();
}

void plot_func(int time, int x, int y, int x1, int y1)
{
  stroke(200, 10, 0);
  strokeWeight(3);
  fill(153);
  rect(x, y, x1, y1);
  stroke(200, 210, 0);
  
  strokeWeight(1);
  stroke(255);
  
  for (int i = 0; i<time; i++)
    point(i, 600*0.5 - (vE[i] /6.5e5)*600);
}
