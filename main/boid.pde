class Boid {  
  PVector pos;
  PVector vel;
  PVector acc;

  // Aceleração e Velocidade maxima;
  float maxAcc = 0.03;
  float maxVel = 1;

  // Distancias de percepção e força de separação
  float separationRadius = 20;
  float maxSeparationForce = 150;
  float alignmentRadius = 70;
  float cohesionRadius = 70;
  float cohesionFactor = 0.02;

  // Distancia das bordas do canvas e força da borda
  float borders = 50;
  float borderForce = 10;

  // Tamanho do desenho do Boid
  float boidSize = 2;

  Boid(float x, float y){
    pos = new PVector(x, y);
    vel = new PVector(random(-1, 1),random(-1, 1));
    acc = new PVector(0,0);
  }

  // Atualiza os vetores de força e aceleração do boid
  // de acordo com a posição relativa dele aos outros e as bordas
  void update(Boid[] others){
    for(int i = 0; i < others.length; i++)
    {
      // Pula a verificação caso se encontre
      if(others[i].pos == pos) continue;

      separation(others[i]);
      alignment(others[i]);
      cohesion(others[i]);
    }

    collisionWalls();

    // Limita a aceleração
    if(acc.mag() > maxAcc)
    {
      acc.setMag(maxAcc);
    }

    vel.add(acc);
    // Limita a Velocidade
    if(vel.mag() > maxVel){
      vel.setMag(maxVel);
    }

    pos.add(vel);
  }

  // Verifica se Boid está proximo de colidir e se afasta
  void separation(Boid other){
    PVector diff = PVector.sub(pos, other.pos);
    if(diff.mag() < separationRadius)
    {
      float xForce = (diff.x > 0 ? 1 : -1) * map(abs(diff.x), 0, separationRadius, maxSeparationForce, 0);
      float yForce = (diff.y > 0 ? 1 : -1) * map(abs(diff.y), 0, separationRadius, maxSeparationForce, 0);
      acc.add(xForce, yForce);
    }
  }

  // Verifica se boid é vizinho e se ajusta para ter mesma direção
  void alignment(Boid other){
    PVector diff = PVector.sub(pos, other.pos);
    if(diff.mag() < alignmentRadius)
    {
      acc.add(PVector.add(vel, other.vel));
    }
  }

  void cohesion(Boid other){
    PVector diff = PVector.sub(pos, other.pos);
    if(diff.mag() < cohesionRadius)
    {
      diff.mult(-1*cohesionFactor);
      acc.add(diff.x, diff.y);
    }
  }

  // Verifica proximidade das bordas do canvas e
  // força boid a retornar caso passe
  void collisionWalls() {
    if(pos.x > width-borders){
      acc.add(-borderForce, 0);
    }
    else if(pos.x < borders){
      acc.add(borderForce, 0);
    }
    else if(pos.y < borders){
      acc.add(0, borderForce);
    }
    else if(pos.y > height-borders){
      acc.add(0, -borderForce);
    }
  }

  // Desenha o Boid no canvas usando
  // pushMatrix e popMatrix para rotate e
  // translate não afetarem outros boids desenhados
  // retornando ao estado padrão a cada fim
  void show(){
    noFill();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    beginShape();
    vertex(-boidSize, 0);
    vertex(-2*boidSize, boidSize);
    vertex(boidSize, 0);
    vertex(-2*boidSize, -boidSize);
    endShape(CLOSE);
    popMatrix();
  }
}
