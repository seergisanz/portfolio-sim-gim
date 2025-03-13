///////////////////////////////////////////////////////////////////////
//
// WAVE
//
///////////////////////////////////////////////////////////////////////

abstract class Wave
{
  
  protected PVector tmp;
  
  protected float A,C,W,Q,phi;
  protected PVector D;//Direction or centre
  
  public Wave(float _a,PVector _srcDir, float _L, float _C)
  {
    //Declaración de parámetros de onda
    tmp = new PVector();
    C = _C; //Velocidad de propagación
    A = _a; //Amplitud
    D = new PVector().add(_srcDir); //Centro (radial) o dirección de onda
    W = PI * 2f / _L; //Velocidad de onda 
    Q = PI*A*W; //Factor Q de las Ondas de Gerstner
    
    phi = C*W; //Fase de onda
  }
  
  abstract PVector getVariation(float x, float y, float z, float time);
}

///////////////////////////////////////////////////////////////////////
//
// DIRECTIONAL WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveDirectional extends Wave
{
  public WaveDirectional(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
  }
  
  public PVector getVariation(float x, float y, float z, float time){
    tmp.x = 0;
    tmp.z = 0;
    tmp.y = A * sin((D.x*x +D.z*z)*W + time*phi); //Obtención de la variación de onda mediante la distancia y ecuación de onda direccional
    return tmp;
  }
}

///////////////////////////////////////////////////////////////////////
//
// RADIAL WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveRadial extends Wave
{
  public WaveRadial(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
  }
  
  public PVector getVariation(float x, float y, float z, float time){
    tmp.x = 0;
    tmp.z = 0;
    
    float dist = (sqrt((x-D.x)*(x-D.x) + (z-D.z)*(z - D.z)));
    tmp.y = A * sin(W*dist - time*phi); //Obtención de la variación de onda mediante la distancia y ecuación de onda radial
    
    return tmp;
  }
}

class WaveRadial2 extends Wave {
  public WaveRadial2(float _a, PVector _srcDir, float _L, float _C) {
    super(_a, _srcDir, _L, _C);
  }

  public PVector getVariation(float x, float y, float z, float time){
    tmp.x = 0;
    tmp.z = 0;

    float dist = sqrt((x - D.x) * (x - D.x) + (z - D.z) * (z - D.z));
    float range = 100; // Define el rango máximo de la onda en unidades
    float decayFactor = 0.01;  // Controla qué tan rápido decae la amplitud con el tiempo
    float amplitude = A * exp(-time * decayFactor);  // Decaimiento exponencial con el tiempo

    if (dist > range) {
      amplitude = 0; // La amplitud se reduce a cero más allá del rango definido
    }

    tmp.y = amplitude * sin(W * dist - time * phi);    
    return tmp;
  }
}

///////////////////////////////////////////////////////////////////////
//
// GERSTNER WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveGerstner extends Wave
{
  public WaveGerstner(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
 
  }
  
  public PVector getVariation(float x, float y, float z, float time){
    
    //Obtención de la variación de onda mediante la distancia y ecuación de onda de Gerstner
    tmp.x = Q * A * D.x * cos(W*(D.x*x + D.z*z) + time*phi);
    tmp.z = Q * A * D.z * cos(W*(D.x*x + D.z*z) + time*phi);
    tmp.y = -A * sin(W*(D.x*x + D.z*z) + time*phi);    
    
    return tmp;
  }
}
