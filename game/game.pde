/*
DEFENDER
14 July 2020
Joshua Keegan
*/

// Initulise variables

// Speed
int BASE_SPEED;             // Speed of Program
float boostMult;            // Not really sure just multipler for speed

// Location
float x;                    // Left of the inital frame

// Background
int maxHeight;              // Maximum height of landscape
int frames;                 // How may extra things are shown on the mini map // DOES NOTHING AT THE MOMENT
float landscapeStep;        // How far before next point on landscape
float landscapePoints;      // Resolution of Landscape
float noiseStep;            // How quickly the landscape changes
float scrollSpeed;          // How fast landscape changes while boosting
boolean reverse;            // Direction of Landscape change
ArrayList<Float> pys;       // Y values of landscape after x=0 
ArrayList<Float> nys;       // Y values of landscape before x=0 

// Objects
Player playerShip;            // Player Ship
ArrayList<Bullet> bullets;  // All projectiles
ArrayList<EnemyBullet> enemyBullets;
ArrayList<Ship> enemies;    // All enimies
ArrayList<Human> humans;
ArrayList<Lander> landers;

// Timing
int eventStart;
int eventLength = 800;
String event="";

int level=1;

void setup(){
  // Parameters
  size(700,400);
  //fullScreen();
  noiseSeed(0);  // Noise seed so everytime is the same
  
  ellipseMode(CENTER);
  
  // Speed
  BASE_SPEED = 5;
  boostMult = 2;

  // Location
  x = 0;
  
  // level
  
  // Background
  maxHeight = height/4;
  frames=5;
  landscapeStep = 8;
  landscapePoints = width/landscapeStep;
  noiseStep = 1/landscapeStep;
  scrollSpeed = 0;
  reverse=false;
  pys = new ArrayList<Float>();
  nys = new ArrayList<Float>();
  
  // Objects
  playerShip=new Player(BASE_SPEED);
  bullets = new ArrayList<Bullet>();
  enemyBullets = new ArrayList<EnemyBullet>();
  enemies = new ArrayList<Ship>();
  landers = new ArrayList<Lander>();
  humans = new ArrayList<Human>();
  
  // Fill background
  for(int i=0; i<(floor(frames/2)+1)*landscapePoints;i++){
    pys.add(height - maxHeight*noise(i*noiseStep));
  }
  for(int i=0; i<floor(frames/2)*landscapePoints;i++){
    nys.add(height - maxHeight*noise(i*noiseStep));
  }
  // make ais
  makeMobs();
  
  textAlign(CENTER);
}

void makeMobs(){
    // Make humans
  for(int i=0;i<level;i++){
    float hx = random(x-floor(frames/2)*width,x+(floor(frames/2)+1)*width);
    ArrayList<Float> l=nys;
    if(hx>0){
      l=pys;
    }
    
    float hy = random(l.get(round(abs(hx)/landscapeStep))-1, height);
    humans.add(new Human(hx,hy));
  } 
  // make landers
  for(Human h:humans){
    landers.add(new Lander(h.ox, 0, h));
  }
}

void drawMap(){
  // Draw background and outline
  strokeWeight(3);
  stroke(40,255,0,170);
  fill(0);
  rect(width/4,0,width/2, height/(frames*2));
  
  // Dividers
  stroke(255);
  
  int frontOfDivider= width/2/4+width/(floor(frames/2)+1);
  int backOfDivider = width/2/frames+frontOfDivider;
  float h = height/(frames*2);
  
  line(frontOfDivider,0,frontOfDivider,h/8);                    //front top stub
  line(frontOfDivider,h-h/8,frontOfDivider,h);  //front bottom stub
  
  line(backOfDivider,0,backOfDivider,h/8);                      //back top stub
  line(backOfDivider,h-h/8,backOfDivider,h);    //back bottom stub
  
  line(frontOfDivider,0,backOfDivider,0);
  line(frontOfDivider,h,backOfDivider,h);
  
  // Draw landscape
  strokeWeight(1);
  stroke(255,102,0);
  int startX = round(x-(floor(frames/2))*width);
  int endX = round(x+(floor(frames/2)+1)*width);
  
  float py;
  if(round(startX/landscapeStep)>=0){
    py=pys.get(round(startX/landscapeStep));
  }else{
    py=nys.get(round(-1*startX/landscapeStep)-1);
  }
  for(int pos = startX; pos<endX;pos+=10){
    // Get all other y values
    float y;
    
    if(round(pos/landscapeStep)>=0){
      y=pys.get(round(pos/landscapeStep));
    }else{
      y=nys.get(round(-1*pos/landscapeStep)-1);
    }
    line((pos-x)/frames/2+width/2-width/4/frames,
         y/(frames*2),
         (pos-x-10)/frames/2+width/2-width/4/frames,
         py/(frames*2));       // Join current point with previous point

    py=y;  // previous = current
  }
  
  // draw Player ship
  noStroke();
  fill(255);
  ellipse(playerShip.ox/2/frames+width/2-width/4/frames,
         playerShip.oy/frames/2,
         5,
         5);       // Join current point with previous point
         
  // draw humans
  fill(180);
  noStroke();
  for(Human human:humans){
    rect((human.ox-x)/frames/2+width/2-width/(floor(frames/2)+1)/frames,
         human.oy/(frames*2),
         5,
         5);       // Join current point with previous point);
  }
  // draw enemies
  for(Lander l: landers){
    fill(0,255,0);
    rect((l.ox-x)/frames/2+width/2-width/(floor(frames/2)+1)/frames,
     l.oy/(frames*2),
     5,
     5);       // Join current point with previous point);
  }
  // remove off screen bullets
  for(int i=enemyBullets.size();i<-1;i--){
    if(enemyBullets.get(i).oy<0||enemyBullets.get(i).oy>height){
      enemyBullets.remove(i);
    }
  }
  
}

