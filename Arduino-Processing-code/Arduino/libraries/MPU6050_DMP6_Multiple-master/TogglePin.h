
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

#ifndef TOGGLEPIN_H
#define TOGGLEPIN_H

#include <Arduino.h>

class TogglePin {
  public:
    TogglePin(uint8_t pin, uint32_t period):_pin(pin), _period(period) {
      _lastToggle = millis();
      _state = false;
      pinMode(_pin, OUTPUT);
      digitalWrite(_pin, _state);
    }

    bool update() {
      uint32_t now = millis();
      if ((now - _lastToggle) > _period) {
        digitalWrite(_pin, _state = !_state);
        _lastToggle = now;
        return true;
      } 
      return false;
    }

    void setPeriod(uint16_t period) {
      _period = period;
    }
    
  protected:  
    const uint8_t _pin;
    bool _state;
    uint16_t _period;
    uint32_t _lastToggle;
};

#endif // TOGGLEPIN_H

