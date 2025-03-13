// Ejercicio 5: Simulación de un tiro parabólico //<>//
// Autor: Sergi Sanz Sancho

enum IntegratorType // Metodos numéricos
{
  NONE,
  EXPLICIT_EULER,    
  SIMPLECTIC_EULER,  
  HEUN,              
  RK2,               
  RK4                
}
// Condiciones o parametros del problema:
final float   M  = 10.0;   // Particle mass (kg)
final float   Gc = 9.8;   // Gravity constant (m/(s*s))
final PVector G  = new PVector(0.0, -Gc);   // Acceleration due to gravity (m/(s*s))
float         K  = 0.2;     // Coefieciente de rozamiento
final PVector S0 = new PVector(10.0, 10.0);   // Particle's start position (pixels)
IntegratorType integrator = IntegratorType.EXPLICIT_EULER;   // ODE integration method

PVector _s  = new PVector();   // Position of the particle (pixels)
PVector _v  = new PVector();   // Velocity of the particle (pixels/s)
PVector _a  = new PVector();   // Accleration of the particle (pixels/(s*s))
PVector _v0 = new PVector();
PVector v_a = new PVector();
PVector s_a = new PVector();   // Position of the particle (pixels)

/////////////////////////////////////////////////////////////////////
// Parameters of the numerical integration:
float         SIM_STEP = .02;   // dt = Simulation time-step (s)
float         _simTime;
////////////////////////////////////////////////////////////////////////////77

// Ley de Newton: 
//      a(s(t), v(t)) = [Froz(v(t)) + Fpeso ]/m
//      Froz = -k·v(t)
//      Fpeso = mg; siendo g(0, -9.8) m/s²
//      
// Ejemplo de fuerzas para el tiro parabolico.
PVector calculateAcceleration(PVector s, PVector v)
{
  PVector Froz  = PVector.mult(v,-K);
  PVector Fpeso = PVector.mult(G,M);
  PVector SumF  = new PVector(Froz.x, Froz.y);
  SumF.add(Fpeso);
  
  PVector a = SumF.div(M);

  return a;
  
}

void settings()
{
    size(600, 600);
}

void setup()
{
  frameRate(60);
  
  _v0.set(38.0, 80);
  _s = S0.copy();
  _v.set(_v0.x, _v0.y);
  _a.set(0.0, 0.0);
  _simTime = 0;
}

void draw()
{
  background(255);
 
  drawScene();
  updateSimulation();
  
  if (_s.y < 0){
    println(_s);
    exit();
  }
}

void drawScene() {
  int radio = 20;

  translate(0, height); // Mueve el origen al fondo de la ventana para que 'y' sea positiva hacia arriba.
  strokeWeight(3);
  noFill();

  // Dibuja la solución analítica en azul
  fill(0, 0, 200);
  circle(s_a.x, -s_a.y, radio);

  // Dibuja la aproximación numérica en rojo
  fill(200, 0, 0);
  circle(_s.x, -_s.y, radio);

  // Mostrar el método de integración actual
  fill(0); // Color negro para el texto
  textSize(25);
  text("Método: " + getMethodName(integrator), 20, -height + 30); // Posición del texto en la parte superior izquierda
}

// Función para obtener el nombre del método de integración basado en el tipo de enumeración
String getMethodName(IntegratorType type) {
  switch (type) {
    case EXPLICIT_EULER:
      return "Euler Explícito";
    case SIMPLECTIC_EULER:
      return "Euler Simpléctico";
    case HEUN:
      return "Heun";
    case RK2:
      return "RK2";
    case RK4:
      return "RK4";
    default:
      return "Ninguno";
  }
}

void updateSimulation()
{
  switch (integrator)
  {
    case EXPLICIT_EULER:
      updateSimulationExplicitEuler();
      break;
  
    case SIMPLECTIC_EULER:
      updateSimulationSimplecticEuler();
      break;
  
    case HEUN:
      updateSimulationHeun();
      break;
  
    case RK2:
      updateSimulationRK2();
      break;
  
    case RK4:
      updateSimulationRK4();
      break;
  }
  
  _simTime += SIM_STEP;
  
  // Solucion analitica de la posicion: doble integracion 
  s_a.x = S0.x + (M*_v0.x/K)*(1-exp((-K/M)*_simTime));
  s_a.y = S0.y + (M/K)*((M*Gc/K) + _v0.y)*(1-exp((-K/M)*_simTime)) - (M*Gc*_simTime)/K;
}

void updateSimulationExplicitEuler()
{

  PVector acel =  calculateAcceleration(_s, _v);
  
  _s.add(PVector.mult(_v, SIM_STEP));
  _v.add(PVector.mult(acel, SIM_STEP)); 
  
}

