ArrayList<BouncingGradient> bGradients = new ArrayList<BouncingGradient>();
int size = 100;
float opacity;

float targetX = width/2;
float targetY = height/2;

//----------------------------
void setup(){
  //size(800,600);
  fullScreen(P3D);
  frameRate(600);
  noStroke();
  //noCursor();
  opacity = 255;
}

//----------------------------
void draw(){
  //background(255,255,255);
  for (int i = 0; i < bGradients.size(); i++) {
    BouncingGradient bGradient = bGradients.get(i);
    bGradient.update();
    bGradient.draw();
  }
  
  if(mousePressed && (mouseButton == LEFT)){
    float vx = (targetX - mouseX)/50;
    float vy = (targetY - mouseY)/50;

    bGradients.add(new BouncingGradient(
      size,
      size,
      
      new Bouncer(0.0, 13.0, 0.0, 255.0),
      new Bouncer(50.0, 7.0, 0.0, 255.0),
      new Bouncer(100.0, 11.0, 0.0, 255.0),
      
      new Bouncer(100.0, 5.0, 0.0, 255.0),
      new Bouncer(50.0, 9.0, 0.0, 255.0),
      new Bouncer(0.0, 8.0, 0.0, 255.0),
      
      new PositionBouncer(mouseX, mouseY, size, size, vx, vy, 0.05),
      
      opacity
    ));
  }
  if(mousePressed && (mouseButton == RIGHT)){
    targetX = mouseX;
    targetY = mouseY;
  }
}
//----------------------------
void mouseWheel(MouseEvent event){
  float e = event.getCount();
  size = size + (int) e + (int)(size * e/10);
  if(size<0){
    size = 1;
  }
}

//----------------------------
class BouncingGradient{
  float speed = 1.0;
  
  Bouncer r1;
  Bouncer g1;
  Bouncer b1;
  Bouncer r2;
  Bouncer g2;
  Bouncer b2;
  
  float bwidth;
  float bheight;
  
  float _red1;
  float _grn1;
  float _blu1;
  float _red2;
  float _grn2;
  float _blu2;
  
  float opacity;
  
  PositionBouncer positionBouncer;
  
  BouncingGradient(int _width, int _height, Bouncer _r1, Bouncer _g1, Bouncer _b1, Bouncer _r2, Bouncer _g2, Bouncer _b2, PositionBouncer pb, float _opacity){
    r1 = _r1;
    g1 = _g1;
    b1 = _b1;
    r2 = _r2;
    g2 = _g2;
    b2 = _b2;
    
    bwidth = _width;
    bheight = _height;
    
    positionBouncer = pb;
    
    opacity = _opacity;
  }
  
  void update(){
    _red1 = r1.update();
    _grn1 = g1.update();
    _blu1 = b1.update();
    _red2 = r2.update();
    _grn2 = g2.update();
    _blu2 = b2.update();
    positionBouncer.update();
  }
  
  void draw(){
    if(abs(sqrt(positionBouncer.vx*positionBouncer.vx + positionBouncer.vy*positionBouncer.vy))<positionBouncer.frictionAcc){
      
    }else{
      float dr = (_red2 - _red1)/bheight;
      float dg = (_grn2 - _grn1)/bheight;
      float db = (_blu2 - _blu1)/bheight;
    
      for(int j=0;j<bheight;j++){
        stroke(_red1+dr*j,_grn1+dg*j,_blu1+db*j,opacity);
        line(
          positionBouncer.px-bwidth/2.0,positionBouncer.py+j-bheight/2,
          positionBouncer.px+bwidth/2.0,positionBouncer.py+j-bheight/2);
      }
    }
  }
  
}

void keyPressed(){
 
  if(key == CODED){
    
    
  }else{
    //ASCII spec includes BACKSPACE, TAB, ENTER, RETURN, ESC, DELETE
    if(key == DELETE){
      saveFrame("scene-#####.png");
    }else if(key == ENTER || key == RETURN){
      //shouldClearScreen = true;
    }
  }
}

//----------------------------
class PositionBouncer{
  float px;
  float py;
  
  float vx;
  float vy;
  
  float pwidth;
  float pheight;
  
  float frictionAcc; //acceleration due to friction
  
  PositionBouncer(float x, float y, float _width, float _height, float _vx, float _vy, float friction){
    px = x;
    py = y;
    
    vx = _vx;
    vy = _vy;
    
    frictionAcc = friction;
    
    pwidth = _width;
    pheight = _height;
  }
  
  void update(){
    px = px+vx;
    py = py+vy;
    
    float speed = sqrt(vx*vx + vy*vy);
    if(abs(speed)<frictionAcc){
      vx=0;
      vy=0;
    }else{
      float ratioX = vx/speed;
      float ratioY = vy/speed;
      speed = speed - frictionAcc;      
      vx = ratioX* speed;
      vy = ratioY* speed;
    }
    
    if((vx>0 && px>width-pwidth/2)||(vx<0 && px<0)){
      vx = vx*-1.0;
    }
    if((vy>0 && py>height-pheight/2)||(vy<0 && py<0+pheight/2)){
      vy = vy*-1.0;
    }  
    
  }
  
}

//----------------------------
class Bouncer{
  float value;
  float delta;
  float min;
  float max;
  
  Bouncer(float _value, float _delta, float _min, float _max){
    value = _value;
    delta = _delta;
    min = _min;
    max = _max;
  }
  
  float update(){
    value = value+delta;
    if((value>max && delta >=0) || value<min && delta <=0){
      delta = delta * -1.0;
    }
    return value;
  }
  
}
