// I2Cdev and MPU6050 must be installed as libraries, or else the .cpp/.h files
// for both classes must be in the include path of your project

const int S0 = 5;      
const int S1 = 4;       
const int S2 = 3;       
const int S3 = 2;   
#include <SoftwareSerial.h>

#include "I2Cdev.h"
#include "MPU6050_Wrapper.h"
#include "TogglePin.h"
#include "DeathTimer.h"
#include "Kalman.h"
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
#include "Wire.h"
#endif


#define OUTPUT_READABLE_EULER
//#define RESTRICT_PITCH
const bool useSecondMpu = true;
MPU6050_Array mpus(useSecondMpu ? 2 : 1);

#define AD0_PIN_0 6  // Connect this pin to the AD0 pin on MPU #0
#define AD0_PIN_1 7  // Connect this pin to the AD0 pin on MPU #1

Kalman kalmanX; // Create the Kalman instances IMU 1
Kalman kalmanY;

Kalman kalmanX1; // Create the Kalman instances IMU 2
Kalman kalmanY1;

/* IMU Data */
double accX1, accY1, accZ1;
double gyroX1, gyroY1, gyroZ1;

double accX, accY, accZ;
double accXprevious, accX1previous;
double gyroX, gyroY, gyroZ;

int trigger=0, trigger1=0;
int16_t tempRaw;
int Sec20=0;

double gyroXangle, gyroYangle; // Angle calculate using the gyro only
double compAngleX, compAngleY; // Calculated angle using a complementary filter
double kalAngleX, kalAngleY; // Calculated angle using a Kalman filter

double compcalAngleX=0.00, compAngleXprevious, kalcalAngleX=0.00, kalAngleXprevious;
double compcalAngleX1=0.00, compAngleX1previous, kalcalAngleX1=0.00, kalAngleX1previous;

double gyroXangle1, gyroYangle1; // Angle calculate using the gyro only
double compAngleX1, compAngleY1; // Calculated angle using a complementary filter
double kalAngleX1, kalAngleY1; // Calculated angle using a Kalman filter

uint32_t timer;
uint8_t i2cData[14]; // Buffer for I2C data

uint32_t timer1;
uint8_t i2cData1[14]; // Buffer for I2C data

uint8_t fifoBuffer[64]; // FIFO storage buffer

// orientation/motion vars
Quaternion q;        // [w, x, y, z]         quaternion container
VectorInt16 aa;      // [x, y, z]            accel sensor measurements
VectorInt16 aaReal;  // [x, y, z]            gravity-free accel sensor measurements
VectorInt16 aaWorld; // [x, y, z]            world-frame accel sensor measurements
VectorFloat gravity; // [x, y, z]            gravity vector
float euler[3];      // [psi, theta, phi]    Euler angle container
float ypr[3];        // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector
int status=1;
// packet structure for InvenSense teapot demo
uint8_t teapotPacket[14] = { '$', 0x02, 0, 0, 0, 0, 0, 0, 0, 0, 0x00, 0x00, '\r', '\n' };
float theta, z, qw,qx,qz,qy, x,y,l,m, psi,phi;
int timeinitial=millis(), timefinal;

double roll, roll1, pitch, pitch1,gyroXrate, calroll, calroll1;

double Roll_matrix[3]={0.00,0.00,0.00};

double Roll1_matrix[3]={0.00,0.00,0.00};

DeathTimer deathTimer(5000L);

// ================================================================
// ===                      INITIAL SETUP                       ===
// ================================================================

