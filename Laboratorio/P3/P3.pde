// Problem description: Simulación de un billar francés//<>// //<>//
//
// Modelo de colisión basado en velocidades
//

// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:

boolean _writeToFile = true;
PrintWriter _output;
boolean _computeParticleCollisions = true;
boolean _computePlaneCollisions = true;
boolean _atrac = false;
boolean _velaleatoria = false;

// System variables:

ParticleSystem _ps;
ArrayList<PlaneSection> _planes;

// Performance measures:
float _Tint = 0.0;    // Integration time (s)
float _Tdata = 0.0;   // Data-update time (s)
float _Tcol1 = 0.0;   // Collision time particle-plane (s)
float _Tcol2 = 0.0;   // Collision time particle-particle (s)
float _Tsim = 0.0;    // Total simulation time (s) Tsim = Tint + Tdata + Tcol1 + Tcol2
float _Tdraw = 0.0;   // Rendering time (s)


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
   else if (key == 'c' || key == 'C')
      _computeParticleCollisions = !_computeParticleCollisions;
   else if (key == 'p' || key == 'P')
      _computePlaneCollisions = !_computePlaneCollisions;
   else if (key == 'n' || key == 'N')
      _ps.setCollisionDataType(CollisionDataType.NONE);
   else if (key == 'g' || key == 'G')
      _ps.setCollisionDataType(CollisionDataType.GRID);
   else if (key == 'h' || key == 'H')
      _ps.setCollisionDataType(CollisionDataType.HASH);
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
   else if (key == 'f' || key == 'K')
       _atrac = !_atrac;
   else if (key == 'v' || key == 'V')
       _velaleatoria = !_velaleatoria;
}

void mousePressed()
{
   PVector mousePos = new PVector(mouseX, mouseY);
   for(int i = 0; i < _ps.getNumParticles(); i++){
      Particle p = _ps._particles.get(i);
      float distance = PVector.dist(mousePos, p._s);
      if (distance < p._radius) {
        PVector vsum = new PVector(1, 1); //Para mover la partícula en caso de v = 0
        PVector newVel = PVector.mult(PVector.add(p._v, vsum), 2);
        p.setVel(newVel);
      }
   }
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, n, Tsim");
   }

   _simTime = 0.0;
   _timeStep = TS;

   initPlanes();
   initParticleSystem();
}

void initPlanes()
{
   _planes = new ArrayList<PlaneSection>();

    //abajo
    _planes.add(new PlaneSection(X1,  Y2,  X2, Y2, false)); 
    //arriba
    _planes.add(new PlaneSection(X1,  Y1,  X2, Y1, true)); 
    //derecha
    _planes.add(new PlaneSection(X2,  Y1,  X2, Y2, true)); 
    //izquierda
    _planes.add(new PlaneSection(X1,  Y1,  X1, Y2, false)); 
}

        
void initParticleSystem()
{
    
    _ps = new ParticleSystem(new PVector()); 
   for (int i = 0; i < N; i++) {
     float x = random(X1 + R*2, X2 - R*2); 
     float y = random(Y1 + R*2, Y2 - R*2);
     if (!_velaleatoria)
       _ps.addParticle(M, new PVector(x,y), v0, R, color(int(random(0,255)), int(random(0,255)), int(random(0,255))));
     else
       _ps.addParticle(M, new PVector(x,y), new PVector(random(1,100), random(1,100)), R, color(int(random(0,255)), int(random(0,255)), int(random(0,255))));
   }
}


void restartSimulation()
{
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
   float time = millis();
   drawStaticEnvironment();
   drawMovingElements();
   _Tdraw = millis() - time;

   time = millis();
   updateSimulation();
   _Tsim = millis() - time;

   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _ps.getNumParticles() + "," + _Tsim);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

   fill(0,135,0); 
   rect(X1, Y1, X2-X1, Y2-Y1);
   //}
   
   for (int i = 0; i < _planes.size(); i++)
   {
      PlaneSection p = _planes.get(i);
      p.render();
   }
}

void drawMovingElements()
{
   _ps.render();
}

void updateSimulation()
{
   float time = millis();
   if (_computePlaneCollisions)
      _ps.computePlanesCollisions(_planes);
   _Tcol1 = millis() - time;

   time = millis();
   if (_computeParticleCollisions)
      _ps.updateCollisionData();
   _Tdata = millis() - time;

   time = millis();
   if (_computeParticleCollisions)
      _ps.computeParticleCollisions(_timeStep);
   _Tcol2 = millis() - time;

   time = millis();
   _ps.update(_timeStep);
   _simTime += _timeStep;
   _Tint = millis() - time;
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
   text("Time integrating equations: " + _Tint + " ms", width*0.3, height*0.025);
   text("Time updating collision data: " + _Tdata + " ms", width*0.3, height*0.050);
   text("Time computing collisions (planes): " + _Tcol1 + " ms", width*0.3, height*0.075);
   text("Time computing collisions (particles): " + _Tcol2 + " ms", width*0.3, height*0.100);
   text("Total simulation time: " + _Tsim + " ms", width*0.3, height*0.125);
   text("Time drawing: " + _Tdraw + " ms", width*0.3, height*0.150);
   text("Total step time: " + (_Tsim + _Tdraw) + " ms", width*0.3, height*0.175);
   text("Fps: " + frameRate + "fps", width*0.3, height*0.200);
   text("Simulation time step = " + _timeStep + " s", width*0.3, height*0.225);
   text("Simulated time = " + _simTime + " s", width*0.3, height*0.250);
   text("Number of particles: " + _ps.getNumParticles(), width*0.3, height*0.275);
   text("Tecla F - Fuerza que atrae a las bolas a una esquina (" + (_atrac ? "Activada" : "Desactivada") + ")",300, 300);
   text("Tecla V - Velocidades aleatorias (" + (_velaleatoria ? "Activada" : "Desactivada") + ")", 300, 325);
   //text("Tecla D - Cambia la pantalla a la del diamante para las pruebas grid y hash", 300, 350);
}
