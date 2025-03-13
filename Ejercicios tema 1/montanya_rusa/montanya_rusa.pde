// Ejercicio 1: Simulación de una montaña rusa
// Autor: Sergi Sanz Sancho

float dt = 0.1;
PVector a, b, c, d, p, velAB, velBC, velCD, velDC, velCB, velBA;
int state = 0;  // Estado para controlar el ciclo de movimiento

void setup() {
  size(600, 600);
  a = new PVector(width / 2 - 0.2 * width, height / 2 + 0.2 * height); // Punto más bajo
  b = new PVector(width / 2, height / 2 - 0.3 * height);              // Pico alto
  c = new PVector(width / 2 + 0.2 * width, height / 2 + 0.1 * height); // Bajada
  d = new PVector(width / 2 + 0.3 * width, height / 2 - 0.3 * height); // Otro pico alto
  p = new PVector(a.x, a.y); // Partícula inicia en a

  // Define velocidades para cada segmento
  velAB = PVector.sub(b, a).normalize().mult(10);
  velBC = PVector.sub(c, b).normalize().mult(20); // Aceleración hacia c
  velCD = PVector.sub(d, c).normalize().mult(10); // Desaceleración hacia d
  velDC = PVector.sub(c, d).normalize().mult(15); // Rápido retorno a c
  velCB = PVector.sub(b, c).normalize().mult(10); // Rápido retorno a b
  velBA = PVector.sub(a, b).normalize().mult(15); // Retorno suave a a
}

void draw() {
  background(255);
  addText();

  // Dibuja las partículas y las líneas
  stroke(0);
  fill(128, 0, 128);
  ellipse(p.x, p.y, 40, 40);

  stroke(255, 0, 0);
  fill(255);
  ellipse(a.x, a.y, 10, 10);

  stroke(0, 0, 255);
  fill(255);
  ellipse(b.x, b.y, 10, 10);

  stroke(0, 255, 0);
  fill(255);
  ellipse(c.x, c.y, 10, 10);
  
  stroke(0, 255, 255);
  fill(255);
  ellipse(d.x, d.y, 10, 10);

  stroke(0);
  line(a.x, a.y, b.x, b.y);
  line(b.x, b.y, c.x, c.y);
  line(c.x, c.y, d.x, d.y); // Añadido para conectar c a d
  line(d.x, d.y, c.x, c.y); // Añadido para conectar d a c


  // Gestión del movimiento basado en el estado actual
  switch (state) {
    case 0: // Mover de a a b
      if (PVector.dist(p, b) < 1) {
        state = 1; // Cambiar al estado b a c
      } else {
        p.add(PVector.mult(velAB, dt));
      }
      break;
    case 1: // Mover de b a c
      if (PVector.dist(p, c) < 1) {
        state = 2; // Cambiar al estado c a b
      } else {
        p.add(PVector.mult(velBC, dt));
      }
      break;
    case 2: // Mover de c a d
      if (PVector.dist(p, d) < 1) {
        state = 3; // Cambiar al estado b a a
      } else {
        p.add(PVector.mult(velCD, dt));
      }
      break;
    case 3: // Mover de d a c
      if (PVector.dist(p, c) < 1) {
        state = 4; 
      } else {
        p.add(PVector.mult(velDC, dt));
      }
      break;
    case 4: // Mover de c a b
      if (PVector.dist(p, b) < 1) {
        state = 5; // Reiniciar el ciclo
      } else {
        p.add(PVector.mult(velCB, dt));
      }
      break;
     case 5: // Mover de b a a
     if (PVector.dist(p, a) < 1) {
        state = 0; // Reiniciar el ciclo
      } else {
        p.add(PVector.mult(velBA, dt));
      }
      break;
  }
  
}

void addText() {
  fill(0);
  textSize(20);
  text("Tramos: 3", 20, 30);
  text("Aceleración en bajadas y deceleración en subidas", 20, 50);
}
