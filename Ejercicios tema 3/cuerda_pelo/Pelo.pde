//Clase pelo: creación del sistema de pelos mediante muelles y extremos

class Pelo
{
  float _longitud;
  int _nmuelles, _npelos;
  float _Lmuelle;
  PVector _origen;
  
  Extremo[] vExtr = new Extremo[N_MUELLES+1];
  Muelle[] vMuelles = new Muelle[N_MUELLES];
  
  Pelo (float longitud, int nmuelles, PVector origen)
  {
    _longitud = longitud;
    _nmuelles = nmuelles;
    _Lmuelle = longitud/nmuelles;
    _origen = origen;
    
    for(int i = 0; i < vExtr.length; i++)
      vExtr[i] = new Extremo (_origen.x + i *_Lmuelle, origen.y); //inicialización de extremos
    
    for (int i = 0; i<vMuelles.length; i++)
      vMuelles[i] = new Muelle(vExtr[i], vExtr[i+1], _Lmuelle); //inicialización de los muelles que unen los extremos
  }
  
  void update()
  {
    for (Muelle m: vMuelles)
    {
      m.update();
      m.display();
    }
    
    //El bucle deberá empezar desde 1 (y no de 0) para que el primer punto del pelo se quede fijo en la pantalla
    for (int i = 1; i < vExtr.length; i++)
    {
      vExtr[i].update();
      vExtr[i].display();
      vExtr[i].drag(mouseX, mouseY); //recogida de coordenadas de ratón
    }
  }
  
  void on_click()
  {
    for(Extremo b: vExtr)
      b.clicked(mouseX, mouseY); //recogida de coordenadas de ratón
  }
  
  void release()
  {
    for (Extremo b: vExtr)
      b.stopDragging();
  }
  
}
