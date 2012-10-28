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

            this.container.innerHTML = this.template;

            this.moveLogContainer = $(this.container).find('.moveLog')[0];
            this.moveCountContainer = $(this.container).find('.moveCount')[0];
            this.activeCache = $(this.container).find('.activeCache')[0];
            this.timeCountCont = $(this.container).find('.timeCount')[0];
            var clearMoves = $(this.container).find('.clearMoves')[0];
            this.wrapTouchEvent(clearMoves, 'clearMoves');

            this.activeCache.style.display = '';
            this.moveLogContainer.parentNode.style.display = 'none';

            this.activeCache.innerHTML = '';
            /*
            var tbody = ce(ce(this.container, 'table', null, ''), 'tbody', null, '');
                  
            this.timer = ce(ce(ce(tbody, 'tr'), 'td'), 'div', null, 'timer');
            this.timerCanvas = ce(this.timer, 'canvas', null, 'timerCanvas');
            this.timerCanvas.height = this.timerCanvas.width = 1000;
            this.timer.style.display = 'none';
            
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
            this.moveLogContainer.style.visibility = '';
            
            this.player1Cache.innerHTML = '';
            this.activeCache.innerHTML = '';
            */
            //p1Data.style.display = 'none';
            
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

        replay: function(moves)
        {
            if (this.isReplay)
            {
                this.clearMoves();
            }

            this.container.style.display = 'none';

            this.isReplay = true;
            this.clearMoves();
            this.startGame();
            clearInterval(this.startInterval);
            this.drawTime(this.maxTime-0.01);

            //var moves = round.MoveLog;
            this.isActive = false;
            this.hideMessage();
            var index = 0;
            var that = this;

            // this.moveMover = function (mover, from, to, duration, callback)

            var interval = setInterval(function()
            {
                if (index >= moves.length)
                {
                    that.render();
                    clearInterval(interval);

                    setTimeout(function() { that.moveLog = that.replayMoveLog; that.replay(moves); }, 2500);

                    return;
                }

                var move = moves[index];

                var mover = that.movers[move.p];
                var dir = move.d + 37;

                console.log(move.p + ': ' + (dir - 37));

                that.activeTile = that.tiles[mover.tileIndex];
                that.activeTile.isActive = true;
                that.showPossible();
                that.render();

                // End game needs to move the log
                that.isActive = true;
                that.keyDown({ keyCode: dir });
                that.isActive = false;

                index++;
            }, 750);
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

        clearMoves : function(e)
        {
            if (this.moveLogContainer && this.moveLogContainer.childNodes.length)
            {
                this.logClick({ currentTarget : this.moveLogContainer.childNodes[this.moveLogContainer.childNodes.length - 1]});
            }

            return false;
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

                this.moveCountContainer.innerHTML = this.moveLogContainer.childNodes.length;

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

            moveLogItem.innerHTML = this.moveLogTemplate;

            $(moveLogItem).find('.index')[0].innerHTML = this.moveLog.length + '.';
            var dir = $(moveLogItem).find('.direction')[0];

            dir.firstChild.style.backgroundColor = move.color;
            dir.firstChild.className = move.direction;

            /*
            var moveLogItemIndex = document.createElement('div');
            moveLogItemIndex.className = 'index';
            moveLogItemIndex.innerHTML = this.moveLog.length + '.';
            moveLogItemIndex.style.backgroundColor = move.color;
            
            var moveLogItemDesc = document.createElement('div');
            moveLogItemDesc.className = 'description';
            moveLogItemDesc.innerHTML = 'Moved ' + move.direction;
            
            moveLogItem.appendChild(moveLogItemIndex);
            moveLogItem.appendChild(moveLogItemDesc);
            */
            if (this.moveLogContainer.childNodes.length)
            {
                this.moveLogContainer.insertBefore(moveLogItem, this.moveLogContainer.childNodes[0]);
            }
            else
            {
                this.moveLogContainer.appendChild(moveLogItem);
            }

            this.moveCountContainer.innerHTML = this.moveLogContainer.childNodes.length;
            this.moveLogContainer.parentNode.style.display = 'block';
        },
        
        startRound : function()
        {
            var that = this;
        },
        
        endRound : function(success)
        {
            if (this.isReplay)
            {
                this.replayMoveLog = this.moveLog;
                return;
            }

            var elapsed = new Date().getTime() - this.startTime;
            
            this.endResult =
            {
                Success: success,
                Duration: elapsed,
                Moves: this.moveLog.length,
                MoveLog: this.moveLog.select(function(i) { return { 'd': i.dir, 'p': i.moverId }; })
            };

            this.elapsedTime = 0;
            this.moveLogContainer.innerHTML = '';
            
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
            //this.timer.style.display = '';
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
        },

        drawTime : function(seconds)
        {
            arguments.callee.$.drawTime.call(this, seconds);

            if (this.timeCountCont && seconds)
            {
                var time = Math.round(seconds);
                var min = Math.floor(time / 60);
                var seconds = Math.floor(time % 60);

                if (min < 10)
                {
                    min = '0' + min;
                }
                if (seconds < 10)
                {
                    seconds = '0' + seconds;
                }

                this.timeCountCont.innerHTML = min + ':' + seconds;
            }
        },

        moveLogTemplate: ' \
                        <div class="index">1</div> \
                        <div class="direction"><div class="left yellow"></div></div> \
                        <div class="undo"><div></div></div>',

        template : ' \
        <div style="position:relative;height:100%"> \
            <div style="display:none; vertical-align: bottom; position:absolute; top:0; right:0; left: 0; border: 1px solid blue;"> \
                <div class="activeCache"> \
                </div> \
            </div> \
            <div style=" position:absolute; bottom:233px; z-index:10; left:20px; right:20px; border: 1px solid black; border-radius: 5px 5px 0 0; overflow: hidden; padding:0px; max-height: 400px"> \
                <div class="moveLog" style="border-radius: 5px 5px 0 0;"></div> \
            </div> \
            <table cellpadding="0" cellspacing="0" class="userInfo" style="position:absolute; bottom:0"> \
                <tr> \
                    <td align="center" colspan="2" class="moveCount"> \
                    0 \
                    </td> \
                </tr> \
                <tr class="timeInfo"> \
                    <td class="timeCount"></td> \
                    <td class="clearMoves"><a href="">clear</a></td> \
                </tr> \
                <tr> \
                    <td colspan="2" class="profile"> \
                        <img src="img/noface.png" style="height:50px; width:50px" align="absmiddle"> \
                        Nicholas \
                    </td> \
                </tr> \
            </table>    \
        </div>'
});
    
    window['turnModeGameboard'] = turnModeGameboard;
})();