class Human{
  float ox;
  float oy;
  
  boolean falling;
  boolean onLand;
  int size;
  
  Human(float x1, float y1){
    ox=x1;
    this.oy=y1;
    this.falling =false;
    this.onLand=true;
    size = 10;
  }
  
  void wander(){
    /* Make the human and the lander jiggle  */
    if(onLand){
      if (round(random(30))==3){
        this.ox+=random(-5,5);
        this.oy+=random(-3,3);
      }
    }
    else{ // move up if picked up byt the lander
      oy--;
    }
  }
  
  void pickedUp(){ 
    onLand = false;
  }
  void dropped(){
    falling = true;
  }
  
  boolean hitLand(){
    float groundHeight;
    if(this.ox>=0){
      groundHeight=pys.get(round(this.ox/landscapeStep));
    }else{
      groundHeight=nys.get(round(-1*this.ox/landscapeStep));
    }
    return groundHeight-oy>0;
  }
  
  void draw(){
    strokeWeight(2);
    noFill();
    stroke(255,0,0);
    rect(this.ox-x,oy,size,size);
  }
}
