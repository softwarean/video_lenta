(function() {
  this.Slider = (function() {
    Slider.version = '10/07/2014 18:20';

    function Slider(selector, cfgUrl, picUrl, fps, timezone, videoState, cameraType, finishTime) {
      if (fps == null) {
        fps = 10;
      }
      if (timezone == null) {
        timezone = 600;
      }
      if (videoState == null) {
        videoState = 'active';
      }
      if (cameraType == null) {
        cameraType = 'http';
      }
      this.container = $(selector);
      this.options = {
        videoParamsUrl: cfgUrl,
        picUrl: picUrl,
        fps: fps,
        updInterval: 1000 / fps,
        frameStep: 60,
        timezone: timezone * -1,
        videoState: videoState,
        cameraType: cameraType,
        selectTime: '12:00',
        finishTime: finishTime
      };
      this.heartbeat;
      this.polling;
      this.buffer = [];
      this.emergentFrames = [];
      this.state = "paused";
      this.speedTest = false;
      this.currentRequests = [];
      this.killRequestsFlag = false;
      this.killRequestTimeout;
      this.isCalendarOpened = false;
      this.loadViseoOptions().success((function(_this) {
        return function() {
          if (_this.options.finishTime) {
            _this.options.last = _this.options.finishTime;
          }
          _this.render(true);
          _this.setResolution();
          _this.seekTo(_this.options.last);
          if (_this.options.videoState !== 'active' || _this.options.finishTime) {
            _this.videoStateContiner.find('.live').hide();
            return _this.activateArchive();
          } else {
            return _this.activateLive();
          }
        };
      })(this)).error((function(_this) {
        return function() {
          _this.options.width = 720;
          _this.options.height = 480;
          _this.render(false);
          _this.error.show();
          return _this.noSource.show();
        };
      })(this));
    }

    Slider.prototype.template = function() {
      return "<div class=\"b__slider\" style=\"width: " + this.options.width + "px\">\n    <div class=\"player\" style=\"height: " + this.options.height + "px\">\n      <div class=\"img-placeholder\"></div>\n      <div class=\"calendar disable-selection\">\n        <div class=\"date\"></div>\n        <div class=\"state-container\">\n          <div class=\"archive\">Архив</div>\n          <div class=\"live\">\n            <span class=\"live-icon\"></span>\n            Прямой эфир\n          </div>\n        </div>\n      </div>\n      <div class=\"calendar-container\"></div>\n      <span class=\"loader-container\">\n        <span class=\"loader-wrap\">\n          <span class=\"loader\"></span>\n          </span>\n        </span>\n      <span class=\"left\">\n        <span class=\"left-arrow\"></span>\n      </span>\n      <span class=\"right\">\n        <span class=\"right-arrow\"></span>\n      </span>\n      <span class=\"error\">\n        <span class=\"no-source\">\n          Трансляция временно недоступна\n        </span>\n      </span>\n    </div>\n    <div class=\"timeline-control disable-selection\">\n      <div class=\"archive\">\n        <div class=\"play-pause\"></div>\n        <div class=\"calendar-icon\"></div>\n        <div class=\"controls\">\n          <div class=\"fullscreen\"></div>\n          <div class=\"inc\"></div>\n          <div class=\"speed\"></div>\n          <div class=\"desc\"></div>\n        </div>\n        <div class=\"timeline-wrapper\">\n          <div class=\"timeline\">\n            <div class=\"progres-bar\"></div>\n            <div class=\"timeline-pointer\"></div>\n          </div>\n        </div>\n      </div>\n      <div class=\"live\">\n        <div class=\"message\">Кадры обновляются каждую минуту</div>\n        <div class=\"controls\">\n          <div class=\"fullscreen\"></div>\n        </div>\n      </div>\n    </div>\n</div>";
    };

    Slider.prototype.render = function(addEvents) {
      var onDateAndIconClick;
      this.container.html(this.template());
      this.slider = this.container.find('.b__slider');
      this.player = this.container.find('.player');
      this.imgPlaceholder = this.player.find('.img-placeholder');
      this.timeline = this.container.find('.timeline');
      this.progresBar = this.timeline.find('.progres-bar');
      this.pointer = this.timeline.find('.timeline-pointer');
      this.playPause = this.container.find('.play-pause');
      this.plus = this.container.find('.inc');
      this.minus = this.container.find('.desc');
      this.speed = this.container.find('.speed');
      this.fullscreen = this.container.find('.fullscreen');
      this.error = this.container.find('.error');
      this.noSource = this.container.find('.no-source');
      this.date = this.player.find('.date');
      this.icon = this.container.find('.calendar-icon');
      this.calendar = this.player.find('.calendar-container');
      this.videoStateContiner = this.player.find('.state-container');
      this.timelineControl = this.container.find('.timeline-control');
      this.togglePlayPause();
      this.renderFrameStep();
      if (isMobile.any) {
        this.timelineControl.addClass('mobile');
      }
      if (addEvents) {
        this.plus.click((function(_this) {
          return function(event) {
            return _this.changeFrameStep();
          };
        })(this));
        this.minus.click((function(_this) {
          return function(event) {
            return _this.changeFrameStep('/');
          };
        })(this));
        this.playPause.click((function(_this) {
          return function(event) {
            if (_this.state === 'playing') {
              _this.state = 'paused';
              _this.pause();
            } else {
              if (_this.player.hasClass('show-loader')) {
                return;
              }
              _this.state = 'playing';
              _this.play();
            }
            return _this.togglePlayPause();
          };
        })(this));
        this.timeline.mousemove((function(_this) {
          return function(event) {
            var position;
            position = _this.getTimelineMousePosition(event.pageX);
            _this.pointer.css({
              left: "" + position + "%"
            });
            return _this.pointer.text(_this.getTimeByPosition(position));
          };
        })(this));
        this.timeline.click((function(_this) {
          return function(event) {
            var state, timestamp;
            timestamp = _this.getTimestampByPosition(_this.getTimelineMousePosition(event.pageX));
            state = _this.state;
            clearInterval(_this.heartbeat);
            return _this.seekTo(_this.getStartOfMinute(timestamp));
          };
        })(this));
        this.player.find(".left").click((function(_this) {
          return function(event) {
            return _this.showPrev();
          };
        })(this));
        this.player.find(".right").click((function(_this) {
          return function(event) {
            return _this.showNext();
          };
        })(this));
        onDateAndIconClick = (function(_this) {
          return function(event) {
            var currentHour, currentMin, message, select, selectContainer, _i, _ref, _results;
            if (!_this.isCalendarOpened) {
              _this.calendar.datepicker({
                beforeShow: function(a, b) {
                  return _this.isCalendarOpened = true;
                },
                onSelect: function(dateText, inst) {
                  var date, hours, minutes, timestamp, _ref;
                  _ref = _this.calendar.find('select').val().split(':'), hours = _ref[0], minutes = _ref[1];
                  date = moment("" + dateText + " " + (_this.getMomentTimezone()), 'MM/DD/YYYY Z').zone(_this.getTimezone()).startOf('day').add({
                    hours: hours,
                    minutes: minutes
                  });
                  timestamp = date.valueOf() / 1000;
                  timestamp = Math.max(_this.options.first, Math.min(timestamp, _this.options.last));
                  _this.seekTo(timestamp);
                  return _this.hideDatepicker();
                },
                dateFormat: "mm/dd/yy",
                minDate: moment.unix(_this.options.first).zone(_this.getTimezone()).format('MM/DD/YY'),
                maxDate: moment.unix(_this.options.last).zone(_this.getTimezone()).format('MM/DD/YY'),
                defaultDate: moment.unix(_this.current).zone(_this.getTimezone()).format('MM/DD/YY')
              });
              message = $('<div />').addClass('time-message').text('Время трансляции');
              selectContainer = $('<div />').addClass('select-container disable-selection');
              select = $('<select />');
              _ref = _this.options.selectTime.split(":"), currentHour = _ref[0], currentMin = _ref[1];
              (function() {
                _results = [];
                for (_i = 0; _i <= 23; _i++){ _results.push(_i); }
                return _results;
              }).apply(this).forEach(function(hour) {
                hour = hour < 10 ? "0" + hour : hour;
                return ['00', '30'].forEach(function(min) {
                  var option, value;
                  value = "" + hour + ":" + min;
                  option = $('<option />', {
                    value: value
                  }).text(value);
                  if (parseFloat(hour) === parseFloat(currentHour) && min === currentMin) {
                    option.attr('selected', 'selected');
                  }
                  return select.append(option);
                });
              });
              select.change(function(e) {
                return _this.options.selectTime = e.target.value;
              });
              selectContainer.append(select);
              _this.calendar.append(message, selectContainer);
              _this.calendar.find('select').customSelect();
            } else {
              _this.hideDatepicker();
            }
            return event.stopPropagation();
          };
        })(this);
        this.videoStateContiner.find('.archive').click((function(_this) {
          return function() {
            return _this.activateArchive();
          };
        })(this));
        this.videoStateContiner.find('.live').click((function(_this) {
          return function() {
            return _this.activateLive();
          };
        })(this));
        this.icon.click((function(_this) {
          return function(e) {
            return onDateAndIconClick(e);
          };
        })(this));
      } else {
        this.pointer.remove();
      }
      this.fullscreen.click((function(_this) {
        return function(event) {
          if ($.fullscreen.isNativelySupported()) {
            if (!$.fullscreen.isFullScreen()) {
              _this.player.height("" + (window.screen.height - 50) + "px");
              return _this.slider.fullscreen();
            } else {
              return $.fullscreen.exit();
            }
          } else {
            if (!_this.isFullScreen) {
              return _this.openCustomFullscreen();
            } else {
              return _this.closeCustomFullscreen();
            }
          }
        };
      })(this));
      $(document).click((function(_this) {
        return function(e) {
          var isCalendar, t;
          t = $(e.target);
          isCalendar = t.hasClass('ui-datepicker-prev') || t.hasClass('ui-icon-circle-triangle-w') || t.hasClass('ui-datepicker-next') || t.hasClass('ui-icon-circle-triangle-e');
          if (_this.isCalendarOpened && !isCalendar) {
            if (!$(e.target).closest('.calendar-container').length) {
              _this.hideDatepicker();
              return e.stopPropagation();
            }
          }
        };
      })(this));
      $(document).on('fscreenchange', (function(_this) {
        return function() {
          if (!arguments[1]) {
            _this.player.height("" + _this.options.height + "px");
            return $.fullscreen.exit();
          }
        };
      })(this));
      $(document).keydown((function(_this) {
        return function(event) {
          switch (event.keyCode) {
            case 37:
              if (!_this.isCalendarOpened && !_this.player.hasClass('overlay-hidden')) {
                _this.showPrev();
              }
              return event.preventDefault();
            case 39:
              if (!_this.isCalendarOpened && !_this.player.hasClass('overlay-hidden')) {
                _this.showNext();
              }
              return event.preventDefault();
            case 27:
              if (_this.isFullScreen) {
                _this.closeCustomFullscreen();
                return event.preventDefault();
              }
          }
        };
      })(this));
      return $(window).resize((function(_this) {
        return function() {
          if (_this.isFullScreen) {
            return _this.setHeightForFullscreen();
          } else {
            return _this.setResolution();
          }
        };
      })(this));
    };

    Slider.prototype.openCustomFullscreen = function() {
      this.isFullScreen = true;
      this.slider.css({
        position: 'fixed',
        top: 0,
        left: 0,
        width: '100%',
        zIndex: 9999
      });
      this.setHeightForFullscreen();
      return window.scrollTo(0, 0);
    };

    Slider.prototype.closeCustomFullscreen = function() {
      this.isFullScreen = false;
      this.slider.css({
        position: '',
        top: '',
        left: '',
        width: "" + this.options.width + "px",
        zIndex: ''
      });
      return this.player.css({
        height: "" + this.options.height + "px"
      });
    };

    Slider.prototype.setHeightForFullscreen = function() {
      return this.player.css({
        height: "" + ($(window).height() - 50) + "px"
      });
    };

    Slider.prototype.setResolution = function() {
      var currentWidth, height, width;
      if (!$.fullscreen.isFullScreen()) {
        currentWidth = $('body').width();
        if (currentWidth < this.options.width) {
          width = currentWidth;
          height = Math.round(currentWidth / this.options.frameRate);
        } else {
          width = this.options.width;
          height = this.options.height;
        }
        if (currentWidth < 500 || this.options.width < 500) {
          width = 500;
          height = Math.round(500 / this.options.frameRate);
        }
        this.slider.width(width);
        return this.player.height(height);
      }
    };

    Slider.prototype.changeFrameStep = function(x) {
      var step;
      if (x == null) {
        x = '*';
      }
      if (x === '*') {
        step = this.options.frameStep * 2;
        if (step > 960) {
          return;
        }
      } else {
        step = this.options.frameStep / 2;
        if (step < 60) {
          return;
        }
      }
      this.options.frameStep = Math.max(60, Math.min(960, step));
      this.renderFrameStep();
      if (this.state === 'playing') {
        this.buffer = [];
        return this.startBuffering();
      }
    };

    Slider.prototype.showPrev = function() {
      var prev;
      if (this.state === 'paused' && this.current !== this.options.first) {
        this.buffer.length = 0;
        prev = this.current - this.options.frameStep;
        if (prev > this.options.first) {
          return this.seekTo(prev, false);
        } else {
          return this.seekTo(this.options.first, false);
        }
      }
    };

    Slider.prototype.showNext = function() {
      var next;
      if (this.state === 'paused' && this.current !== this.options.last) {
        this.buffer.length = 0;
        next = this.current + this.options.frameStep;
        if (next < this.options.last) {
          return this.seekTo(next, false);
        } else {
          return this.seekTo(this.options.last, false);
        }
      }
    };

    Slider.prototype.renderFrameStep = function() {
      return this.speed.html("&times;" + (this.options.frameStep / 60));
    };

    Slider.prototype.changeFps = function(x) {
      if (x == null) {
        x = 1;
      }
      this.options.fps = Math.max(2, Math.min(10, this.options.fps + 2 * x));
      this.options.updInterval = 1000 / this.options.fps;
      if (this.state === 'playing') {
        this.pause();
        return this.play();
      }
    };

    Slider.prototype.togglePlayPause = function() {
      if (this.state === 'playing') {
        return this.playPause.removeClass('play').addClass('pause');
      } else {
        return this.playPause.removeClass('pause').addClass('play');
      }
    };

    Slider.prototype.showArrows = function() {
      var left, right;
      left = this.player.find('.left');
      right = this.player.find('.right');
      if (this.state === 'playing') {
        this.player.removeClass('overlay');
        left.hide();
        return right.hide();
      } else {
        this.player.addClass('overlay');
        if (this.current === this.options.first) {
          left.hide();
        } else {
          left.show();
        }
        if (this.current === this.options.last) {
          return right.hide();
        } else {
          return right.show();
        }
      }
    };

    Slider.prototype.getStartOfMinute = function(timestamp) {
      return moment.unix(timestamp).zone(0).startOf('minute').valueOf() / 1000;
    };

    Slider.prototype.getStartOfHour = function(timestamp) {
      return moment.unix(timestamp).zone(0).startOf('hour').valueOf() / 1000;
    };

    Slider.prototype.getTimelineMousePosition = function(mouseX) {
      var position;
      position = ((mouseX - this.timeline.offset().left) / this.timeline.width()) * 100;
      return Math.max(0, Math.min(100, position));
    };

    Slider.prototype.getTimestampByPosition = function(position) {
      return Math.floor((this.options.last - this.options.first) * position / 100) + this.options.first;
    };

    Slider.prototype.getTimeByPosition = function(position) {
      var timestamp;
      timestamp = this.getTimestampByPosition(position);
      return moment.unix(timestamp).zone(this.getTimezone()).format('DD.MM.YYYY HH:mm');
    };

    Slider.prototype.loadViseoOptions = function() {
      return $.get(this.options.videoParamsUrl).success((function(_this) {
        return function(data) {
          $.extend(_this.options, data);
          return _this.options.frameRate = data.width / data.height;
        };
      })(this));
    };

    Slider.prototype.seekTo = function(timestamp, startBuffering) {
      var img, url;
      if (startBuffering == null) {
        startBuffering = true;
      }
      this.current = timestamp;
      this.moveProgresbar(this.current);
      this.setDate(timestamp);
      this.showArrows();
      url = this.getPicUrl(timestamp);
      img = new Image();
      img.onload = (function(_this) {
        return function() {
          return _this.imgPlaceholder.css('background-image', "url('" + url + "')");
        };
      })(this);
      img.src = url;
      this.buffer = [];
      if (startBuffering && this.current !== this.options.last) {
        return this.startBuffering();
      } else {
        return jQuery.Deferred().resolve().promise();
      }
    };

    Slider.prototype.startBuffering = function(forced) {
      var deferred;
      if (forced == null) {
        forced = false;
      }
      deferred = jQuery.Deferred();
      if (this.current >= this.options.last) {
        deferred.reject();
        return deferred.promise();
      }
      this.buffer = [];
      this.setLoading();
      if (forced) {
        this.promiseWhile(this.isBufferNotLoaded.bind(this), this.loadFramesInBuffer.bind(this)).then((function(_this) {
          return function() {
            _this.player.removeClass('show-loader');
            if (_this.state === "playing" && _this.current !== _this.options.last) {
              return _this.play();
            }
          };
        })(this));
      } else {
        this.killRequests().done((function(_this) {
          return function() {
            return _this.promiseWhile(_this.isBufferNotLoaded.bind(_this), _this.loadFramesInBuffer.bind(_this)).then(function() {
              _this.player.removeClass('show-loader');
              if (_this.state === "playing" && _this.current !== _this.options.last) {
                return _this.play();
              }
            });
          };
        })(this));
      }
      return deferred.promise();
    };

    Slider.prototype.isBufferNotLoaded = function() {
      var bufferLength, last;
      if (this.killRequestsFlag) {
        return false;
      }
      bufferLength = this.buffer.length;
      last = bufferLength ? this.buffer[bufferLength - 1].timestamp : void 0;
      if (last === this.options.last || bufferLength >= 100) {
        return false;
      } else {
        return true;
      }
    };

    Slider.prototype.killRequests = function() {
      var deferred;
      clearTimeout(this.killRequestTimeout);
      deferred = jQuery.Deferred();
      this.killRequestsFlag = true;
      this.currentRequests.forEach(function(item) {
        item.img.src = '';
        return item.deferred.resolve();
      });
      this.killRequestTimeout = setTimeout((function(_this) {
        return function() {
          _this.buffer = [];
          _this.currentRequests = [];
          _this.killRequestsFlag = false;
          return deferred.resolve();
        };
      })(this), 100);
      return deferred.promise();
    };

    Slider.prototype.loadFramesInBuffer = function(number) {
      var bufferLength, deferred, loaded, promise, promises, timeout, timestamp, _i;
      if (number == null) {
        number = 10;
      }
      deferred = Q.defer();
      promises = [];
      loaded = 0;
      timeout = 0;
      bufferLength = this.buffer.length;
      timestamp = bufferLength ? this.buffer[bufferLength - 1].timestamp : this.current;
      if (timestamp !== this.options.last) {
        for (promise = _i = 1; 1 <= number ? _i <= number : _i >= number; promise = 1 <= number ? ++_i : --_i) {
          timestamp += this.options.frameStep;
          if (timestamp < this.options.last) {
            promises.push(this.loadFrame(timestamp));
          }
          if (timestamp >= this.options.last) {
            promises.push(this.loadFrame(this.options.last));
            break;
          }
        }
      } else {
        deferred.resolve();
        return deferred.promise;
      }
      Q.all(promises).done((function(_this) {
        return function(data) {
          var lastTimestamp, newBufferLength;
          newBufferLength = _this.buffer.length;
          lastTimestamp = newBufferLength ? _this.buffer[newBufferLength - 1].timestamp : _this.current;
          data.forEach(function(item) {
            if (item && item.loaded) {
              if (item.timestamp > lastTimestamp) {
                _this.buffer.push(item);
              }
              loaded += 1;
            }
            if (item.timeout) {
              return timeout += 1;
            }
          });
          if (!_this.speedTest) {
            _this.speedTest = true;
            $('body').trigger('analytics', timeout);
          }
          if (loaded || _this.killRequestsFlag) {
            return deferred.resolve();
          } else {
            return _this.getEmergentFrames(deferred, timestamp);
          }
        };
      })(this));
      return deferred.promise;
    };

    Slider.prototype.loadFrame = function(timestamp) {
      var deferred, img, request, url;
      deferred = jQuery.Deferred();
      url = this.getPicUrl(timestamp);
      img = new Image();
      img.onload = (function(_this) {
        return function() {
          _this.without(_this.currentRequests, request);
          return deferred.resolve({
            loaded: true,
            timestamp: timestamp,
            url: url,
            img: img
          });
        };
      })(this);
      img.onerror = (function(_this) {
        return function() {
          _this.without(_this.currentRequests, request);
          return deferred.resolve({
            loaded: false
          });
        };
      })(this);
      img.src = url;
      request = {
        img: img,
        deferred: deferred
      };
      this.currentRequests.push(request);
      setTimeout((function(_this) {
        return function() {
          img.onload = null;
          img.onerror = null;
          if (deferred.state() === 'pending') {
            _this.without(_this.currentRequests, request);
            return deferred.resolve({
              loaded: false,
              timeout: true
            });
          }
        };
      })(this), 3000);
      return deferred.promise();
    };

    Slider.prototype.play = function() {
      clearInterval(this.heartbeat);
      if (this.current === this.options.last) {
        this.seekTo(this.options.first);
        return;
      }
      this.tickNumber = 0;
      this.heartbeat = setInterval(this.tick.bind(this), this.options.updInterval);
      this.state = "playing";
      this.togglePlayPause();
      return this.showArrows();
    };

    Slider.prototype.pause = function() {
      clearInterval(this.heartbeat);
      this.state = "paused";
      this.showArrows();
      return this.togglePlayPause();
    };

    Slider.prototype.setLoading = function() {
      clearInterval(this.heartbeat);
      return this.player.addClass('show-loader');
    };

    Slider.prototype.tick = function() {
      var current;
      current = this.buffer[0];
      if (current) {
        this.tickNumber += 1;
        this.current = current.timestamp;
        this.moveProgresbar(this.current);
        this.setDate(current.timestamp);
        this.showFrame(current.url);
        this.buffer = this.buffer.slice(1);
        if (this.tickNumber === this.options.fps) {
          this.tickNumber = 0;
          return this.loadFramesInBuffer();
        }
      } else if (this.current === this.options.last) {
        return this.pause();
      } else {
        return this.startBuffering('forced');
      }
    };

    Slider.prototype.getEmergentFrames = function(deferred, timestamp) {
      return this.getEmergentFrame(timestamp).done(function() {
        return deferred.resolve();
      });
    };

    Slider.prototype.getEmergentFrame = function(timestamp) {
      var deferred, hour, loadFrame, startOfNextHour;
      deferred = jQuery.Deferred();
      hour = 3600;
      startOfNextHour = hour + this.getStartOfHour(timestamp);
      loadFrame = (function(_this) {
        return function(ts) {
          var img, request, url;
          if (ts > _this.options.last) {
            deferred.resolve();
            return;
          }
          url = _this.getEmergentPicUrl(ts);
          img = new Image();
          img.onload = function() {
            var length;
            _this.without(_this.currentRequests, request);
            length = _this.buffer.length;
            timestamp = length ? _this.buffer[length - 1].timestamp : _this.current;
            if (timestamp < ts) {
              _this.buffer.push({
                loaded: true,
                timestamp: ts,
                url: url,
                img: img
              });
            }
            return deferred.resolve();
          };
          img.onerror = function() {
            _this.without(_this.currentRequests, request);
            return loadFrame(ts + hour);
          };
          img.src = url;
          request = {
            img: img,
            deferred: deferred
          };
          return _this.currentRequests.push(request);
        };
      })(this);
      loadFrame(startOfNextHour);
      return deferred.promise();
    };

    Slider.prototype.getPicUrl = function(timestamp) {
      var date;
      date = moment.unix(timestamp).zone(0).format('YYYY/MM/DD');
      return "" + (this.options.picUrl + date) + "/" + timestamp + ".jpg";
    };

    Slider.prototype.getEmergentPicUrl = function(timestamp) {
      var date;
      date = moment.unix(timestamp).zone(0).format('YYYY/MM/DD');
      return "" + (this.options.picUrl + date) + "/" + timestamp + ".jpg?base=true";
    };

    Slider.prototype.without = function(arr, elem) {
      var index;
      index = arr.indexOf(elem);
      if (index > -1) {
        return arr.splice(index, 1);
      }
    };

    Slider.prototype.updateLastFrame = function() {
      return $.get(this.options.videoParamsUrl).success((function(_this) {
        return function(data) {
          if (data.last !== _this.options.last) {
            _this.options.last = data.last;
            return _this.seekTo(_this.options.last);
          }
        };
      })(this));
    };

    Slider.prototype.startPolling = function() {
      return this.polling = setInterval(this.updateLastFrame.bind(this), 60000);
    };

    Slider.prototype.stopPolling = function() {
      return clearInterval(this.polling);
    };

    Slider.prototype.moveProgresbar = function(timestamp) {
      return this.progresBar.width("" + (((timestamp - this.options.first) / (this.options.last - this.options.first) * 100).toFixed(2)) + "%");
    };

    Slider.prototype.setDate = function(timestamp) {
      var date, dayOfWeek, ddmmyy, diff, time;
      date = moment.unix(timestamp).zone(this.getTimezone());
      dayOfWeek = this.daysOfWeek[date.weekday()];
      ddmmyy = date.format('DD.MM.YYYY');
      time = date.format('HH:mm');
      diff = (-1 * this.options.timezone - 240) / 60;
      return this.date.html("" + dayOfWeek + "&nbsp;&nbsp;" + ddmmyy + "&nbsp;&nbsp;" + time + " (MCK +" + diff + ")");
    };

    Slider.prototype.daysOfWeek = ['ВС', 'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ'];

    Slider.prototype.showFrame = function(url) {
      return this.imgPlaceholder.css('background-image', "url('" + url + "')");
    };

    Slider.prototype.hideDatepicker = function() {
      if (this.isCalendarOpened) {
        this.calendar.html('');
        this.calendar.removeClass("hasDatepicker").removeAttr('id');
        return this.isCalendarOpened = false;
      }
    };

    Slider.prototype.activateLive = function() {
      this.player.addClass('overlay-hidden');
      this.videoStateContiner.removeClass('active-archive').addClass('active-live');
      this.timelineControl.removeClass('active-archive').addClass('active-live');
      this.player.addClass('show-loader');
      this.updateLastFrame().success((function(_this) {
        return function() {
          return _this.player.removeClass('show-loader');
        };
      })(this));
      return this.startPolling();
    };

    Slider.prototype.activateArchive = function() {
      this.player.removeClass('overlay-hidden');
      this.videoStateContiner.removeClass('active-live').addClass('active-archive');
      this.timelineControl.removeClass('active-live').addClass('active-archive');
      return this.stopPolling();
    };

    Slider.prototype.getTimezone = function() {
      if (this.options.cameraType === 'ftp') {
        return 0;
      } else {
        return this.options.timezone;
      }
    };

    Slider.prototype.getMomentTimezone = function() {
      if (this.options.cameraType === 'ftp') {
        return '+0000';
      } else {
        return "+" + (this.options.timezone * -1 / 60) + "00";
      }
    };

    Slider.prototype.promiseWhile = function(condition, body) {
      var done, looop;
      done = Q.defer();
      looop = function() {
        if (!condition()) {
          return done.resolve();
        }
        return Q.when(body(), looop, done.reject);
      };
      Q.nextTick(looop);
      return done.promise;
    };

    return Slider;

  })();

}).call(this);
