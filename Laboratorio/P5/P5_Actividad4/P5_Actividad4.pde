import fisica.*;

FWorld world; 
ArrayList<FBox> castles; // Lista que contiene los bloques que componen los castillos de ambos jugadores
ArrayList<FCircle> projectiles; // Lista que contiene los proyectiles que se lanzan 

boolean playerTurn = true; // true: player 1, false: player 2
float angle = radians(5); // Angulo de tiro
float force = 1500; // Fuerza de tiro
float launchHeight1 = 300; // Altura inicial de lanzamiento del jugador 1
float launchHeight2 = 300; // Altura inicial de lanzamiento del jugador 2
boolean gameOver = false; // Juego terminado

FBox shield1, shield2; // Añadir referencias a los escudos

void setup() {
  // Configuración inicial del juego
  size(1200, 600);
  smooth();
  Fisica.init(this);

  world = new FWorld(); // Inicializar el mundo físico
  world.setEdges(); // Establecer los bordes del mundo

  castles = new ArrayList<FBox>();

  // Crear castillo del jugador 1
  shield1 = createCastle(250, height - 100, color(0, 155, 155));

  // Crear castillo del jugador 2
  shield2 = createCastle(width - 350, height - 100, color(120, 30, 20));

  projectiles = new ArrayList<FCircle>();
}

void draw() {
  // Dibuja la pantalla del juego en cada cuadro
  background(173, 216, 230); // Fondo azul claro
  world.step(); // Actualizar la física del mundo
  world.draw(); // Dibujar el mundo físico

  drawHUD(); // Dibujar la interfaz de usuario

  // Eliminar proyectiles que están fuera de la pantalla
  for (int i = projectiles.size() - 1; i >= 0; i--) {
    FCircle p = projectiles.get(i);
    if (p.getX() < 0 || p.getX() > width || p.getY() < 0 || p.getY() > height) {
      world.remove(p);
      projectiles.remove(i);
    }
  }
}

void drawHUD() {
  // Dibujar la interfaz de usuario (HUD)
  fill(0);
  textAlign(CENTER);
  textSize(20);
  if (!gameOver) {
    // Mostrar información del turno y controles mientras el juego está en curso
    text("Player " + (playerTurn ? "1" : "2") + "'s Turn", width / 2, 30);
    text("Angle: " + degrees(angle) + "°", width / 2, 60);
    text("Force: " + force, width / 2, 90);
    text("Height: " + (playerTurn ? launchHeight1 : launchHeight2), width / 2, 120);
    text("Controls: UP/DOWN to change angle, LEFT/RIGHT to change force, +/- to change height of the shot, SPACE to shoot", width / 2, 150);
  } else {
    // Mostrar el mensaje de "Juego Terminado" y el ganador
    textSize(32);
    text("Game Over! Player " + (playerTurn ? "2" : "1") + " wins!", width / 2, 45);
  }
}

FBox createCastle(float x, float y, int castleColor) {
  // Crear bloques del castillo con alturas y posiciones pseudoaleatorias
  FBox shield = null;

  for (int i = 0; i < 5; i++) { 
    int colHeight = int(random(4, 9)); 
    for (int j = 0; j < colHeight; j++) {
      float bx = x + i * 35;
      float by = y - j * 35;

      FBox block = new FBox(35, 35);
      block.setPosition(bx, by);
      block.setStatic(false);
      block.setDensity(0.2f);
      block.setFriction(0.3);
      block.setDamping(0.1);
      block.setAngularDamping(0.1);
      block.setRestitution(0.2);
      block.setFillColor(castleColor); // Color del castillo
      block.setStroke(0);

      world.add(block);
      castles.add(block);

      // Crear el escudo en el centro de la base del castillo
      if (i == 2 && j == 0) {
        block.setFill(255, 128, 0); 
        shield = block; 
      }
    }
  }
  return shield;
}

void keyPressed() {
  // Manejar eventos de teclado
  if (key == ' ' && !gameOver) {
    // Lanzar proyectil y cambiar de turno
    launchProjectile();
    playerTurn = !playerTurn;
  } else if (key == CODED) {
    // Ajustar ángulo y fuerza del lanzamiento
    if (keyCode == UP) {
      angle += radians(5);
    } else if (keyCode == DOWN) {
      angle -= radians(5);
    } else if (keyCode == LEFT) {
      force -= 10; 
    } else if (keyCode == RIGHT) {
      force += 10; 
    }
  } else {
    // Ajustar la altura del lanzamiento
    if (key == '-') {
      if (playerTurn) {
        launchHeight1 = constrain(launchHeight1 - 10, 0, height - 100);
      } else {
        launchHeight2 = constrain(launchHeight2 - 10, 0, height - 100);
      }
    } else if (key == '+') {
      if (playerTurn) {
        launchHeight1 = constrain(launchHeight1 + 10, 0, height - 100);
      } else {
        launchHeight2 = constrain(launchHeight2 + 10, 0, height - 100);
      }
    }
  }
}

void launchProjectile() {
  // Lanzar un proyectil desde el castillo del jugador actual
  float startX = playerTurn ? 25 : width - 25; 
  float startY = playerTurn ? height - launchHeight1 : height - launchHeight2;
  FCircle projectile = new FCircle(20); 
  projectile.setPosition(startX, startY);
  projectile.setDensity(0.8);
  projectile.setRestitution(0.3);
  projectile.setStroke(0);
  projectile.setFill(0, 0, 0);
  world.add(projectile);
  projectiles.add(projectile);

  // Ajuste para lanzar hacia arriba y adelante
  float forceX = cos(angle) * force * (playerTurn ? 1 : -1);
  float forceY = -sin(angle) * force;
  projectile.setVelocity(forceX, forceY);
}

void contactStarted(FContact c) {
  // Manejar colisiones entre cuerpos
  FBody body1 = c.getBody1();
  FBody body2 = c.getBody2();

  if (!gameOver) {
    // Determinar si un proyectil golpea el escudo de un castillo
    if ((body1 instanceof FCircle && body2 == shield1) ||
        (body2 instanceof FCircle && body1 == shield1)) {
      gameOver = true;
      println("Player 2 wins!");
    } else if ((body1 instanceof FCircle && body2 == shield2) ||
               (body2 instanceof FCircle && body1 == shield2)) {
      gameOver = true;
      println("Player 1 wins!");
    }
  }
}
