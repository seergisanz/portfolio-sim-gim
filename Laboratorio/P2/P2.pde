// Authors:  //<>// //<>//
// Sergi Sanz
// Carlos Marques

// Problem description: //<>// //<>//
// Simular una hoguera con humo mediante sistemas
// de particulas
//
// Differential equations:
// Ley de Newton
// a = (Fw + Fd + Fv)/M
//   Fw = M * G
//   Fd = -KD * v^2     
//   Fv = (dirViento, 0)
// Euler simpléctico:
// v(t) = a(t) * dt
// s(t) = v(t) * dt

// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:

boolean _writeToFile = true;
boolean _useTexture = true;
PrintWriter _output;


// Variables to be monitored:

float _energy;                // Total energy of the system (J)
int _numParticles;            // Total number of particles
long duracion;
ParticleSystem _ps;

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

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == 't' || key == 'T')
      _useTexture = !_useTexture;
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
      writeToFile("t;E;n;duracionTimeStep");
   }
    _ps = new ParticleSystem(C);
   _simTime = 0.0;
   _timeStep = TS;
      

}

void restartSimulation()
{
   endSimulation();
   _simTime = 0.0;
   _energy = 0.0;
   _numParticles = 0;
   initSimulation();
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
   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ";" + _energy + ";" + _numParticles + ";" + duracion);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
   
   //
}

void drawMovingElements()
{
   //_ps.addParticle(M, new PVector(), v, R, col, L);
   _ps.render(_useTexture);
}

void updateSimulation()
{
  long timeIterI = System.nanoTime();
  
  for (int i = 0; i < NT*_timeStep; i++){
    _ps.addParticle(M, new PVector(), v, R, col, L);
  }
   //Actualizar la simulación
   _ps.update(_timeStep);
   _simTime += _timeStep;
   _energy = _ps.getTotalEnergy();
   _numParticles = _ps.getNumParticles();
   
  long timeIterO = System.nanoTime();
  duracion = timeIterO - timeIterI;

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
   text("Simulation time step = " + _timeStep + " s", width*0.025, height*0.075);
   text("Simulated time = " + _simTime + " s", width*0.025, height*0.1); 
   text("Number of particles: " + _numParticles, width*0.025, height*0.125);
   text("Total energy: " + _energy/1000.0 + " kJ", width*0.025, height*0.15);
}
