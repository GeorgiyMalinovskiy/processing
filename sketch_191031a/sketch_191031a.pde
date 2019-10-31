color c_back = color(0);
Body Sun;
ArrayList<Body> Bodys = new ArrayList<Body>();

void setup(){
  smooth();
  size(600,600);
  Sun = new Body(new PVector(width/2,height/2), new PVector(0,0), 51);
  Bodys.add(Sun);
  background(c_back);
}

void draw(){
  //background(c_back);
  Sun.display();
  for(int i=0; i<Bodys.size(); i++){
    Body newBody = Bodys.get(i);
    newBody.calcGrav(Bodys);
    newBody.update();
    newBody.display();
  }
}

void mousePressed(){
  if(mouseButton == LEFT){
    Bodys.add(new Body(new PVector(mouseX, mouseY), new PVector(0,0), random(5,15)));
  }else if(mouseButton == RIGHT){
    Body lastBody = Bodys.get(Bodys.size()-1);
    lastBody.setVel();
    lastBody.update = true;
  }else{
    Bodys.remove(Bodys.size()-1);
    background(c_back);
  }
}


class Body{
  PVector loc;
  PVector vel;
  PVector acc = new PVector(0,0);
  float mass;
  float d_mass;
  float G = 1;
  color c_body = color(220);
  boolean update = false;
  color stroke = color(random(0,255),random(0,255),random(0,255)); 
  
  Body(PVector _loc, PVector _vel, float _mass){
    loc = _loc;
    vel = _vel;
    mass = _mass;
    d_mass = mass;
    if(mass >= 50){
      mass = 3000;
      c_body = color(200,200,0);
    }
  }
  
  void calcGrav(ArrayList<Body> Bodys){
    for(int i=0; i<Bodys.size(); i++){
      Body otherBody = Bodys.get(i);
      if(otherBody != this){
        PVector force = PVector.sub(otherBody.loc,this.loc);
        float distance = force.mag();
        if(distance <= (mass+otherBody.mass)*3 && distance > this.mass){
          force.normalize();
          float strength = (G * this.mass * otherBody.mass) / sq(distance);
          force.mult(strength*0.01);
          this.addForce(force);
        }
      }
    }
  }
  
  void addForce(PVector force){
    acc.add(force);
    vel.add(acc);
    acc.mult(0);
  }
  
  void update(){
    if(this.mass < 80 && update){
      loc.add(vel);
    }
  }
  
  void display(){
    //stroke(stroke);
    //strokeWeight(1);
    //noStroke();
    fill(stroke);
    ellipse(loc.x, loc.y, d_mass, d_mass);
    if(mass >= 80){
      ellipse(loc.x, loc.y, d_mass, d_mass);
    }
  }
  
  void setVel(){
    PVector mouse = new PVector(mouseX, mouseY);
    vel = PVector.sub(mouse,loc);
    vel.mult(0.01);
  }
  
}
