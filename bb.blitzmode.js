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

    blitzModeGameboard = gameboard.extend
    ({        
        init : function(isActive, gameData)
        {
            arguments.callee.$.init.call(this);
            
            _('#canvas').style.opacity = 0;
            $("#canvas").animate({
                
              opacity: 1
            }, 1500, 'ease-out');
            
            
            this.container = document.getElementById('blitzModeContainer');
            this.container.style.display = 'block';
            
            var tbody = ce(ce(this.container, 'table', null, ''), 'tbody', null, '');
                  
            this.timer = ce(ce(ce(tbody, 'tr'), 'td'), 'div', null, 'counter');
            this.moveCounter = ce(ce(ce(tbody, 'tr'), 'td'), 'div', null, 'mcounter');
            
            this.wrapTouchEvent(this.timer, 'pauseGame');
            
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
                this.decodeBoard(gameData);
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
            
            _('#blitzModeContainer').innerHTML = '';
            _('#blitzModeContainer').style.display = 'none';

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
                var index = 1;
                while (this.moveLogContainer.childNodes.length)
                {
                    var node = this.moveLogContainer.childNodes[0];
                    this.moveLogContainer.removeChild(node);
                    
                    if (e.currentTarget === node)
                    {
                        break;
                    }
                    
                    index++;
                }
                
                for (var i = 0; i < index; ++i)
                {
                    var move = this.moveLog[this.moveLog.length - 1];
                    move.from.piece = move.to.piece;
                    move.from.piece.tile = move.from;
                    move.to.piece = null;
                    this.activeTile = move.from;
                    
                    if (!move.from.piece)
                    {
                        _alert('wtf');
                    }
                    
                    this.moveLog.splice(this.moveLog.length - 1, 1);
                }
                
                this.showPossible();
                this.render();
            }
            catch (e)
            {
                _alert(e);
            }
            
            this.moveCounter.innerHTML = this.totalMoves + this.moveLog.length ;
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
            
            this.moveCounter.innerHTML = this.totalMoves + this.moveLog.length ;
        },
        
        endRound : function(success)
        {
            var that = this;
            
            this.activeCache.style.display = '';
            this.getStartedButton.style.display = 'none';
            
            clearInterval(this.startInterval);
            var target = this.captureTile.target;
            this.captureTile.target = null;
            
            var token = this.createToken(target.id, target.color);
            
            this.targetTile = null;
            this.activeTile = null;
            
            this.activeBidder = null;
            
            for (var i = 0; i <  this.moveOptions.length; ++i)
            {
                this.moveOptions[i] = null;
            }
            
            this.render();
            this.totalMoves += this.moveLog.length;
            this.captureCount++;
            
            if (this.moveLog.length == this.bestSolution)
            {
                this.bestSolutionCount++;
            }
            
            if (this.targets.length)
            {
                this.flashMessage('Great! ' + this.targets.length + ' tokens remain!', 750, function()
                {
                    that.startRound();
                });
            }
            else
            {
                this.isActive = false;
                this.moveLogContainer.style.visibility = 'hidden';
                
                this.endResult =
                {
                    Success: success,
                    Duration: this.elapsedTime,
                    Moves: this.totalMoves,
                    Captures: this.captureCount,
                    BestSolutions: this.bestSolutionCount
                };
                
                this.elapsedTime = 0;
                window._endGame();
            }
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
            var that = this;
            
            if (this.startInterval)
            {
                clearInterval(this.startInterval);
                this.startInterval = 0;
                
                this.showMessage('Click to resume...', function() { that.pauseGame(); });
            }
            else
            {
                // resume game…
                this.hideMessage();
                this.startTime = new Date().getTime();
                this.startInterval = setInterval(this.gameWrapper, 250);
            }
        },
        
        startGame : function()
        {
            this.letsGo = false;
            this.timer.style.display = '';
            this.moveLogContainer.style.visibility = 'visible';
            
            this.activeBid = 40;
            this.isActive = true;
            
            this.elapsedTime = 0;
            this.totalMoves = 0;
            this.captureCount = 0;
            this.bestSolutionCount = 0;
            
            this.startRound();
        },
        
        startRound : function()
        {
            var that = this;
            this.moveLog = Array();
            this.moveLogContainer.innerHTML = '';
            
            this.captureTileIndex = Math.floor(Math.random()*this.targets.length);
            
            var t = this.targets[this.captureTileIndex];
            that.targets.splice(this.captureTileIndex, 1);
            
            for (var i = 0; i < this.activeCache.childNodes.length;++i)
            {
                var node = this.activeCache.childNodes[i];
                
                if (node.id == t.id)
                {
                    this.activeCache.removeChild(node);
                    break;
                }
            }
            
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
            this.bestSolution = this.solve();
            this.startTime = new Date().getTime();
            
            this.gameWrapper = function()
            {
                var now = new Date().getTime();
                that.elapsedTime = that.elapsedTime + (now - that.startTime);
                that.startTime = now;
                
                that.timer.innerHTML = Math.floor(that.elapsedTime / 1000);
                
            };
            
            this.startInterval = setInterval(this.gameWrapper, 250);
        }
    });
    
    window['blitzModeGameboard'] = blitzModeGameboard;
})();