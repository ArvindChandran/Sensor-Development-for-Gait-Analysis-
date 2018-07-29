
/* ============================================
  I2Cdev device library code is placed under the MIT license
  Copyright (c) 2012, 2016 Jeff Rowberg

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  ===============================================
*/

#ifndef _DeathTimer_H
#define _DeathTimer_H

#include <Arduino.h>

class DeathTimer {
  public:
    DeathTimer(uint32_t period): _period(period) {
      _startTime = _lastPrintout = millis();
    }

    bool update() {
      uint32_t now = millis();
      if ((now - _lastPrintout) > _period) {
        _lastPrintout = now;
        uint32_t time = (now - _startTime)/1000L; // in seconds

        Serial.print(F("H:")); Serial.print(time / (60*60));
        Serial.print(F("M:")); Serial.print((time / 60) % 60);
        Serial.print(F("S:")); Serial.println(time % 60);
        return true;
      } 
      return false;
    }

    void setPeriod(uint16_t period) {
      _period = period;
    }
    
  protected:  
    uint16_t _period;
    uint32_t _lastPrintout;
    uint32_t _startTime;
};

#endif // DeathTimer_H

