class Boid {  
  PVector pos;
  PVector vel;
  PVector acc;
  
  float maxAcc = 1;
  float maxVel = 2.0;
  
  float flockCollRadius = 20;
  float maxFlockCollForce = 300;
  float flockFollowRadius = 50;
  
  float borders = 50;
  float borderForce = 10;
  
  float boidSize = 2;

  Boid(float x, float y){
    pos = new PVector(x, y);
    vel = new PVector(random(-1, 1),random(-1, 1));
    acc = new PVector(0,0);
  }
  
  void update(Boid[] others){
    for(int i = 0; i < others.length; i++)
    {
      if(others[i].pos == pos) continue;
      PVector diff = PVector.sub(pos, others[i].pos);
      followFlock(others[i], diff);
      collisionFlock(diff);
    }
    collisionWalls();
    if(acc.mag() > maxAcc)
    {
      acc.setMag(maxAcc);
    }
    vel.add(acc);
    if(vel.mag() > maxVel){
      vel.setMag(maxVel);
    }
    pos.add(vel);
  }
  
  void collisionFlock(PVector diff){
      if(diff.mag() < flockCollRadius)
      {
        float xForce = (diff.x > 0 ? 1 : -1) * map(abs(diff.x), 0, flockCollRadius, maxFlockCollForce, 0);
        float yForce = (diff.y > 0 ? 1 : -1) * map(abs(diff.y), 0, flockCollRadius, maxFlockCollForce, 0);
        acc.add(xForce, yForce);
      }
  }
  
  void followFlock(Boid other, PVector diff){
      if(diff.mag() < flockFollowRadius)
      {
        acc.add(PVector.add(vel, other.vel));
      }
  }
  
  void collisionWalls() {
    if(pos.x > width-borders){
      acc.add(-borderForce, 0);
    }
    if(pos.x < borders){
      acc.add(borderForce, 0);
    }
    if(pos.y < borders){
      acc.add(0, borderForce);
    }
    if(pos.y > height-borders){
      acc.add(0, -borderForce);
    }
  }
  
  void show(){
    noFill();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(atan2(vel.x, -vel.y));
    beginShape();
    vertex(0, -boidSize);
    vertex(boidSize, 2*boidSize);
    vertex(0, boidSize);
    vertex(-boidSize, 2*boidSize);
    endShape(CLOSE);
    popMatrix();
  }
}
