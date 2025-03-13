// Ejercicio 4: Simulación de un bubble shooter
// Autor: Sergi Sanz Sancho

PVector canon;
PVector proyectil;
PVector velocidad;
boolean disparado;

void setup() {
  size(600, 600);
  canon = new PVector(width/2, height);
  proyectil = new PVector(canon.x, canon.y);
  velocidad = new PVector(0, -5);
  disparado = false;
}

void draw() {
  background(90, 180, 200);
  
  // Dibujar el cañón
  stroke(0);
  float angulo = atan2(mouseY - canon.y, mouseX - canon.x);
  line(canon.x, canon.y, canon.x + 50 * cos(angulo), canon.y + 50 * sin(angulo));
  
  // Dibujar el proyectil
  if (disparado) {
    proyectil.add(velocidad);
    ellipse(proyectil.x, proyectil.y, 2*10, 2*10);
    
    // Resetear el proyectil si sale de la pantalla
    if (proyectil.y < 0) {
      disparado = false;
    }
  }
}

void mousePressed() {
  disparado = true;
  float angulo = atan2(mouseY - canon.y, mouseX - canon.x);
  velocidad = new PVector(5 * cos(angulo), 5 * sin(angulo));
  proyectil = new PVector(canon.x, canon.y);
}