void setup() {

    // initialize serial communication at 9600 bits per second:
  Serial.begin(115200);
  //BluetoothSerial.begin(2000000);
  pinMode(S0, OUTPUT);
  pinMode(S1, OUTPUT);
  pinMode(S2, OUTPUT); 
  pinMode(S3, OUTPUT);
  
  // join I2C bus (I2Cdev library doesn't do this automatically)
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
  Wire.begin();
  Wire.setClock(400000); // 400kHz I2C clock. Comment this line if having compilation difficulties
#elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
  Fastwire::setup(400, true);
#endif

  // initialize serial communication
  // (115200 chosen because it is required for Teapot Demo output, but it's
  // really up to you depending on your project)
  //Serial.begin(115200);
  TWBR = ((F_CPU / 400000L) - 16) / 2; // Set I2C frequency to 400kHz

  i2cData[0] = 7; // Set the sample rate to 1000Hz - 8kHz/(7+1) = 1000Hz
  i2cData[1] = 0x00; // Disable FSYNC and set 260 Hz Acc filtering, 256 Hz Gyro filtering, 8 KHz sampling
  i2cData[2] = 0x00; // Set Gyro Full Scale Range to ±250deg/s
  i2cData[3] = 0x00; // Set Accelerometer Full Scale Range to ±2g

  i2cData1[0] = 7; // Set the sample rate to 1000Hz - 8kHz/(7+1) = 1000Hz
  i2cData1[1] = 0x00; // Disable FSYNC and set 260 Hz Acc filtering, 256 Hz Gyro filtering, 8 KHz sampling
  i2cData1[2] = 0x00; // Set Gyro Full Scale Range to ±250deg/s
  i2cData1[3] = 0x00; // Set Accelerometer Full Scale Range to ±2g

  while (i2cWrite(0x19, i2cData, 4, false)); // Write to all four registers at once
  while (i2cWrite(0x6B, 0x01, true)); // PLL with X axis gyroscope reference and disable sleep mode

 // while (i2cRead(0x75, i2cData, 1));
//  if (i2cData[0] != 0x68) { // Read "WHO_AM_I" register
//    Serial.print(F("Error reading sensor"));
//    while (1);
//  }

  while (i2cWrite(0x19, i2cData1, 4, false)); // Write to all four registers at once
  while (i2cWrite(0x6B, 0x01, true)); // PLL with X axis gyroscope reference and disable sleep mode

  //while (i2cRead(0x75, i2cData1, 1));
//  if (i2cData[0] != 0x68) { // Read "WHO_AM_I" register
//    Serial.print(F("Error reading sensor"));
//    while (1);
//  }

  delay(100); // Wait for sensor to stabilize

  /* Set kalman and gyro starting angle */
  while (i2cRead(0x3B, i2cData, 6));
  accX = (i2cData[0] << 8) | i2cData[1];
  accY = (i2cData[2] << 8) | i2cData[3];
  accZ = (i2cData[4] << 8) | i2cData[5];

  while (i2cRead(0x3B, i2cData1, 6));
  accX1 = (i2cData[0] << 8) | i2cData1[1];
  accY1 = (i2cData[2] << 8) | i2cData1[3];
  accZ1 = (i2cData[4] << 8) | i2cData1[5];

#ifdef RESTRICT_PITCH // Eq. 25 and 26
  double roll  = atan2(accY, accZ) * RAD_TO_DEG;
  double pitch = atan(-accX / sqrt(accY * accY + accZ * accZ)) * RAD_TO_DEG;

  double roll1  = atan2(accY1, accZ1) * RAD_TO_DEG;
  double pitch1 = atan(-accX1 / sqrt(accY1 * accY1 + accZ1 * accZ1)) * RAD_TO_DEG;
#else // Eq. 28 and 29
  double roll  = atan(accY / sqrt(accX * accX + accZ * accZ)) * RAD_TO_DEG;
  double pitch = atan2(-accX, accZ) * RAD_TO_DEG;
  
  double roll1  = atan(accY1 / sqrt(accX1 * accX1 + accZ1 * accZ1)) * RAD_TO_DEG;
  double pitch1 = atan2(-accX1, accZ1) * RAD_TO_DEG;
#endif

  kalmanX.setAngle(roll); // Set starting angle
  kalmanY.setAngle(pitch);
  gyroXangle = roll;
  gyroYangle = pitch;
  compAngleX = roll;
  compAngleY = pitch;

  kalmanX1.setAngle(roll); // Set starting angle
  kalmanY1.setAngle(pitch);
  gyroXangle1 = roll1;
  gyroYangle1 = pitch1;
  compAngleX1 = roll1;
  compAngleY1 = pitch1;

  timer = micros();
  timer1 = micros();
  
  while (!Serial)
    ; // wait for Leonardo enumeration, others continue immediately

  // NOTE: 8MHz or slower host processors, like the Teensy @ 3.3v or Ardunio
  // Pro Mini running at 3.3v, cannot handle this baud rate reliably due to
  // the baud timing being too misaligned with processor ticks. You must use
  // 38400 or slower in these cases, or use some kind of external separate
  // crystal solution for the UART timer.

  // initialize device
  //Serial.println(F("Initializing I2C devices..."));
  mpus.add(AD0_PIN_0);
  if (useSecondMpu) mpus.add(AD0_PIN_1);

  mpus.initialize();
  // load and configure the DMP
  //Serial.println(F("Initializing DMP..."));
  mpus.dmpInitialize();

  // supply your own gyro offsets here, scaled for min sensitivity
  MPU6050_Wrapper* currentMPU = mpus.select(0);
    currentMPU->_mpu.setXGyroOffset(220);
    currentMPU->_mpu.setYGyroOffset(76);
    currentMPU->_mpu.setZGyroOffset(-85);
    currentMPU->_mpu.setZAccelOffset(1788); // 1688 factory default for my test chip
  if (useSecondMpu) {
    currentMPU = mpus.select(1);
    currentMPU->_mpu.setXGyroOffset(220);
    currentMPU->_mpu.setYGyroOffset(76);
    currentMPU->_mpu.setZGyroOffset(-85);
    currentMPU->_mpu.setZAccelOffset(1788); // 1688 factory default for my test chip
  }
  mpus.programDmp(0);
  if (useSecondMpu)
    mpus.programDmp(1);
}