void updateSimulationSimplecticEuler()
{

  PVector acel =  calculateAcceleration(_s, _v);
  
  _v.add(PVector.mult(acel, SIM_STEP)); 
  _s.add(PVector.mult(_v, SIM_STEP));
  
}

void updateSimulationHeun()
{
  PVector acel = calculateAcceleration(_s, _v);
  
  PVector k1v = PVector.mult(acel, SIM_STEP);
  PVector k1s = PVector.mult(_v, SIM_STEP);
  
  PVector s2 = PVector.add(_s, k1s);
  PVector v2 = PVector.add(_v, k1v);
  
  PVector acel2 = calculateAcceleration(s2, v2);
  
  PVector k2v = PVector.mult(acel2, SIM_STEP);
  PVector k2s = PVector.mult(v2, SIM_STEP);
  
  _v.add(PVector.div(PVector.add(k1v, k2v), 2));
  _s.add(PVector.div(PVector.add(k1s, k2s), 2));
}

void updateSimulationRK2()
{
  PVector acel = calculateAcceleration(_s, _v);
  
  PVector k1v = PVector.mult(acel, SIM_STEP);
  PVector k1s = PVector.mult(_v, SIM_STEP);
  
  PVector s2 = PVector.add(_s, PVector.mult(k1s, 0.5));
  PVector v2 = PVector.add(_v, PVector.mult(k1v, 0.5));
  
  PVector acel2 = calculateAcceleration(s2, v2);
  
  PVector k2v = PVector.mult(acel2, SIM_STEP);
  PVector k2s = PVector.mult(v2, SIM_STEP);
  
  _v.add(k2v);
  _s.add(k2s);
}

void updateSimulationRK4() 
{
  // k1v = h*a(t)
   // k1s = h*v
   _a = calculateAcceleration(_s, _v);
   PVector k1v = PVector.mult(_a, SIM_STEP);
   PVector k1s = PVector.mult(_v, SIM_STEP);

   // k2v = h*a(t + h/2, v + k1v/2)
   // k2s = h*(v + k1v/2)
   PVector k2v = PVector.mult(calculateAcceleration(PVector.add(_s, PVector.mult(k1s, 0.5)), PVector.add(_v, PVector.mult(k1v, 0.5))), SIM_STEP);
   PVector k2s = PVector.mult(PVector.add(_v, PVector.mult(k1v, 0.5)), SIM_STEP);

   // k3v = h*a(t + h/2, v + k2v/2)
   // k3s = h*(v + k2v/2)
   PVector k3v = PVector.mult(calculateAcceleration(PVector.add(_s, PVector.mult(k2s, 0.5)), PVector.add(_v, PVector.mult(k2v, 0.5))), SIM_STEP);
   PVector k3s = PVector.mult(PVector.add(_v, PVector.mult(k2v, 0.5)), SIM_STEP);

   // k4v = h*a(t + h, v + k3v)
   // k4s = h*(v + k3v)
   PVector k4v = PVector.mult(calculateAcceleration(PVector.add(_s, k3s), PVector.add(_v, k3v)), SIM_STEP);
   PVector k4s = PVector.mult(PVector.add(_v, k3v), SIM_STEP);

   // v(t+h) = v(t) + 1/6 * (k1v + 2*k2v + 2*k3v + k4v)
   // s(t+h) = s(t) + 1/6 * (k1s + 2*k2s + 2*k3s + k4s)
   _v.add(PVector.div(PVector.add(PVector.add(k1v, PVector.mult(k2v, 2)), PVector.add(PVector.mult(k3v, 2), k4v)), 6));
   _s.add(PVector.div(PVector.add(PVector.add(k1s, PVector.mult(k2s, 2)), PVector.add(PVector.mult(k3s, 2), k4s)), 6));

}

void keyPressed() {
  boolean methodChanged = false;

  if (key == '1') {
    if (integrator != IntegratorType.EXPLICIT_EULER) {
      integrator = IntegratorType.EXPLICIT_EULER;
      methodChanged = true;
    }
  } else if (key == '2') {
    if (integrator != IntegratorType.SIMPLECTIC_EULER) {
      integrator = IntegratorType.SIMPLECTIC_EULER;
      methodChanged = true;
    }
  } else if (key == '3') {
    if (integrator != IntegratorType.HEUN) {
      integrator = IntegratorType.HEUN;
      methodChanged = true;
    }
  } else if (key == '4') {
    if (integrator != IntegratorType.RK2) {
      integrator = IntegratorType.RK2;
      methodChanged = true;
    }
  } else if (key == '5') {
    if (integrator != IntegratorType.RK4) {
      integrator = IntegratorType.RK4;
      methodChanged = true;
    }
  } else if (key == 'r' || key == 'R') {
    setup();  // Reiniciar la simulación
    return;
  }

  if (methodChanged) {
    setup();
  }
}
