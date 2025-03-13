// Authors:  //<>//
// Sergi Sanz
// Carlos Marques

// Problem description:
// Simular el movimiento de un péndulo con muelle sobre un objeto con elongación l0
// y una aceleración dada por tres fuerzas: fuerza elástica, fuerza del peso y 
// fuerza de rozamiento

// Differential equations:
//
// Ley de Newton:
//    a(s(t), v(t)) = [Fd(v(t)) + Fe + Fw]/m
//    Fd = -Kd·v(t)   
//    Fw = m·g
//    Fe = -Ke*((s(t) - c)-l0)
//    s(t) = ∫v(t) dt
//    v(t) = ∫a(t) dt

// Simulation and time control:

IntegratorType _integrator = IntegratorType.NONE;   // ODE integration method
float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)


// Output control:

boolean _writeToFile = false;
PrintWriter _output;


// Variables to be solved:

PVector _s = new PVector();   // Position of the particle (m)
PVector _v = new PVector();   // Velocity of the particle (m/s)
PVector _a = new PVector();   // Accleration of the particle (m/(s*s))
float _energy;                // Total energy of the particle (J)

// Springs:

Spring _sp;


// Main code:

void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
   frameRate(DRAW_FREQ);
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

   initSimulation();
}

void stop()
{
   endSimulation();
}

void mouseClicked()
{
   _v.set(0.0, 0.0, 0.0);
   _a.set(0.0, 0.0, 0.0);
   _s = new PVector(mouseX, mouseY);
}

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == ' ')
      _integrator = IntegratorType.NONE;
   else if (key == '1')
      _integrator = IntegratorType.EXPLICIT_EULER;
   else if (key == '2')
      _integrator = IntegratorType.SIMPLECTIC_EULER;
   else if (key == '3')
      _integrator = IntegratorType.RK2;
   else if (key == '4')
      _integrator = IntegratorType.RK4;
   else if (key == '5')
      _integrator = IntegratorType.HEUN;
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, E, sx, sy, vx, vy, ax, ay");
   }

   _simTime = 0.0;
   _timeStep = TS;

   _s = S0.copy();
   _v.set(0.0, 0.0, 0.0);
   _a.set(0.0, 0.0, 0.0);

   _sp = new Spring(C, _s, KE, L0);
   _energy = 0.0;
}

void restartSimulation()
{
   initSimulation();
   _integrator = IntegratorType.NONE;
}

void endSimulation()
{
   if (_writeToFile)
   {
      _output.flush();
      _output.close();
   }
}

void draw()
{
   drawStaticEnvironment();
   drawMovingElements();

   updateSimulation();
   calculateEnergy();
   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _energy + ", " + _s.x + ", " + _s.y + ", " + _v.x + ", " + _v.y + "," + _a.x + ", " + _a.y);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
   fill(STATIC_ELEMENTS_COLOR[0], STATIC_ELEMENTS_COLOR[1], STATIC_ELEMENTS_COLOR[2]);
   circle(C.x, C.y, OBJECTS_SIZE);
}

void drawMovingElements()
{
   fill(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]);
   circle(_s.x, _s.y, OBJECTS_SIZE);
   line(C.x, C.y, _s.x, _s.y);
}

void updateSimulation()
{
   switch (_integrator)
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
   
      case NONE:
      default:
   }

   _simTime += _timeStep;
}

void calculateEnergy()
{
   // E = Ek + Ep + Ee
     
   //Energia cinetica: Ek = (1/2)*m*v^2
   float Ek = 0.5 * M * _v.magSq(); 
       
   //Energia potencial gravitatoria: Ep = m*g*h
   float h = _s.copy().y;
   float Ep = M * G * h;
   
   //Energia potencial elastica: Ee = 1/2 * Ke*(l-l0)^2
   float Ee = _sp.getEnergy();
   
   _energy = Ek + Ep + Ee;
}

void writeToFile(String data)
{
   _output.println(data);
}

