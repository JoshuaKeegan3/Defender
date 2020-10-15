class Lander extends Ship{
  Human tracked;
  int r=12; 
  boolean found;
  Lander(float x,float y, Human toTrack){
    this.ox=x;
    this.oy=y;
    this.tracked = toTrack;
  }
  void track(){
    /* Follow the human below it
     * If found then move up
     * Stop if boomed
     */
    
    if(!found && !boomed){
      this.ox=tracked.ox;
      this.oy+=0.5;
      if(this.oy>=tracked.oy){
        this.found=true;
      }
    }
    else if(!boomed){
      oy-=1;
      tracked.onLand=false;
    }
  }
  void draw(){
    // Draw Lander
    if(!boomed){
      noFill();
      strokeWeight(2);
      stroke(0,255,0);
      circle(this.ox-x+r/2.0,oy,r);
    }else{ // Draw exploded lander
      for(PVector pv:particles){
        fill(255);
        noStroke();
        ellipse(pv.x-x,pv.y,5,5);
        // Move particles away from the explosion at constant rate
        float mag=sqrt(pow((pv.x-ox),2)+pow((pv.y-oy),2));
        pv.x+=(pv.x-ox)/mag*3;
        pv.y+=(pv.y-oy)/mag*3;
      }
    }
  }
  void shoot(){
    // Shoot ur shot
    if(random(1)<0.004&&!found&&(this.ox-x>-width||this.ox-x<width*2)&&!boomed){
      float bx=(this.ox);
      enemyBullets.add(new EnemyBullet(bx,this.oy,x+playerShip.ox-this.ox,playerShip.oy-this.oy,3));
    }
  }
  boolean touching(float bfx,float bbx, float by){
    // Checks fot the lander is touching a bullter
    if(abs(oy-by)<r&&(ox<bfx+x&&ox>bbx+x||ox>bfx+x&&ox<bbx+x)&&!boomed){
      this.boom();
      return true;
    }
    return false;
  }
}
