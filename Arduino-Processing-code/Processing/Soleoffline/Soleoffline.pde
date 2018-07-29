PShape sole;
String myString = null;
Table table1, data;
int i=0,i1=0,j=0, R,G,B, ln=10, k=1, m, gain=2050, numl, a=0,b=0,c=0,d=0,e=0,f=0,g=0,h=0,x=0,x1, count=0, ff, mf, bf, bar;
float val, limiter=0.25, v=0.01;
float[] numsfront = { 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 };
float[] numsmid = { 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 };
float[] numsback = { 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 };
float maxvaluefront, maxvaluemid, maxvalueback;
int positionfront, positionmid, positionback;

void setup() {

  size(1200,600);
  background(156);
  frameRate(600);
  
  table1 = loadTable("Plantar Pressure Distribution 2.csv");
}


void draw() {
  
  background(156);
  myString = table1.getString(k,1);
  
  if (myString != null) {
  delay(60);
  float nums [] = float(split(myString, ','));
  numl=nums.length;
  
  // Find Max pressure position and Values
  maxvaluefront = 0.00;
  positionfront = -1;
  
  maxvaluemid = 0.00;
  positionmid = -1;
  
  maxvalueback = 0.00;
  positionback = -1;
  k++;

if(k>41){k=1;}

if(numl>63)
{

 for(ff=0;ff<28;ff++){
  numsfront [ff]= nums[ff];

  if(numsfront [ff]>maxvaluefront){
    positionfront=ff;
    maxvaluefront=numsfront [ff];

  } 
}

  for(mf=28;mf<49;mf++){
  numsmid [mf-28]= nums[mf];

  if(numsmid [mf-28]>maxvaluemid){
    positionmid=mf;
    maxvaluemid=numsmid [mf-28];
  } 
}

  for(bf=49;bf<63;bf++){
  numsback [bf-49]= nums[bf];

  
  if(numsback [bf-49]>maxvalueback){
    positionback=bf;
    maxvalueback=numsback [bf-49];
  } 
}

for(bar=0;bar<64;bar++){
 
  fill(0);
  stroke(0);
  rect (bar*10+500, 400-(nums[bar]*200), 8, (nums[bar]*200));
 
}

  textSize(16);
  fill(0);
  text("Frontfoot",610,420);
  
  textSize(16);
  fill(0);
  text("Midfoot",850,420);
  
  textSize(16);
  fill(0);
  text("Backfoot",1035,420);
  
  print("Forefoot: ");
  print(positionfront);print("\t");print(maxvaluefront);print("\t");print("\t");
  print("Midfoot: ");
  print(positionmid);print("\t");print(maxvaluemid);print("\t");print("\t");
  print("Backfoot: ");
  print(positionback);print("\t");print(maxvalueback);print("\t");println("\t");
  
  
  
//R1C2  
j=int((nums[0]-limiter)*gain);
a=constrain(int(((nums[1]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[3]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[4]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[5]-limiter)*gain)*v),0,255);
x=j+a+b+c+d;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
//translate(100, 100, 0);
//rotateY(PI/8);
//rotateY(PI/4);
vertex(308,3);
vertex(268,38);
vertex(308,38);

// etc;
endShape();  


//R1C3  
j=int((nums[1]-limiter)*gain);
a=constrain(int(((nums[0]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[2]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[4]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[5]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[6]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,3);
vertex(350,5);
vertex(350,39);
vertex(308,39);

// etc;
endShape();

//R1C4  
j=int((nums[2]-limiter)*gain);
a=constrain(int(((nums[1]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[5]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[6]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[7]-limiter)*gain)*v),0,255);
x=j+a+b+c+d;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,6);
vertex(390,39);
vertex(351,39);
// etc;
endShape(); 

//R2C1  
j=int((nums[3]-limiter)*gain);
a=constrain(int(((nums[0]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[4]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[8]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[9]-limiter)*gain)*v),0,255);

x=j+a+b+c+d;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(266,42);
vertex(249,79);
vertex(266,79);
// etc;
endShape(); 

//R2C2
j=int((nums[4]-limiter)*gain);
a=constrain(int(((nums[0]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[1]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[3]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[5]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[8]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[9]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[10]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(266,79);
vertex(308,79);
vertex(308,39);
vertex(266,39);
// etc;
endShape();

//R2C3
j=constrain(int((nums[5]-limiter)*gain),0,255);
a=constrain(int(((nums[0]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[1]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[2]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[4]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[6]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[9]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[10]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[11]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,79);
vertex(350,79);
vertex(350,39);
vertex(308,39);
// etc;
endShape();

//R2C4
j=int((nums[6]-limiter)*gain);
a=constrain(int(((nums[1]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[2]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[5]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[7]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[10]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[11]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[12]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,78);
vertex(391,78);
vertex(391,39);
vertex(351,39);
// etc;
endShape();

//R2C5
j=int((nums[7]-limiter)*gain);
a=constrain(int(((nums[2]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[6]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[11]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[12]-limiter)*gain)*v),0,255);
x=j+a+b+c+d;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(412,78);
vertex(392,78);
vertex(392,40);
// etc;
endShape();

//R3C1
j=int((nums[8]-limiter)*gain);
a=constrain(int(((nums[3]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[4]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[9]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[13]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[14]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(248,80);
vertex(266,80);
vertex(266,119);
vertex(241,119);
// etc;
endShape();

//R3C2
j=int((nums[9]-limiter)*gain);
a=constrain(int(((nums[3]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[4]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[5]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[8]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[10]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[13]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[14]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[15]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,80);
vertex(266,80);
vertex(266,119);
vertex(308,119);
// etc;
endShape();

//R3C3
j=int((nums[10]-limiter)*gain);
a=constrain(int(((nums[4]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[5]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[6]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[9]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[11]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[14]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[15]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[16]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,80);
vertex(308,80);
vertex(308,119);
vertex(351,119);
// etc;
endShape();

//R3C4
j=int((nums[11]-limiter)*gain);
a=constrain(int(((nums[5]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[6]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[7]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[10]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[12]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[15]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[16]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[17]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,79);
vertex(391,79);
vertex(391,119);
vertex(351,119);
// etc;
endShape();

//R3C5
j=int((nums[12]-limiter)*gain);
a=constrain(int(((nums[6]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[7]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[11]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[16]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[17]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(413,79);
vertex(392,79);
vertex(392,119);
vertex(427,119);
// etc;
endShape();

//R4C1
j=int((nums[13]-limiter)*gain);
a=constrain(int(((nums[8]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[9]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[14]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[18]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[19]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(241,119);
vertex(266,119);
vertex(266,159);
vertex(240,159);
// etc;
endShape();

//R4C2
j=int((nums[14]-limiter)*gain);
a=constrain(int(((nums[8]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[9]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[10]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[13]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[15]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[18]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[19]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[20]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(266,119);
vertex(308,119);
vertex(308,159);
vertex(266,159);
// etc;
endShape();

//R4C3
j=int((nums[15]-limiter)*gain);
a=constrain(int(((nums[9]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[10]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[11]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[14]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[16]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[19]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[20]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[21]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,119);
vertex(308,119);
vertex(308,159);
vertex(351,159);
// etc;
endShape();

//R4C4
j=int((nums[16]-limiter)*gain);
a=constrain(int(((nums[10]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[11]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[12]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[15]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[17]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[20]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[21]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[22]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,120);
vertex(391,120);
vertex(391,159);
vertex(351,159);
// etc;
endShape();

//R4C5
j=int((nums[17]-limiter)*gain);
a=constrain(int(((nums[11]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[12]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[16]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[21]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[22]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(428,120);
vertex(392,120);
vertex(392,159);
vertex(434,159);
// etc;
endShape();

//R5C1
j=int((nums[18]-limiter)*gain);
a=constrain(int(((nums[13]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[14]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[19]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[23]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[24]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(239,160);
vertex(265,160);
vertex(265,199);
vertex(242,199);
// etc;
endShape();

//R5C2
j=int((nums[19]-limiter)*gain);
a=constrain(int(((nums[13]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[14]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[15]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[18]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[20]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[23]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[24]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[25]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(309,160);
vertex(266,160);
vertex(266,199);
vertex(309,199);
// etc;
endShape();

//R5C3
j=int((nums[20]-limiter)*gain);
a=constrain(int(((nums[14]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[15]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[16]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[19]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[21]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[24]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[25]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[26]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,160);
vertex(309,160);
vertex(309,199);
vertex(351,199);
// etc;
endShape();

//R5C4
j=int((nums[21]-limiter)*gain);
a=constrain(int(((nums[15]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[16]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[17]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[20]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[22]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[25]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[26]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[27]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,160);
vertex(391,160);
vertex(391,199);
vertex(351,199);
// etc;
endShape();

//R5C5
j=int((nums[22]-limiter)*gain);
a=constrain(int(((nums[16]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[17]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[21]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[26]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[27]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(435,160);
vertex(392,160);
vertex(392,199);
vertex(438,199);
// etc;
endShape();

//R6C1
j=int((nums[23]-limiter)*gain);
a=constrain(int(((nums[18]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[19]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[24]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[28]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[29]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(266,200);
vertex(243,200);
vertex(252,239);
vertex(266,239);
// etc;
endShape();

//R6C2
j=int((nums[24]-limiter)*gain);
a=constrain(int(((nums[18]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[19]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[20]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[23]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[25]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[28]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[29]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[30]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,200);
vertex(266,200);
vertex(266,239);
vertex(308,239);
// etc;
endShape();

//R6C3
j=int((nums[25]-limiter)*gain);
a=constrain(int(((nums[19]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[20]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[21]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[24]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[26]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[29]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[30]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[31]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,200);
vertex(308,200);
vertex(308,239);
vertex(351,239);
// etc;
endShape();

//R6C4
j=int((nums[26]-limiter)*gain);
a=constrain(int(((nums[20]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[21]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[22]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[25]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[27]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[30]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[31]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[32]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,200);
vertex(391,200);
vertex(391,239);
vertex(351,239);
// etc;
endShape();

//R6C5
j=int((nums[27]-limiter)*gain);
a=constrain(int(((nums[21]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[22]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[26]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[31]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[32]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(438,200);
vertex(392,200);
vertex(392,239);
vertex(437,239);
// etc;
endShape();

//R7C1
j=int((nums[28]-limiter)*gain);
a=constrain(int(((nums[23]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[24]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[29]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[33]-limiter)*gain)*v),0,255);

x=j+a+b+c+d;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(266,240);
vertex(252,240);
vertex(266,278);
// etc;
endShape();

//R7C2
j=int((nums[29]-limiter)*gain);
a=constrain(int(((nums[23]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[24]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[25]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[28]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[30]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[33]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[34]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,240);
vertex(266,240);
vertex(266,279);
vertex(308,279);
// etc;
endShape();

//R7C3
j=int((nums[30]-limiter)*gain);
a=constrain(int(((nums[24]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[25]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[26]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[29]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[31]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[33]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[34]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[35]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,240);
vertex(308,240);
vertex(308,279);
vertex(351,279);
// etc;
endShape();

//R7C4
j=int((nums[31]-limiter)*gain);
a=constrain(int(((nums[25]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[26]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[27]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[31]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[32]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[34]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[35]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[36]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,240);
vertex(391,240);
vertex(391,279);
vertex(351,279);
// etc;
endShape();

//R7C5
j=int((nums[32]-limiter)*gain);
a=constrain(int(((nums[26]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[27]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[31]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[35]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[36]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(437,240);
vertex(392,240);
vertex(392,279);
vertex(433,279);
// etc;
endShape();

//R8C2
j=int((nums[33]-limiter)*gain);
a=constrain(int(((nums[28]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[29]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[30]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[34]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[37]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[38]-limiter)*gain)*v),0,255);;

x=j+a+b+c+d+e+f;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,280);
vertex(267,280);
vertex(284,321);
vertex(308,321);
// etc;
endShape();

//R8C3
j=int((nums[34]-limiter)*gain);
a=constrain(int(((nums[29]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[30]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[31]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[33]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[35]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[37]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[38]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[39]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,280);
vertex(308,280);
vertex(308,321);
vertex(351,321);
// etc;
endShape();

//R8C4
j=int((nums[35]-limiter)*gain);
a=constrain(int(((nums[30]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[31]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[32]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[34]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[36]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[38]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[39]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[40]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,280);
vertex(391,280);
vertex(391,321);
vertex(351,321);
// etc;
endShape();

//R8C5
j=int((nums[36]-limiter)*gain);
a=constrain(int(((nums[31]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[32]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[35]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[39]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[40]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(433,280);
vertex(392,280);
vertex(392,321);
vertex(426,321);
// etc;
endShape();

//R9C2
j=int((nums[37]-limiter)*gain);
a=constrain(int(((nums[33]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[34]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[38]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[41]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[42]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,322);
vertex(284,322);
vertex(287,361);
vertex(308,361);
// etc;
endShape();

//R9C3
j=int((nums[38]-limiter)*gain);
a=constrain(int(((nums[33]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[34]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[35]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[37]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[39]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[41]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[42]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[43]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,322);
vertex(308,322);
vertex(308,361);
vertex(351,361);
// etc;
endShape();

//R9C4
j=int((nums[39]-limiter)*gain);
a=constrain(int(((nums[34]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[35]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[36]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[38]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[40]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[42]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[43]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[44]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,322);
vertex(391,322);
vertex(391,361);
vertex(351,361);
// etc;
endShape();

//R9C5
j=int((nums[40]-limiter)*gain);
a=constrain(int(((nums[35]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[36]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[39]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[43]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[44]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(426,322);
vertex(392,322);
vertex(392,361);
vertex(420,361);
// etc;
endShape();

//R10C2
j=int((nums[41]-limiter)*gain);
a=constrain(int(((nums[37]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[38]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[42]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[45]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[46]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,362);
vertex(288,362);
vertex(282,400);
vertex(308,400);
// etc;
endShape();

//R10C3
j=int((nums[42]-limiter)*gain);
a=constrain(int(((nums[37]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[38]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[39]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[41]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[43]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[45]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[46]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[47]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,362);
vertex(308,362);
vertex(308,400);
vertex(351,400);
// etc;
endShape();

//R10C4
j=int((nums[43]-limiter)*gain);
a=constrain(int(((nums[38]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[39]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[40]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[42]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[44]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[46]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[47]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[48]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,362);
vertex(391,362);
vertex(391,400);
vertex(351,400);
// etc;
endShape();

//R10C5
j=int((nums[44]-limiter)*gain);
a=constrain(int(((nums[39]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[40]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[43]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[47]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[48]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(420,362);
vertex(392,362);
vertex(392,400);
vertex(417,400);
// etc;
endShape();

//R11C2
j=int((nums[45]-limiter)*gain);
a=constrain(int(((nums[41]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[42]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[46]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[49]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[50]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,401);
vertex(282,401);
vertex(273,441);
vertex(308,441);
// etc;
endShape();

//R11C3
j=int((nums[46]-limiter)*gain);
a=constrain(int(((nums[41]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[42]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[43]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[45]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[47]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[49]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[50]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[51]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,401);
vertex(308,401);
vertex(308,441);
vertex(351,441);
// etc;
endShape();

//R11C4
j=int((nums[47]-limiter)*gain);
a=constrain(int(((nums[42]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[43]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[44]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[46]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[48]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[50]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[51]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[52]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,401);
vertex(391,401);
vertex(391,441);
vertex(351,441);
// etc;
endShape();

//R11C5
j=int((nums[48]-limiter)*gain);
a=constrain(int(((nums[43]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[44]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[47]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[51]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[52]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(417,401);
vertex(392,401);
vertex(392,441);
vertex(415,441);
// etc;
endShape();

//R12C2
j=int((nums[49]-limiter)*gain);
a=constrain(int(((nums[45]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[46]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[50]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[53]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[54]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,442);
vertex(273,442);
vertex(267,482);
vertex(308,482);
// etc;
endShape();

//R12C3
j=int((nums[50]-limiter)*gain);
a=constrain(int(((nums[45]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[46]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[47]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[49]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[51]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[53]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[54]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[55]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,442);
vertex(308,442);
vertex(308,482);
vertex(351,482);
// etc;
endShape();

//R12C4
j=int((nums[51]-limiter)*gain);
a=constrain(int(((nums[46]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[47]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[48]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[50]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[52]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[54]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[55]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[56]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,442);
vertex(391,442);
vertex(391,482);
vertex(351,482);
// etc;
endShape();

//R12C5
j=int((nums[52]-limiter)*gain);
a=constrain(int(((nums[47]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[48]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[51]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[55]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[56]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(415,442);
vertex(392,442);
vertex(392,482);
vertex(415,482);
// etc;
endShape();

//R13C2
j=int((nums[53]-limiter)*gain);
a=constrain(int(((nums[49]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[50]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[54]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[57]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[58]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,483);
vertex(266,483);
vertex(266,521);
vertex(308,521);
// etc;
endShape();

//R13C3
j=int((nums[54]-limiter)*gain);
a=constrain(int(((nums[49]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[50]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[51]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[53]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[55]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[57]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[58]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[59]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,483);
vertex(308,483);
vertex(308,521);
vertex(351,521);
// etc;
endShape();

//R13C4
j=int((nums[55]-limiter)*gain);
a=constrain(int(((nums[50]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[51]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[52]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[54]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[56]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[58]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[59]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[60]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,483);
vertex(391,483);
vertex(391,521);
vertex(351,521);
// etc;
endShape();

//R13C5
j=int((nums[56]-limiter)*gain);
a=constrain(int(((nums[51]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[52]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[55]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[59]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[60]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(415,483);
vertex(392,483);
vertex(392,521);
vertex(412,521);
// etc;
endShape();

//R14C2
j=int((nums[57]-limiter)*gain);
a=constrain(int(((nums[53]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[54]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[58]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[61]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[62]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,522);
vertex(266,522);
vertex(275,560);
vertex(308,560);
// etc;
endShape();

//R14C3
j=int((nums[58]-limiter)*gain);
a=constrain(int(((nums[53]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[54]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[55]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[57]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[59]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[61]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[62]-limiter)*gain)*v),0,255);
h=constrain(int(((nums[63]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g+h;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,522);
vertex(308,522);
vertex(308,560);
vertex(351,560);
// etc;
endShape();

//R14C4
j=int((nums[59]-limiter)*gain);
a=constrain(int(((nums[54]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[55]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[56]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[58]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[60]-limiter)*gain)*v),0,255);
f=constrain(int(((nums[62]-limiter)*gain)*v),0,255);;
g=constrain(int(((nums[63]-limiter)*gain)*v),0,255);
x=j+a+b+c+d+e+f+g;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,522);
vertex(391,522);
vertex(391,560);
vertex(351,560);
// etc;
endShape();

//R14C5
j=int((nums[60]-limiter)*gain);
a=constrain(int(((nums[55]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[56]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[59]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[63]-limiter)*gain)*v),0,255);
x=j+a+b+c+d;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(411,522);
vertex(392,522);
vertex(392,560);
// etc;
endShape();

//R15C2
j=int((nums[61]-limiter)*gain);
a=constrain(int(((nums[57]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[58]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[62]-limiter)*gain)*v),0,255);

x=j+a+b+c;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(308,561);
vertex(277,561);
vertex(308,593);
// etc;
endShape();

//R15C3
j=int((nums[62]-limiter)*gain);
a=constrain(int(((nums[57]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[58]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[59]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[61]-limiter)*gain)*v),0,255);
e=constrain(int(((nums[63]-limiter)*gain)*v),0,255);

x=j+a+b+c+d+e;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,561);
vertex(308,561);
vertex(308,593);
vertex(351,595);
// etc;
endShape();


//R15C4
j=int((nums[63]-limiter)*gain);
a=constrain(int(((nums[58]-limiter)*gain)*v),0,255);
b=constrain(int(((nums[59]-limiter)*gain)*v),0,255);
c=constrain(int(((nums[60]-limiter)*gain)*v),0,255);
d=constrain(int(((nums[62]-limiter)*gain)*v),0,255);

x=j+a+b+c+d;
i=constrain(x,0,255);
fill(i);
stroke(i);
beginShape();
vertex(351,561);
vertex(390,561);
vertex(351,595);
// etc;
endShape();

}
}
}
