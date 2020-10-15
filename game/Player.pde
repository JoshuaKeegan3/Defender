class Player extends Ship{
  // Effect variables
  boolean boost = false;
  Player(float speed){
    ox=width/3;
    oy=height/3;
    size=30;
    dx=0;
    dy=0;
    reverse=false;
    this.speed=speed*3.1;
  }
    void boost(){
    /* Activate or deactivate boost animation */
    boost=!boost;
  }
    private void drawBoost(){
    /* Draw an animation for a boost 
     * Just a bunch of lines comming out of the back of the ship
     */
     
    stroke(255);
    strokeWeight(1);
    
    int mult=reverse?-1:1;    // Direction multipler
    
    if(boost){
      for(int i=0;i<20;i++){
        line(ox-mult*size/3*2,oy,ox-mult*random(size*2/3,size*2),oy+random(-10,10));
      }
    }
  }
  void drawBleepBloop(){
    /* Add animation to the body of the ship */
    
    noStroke();
    int pointSize=4;          // Size of bleep bloop
    int mult=reverse?-1:1;    // Direction multipler
    
    for(int i=0;i<2;i++){
      fill(255,0,0);
      rect(ox-mult*random(size/3,size/3*2),oy-random(4),pointSize,pointSize);
      fill(0,255,0);
      rect(ox-mult*random(size/3,size/3*2),oy-random(4),pointSize,pointSize);
      fill(0,0,255);
      rect(ox-mult*random(size/3,size/3*2),oy-random(4),pointSize,pointSize);
    }
  }
  void draw(){
    if(!boomed){ // Draw ship
      int h=6;
      int mult=reverse?-1:1; //dir
      stroke(255);
      strokeWeight(1);
      line(ox,oy,ox-mult*size,oy+h);
      line(ox-mult*size,oy+h,ox-mult*size/3*2,oy);
      line(ox-mult*size/3*2,oy,ox-mult*size,oy-h);;
      line(ox-mult*size,oy-h,ox,oy);
      drawBleepBloop();
      drawBoost();
    }else{ // Draw Boomed ship
      for(PVector pv:particles){
        fill(255);
        ellipse(pv.x,pv.y,5,5);
        // Move particles away from the explosion at constant rate
        float mag=sqrt(pow((pv.x-ox),2)+pow((pv.y-oy),2));
        pv.x+=(pv.x-ox)/mag*speed;
        pv.y+=(pv.y-oy)/mag*speed;
      }
    }
  }
  boolean touching(float bx, float by, boolean boomed){
    /* Checks if the player is touching a bulltet or a enemy
     * If it is boom and stop movement
     */
    if(Math.pow(bx-ox-x,2) + Math.pow(by-oy,2) < pow(size,2)&&!boomed){
      this.boom(); // BOOM!
      this.setSpeeds(0,0); // Only one of these are needed
      this.setSpeeds(1,0);
      this.setSpeeds(2,0);
      this.setSpeeds(3,0);
      return true;
    }
    return false;
  }
}
