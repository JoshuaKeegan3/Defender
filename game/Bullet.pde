class Bullet{
  
  float frontX;     // Front of bullet
  float backX;      // Back of bullet
  float l;          // Length of bullet
  float y;          // Y position of bullet
  boolean reverse;  // Bullet direction
  float speed;      // Bullet Speed
  int c;
  Bullet(float x,float y, float speed, boolean reverse){
    /* Constructor*/
    this.frontX=x;
    this.backX=x;
    this.y=y;
    this.speed = speed;
    this.reverse=reverse;
    this.c = round(random(255));
    l=width/5;
  }
  void move(){
    /* Move the bullet
     * Always move the front of it
     * Move the back if it has reached its max length
     * This creates a growing animation
     */ 
    int mult=reverse?-1:1;    // Direction multipler
    frontX+=mult*speed;
    if(Math.abs(frontX-backX)>=l){
      backX+=mult*speed;
    }

    for(Lander l:landers){
      if (l.touching(frontX,backX,y)){
        l.boom();
      }
    }
  }
  void destroy(){
    /* Get rid of the bullet is off the screen */ 
    if(backX>width||backX<0){
      stroke(255);
      bullets.remove(0);  // Will always be most recent unless the user is a god at the game
    }
  }
  void draw(){
    /* Draw a line from the start of the bullet to the back */
    colorMode(HSB);
    stroke(this.c%255,255,255);
    strokeWeight(3);
    line(frontX, y, backX, y);
    colorMode(RGB);
    this.c+=3;
  }
}
