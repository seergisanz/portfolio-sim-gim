// Authors: 
// Sergi Sanz
// Carlos Marques

// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 500;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 500;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {30, 20, 50};         // Background color (RGB)
final int [] TEXT_COLOR = {255, 255, 0};              // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables 


// Parameters of the problem:

final float TS = 0.01;   // Initial simulation time step (s)
final float NT = 200;    // Rate at which the particles are generated (number of particles per second) (1/s)           
final float L = 1;       // Particles' lifespan (s) 

final float CONVERSIONM_CM = 100;   //Factor de conversion de m a centimetros 1 pixel == 1 cm
final float R = 0.03 * CONVERSIONM_CM;  //Radio de cada partícula (m)
final float M = 0.01;       // masa de cada partícula (kg) 
final float G = -9.801;       // módulo del vector aceleración de la gravedad (m/s2) 
final float KD = 0.0001/CONVERSIONM_CM;      // constante de fricción con el aire (kg/m) 

final float FACTORRANDOMX = 10;       // Valor que aumenta la varianza de amplitud de las partículas en el eje x
final float FACTORRANDOMY = 0.5;      // Valor que aumenta la varianza de amplitud de las partículas en el eje y
final float TINTA_TEXTURA = 2;        // Valor del retardo del oscurecimiento de la partícula
final color col = color(255, 0, 0);   // Color de cada particula

// Constants of the problem:

final String TEXTURE_FILE = "texture.png";
final PVector GV = new PVector(0, G);  // Vector gravedad
final PVector v = new PVector(0.0, -1.0);  // Vector velocidad inicial
final PVector C = new PVector(DISPLAY_SIZE_X/2, DISPLAY_SIZE_Y);   // Centro del sistema de partículas
