// Definitions:

enum CollisionDataType
{
   NONE,
   GRID,
   HASH
}

// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {200, 190, 210};      // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final String FILE_NAME = "GridSc500.csv";                  // File to write the simulation variables

final int PARTICION = DISPLAY_SIZE_X/9;

//Esquina superior derecha
final int X1 = 1*DISPLAY_SIZE_X/9 ;                     
final int Y1 = 4*DISPLAY_SIZE_Y/9 ;   

//Esquina inferior izquierda
final int X2 = 8*DISPLAY_SIZE_X/9 ;                      
final int Y2 = 7*DISPLAY_SIZE_Y/9 ;   

// Parameters of the problem:
final float CONVERSIONM_CM = 100;   //Factor de conversion de m a centimetros 1 pixel == 1 cm

final float TS = 0.05;      // Initial simulation time step (s)
final float M = 10;        // Particles' mass (kg)
final float R = 0.05*CONVERSIONM_CM;        // Radio de la partícula (m)
final float G = 9.81;       // Gravedad (m/s^2)
final float H = 5*CONVERSIONM_CM;          // Altura del recipiente (m)
final float CR1 = 0.2;      // Constante que representa la perdida de energia sufrida en cada colision bola-banda
final float CR2 = 0.3;      // Constante que representa la perdida de energia sufrida en cada colision bola-bola
final float CR = 0.1;         // Coeficiente de restitución de las paredes del recipiente
final float KE = 0.1;       // Constante elástica de los muelles de colisión (N/m)
final float DM = 0.1*CONVERSIONM_CM;       // Distancia a la que se activan los muelles (m)
final float L0 = 0.1*CONVERSIONM_CM;       // Elongación de reposo de los muelles (m) 
final float KD = 0.01;       // Constante de fricción cuadrática (kg/m)
float N = 750;                         // Numero de particulas

// Constants of the problem:
final PVector GV = new PVector(0.0,G);  // Vector Gravedad
final PVector v0 = new PVector (10.0, 10.0);
final int SC_GRID = 500;             // Cell size (grid) (m)
final int SC_HASH = 50;             // Cell size (hash) (m)
final int NC_HASH = 1000;           // Number of cells (hash)

final float AMORTIGUACION = 0.99;
