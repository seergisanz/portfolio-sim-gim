import fisica.*;

FWorld world;
FCircle body1, body2;
FRevoluteJoint joint;

void setup() {
  size(800, 600);
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 0); 

  // Crear los cuerpos
  body1 = new FCircle(40);
  body1.setPosition(200, height/2);
  body1.setNoStroke();
  body1.setFill(0, 200, 180);
  body1.setDensity(1);
  body1.setFriction(0);  
  body1.setAngularDamping(0);  
  world.add(body1);

  body2 = new FCircle(40);
  body2.setPosition(600, height/2);
  body2.setNoStroke();
  body2.setFill(100, 200, 0);
  body2.setDensity(1);
  body2.setFriction(0);  
  body2.setAngularDamping(0);  
  world.add(body2);

  // Crear la unión
  joint = new FRevoluteJoint(body1, body2);
  joint.setAnchor(width/2, height/2);  
  joint.setEnableLimit(true); 
  joint.setLowerAngle(0); 
  joint.setUpperAngle(0); 
  world.add(joint);
}

void draw() {
  background(255);
  world.step();
  world.draw();
  body1.addTorque(-50); 
}

void mousePressed() {
  world.remove(joint); 
  
  // Cambiar la posición del segundo cuerpo
  body2.setPosition(mouseX, mouseY);
  
  // Crear una nueva unión con la nueva distancia
  joint = new FRevoluteJoint(body1, body2);
  joint.setAnchor((body1.getX() + body2.getX()) / 2, (body1.getY() + body2.getY()) / 2);
  joint.setEnableLimit(true);
  joint.setLowerAngle(0);
  joint.setUpperAngle(0);
  world.add(joint);
}
