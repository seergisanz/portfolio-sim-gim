import peasy.*;

final int _MAP_SIZE = 150;
final float _MAP_CELL_SIZE = 10f;

boolean _viewmode = false;
boolean _clear = false;
boolean cambio = true;
boolean lluvia = true;
Gota gota;

PeasyCam camera;

HeightMap map;
PImage img, img2, img3, img4, imgaux;

float amplitude = 2f; //Amplitud de la onda
float dx = 1; //Dirección en x
float dz = 1; //Dirección en z
float wavelength = amplitude * (30); // Longitud de onda
float speed = wavelength / (3); // Velocidad de propagación
float masagota = 5000; // Masa de la gota
float radiogota = 10; // Radio de la gota
color colorgota = color (100, 100, 255); // Color de la gota
PVector posinicial = new PVector(0, -2000, 0); // Posicion inicial de la gota 
PVector velinicial = new PVector(0,5000,0); // Velocidad inicial de la gota
  
public void settings() {
    System.setProperty("jogl.disable.openglcore", "true");
    size(1080,720, P3D);
    //fullScreen(P3D);
  }
void setup()
{
  gota = new Gota(posinicial, velinicial, masagota, 10, colorgota);     
  //size(1024,768,P3D);
  //fullScreen(P3D);

  img = loadImage("mar.jpg");
  img2 = loadImage("cielo.jpg");
  imgaux = loadImage("mar.jpg");
  
  img3 = loadImage("mar2.jpg");
  img4 = loadImage("cielo2.jpg");
  camera = new PeasyCam(this,100);
  camera.setMinimumDistance(50);
  camera.setMaximumDistance(2500);
  camera.setDistance(400);
  map = new HeightMap(_MAP_SIZE, _MAP_CELL_SIZE);
  if(cambio){
  println(img.width + " : " + img.height);
  }else{
  println(img3.width + " : " + img3.height);
  }
}

void draw()
{

  if(cambio){
   background(img2);
  } else{
    background(img4);
  }
  lights();
  map.update();
  if(_viewmode) map.presentWired();
  else map.present();
  //presentAxis();
  drawInteractiveInfo();
  if(_clear)
  {
    map.waves.clear();
    map.waveArray = new Wave[0];
    _clear = false;
  }
    //Lluvia
  if(lluvia){
  
    gota.update(0.01);
    gota.render();
    
    if(gota.getPosition().y>0){
      map.waves.clear();
      map.waveArray = new Wave[0];
      map.addWave(new WaveRadial2(amplitude,new PVector(gota.getPosition().x,0,gota.getPosition().z),wavelength/2,speed*3));//amplitude,direction,wavelength,speed
  
      float ranx =random(-_MAP_SIZE*_MAP_CELL_SIZE/2, _MAP_SIZE*_MAP_CELL_SIZE/2);
      float ranz =random(-_MAP_SIZE*_MAP_CELL_SIZE/2, _MAP_SIZE*_MAP_CELL_SIZE/2);
      
      gota.setPosition(ranx,posinicial.y,ranz);
    }
  }
}

void drawInteractiveInfo()
{
  float textSize = 50;
  float offsetX = -500;
  float offsetZ = -1000;
  float offsetY = -1000;
  
  int i = 0;
  noStroke();
  textSize(textSize);
  fill(0xff000000);
  text("z : mar tranquilo", offsetX, offsetY + textSize*(++i),offsetZ);
  text("x : mar intranquilo", offsetX, offsetY + textSize*(++i),offsetZ);
  text("c : cambio de dia y mar", offsetX, offsetY + textSize*(++i),offsetZ);
  text("v : lluvia ON/OFF", offsetX, offsetY + textSize*(++i),offsetZ);
  text("w : radial wave", offsetX, offsetY + textSize*(++i),offsetZ);
  text("e : gerstner wave", offsetX, offsetY + textSize*(++i),offsetZ);
  text("r : change viewmode", offsetX, offsetY + textSize*(++i),offsetZ);
  text("t : reset", offsetX, offsetY + textSize*(++i),offsetZ);
}

void keyPressed()
{
  //float amplitude = random(2f)+8f;
  //float dx = random(2f)-1; //Dirección en x
  //float dz = random(2f)-1; //Dirección en z
  //float wavelength = amplitude * (30 + random(2f));
  //float speed = wavelength / (1+random(3f));
  

  
  //amplitude,direction,wavelength,speed
  if(key == 'z'){    
    map.addWave(new WaveDirectional(amplitude/2, new PVector(dx,0,0), wavelength, 2*speed));    
    map.addWave(new WaveDirectional(amplitude/2, new PVector(dx,0,0), wavelength, 1.4*speed));

    map.addWave(new WaveDirectional(amplitude, new PVector(dx,0,dz), wavelength, 2*speed));
    map.addWave(new WaveGerstner(amplitude, new PVector(dx,0,dz), wavelength, 1.4*speed));
    
    map.addWave(new WaveDirectional(amplitude, new PVector(dx,0,dz*2), wavelength, 2*speed));
    map.addWave(new WaveGerstner(amplitude, new PVector(dx,0,dz*2), wavelength, 1.4*speed));


  }
  if(key == 'x'){
    map.addWave(new WaveRadial(amplitude*10,new PVector(0,0,0),wavelength*3,speed*3));//amplitude,position,wavelength,speed
    map.addWave(new WaveDirectional(amplitude*9, new PVector(0,0,dz), wavelength*7, 5*speed));    
    map.addWave(new WaveGerstner(amplitude*6, new PVector(dx*1.5,0,dz), wavelength*5, 7*speed));    
  }
  if(key == 'c'){
      if(cambio){
        img = img3;
  }else{
        img = imgaux;
  }
    cambio = !cambio;
  }
  if(key == 'q')
  {
    map.addWave(new WaveDirectional(amplitude,new PVector(dx,0,dz),wavelength,speed));//amplitude,direction,wavelength,speed
  }
  if(key == 'w')
  {
    map.addWave(new WaveRadial(amplitude,new PVector(dx*(_MAP_SIZE*_MAP_CELL_SIZE/2f),0,dz*(_MAP_SIZE*_MAP_CELL_SIZE/2f)),wavelength,speed));//amplitude,direction,wavelength,speed
  }
  if(key == 'e')
  {
    map.addWave(new WaveGerstner(amplitude,new PVector(dx,0,dz),wavelength,speed));//amplitude,direction,wavelength,speed
  }
    if(key == 'v')
  {
    lluvia = !lluvia;
  }
  if(key == 'r')
  {
    _viewmode = !_viewmode;
  }
  if(key == 't')
  {
    _clear = true;
  }
  
  if(key == '1')
  {
    map.waves.get(0).W -=.001;  
  }
  
  if(key == '2')
  {
    map.waves.get(0).W +=.001;  
  }
  
  if(key == '3')
  {
    map.waves.get(0).phi -=.1;  
  }
  
  if(key == '4')
  {
    map.waves.get(0).phi +=.1;  
  }
  
  if(key == '5')
  {
    map.waves.get(0).A -=1;  
  }
  
  if(key == '6')
  {
    map.waves.get(0).A +=1;  
  }
}



void presentAxis()
{
  float axisSize = _MAP_SIZE*2f;
  stroke(0xffff0000);
  line(0,0,0,axisSize,0,0);
  stroke(0xff00ff00);
  line(0,0,0,0,-axisSize,0);
  stroke(0xff0000ff);
  line(0,0,0,0,0,axisSize);
}