void drawLandscape(){
  /*
  * Draws the landscape
  * Landscape is a continuous white line that crosses the screen
  * Created with noise
  */
  stroke(255,102,0);
  strokeWeight(1);
  
  // Initulise previous height before updating it 
  float py=0;
  
  // Get first y value
  if(x>=0){
    py=pys.get(round(x/landscapeStep));
  }else{
    py=nys.get(round(-1*x/landscapeStep));
  }
  
  // Get all other y values
  for(float i=x; i<width+x;i+=landscapeStep){
    float y;
    if(i>=0){
      y=pys.get(round(i/landscapeStep));
    }else{
      y=nys.get(round(-1.0*i/landscapeStep));
    }
    line(i-x,y,i-landscapeStep-x,py);           // Join current point with previous point
    py=y;  // previous = current
  }
}

void loadLandscape(){
  /* 
  * Loads the extra landscape information in advance
  * This lets the maps display more information 
  */
  
  // Points in front of start
  int req_points = round(x/landscapeStep+(floor(frames/2)+1)*landscapePoints);
  while(pys.size()<req_points){//works for 1 value added at a time so works for current speeds
    pys.add(height - maxHeight*noise(req_points*noiseStep));
  }
  
  // Points behind start
  req_points = round(-x/landscapeStep+(floor(frames/2))*landscapePoints);
  while(nys.size()<req_points){//works for 1 value added at a time so works for current speeds
    nys.add(height - maxHeight*noise(req_points*noiseStep));
  }
}
void draw(){
  // Refresh
  background(0);
  //detect events
  boolean lose =true;
  boolean win=true;
  if(event.equals("")){
    for (Lander l :landers){
      if(!l.boomed){// win condition failed
        win=false;
      }
      if(l.oy>=0&&!playerShip.boomed){// lose condition failed
        lose=false;
      }
    }
    if(win){ // Set events into motion
      eventStart = millis();
      event = "w";
    }else if(lose){
      eventStart = millis();
      event = "l";
    }
  }

  // run events
  if(event.equals("l")&&millis()>=eventStart+eventLength){// Lose Event
    fill(0,255,0);
    textSize(12);
    text("You Lose", width/2,height/2);
    return;
  }
  else if(event.equals("w")&&millis()>=eventStart+eventLength){// Win event
    // Clear objects
    humans.clear();
    landers.clear();
    bullets.clear();
    enemyBullets.clear();
    // Increment Level
    level++;
    // Remake Objects for new level
    makeMobs();
    // Show Level number event
    event="t";
    eventStart=millis();
  }else if(event.equals("t")&&millis()<eventStart+eventLength){// Show Level number event
    fill(0,255,0);
    textSize(20);
    text("Level "+level, width/2,height/2);
  }else if(millis()>eventStart+eventLength){// End Event
    event="";
  }
  
  // Make sure there are enough points
  loadLandscape();
  
  // Draw Background
  drawLandscape();
  
  // Draw mini map
  drawMap();

  // Change position
  if(!reverse){
    x+=scrollSpeed;
  }else{
    x-=scrollSpeed;
  }
  
  // Draw player ship
  playerShip.move();
  playerShip.draw();
  
  // Move bullets and draw them
  for(Bullet bullet:bullets){
    bullet.move();
    bullet.draw();
  }
  
  // Move bullets and draw them
  for(Human human:humans){
    human.wander();
    human.draw();
  }
  // Remove bullet if off screen
  if (bullets.size() > 0){
    bullets.get(0).destroy();
  }
  // Lander activities
  for(Lander l:landers){
    l.track();
    l.draw();
    l.shoot();
    if (playerShip.touching(l.ox,l.oy,l.boomed)) scrollSpeed=0;
  }
  // Enemy bullet activities
  for(EnemyBullet eb:enemyBullets){
    eb.move();
    eb.draw();
    if(playerShip.touching(eb.ox,eb.oy,false)) scrollSpeed=0  ;
  }
}

// Define key controls
int boostKey = SHIFT;
String shootKey = " ";
String reverseKey = "r";
String leftKey = "a";
String upKey = "w";
String rightKey = "d";
String downKey = "s";

void keyPressed(){
  if(playerShip.boomed) return;
  String k = Character.toString(Character.toLowerCase(key));
  if(keyCode == boostKey){
    scrollSpeed=BASE_SPEED*boostMult;
    playerShip.boost();
  }if(k.equals(reverseKey)){
    reverse=!reverse;
    playerShip.changeDir();
  }if(k.equals(leftKey)){
    playerShip.setSpeeds(1,1);
  }
  if(k.equals(rightKey)){
    playerShip.setSpeeds(2,1);
  }
  if(k.equals(downKey)){
    playerShip.setSpeeds(3,1);
  }
  if(k.equals(upKey)){
    playerShip.setSpeeds(0,1);
  }if(k.equals(shootKey)){
    playerShip.shoot();
  }
}
void keyReleased(){
  if(playerShip.boomed) return;
  String k = Character.toString(Character.toLowerCase(key));
  if(keyCode == boostKey){
    scrollSpeed=0;
    playerShip.boost();
  }
  if(k.equals(leftKey)){
    playerShip.setSpeeds(1,0);
  }
  if(k.equals(rightKey)){
    playerShip.setSpeeds(2,0);
  }
  if(k.equals(downKey)){
    playerShip.setSpeeds(3,0);
  }
  if(k.equals(upKey)){
    playerShip.setSpeeds(0,0);
  }
}