void handleMPUevent(uint8_t mpu) {

  MPU6050_Wrapper* currentMPU = mpus.select(mpu);
  // reset interrupt flag and get INT_STATUS byte
  currentMPU->getIntStatus();
  // check for overflow (this should never happen unless our code is too inefficient)
  if ((currentMPU->_mpuIntStatus & _BV(MPU6050_INTERRUPT_FIFO_OFLOW_BIT))
      || currentMPU->_fifoCount >= 1024) {
    // reset so we can continue cleanly
    currentMPU->resetFIFO();
    //Serial.println(F("FIFO overflow!"));
    return;
  }
  // otherwise, check for DMP data ready interrupt (this should happen frequently)
  if (currentMPU->_mpuIntStatus & _BV(MPU6050_INTERRUPT_DMP_INT_BIT)) {
    // read and dump a packet if the queue contains more than one
    while (currentMPU->_fifoCount >= 2 * currentMPU->_packetSize) {
      // read and dump one sample
      //Serial.print("DUMP"); // this trace will be removed soon
      currentMPU->getFIFOBytes(fifoBuffer);
    }

    // read a packet from FIFO
    currentMPU->getFIFOBytes(fifoBuffer);

#ifdef OUTPUT_READABLE_EULER
    // display Euler angles in degrees
    currentMPU->_mpu.dmpGetQuaternion(&q, fifoBuffer);
    currentMPU->_mpu.dmpGetEuler(euler, &q);
    timefinal=millis();
            qw=q.w;
            qx=q.x;
            qy=q.y;
            qz=q.z;
            x = 2*(qw*qx+qz*qy);
            y = (qz*qz)-(qy*qy)-(qx*qx)+(qw*qw);
            z = -2*((qw*qy)-(qx*qz));
            l = 2*((qx*qy)+(qw*qz));
            m = (qz*qz)+(qy*qy)-(qx*qx)-(qw*qw);

           phi = (180/3.1415)*atan2(x,y);
           theta = (180/3.1415)*asin(z);
           psi = (180/3.1415)*atan2(l,m);
            
    if(status!=mpu){
    if(mpu==1){

          while (i2cRead(0x3B, i2cData, 14));
          accX = ((i2cData[0] << 8) | i2cData[1]);
          accY = ((i2cData[2] << 8) | i2cData[3]);
          accZ = ((i2cData[4] << 8) | i2cData[5]);
          tempRaw = (i2cData[6] << 8) | i2cData[7];
          gyroX = (i2cData[8] << 8) | i2cData[9];
          gyroY = (i2cData[10] << 8) | i2cData[11];
          gyroZ = (i2cData[12] << 8) | i2cData[13];
  
          double dt = (double)(micros() - timer) / 1000000; // Calculate delta time
          timer = micros();

#ifdef RESTRICT_PITCH // Eq. 25 and 26
  double roll  = atan2(accY, accZ) * RAD_TO_DEG;
  double pitch = atan(-accX / sqrt(accY * accY + accZ * accZ)) * RAD_TO_DEG;
  
#else // Eq. 28 and 29
  double roll  = (atan2(accY, sqrt(accZ * accZ + accX * accX)) * RAD_TO_DEG);
  double pitch = atan2(-accX, accZ) * RAD_TO_DEG;

#endif

 double gyroXrate = gyroX / 131.0; // Convert to deg/s
 double gyroYrate = gyroY / 131.0; // Convert to deg/s


#ifdef RESTRICT_PITCH
  // This fixes the transition problem when the accelerometer angle jumps between -180 and 180 degrees
  if ((roll < -90 && kalAngleX > 90) || (roll > 90 && kalAngleX < -90)) {
    kalmanX.setAngle(roll);
    compAngleX = roll;
    kalAngleX = roll;
    gyroXangle = roll;
  } else
    {kalAngleX = kalmanX.getAngle(roll, gyroXrate, dt); // Calculate the angle using a Kalman filter
    }
  if (abs(kalAngleX) > 90)
    gyroYrate = -gyroYrate;// Invert rate, so it fits the restriced accelerometer reading
  kalAngleY = kalmanY.getAngle(pitch, gyroYrate, dt);


#else
  // This fixes the transition problem when the accelerometer angle jumps between -180 and 180 degrees
  if ((pitch < -90 && kalAngleY > 90) || (pitch > 90 && kalAngleY < -90)) {
    kalmanY.setAngle(pitch);
    compAngleY = pitch;
    kalAngleY = pitch;
    gyroYangle = pitch;
  } else
    {kalAngleY = kalmanY.getAngle(pitch, gyroYrate, dt); // Calculate the angle using a Kalman filter
    }

  if (abs(kalAngleY) > 90)
    gyroXrate = -gyroXrate; // Invert rate, so it fits the restriced accelerometer reading
  kalAngleX = kalmanX.getAngle(roll, gyroXrate, dt); // Calculate the angle using a Kalman filter
#endif

  gyroXangle += gyroXrate * dt; // Calculate gyro angle without any filter
  gyroYangle += gyroYrate * dt;
  //gyroXangle += kalmanX.getRate() * dt; // Calculate gyro angle using the unbiased rate
  //gyroYangle += kalmanY.getRate() * dt;

  compAngleX = 0.93 * (compAngleX + gyroXrate * dt) + 0.07 * roll; // Calculate the angle using a Complimentary filter
  compAngleY = 0.93 * (compAngleY + gyroYrate * dt) + 0.07 * pitch;
  calroll=roll;

  if (gyroXangle < -180 || gyroXangle > 180)
    gyroXangle = kalAngleX;
  if (gyroYangle < -180 || gyroYangle > 180)
    gyroYangle = kalAngleY;


if(Sec20==1){ 
  if((calroll1>compAngleX1)&&(accX1>0))
  {trigger1=60;}
  
  if((calroll1>compAngleX1)&&(accX1<0))
  {trigger1=0;}  
  
  if(trigger1==0){compcalAngleX1=compcalAngleX1+(compAngleX1-compAngleX1previous);kalcalAngleX1=kalcalAngleX1+(kalAngleX1-kalAngleX1previous);}

  if(trigger1==60){compcalAngleX1=compcalAngleX1+(compAngleX1previous-compAngleX1);kalcalAngleX1=kalcalAngleX1+(kalAngleX1previous-kalAngleX1);} 
  }

// ================================================================
// ===                    IMU 2 PRINT ANGLES                    ===
// ================================================================
  
  Serial.print(compcalAngleX1); Serial.println(";");
  Serial.println(kalcalAngleX1);


   accX1previous=accX;
   compAngleX1previous=compAngleX1;
   kalAngleX1previous=kalAngleX1;
      
    }
    else if(mpu==0){

      while (i2cRead(0x3B, i2cData1, 14));
  accX1 = ((i2cData1[0] << 8) | i2cData1[1]);
  accY1 = ((i2cData1[2] << 8) | i2cData1[3]);
  accZ1 = ((i2cData1[4] << 8) | i2cData1[5]);
  tempRaw = (i2cData1[6] << 8) | i2cData1[7];
  gyroX1 = (i2cData1[8] << 8) | i2cData1[9];
  gyroY1 = (i2cData1[10] << 8) | i2cData1[11];
  gyroZ1 = (i2cData1[12] << 8) | i2cData1[13];
  
  double dt1 = (double)(micros() - timer1) / 1000000; // Calculate delta time
  timer1 = micros();

  #ifdef RESTRICT_PITCH // Eq. 25 and 26

  double roll1  = atan2(accY1, accZ1) * RAD_TO_DEG;
  double pitch1 = atan(-accX1 / sqrt(accY1 * accY1 + accZ1 * accZ1)) * RAD_TO_DEG;
  
#else // Eq. 28 and 29

  double roll1  = atan2(accY1, sqrt(accX1 * accX1 + accZ1 * accZ1)) * RAD_TO_DEG;
  double pitch1 = atan2(-accX1, accZ1) * RAD_TO_DEG;
#endif

  double gyroXrate1 = gyroX1 / 131.0; // Convert to deg/s
  double gyroYrate1 = gyroY1 / 131.0; // Convert to deg/s



#ifdef RESTRICT_PITCH

   // This fixes the transition problem when the accelerometer angle jumps between -180 and 180 degrees
  if ((roll1 < -90 && kalAngleX1 > 90) || (roll1 > 90 && kalAngleX1 < -90)) {
    kalmanX1.setAngle(roll1);
    compAngleX1 = roll1;
    kalAngleX1 = roll1;
    gyroXangle1 = roll1;
  } else
    kalAngleX1 = kalmanX1.getAngle(roll1, gyroXrate1, dt1); // Calculate the angle using a Kalman filter

  if (abs(kalAngleX1) > 90)
    gyroYrate1 = -gyroYrate1; // Invert rate, so it fits the restriced accelerometer reading
  kalAngleY1 = kalmanY1.getAngle(pitch1, gyroYrate1, dt1);

#else

  // This fixes the transition problem when the accelerometer angle jumps between -180 and 180 degrees
  if ((pitch1 < -90 && kalAngleY1 > 90) || (pitch1 > 90 && kalAngleY1 < -90)) {
    kalmanY1.setAngle(pitch1);
    compAngleY1 = pitch1;
    kalAngleY1 = pitch1;
    gyroYangle1 = pitch1;
  } else
    kalAngleY1 = kalmanY1.getAngle(pitch1, gyroYrate1, dt1); // Calculate the angle using a Kalman filter

  if (abs(kalAngleY1) > 90)
    gyroXrate1 = -gyroXrate1; // Invert rate, so it fits the restriced accelerometer reading
  kalAngleX1 = kalmanX1.getAngle(roll1, gyroXrate1, dt1); // Calculate the angle using a Kalman filter
  
#endif


   gyroXangle1 += gyroXrate1 * dt1; // Calculate gyro angle without any filter
  gyroYangle1 += gyroYrate1 * dt1;
  //gyroXangle1 += kalmanX1.getRate() * dt1; // Calculate gyro angle using the unbiased rate
  //gyroYangle1 += kalmanY1.getRate() * dt1;

 compAngleX1 = 0.93 * (compAngleX1 + gyroXrate1 * dt1) + 0.07 * roll1; // Calculate the angle using a Complimentary filter
  compAngleY1 = 0.93 * (compAngleY1 + gyroYrate1 * dt1) + 0.07 * pitch1;
calroll1=roll1;

  if (gyroXangle1 < -180 || gyroXangle1 > 180)
    gyroXangle1 = kalAngleX1;
  if (gyroYangle1 < -180 || gyroYangle1 > 180)
    gyroYangle1 = kalAngleY1;

    if(((timefinal-timeinitial)>20000)){
  Sec20=1;
  }
          if(((Sec20==1)&&(psiref0==0))){
        phiref0=phi;
        if(phiref0>100){phi0positive=1;}
        if(phiref0<-100){phi0negative=1;}
        
        thetaref0=theta;
        if(thetaref0>100){theta0positive=1;}
        if(thetaref0<-100){theta0negative=1;}
        
        psiref0=psi;
        if(psiref0>100){psi0positive=1;}
        if(psiref0<-100){psi0negative=1;}
        }


        if((phi0positive==1)&&(phi<0)){phiangle=360+phi-phiref0;}
        
        else if((phi0negative==1)&&(phi>0)){phiangle=-360+phi-phiref0;}
        
        else{phiangle=phi-phiref0;}

        
        if((theta0positive==1)&&(theta<0)){thetaangle=360+theta-thetaref0;}
        
        else if((theta0negative==1)&&(theta>0)){thetaangle=-360+theta-thetaref0;}
        
        else{thetaangle=theta-thetaref0;}

        
        if((psi0positive==1)&&(psi<0)){psiangle=360+psi-psiref0;}
        
        else if((psi0negative==1)&&(psi>0)){psiangle=-360+psi-psiref0;}
        
        else{psiangle=psi-psiref0;}
        

if(Sec20==1){ 
  if((calroll>compAngleX)&&(accX>0))
  {trigger=60;}
  
  if((calroll>compAngleX)&&(accX<0))
  {trigger=0;} 
  
  if(trigger==0){compcalAngleX=compcalAngleX+(compAngleX-compAngleXprevious);kalcalAngleX=kalcalAngleX+(kalAngleX-kalAngleXprevious);}

  if(trigger==60){compcalAngleX=compcalAngleX+(compAngleXprevious-compAngleX);kalcalAngleX=kalcalAngleX+(kalAngleXprevious-kalAngleX);}
  }

// ================================================================
// ===                    PLANTAR PRESSURE VOLTAGES             ===
// ================================================================
   
//1st Row
  digitalWrite(S0, HIGH);
  digitalWrite(S1, LOW);
  digitalWrite(S2, LOW);
  digitalWrite(S3, LOW);
  
  // read the input on analog pin 0:
  int sensorValue1 = analogRead(A0);
  int sensorValue2 = analogRead(A1);
  int sensorValue3 = analogRead(A2);
  int sensorValue4 = analogRead(A3);
  int sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  float voltage1 = sensorValue1 * (5.0 / 1023.0);
  float voltage2 = sensorValue2 * (5.0 / 1023.0);
  float voltage3 = sensorValue3 * (5.0 / 1023.0);
  float voltage4 = sensorValue4 * (5.0 / 1023.0);
  float voltage5 = sensorValue5 * (5.0 / 1023.0);
  // print out the value you read:
  //Serial.print(voltage1);Serial.print(",");

  Serial.print(millis());Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
 // Serial.print(voltage5);Serial.print(",");

//2nd row
  digitalWrite(S0, LOW);
  digitalWrite(S1, HIGH);
  digitalWrite(S2, LOW);
  digitalWrite(S3, LOW);

  sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

  //3rd row
  digitalWrite(S0, HIGH);
  digitalWrite(S1, HIGH);
  digitalWrite(S2, LOW);
  digitalWrite(S3, LOW);

  sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5); Serial.print(",");

  //4th row
  digitalWrite(S0, LOW);
  digitalWrite(S1, LOW);
  digitalWrite(S2, HIGH);
  digitalWrite(S3, LOW);

  sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

    //5th row
  digitalWrite(S0, HIGH);
  digitalWrite(S1, LOW);
  digitalWrite(S2, HIGH);
  digitalWrite(S3, LOW);

  sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

    //6th row
  digitalWrite(S0, LOW);
  digitalWrite(S1, HIGH);
  digitalWrite(S2, HIGH);
  digitalWrite(S3, LOW);

  sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

    //7th row
  digitalWrite(S0, HIGH);
  digitalWrite(S1, HIGH);
  digitalWrite(S2, HIGH);
  digitalWrite(S3, LOW);

  sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

    //8th row
  digitalWrite(S0, LOW);
  digitalWrite(S1, LOW);
  digitalWrite(S2, LOW);
  digitalWrite(S3, HIGH);

  //sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
 // voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  //Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

    //9th row
  digitalWrite(S0, HIGH);
  digitalWrite(S1, LOW);
  digitalWrite(S2, LOW);
  digitalWrite(S3, HIGH);

  //sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  //voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  //Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

      //10th row
  digitalWrite(S0, LOW);
  digitalWrite(S1, HIGH);
  digitalWrite(S2, LOW);
  digitalWrite(S3, HIGH);

 // sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  //voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  //Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

        //11th row
  digitalWrite(S0, HIGH);
  digitalWrite(S1, HIGH);
  digitalWrite(S2, LOW);
  digitalWrite(S3, HIGH);

  //sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  //voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  //Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

        //12th row
  digitalWrite(S0, LOW);
  digitalWrite(S1, LOW);
  digitalWrite(S2, HIGH);
  digitalWrite(S3, HIGH);

  //sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  //voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  //Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

        //13th row
  digitalWrite(S0, HIGH);
  digitalWrite(S1, LOW);
  digitalWrite(S2, HIGH);
  digitalWrite(S3, HIGH);

  //sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  //voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  //Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

          //14th row
  digitalWrite(S0, LOW);
  digitalWrite(S1, HIGH);
  digitalWrite(S2, HIGH);
  digitalWrite(S3, HIGH);

  //sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  //voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
  voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  //Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(",");
  Serial.print(voltage5);Serial.print(",");

          //15th row
  digitalWrite(S0, HIGH);
  digitalWrite(S1, HIGH);
  digitalWrite(S2, HIGH);
  digitalWrite(S3, HIGH);

  //sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A1);
  sensorValue3 = analogRead(A2);
  sensorValue4 = analogRead(A3);
  //sensorValue5 = analogRead(A6);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
 // voltage1 = sensorValue1 * (5.0 / 1023.0);
  voltage2 = sensorValue2 * (5.0 / 1023.0);
  voltage3 = sensorValue3 * (5.0 / 1023.0);
  voltage4 = sensorValue4 * (5.0 / 1023.0);
 // voltage5 = sensorValue5 * (5.0 / 1023.0);
    // print out the value you read:
  //Serial.print(voltage1);Serial.print(",");
  Serial.print(voltage2);Serial.print(",");
  Serial.print(voltage3);Serial.print(",");
  Serial.print(voltage4);Serial.print(";");
  //Serial.println(voltage5);
  //BlueTooth.write("..");

// ================================================================
// ===                    IMU 1 PRINT ANGLES                    ===
// ================================================================

  Serial.print(compcalAngleX); Serial.print(";");
  Serial.print(kalcalAngleX); Serial.print(";");
  
   accXprevious=accX;
   compAngleXprevious=compAngleX;
   kalAngleXprevious=kalAngleX;
    }
    status=mpu;
    }
#endif
  }
}

// ================================================================
// ===                    MAIN PROGRAM LOOP                     ===
// ================================================================

void loop() {

  static uint8_t mpu = 0;
  static MPU6050_Wrapper* currentMPU = NULL;
  if (useSecondMpu) {
    for (int i=0;i<2;i++) {
      mpu=(mpu+1)%2; // failed attempt at round robin
      currentMPU = mpus.select(mpu);
      if (currentMPU->isDue()) {
        handleMPUevent(mpu);
      }
    }
  } else {
    mpu=0;
    currentMPU = mpus.select(mpu);
    if (currentMPU->isDue()) {
      handleMPUevent(mpu);
    }
  }
}