void displayInfo()
{
   stroke(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   fill(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);   
   textSize(20);
   text("Draw: " + frameRate + "fps", width*0.025, height*0.05);
   text("Integrator: " + _integrator.toString(), width*0.025, height*0.075);
   text("Simulation time step = " + _timeStep + " s", width*0.025, height*0.1);
   text("Simulated time = " + _simTime + " s", width*0.025, height*0.125);
   text("Energy: " + _energy/1000.0 + " kJ", width*0.025, height*0.15);
   text("Speed: " + _v.mag()/1000.0 + " km/s", width*0.025, height*0.175);
   text("Acceleration: " + _a.mag()/1000.0 + " km/s2", width*0.025, height*0.2);
}

void updateSimulationExplicitEuler()
{
   // s(t+h) = s(t) + h*v(t)
   // v(t+h) = v(t) + h*a(s(t),v(t))

   _a = calculateAcceleration(_s, _v);
   _s.add(PVector.mult(_v, _timeStep));
   _v.add(PVector.mult(_a, _timeStep));
}

void updateSimulationSimplecticEuler()
{
   // v(t+h) = v(t) + h*a(s(t),v(t))
   // s(t+h) = s(t) + h*v(t)

   _a = calculateAcceleration(_s, _v);
   _v.add(PVector.mult(_a, _timeStep));
   _s.add(PVector.mult(_v, _timeStep));
}

void updateSimulationRK2()
{
   _a = calculateAcceleration(_s, _v);
   
   // Primer paso (k1)
   // k1v = h * a(s, v)
   // k1s = h * v
   PVector k1v = PVector.mult(_a, _timeStep);
   PVector k1s = PVector.mult(_v, _timeStep);
   
   // Segundo paso (k2)
   // k2v = h*a(s + k1s/2, v + k1v/2)
   // k2s = h*(v + k1v/2)
   PVector k2v = PVector.mult(calculateAcceleration(PVector.add(_s, PVector.div(k1s, 2)), PVector.add(_v, PVector.div(k1v, 2))), _timeStep);
   PVector k2s = PVector.mult(PVector.add(_v, PVector.div(k1v, 2)), _timeStep);
   
   // Actualización de la velocidad y la posición
   // v(t+h) = v(t) + k2v
   // s(t+h) = s(t) + k2s
   _v.add(k2v);
   _s.add(k2s);
}

void updateSimulationRK4() {
   _a = calculateAcceleration(_s, _v);
   
   // Primer paso (k1)
   // k1v = h * a(s, v)
   // k1s = h * v
   PVector k1v = PVector.mult(_a, _timeStep);
   PVector k1s = PVector.mult(_v, _timeStep);
  
   // Segundo paso (k2)
   // k2v = h*a(s + k1s/2, v + k1v/2)
   // k2s = h*(v + k1v/2)
   PVector k2v = PVector.mult(calculateAcceleration(PVector.add(_s, PVector.div(k1s, 2)), PVector.add(_v, PVector.div(k1v, 2))), _timeStep);
   PVector k2s = PVector.mult(PVector.add(_v, PVector.div(k1v, 2)), _timeStep);
  
   // Tercer paso (k3)
   // k3v = h*a(s + k2s/2, v + k2v/2)
   // k3s = h*(v + k2v/2)
   PVector k3v = PVector.mult(calculateAcceleration(PVector.add(_s, PVector.div(k2s, 2)), PVector.add(_v, PVector.div(k2v, 2))), _timeStep);
   PVector k3s = PVector.mult(PVector.add(_v, PVector.div(k2v, 2)), _timeStep);
  
   // Cuarto paso (k4)
   // k4v = h*a(s + k3s, v + k3v)
   // k4s = h*(v + k3v)
   PVector k4v = PVector.mult(calculateAcceleration(PVector.add(_s, k3s), PVector.add(_v, k3v)), _timeStep);
   PVector k4s = PVector.mult(PVector.add(_v, k3v), _timeStep);
  
   // Actualización de la velocidad y posición
   // v(t+h) = v(t) + 1/6 * (k1v + 2*k2v + 2*k3v + k4v)
   // s(t+h) = s(t) + 1/6 * (k1s + 2*k2s + 2*k3s + k4s)
   _v.add(PVector.div(PVector.add(PVector.add(k1v, PVector.mult(k2v, 2)), PVector.add(PVector.mult(k3v, 2), k4v)), 6));
   _s.add(PVector.div(PVector.add(PVector.add(k1s, PVector.mult(k2s, 2)), PVector.add(PVector.mult(k3s, 2), k4s)), 6));
}

void updateSimulationHeun() {
    _a = calculateAcceleration(_s, _v);
    
    // Calculo de la velocidad en el punto medio
  
    PVector v12 = PVector.add(_v, PVector.mult(_a, _timeStep * 0.5));
    
    // Calculo de la posicion en el punto medio
    
    PVector s12 = PVector.add(_s, PVector.mult(_v, _timeStep * 0.5));
    
    // Calculo de la aceleracion en el punto medio
    
    PVector a12 = calculateAcceleration(s12, v12);
    
    // Actualizamos la velocidad y la posicion
    
    _v.add(PVector.mult(a12, _timeStep));
    _s.add(PVector.mult(v12, _timeStep));
}

PVector calculateAcceleration(PVector s, PVector v)
{
  
   PVector Fw = PVector.mult(Gv, M); // Fuerza de gravedad
   PVector Fd = PVector.mult(v, -KD); // Fuerza de fricción

   _sp.setPos2(s);
   _sp.update();
   
   PVector Fe = _sp.getForce(); // Fuerza elástica
   PVector Sum = PVector.add(Fw, PVector.add(Fd, Fe));
   PVector a = Sum.div(M);

   return a;
}
