class EnemyBullet{
  
  float ox;
  float oy;          // Y position of bullet
  float dx;
  float dy;
  float speed;      // Bullet Speed
  EnemyBullet(float x,float y, float idx, float idy, float speed){
    /* Constructor*/
    this.speed = speed;
    float maxSpeed = pow(idy*idy+idx*idx,0.5);
    this.ox=x; 
    this.oy=y;
    this.dx = idx/maxSpeed*speed;
    this.dy = idy/maxSpeed*speed;
    //this.dy = -pow(idy*idy+idx*idx,0.5)/idy;
  }
  void move(){
    this.ox+=dx;
    this.oy+=dy;
  }
  void draw(){
    fill(0,255,0);
    rect(this.ox-x,oy,10,10);
  }
}
