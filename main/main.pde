Boid[] boids;
int numBoids= 1000;

void setup() {
  size(1900,1000);
  boids = new Boid[numBoids];
  for(int i = 0; i < boids.length; i++)
  {
    boids[i] = new Boid(random(0, width), random(0, height));  
  }
}

void draw(){
  background(51);
  stroke(255);
  for(int i = 0; i < boids.length; i++)
  {
    boids[i].update(boids);
    boids[i].show();
  }
  
}
