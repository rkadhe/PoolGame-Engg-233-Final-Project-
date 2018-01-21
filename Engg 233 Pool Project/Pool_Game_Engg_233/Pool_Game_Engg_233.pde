
Table pool_table;                              
Ball cueball;                          
Ball[] all;                             
mov new_position;
Stick cue;
check check_edge;

float size_of_pocket;
float pocket []={0, width, height};
//used to create the window that displays game

void setup() 
{
  size(800, 500);
  check_edge= new check();
// constructing the cueball
  cueball =new Ball(200, 250, 30, 255, 255, 255); 
// Draws table
  pool_table=new Table(); 
// Makes ball array
  pool_table.ball_arr(6);

  cue= new Stick();
  new_position= new mov(cueball.center.x, cueball.center.y);
}

void draw()
{
  pool_table.table();
  cue.StickPower(cueball.center.x, cueball.center.y); //drawing cue stick according to middle of PlayingBall to mouse location

  cueball.latest();//Updates position of cueBall

  for (int i=0; i<6; i++) {

    pool_table.all[i].latest();
    check_edge.check_scored(pool_table.all[i]);
    cueball.coll(cueball, pool_table.all);

    if (pool_table.all[i].dir.x !=-10)
      if (pool_table.all[i].dir.x !=-50)
        pool_table.all[i].coll(pool_table.all[i], pool_table.all);

// Ends the game 
    if (pool_table.all[0].scored==true && pool_table.all[1].scored==true && pool_table.all[2].scored==true && pool_table.all[3].scored==true && pool_table.all[4].scored==true && pool_table.all[5].scored==true)
    {

      fill(#F6FF12);
      textSize(80);
      text("You Win!\nReset by hitting \nthe space bar", 50, 200);
      if (keyPressed && key==' ') //If all 6 Balls are pocketed, display the following message and press space to start over
      {  
        for (int j=0; j<6; j++) {
          pool_table.all[j].scored=false;
        }
        setup();
      }
    }
  }
  //Checks the position of the edges
  check_edge.checkCueBall(cueball); 
  //speed of cueBall
  new_position.velocity(cueball.center.x, cueball.center.y); 
}
// Ball only moves if mouse is released
void mouseReleased()
{

  if (cueball.velocity_x==0 && cueball.velocity_y==0)
  {
    
    cueball.velocity_x = new_position.velocity_of_x;
    cueball.velocity_y = new_position.velocity_of_y;
  }
}
class check 
{
  check() {
  }
// checks if user scored
  void check_scored(Ball a)
  {

    if (a.dir.x==(-50))
    {
      a.scored=true; 
    }
    if (a.dir.x!=(-50))
    {
      a.scored=false; 
    }
  // Bounds
    if ((a.dir.x<=50 && a.dir.y<=50) || (a.dir.x>=width-60 && a.dir.y<=60) || 
      (a.dir.x<=60 && a.dir.y>=height-60)||(a.dir.x>=width-60 && a.dir.y>=height-60)) 
    {  

      a.dir.y=(99);
      a.dir.x=(-49); 
      a.velocity_x=0;
      a.velocity_y=0;
    }

    if (a.center.x>=width-20 || a.center.x<=20 ) 
    {
      a.velocity_x *=-1;
    }

    if (a.center.y>=height-20 || a.center.y<=20 ) 
    {
      a.velocity_y *=-1;
    }

    if (abs(a.velocity_x)<0.3 && abs(a.velocity_y)<0.3) 
    {
      a. velocity_x=0;
      a.velocity_y=0;
    }
  }
// 
  void checkCueBall(Ball a) 
  {

    if ((a.dir.x<=50 && a.dir.y<=50) || (a.center.x>=width-60 && a.center.y<=60) || 
      (a.center.x<=60 && a.center.y>=height-60)||(a.center.x>=width-60 && a.center.y>=height-60)) 
    {  


      a. velocity_x=0;
      a.velocity_y=0;
      a.dir.x=(-11);
      a.dir.y=(-11);
      fill(#F6FF12);
      textSize(50);
      text("You lose\nReset by hitting \nthe space bar", 40, 150);

//If the user pockets the cue Ball reset game by hitting space ball
      if (keyPressed && key==' ') 
      {
        setup();
      }
    }
    if (a.center.x>=width-30 || a.center.x<=30 && a.center.x !=-10  ) //collision edge Location X 
    {

      a.velocity_x *=-1;
    }
    if (a.center.y>=height-30 || a.center.y<=30 && a.center.x !=-10 ) //collision edge Location Y 
    {
      a.velocity_y *=-1;
    }

    if (abs(a.velocity_x)<0.3 && abs(a.velocity_y)<0.3) //when the Ball increments reach a value close to zero make it zero
    {
      a. velocity_x=0;
      a.velocity_y=0;
    }

    if (keyPressed && key=='q') //Stop the cue Ball instantly by pressing 'q'
    {
      a.velocity_x=0;
      a.velocity_y=0;
    }
  }
}
// Calculates distance between center of cueball and mousex and y
// Used to for power calculation 
float calc_distance()
{
  return sqrt(pow(mouseX-cueball.center.x, 2)+pow(mouseY-cueball.center.y, 2));
}


class Ball 
{ 
  PVector dir;
  int radius;
  float velocity_x;
  float velocity_y;
  boolean scored;

  Point center;
  Point contact_place;

  float C1; 
  float C2;
  float C3;
 //Constructors the ball
  Ball(int x, int y, int rad, float red, float green, float blue)
  {
    center= new Point(x, y);
    radius= rad;
    C1=red;
    C2=green;
    C3=blue;
    dir = new PVector(center.x, center.y); 
  }
// Most recent ball position
  void latest() 
  {
    dir.add(velocity_x, velocity_y);
    center.x=dir.x;
    center.y=dir.y;
//Decelates Cue Ball via friction factor
    velocity_x *=new_position.fric; 
    velocity_y *=new_position.fric;
    fill(color(C1, C2, C3));
    ellipse(center.x, center.y, radius, radius);
  }
// collision detection
  void coll(Ball a, Ball b[]) 
  { 

    for (int i=0; i<6; i++)
    {
      for (int j=i; j<6; j++) 
      {
        float xx=b[i].center.x-a.center.x;
        float yy=b[i].center.y-a.center.y;
        float dist = sqrt(xx*xx + yy*yy);
        float LeastDistance = 33;

        if ( dist < LeastDistance ) {

          float ang = atan2(yy, xx);
          float targA = a.center.x + cos(ang) * LeastDistance;
          float targB = a.center.y + sin(ang) * LeastDistance;
          float aa = (targA - b[i].center.x)*0.045 ;
          float bb = (targB - b[i].center.y)*0.045 ;
          velocity_x -= aa;
          velocity_y -= bb;
          b[i].velocity_x += aa;
          b[i].velocity_y += bb;
        }
      }
    }
  }
}


class Stick { 

// Power control colors
  void StickPower(float x, float y)
  {

    if (mousePressed==true && cueball.velocity_x==0 && cueball.velocity_y==0 && cueball.center.x !=-10)
    {
      if (calc_distance()>=0&&calc_distance()<100) { 
        stroke(#00F025);
      }
      if (calc_distance()>100 && calc_distance()<200) {  
        stroke(#072662);
      }
      if (calc_distance()>200&&calc_distance()<300) { 
        stroke(#FFF303);
      }
      if (  calc_distance()>=300) 
      {
        stroke(#FF0000);
      }
      strokeWeight(5);
      line(x, y, mouseX, mouseY);
     
    }
   noStroke();
  }
}


class Table
{
  Ball[] all; //The rest of the Balls placed on the table

  void table()
  {
    noStroke();
    fill(139, 70, 19, 100);
    rect(0, 0, width, height);//Outter rectangle 
    fill(0, 128, 0);//Smaller inner rectangle
    rect(10, 10, width-20, height-20);

    fill(255);
    stroke(2);
    ellipse(0, 0, 100, 100);
    ellipse(0, height, 100, 100);
    ellipse(width, 0, 100, 100);
    ellipse(width, height, 100, 100);
  }
//Ball array initialized 
  void ball_arr(int num) 
  {
    all=new Ball[6]; 
    int x=600;
    int y=250;
    for (int i=0; i<num; i++) 
    {
      if (i==0) 
      {
        x=600;
        y=250;
        all[i] =new Ball(x, y, 30, 0, 128, 255);
      }
      if (i==1) { 
        y=230;
        x=630;
        noStroke();
        all[i]=new Ball(x, y, 30, 0, 128, 255);
      }
      if (i==2) { 
        y=265;
        x=630;
        all[i]=new Ball(x, y, 30, 0, 128, 255);
      }
      if (i==3) { 
        y=250;
        x=660;
        all[i]=new Ball(x, y, 30, 0, 128, 255);
      }
      if (i==4) { 
        y=285;
        x=660;

        all[i]=new Ball(x, y, 30, 0, 128, 255);
      }
      if (i==5) { 
        y=215;
        x=660;

        all[i]=new Ball(x, y, 30, 0, 128, 255);
      }
    }
  }
}
class Point  
{
  float x, y; 
  Point (float a, float b)
  {
    x = a;
    y = b;
  }
}
// 
class mov  
{
  float velocity_of_x;
  float velocity_of_y;
  float fric=0.98;

  mov(float x, float y){}
  
  void velocity(float x, float y)
  {

    velocity_of_x=(x-mouseX)/10;
    velocity_of_y=(y-mouseY)/10;
  }
}