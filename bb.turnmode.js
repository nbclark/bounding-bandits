(function() {

    function ce(p, n, id, c, html)
    {
        var e = document.createElement(n);
        p.appendChild(e);
        if (id) e.id = id;
        if (c) e.className = c;
        if (html) e.innerHTML = html;
        
        return e;
    }

    turnModeGameboard = gameboard.extend
    ({        
        init : function(isActive, gameData, generateState, elapsedTime)
        {
            arguments.callee.$.init.call(this);

            this.maxTime = 120.0;
            
            _('#canvas').style.opacity = 0;
            $("#canvas").animate({
                
              opacity: 1
            }, 500, 'ease-out');

            this.elapsedTime = 0;
            this.container = document.getElementById('turnModeContainer');
            this.container.style.display = 'block';
            
            var tbody = ce(ce(this.container, 'table', null, ''), 'tbody', null, '');
                  
            this.timer = ce(ce(ce(tbody, 'tr'), 'td'), 'div', null, 'timer');
            this.timerCanvas = ce(this.timer, 'canvas', null, 'timerCanvas');
            this.timerCanvas.height = this.timerCanvas.width = 1000;
            
            this.wrapTouchEvent(this.timerCanvas, 'toggleGame');

            var logCell = ce(ce(tbody, 'tr'), 'td');
            logCell.height = '100%';
            logCell.vAlign = 'top';
            this.activeCache = ce(logCell, 'div', null, 'activeCache');
            this.getStartedButton = ce(logCell, 'button', null, 'getStarted', 'Let\'s Go!');
            this.moveLogContainer = ce(logCell, 'div', null, 'moveLog');
            
            
            var p1Data = ce(ce(ce(tbody, 'tr', null, null), 'td', null, null), 'div', null, 'player1Data', null);
            var p1Title = ce(p1Data, 'div', null, null, 'Player 1: ');
            var p1Buttons = ce(p1Data, 'div', null, 'playerButtons');
            this.player1UpButton = ce(p1Buttons, 'button', null, 'player1Up', 'Up');
            this.player1DownButton = ce(p1Buttons, 'button', null, 'player1Down', 'Down');
            this.player1Bid = ce(p1Buttons, 'div', null, 'player1Bid', '--');
            this.player1SetButton = ce(p1Buttons, 'button', null, 'player1Set', 'Set');
            this.player1Cache = ce(p1Data, 'div', null, 'player1Cache', '');

            this.timerCanvasCtx = this.timerCanvas.getContext("2d");
            
            this.wrapTouchEvent(this.player1UpButton, 'player1Up');
            this.wrapTouchEvent(this.player1DownButton, 'player1Down');
            this.wrapTouchEvent(this.player1SetButton, 'player1Set');
            this.wrapTouchEvent(this.getStartedButton, 'getStarted');
            
            this.getStartedButton.style.display = 'none';
            this.activeCache.style.display = '';
            this.moveLogContainer.style.visibility = 'hidden';
            
            this.player1Cache.innerHTML = '';
            this.activeCache.innerHTML = '';
            
            p1Data.style.display = 'none';
            
            if (gameData)
            {
                this.decodeBoard(gameData, generateState);

                if (elapsedTime)
                {
                    this.elapsedTime = elapsedTime;
                }
            }

            var removeTarget = false;

            if (this.activeTarget)
            {
                removeTarget = false;
            }
            else
            {
                this.captureTileIndex = Math.floor(Math.random()*this.targets.length);
                this.activeTarget = this.targets[this.captureTileIndex];

                this.targets.splice(this.captureTileIndex, 1);
            }

            for (var i = 0; i < this.targets.length; ++i)
            {
                var t = this.targets[i];
                var token = this.createToken(t.id, t.color);

                this.activeCache.appendChild(token);
            }

            this.player1Score = 0;
            
            var that = this;
            this.showMessage('Click to get started', function() { that.hideMessage(); that.startGame(); });
            
            return this.encodeBoard();
        },
        
        uninit : function()
        {
            arguments.callee.$.uninit.call(this);
            
            _('#turnModeContainer').innerHTML = '';
            _('#turnModeContainer').style.display = 'none';

            clearInterval(this.startInterval);
            clearInterval(this.confirmInterval);
        },
        
        encodeBoard : function()
        {
            var boardData = arguments.callee.$.encodeBoard.call(this);
            
            return boardData;
        },
        
        logClick : function(e)
        {            
            try
            {
                var index = this.moveLogContainer.childNodes.length - 1;
                while (this.moveLogContainer.childNodes.length)
                {
                    var node = this.moveLogContainer.childNodes[0];
                    this.moveLogContainer.removeChild(node);

                    if (e.currentTarget === node)
                    {
                        break;
                    }

                    index--;
                }

                this.goToMove(index);

                this.showPossible();
                this.render();
            }
            catch (e)
            {
                _alert(e);
            }
        },
        
        onBeforeUserMove : function(move)
        {
            if (this.moveLog.length + 1 > this.activeBid)
            {
                return false;
            }
            
            return true;
        },
        
        onUserMove : function(move)
        {
            var moveLogItem = document.createElement('div');
            moveLogItem.className = 'moveLogItem';
            moveLogItem.onclick = this.wrapCallback('logClick');
            
            var moveLogItemIndex = document.createElement('div');
            moveLogItemIndex.className = 'index';
            moveLogItemIndex.innerHTML = this.moveLog.length + '.';
            moveLogItemIndex.style.backgroundColor = move.color;
            
            var moveLogItemDesc = document.createElement('div');
            moveLogItemDesc.className = 'description';
            moveLogItemDesc.innerHTML = 'Moved ' + move.direction;
            
            moveLogItem.appendChild(moveLogItemIndex);
            moveLogItem.appendChild(moveLogItemDesc);
            
            if (this.moveLogContainer.childNodes.length)
            {
                this.moveLogContainer.insertBefore(moveLogItem, this.moveLogContainer.childNodes[0]);
            }
            else
            {
                this.moveLogContainer.appendChild(moveLogItem);
            }
        },
        
        startRound : function()
        {
            var that = this;
        },
        
        drawTime : function(seconds)
        {
            if (seconds == this.maxTime) seconds = 59.999;
            
            this.timerCanvasCtx.fillStyle ='#000';
            this.timerCanvasCtx.clearRect(0,0,1000,1000);
            
            this.timerCanvasCtx.beginPath();
            this.timerCanvasCtx.moveTo(500,500);
            this.timerCanvasCtx.arc(500, 500, 500, 0, Math.PI*2*(1 - seconds / this.maxTime), true);
            
            this.timerCanvasCtx.closePath();
            this.timerCanvasCtx.fill();
        },
        
        endRound : function(success)
        {
            var elapsed = new Date().getTime() - this.startTime;
            
            this.endResult =
            {
                Success: success,
                Duration: elapsed,
                Moves: this.moveLog.length,
                MoveLog: this.moveLog.select(function(i) { return { 'd': i.dir, 'p': i.moverId }; })
            };

            this.elapsedTime = 0;
            this.activeCache.style.display = '';
            this.getStartedButton.style.display = 'none';
            this.moveLogContainer.style.visibility = 'hidden';
            
            clearInterval(this.startInterval);
            var target = this.captureTile.target;
            this.captureTile.target = null;
            
            var token = this.createToken(target.id, target.color);
            
            this.targetTile = null;
            this.activeTile = null;
            this.isActive = false;
            
            this.activeBidder = null;
            
            for (var i = 0; i <  this.moveOptions.length; ++i)
            {
                this.moveOptions[i] = null;
            }
            
            this.render();
            window._endGame();
        },
        
        getResult : function()
        {
            return this.endResult;
        },
        
        getStarted : function()
        {
            this.letsGo = true;
        },

        pauseGame : function()
        {
            clearInterval(this.startInterval);
            this.startInterval = 0;

            this.showMessage('Click to resume...', function() { that.resumeGame(); });

            return this.elapsedTime;
        },

        resumeGame : function()
        {
            // resume game…
            this.hideMessage();
            this.startTime = new Date().getTime();
            this.startInterval = setInterval(this.gameWrapper, 250);
        },
        
        toggleGame : function()
        {
            var that = this;
            
            if (this.startInterval)
            {
                this.pauseGame();
            }
            else
            {
                // resume game…
                this.resumeGame();
            }
        },
        
        startGame : function()
        {
            this.letsGo = false;
            this.timer.style.display = '';
            this.moveLog = Array();
            this.moveLogContainer.innerHTML = '';
            this.moveLogContainer.style.visibility = 'visible';
            
            var that = this;
            
            this.activeBid = 40;
            
            this.drawTime(this.maxTime);
            this.isActive = true;
            
            var time = this.maxTime;
            this.startTime = new Date().getTime();

            var t = this.activeTarget;
            
            for (var j = 0; j < this.tiles.length; ++j)
            {
                var ti = this.tiles[j];
                
                if (ti.targetId === t.id)
                {
                    ti.target = t;
                    this.captureTile = ti;
                    break;
                }
            }
            
            this.render();
            
            this.gameWrapper = function()
            {
                var now = new Date().getTime();
                that.elapsedTime = that.elapsedTime + (now - that.startTime);
                that.startTime = now;
                
                var remaining = time - Math.floor(that.elapsedTime / 100) / 10;
                that.drawTime(remaining);
                
                if (remaining < 0)
                {
                    clearInterval(that.startInterval);
                    
                    that.showMessage('You lose!', function()
                    {
                        that.endRound(false);
                    });
                }
                
            };
            
            this.startInterval = setInterval(this.gameWrapper, 250);
        }
    });
    
    window['turnModeGameboard'] = turnModeGameboard;
})();