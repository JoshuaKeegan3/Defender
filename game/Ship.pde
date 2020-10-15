class Ship{
  // Initualise variables
  
  // Proporties
  float ox;         // x postion of front of the nose of the ship
  float oy;         // y postion of front of the nose of the ship
  float size;      // Size of ship
  
  // Movement
  float speed;     // Speed the ship moves at
  float dx;        // Change in x (X Speed)
  float dy;        // Change in y (Y Speed)
  
  // Direction
  int dir[] ={0,0,0,0};//top left right bottom
  boolean reverse; 
  
  // explosion animation stuff
  boolean boomed = false;
  PVector particles[] = new PVector[100];

  void move(){
    /* Move Ship through the space (litterally)
     * Add dx to x and dy to y
     * Constrain the y values to the height
     * Let the ship loop around the x values
     */
    ox+=dx;
    oy+=dy;
    oy=max(0,min(height,oy));
    if(ox>width){
      ox-=width;
    } else if(ox<0){
      ox+=width;
    }
  }
  
  void setSpeeds(int d,int value){
    /* Update dir
     * dir contains a value for every direction
     * values of d will update the following directions
     *  0   1     2     3
     * top left right bottom
     * value should be 1 or 0 
     * value is contains the information of if it is moving in that direction or not 
     */
    
    // Set the direction
    dir[d]=value;
    
    // Set the speed
    updateSpeeds();
  }
  
  private void updateSpeeds(){
    /* Set dx and dy of the ship */
    
    // Sum all directions
    // Depending on activity give a value
    // if one is active set to 1
    // if two are active set to 2
    // if three are active set to 1
    // if four are active set to 2
    // This works because if there is a multiple of 2, two values will cancel eachother out
    float speedDistrubution = (dir[0]+dir[1]+dir[2]+dir[3]+1)%2+1;
    
    // Update speeds
    dx=speed*(-dir[1]+dir[2])/speedDistrubution;
    dy=speed*(-dir[0]+dir[3])/speedDistrubution;
  }
  
  void shoot(){
    /* Shoots Bullet. Pretty straight forward */
    bullets.add(new Bullet(ox,oy,(2*speed)*boostMult,reverse));
  }
  
  void changeDir(){
    /* Flip the ship around */
    reverse = !reverse;
  }
  void boom(){
    /* Explode animation */
    if(!boomed){
      boomed=true;
      for(int i=0;i<100;i++){
        particles[i]=new PVector(this.ox+random(-1,1),this.oy+random(-1,1));
      }
    }
  }
}
