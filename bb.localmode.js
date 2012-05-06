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

    localModeGameboard = gameboard.extend
    ({        
        init : function(isActive, gameData)
        {
            arguments.callee.$.init.call(this);
            
            /*
            _('#canvas').style.opacity = 0;
            $("#canvas").animate({
                
              opacity: 1
            }, 1500, 'ease-out');*/
            
            
            this.container = document.getElementById('localModeContainer');
            this.container.style.display = 'block';
            
            var tbody = ce(ce(this.container, 'table', null, ''), 'tbody', null, '');
            
            var p2Data = ce(ce(ce(tbody, 'tr', null, null), 'td', null, null), 'div', null, 'player2Data', null);
            var p2Title = ce(p2Data, 'div', null, null, 'Player 2: ');
            var p2Buttons = ce(p2Data, 'div', null, 'playerButtons');
            this.player2UpButton = ce(p2Buttons, 'button', null, 'player2Up', 'Up');
            this.player2DownButton = ce(p2Buttons, 'button', null, 'player2Down', 'Down');
            this.player2Bid = ce(p2Buttons, 'div', null, 'player2Bid', '--');
            this.player2SetButton = ce(p2Buttons, 'button', null, 'player2Set', 'Set');
            this.player2Cache = ce(p2Data, 'div', null, 'player2Cache', '');            
            this.timer = ce(ce(ce(tbody, 'tr'), 'td'), 'div', null, 'timer');
            this.timerCanvas = ce(this.timer, 'canvas', null, 'timerCanvas');
            this.timerCanvas.height = this.timerCanvas.width = 1000;
            
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
            this.wrapTouchEvent(this.player2UpButton, 'player2Up');
            this.wrapTouchEvent(this.player2DownButton, 'player2Down');
            this.wrapTouchEvent(this.player1SetButton, 'player1Set');
            this.wrapTouchEvent(this.player2SetButton, 'player2Set');
            this.wrapTouchEvent(this.getStartedButton, 'getStarted');
            
            this.getStartedButton.style.display = 'none';
            this.activeCache.style.display = '';
            this.moveLogContainer.style.visibility = 'hidden';
            
            this.activeBidder = null;
            this.activeBid = 21;
            
            this.player1Cache.innerHTML = '';
            this.player2Cache.innerHTML = '';
            this.activeCache.innerHTML = '';
            
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
            this.player2Score = 0;
            
            var that = this;
            this.showMessage('Click to get started', function() { that.hideMessage(); that.startGame(); });
            
            console.log(JSON.stringify(this.encodeBoard()));
            
            return this.encodeBoard();
        },
        
        uninit : function()
        {
            arguments.callee.$.uninit.call(this);
            
            _('#localModeContainer').style.display = 'none';

            clearInterval(this.startInterval);
            clearInterval(this.confirmInterval);
        },
        
        encodeBoard : function()
        {
            var boardData = arguments.callee.$.encodeBoard.call(this);
            
            return boardData;
        },
        
        createToken : function(id, color)
        {
            var token = document.createElement('div');
            token.id = id;
            token.style['background-color'] = color;
            token.style.height = '30px';
            token.style.width = '30px';
            token.style.margin = '2px';
            token.style.display = 'inline-block';
            
            return token;
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
                return;
                
                for (var i = 0; i < index; ++i)
                {
                    var move = this.moveLog[this.moveLog.length - 1];
                    move.from.piece = move.to.piece;
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
            /*
                <div class="moveLogItem">
                    <div class="index">1.</div>
                    <div class="description">Moved Left</div>
                </div>
            */
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
            
            if (this.targets.length)
            {
                this.showMessage('Click to start next round...', function() { that.hideMessage(); that.startGame(); });
            }
            else
            {
                var winner = (this.player1Score > this.player2Score) ? 1 : 2;
                var winText = 'Player ' + winner + ' wins!';
                
                if (this.player1Score == this.player2Score)
                {
                    winText = 'You Tied!';
                }
                
                this.showMessage('Game over. ' + winText + '...', function() { that.hideMessage(); gameOver(); });
            }
        },
        
        drawTime : function(seconds)
        {
            if (seconds == 60) seconds = 59.999;
            
            this.timerCanvasCtx.fillStyle ='#000';
            this.timerCanvasCtx.clearRect(0,0,1000,1000);
            
            this.timerCanvasCtx.beginPath();
            this.timerCanvasCtx.moveTo(500,500);
            this.timerCanvasCtx.arc(500, 500, 500, 0, Math.PI*2*(1 - seconds / 60.0), true);
            
            this.timerCanvasCtx.closePath();
            this.timerCanvasCtx.fill();
        },
        
        endRound : function()
        {
            this.activeCache.style.display = '';
            this.getStartedButton.style.display = 'none';
            this.moveLogContainer.style.visibility = 'hidden';
            
            clearInterval(this.confirmInterval);
            var target = this.captureTile.target;
            this.captureTile.target = null;
            
            var token = this.createToken(target.id, target.color);
            
            if (this.activeBidder == 1)
            {
                this.player1Score++;
                this.player1Cache.appendChild(token);
            }
            else
            {
                this.player2Score++;
                this.player2Cache.appendChild(token);
            }
            
            this.targetTile = null;
            this.activeTile = null;
            this.isActive = false;
            
            this.activeBidder = null;
            
            for (var i = 0; i <  this.moveOptions.length; ++i)
            {
                this.moveOptions[i] = null;
            }
            
            this.render();
            this.startRound();
        },
        
        getStarted : function()
        {
            this.letsGo = true;
            // this.solve();
        },
        
        startConfirm : function()
        {
            this.moveLog = Array();
            this.moveLogContainer.innerHTML = '';
            
            var that = this;
            var time = 60;
            var start = new Date().getTime();
            
            this.drawTime(time);
            this.isActive = true;
            
            this.confirmInterval = setInterval(function()
            {
                //that.timer.innerHTML = time;
                var remaining = time - Math.floor((new Date().getTime() - start) / 100) / 10;
                that.drawTime(remaining);
                
                if (remaining <= 0)
                {
                    clearInterval(that.confirmInterval);
                    that.confirmInterval = null;
                    that.activeBidder = (that.activeBidder == 1) ? 2 : 1;
                    
                    that.showMessage('You lose!', function()
                    {
                        that.endRound();
                    });
                }
                
            }, 250);
        },
        
        startGame : function()
        {
            this.letsGo = false;
            this.timer.style.display = '';
            
            var that = this;
            var wait = 6;
            
            this.player1Bid.innerHTML = 20;
            this.player2Bid.innerHTML = 20;
            this.activeBid = 21;
            this.activeBidder = null;
            
            this.drawTime(60);
            
            this.startInterval = setInterval(function()
            {
                that.drawTime((wait%2!=0) ? .01 : 60);
                wait--;
                
                if (wait == 0)
                {
                    clearInterval(that.startInterval);
                    
                    var time = 60;
                    var start = new Date().getTime();
                    
                    var index = Math.floor(Math.random()*that.targets.length);
                    var t = that.targets[index];
                    that.targets.splice(index, 1);
                    
                    for (var i = 0; i < that.activeCache.childNodes.length;++i)
                    {
                        var node = that.activeCache.childNodes[i];
                        
                        if (node.id == t.id)
                        {
                            that.activeCache.removeChild(node);
                            break;
                        }
                    }
                    
                    for (var j = 0; j < that.tiles.length; ++j)
                    {
                        var ti = that.tiles[j];
                        
                        if (ti.targetId === t.id)
                        {
                            ti.target = t;
                            that.captureTile = ti;
                            break;
                        }
                    }
                    
                    that.render();
                    
                    that.startInterval = setInterval(function()
                    {
                        var remaining = time - Math.floor((new Date().getTime() - start) / 100) / 10;
                        that.drawTime(remaining);
                        //that.timer.innerHTML = elapsed;
                        
                        if (remaining <= 0 || that.letsGo)
                        {
                            clearInterval(that.startInterval);
                            
                            if (that.activeBidder)
                            {
                                //that.timer.innerHTML = '--';
                                that.flashMessage('Player ' + (that.activeBidder) + ' get ready...', 1500, function()
                                {
                                    that.activeCache.style.display = 'none';
                                    that.getStartedButton.style.display = 'none';
                                    
                                    that.moveLogContainer.style.visibility = 'visible';
                                    that.moveLogContainer.style['-webkit-transform'] = '';
                                        
                                    if (that.activeBidder == 2)
                                    {
                                        that.moveLogContainer.style['-webkit-transform'] = 'rotate(-180deg)';
                                    }
                                    
                                    that.startConfirm();
                                });
                            }
                            else
                            {
                                that.targets.push(that.captureTile.target);
                                that.activeCache.appendChild(that.createToken(that.captureTile.target.id, that.captureTile.target.color));
                                that.captureTile.target = null;
                                that.render();
                                
                                // OK no one got this...show a message and move on
                                that.flashMessage('Moving on...', 1500, function()
                                {
                                    that.startRound();
                                });
                                
                                that.timer.style.display = 'none';
                            }
                        }
                        
                    }, 250);
                }
            }, 250);
        },
        
        player1Up : function()
        {
            var bid = parseInt(this.player1Bid.innerHTML) + 1;
            
            if (bid < this.activeBid)
            {
                this.player1Bid.innerHTML = bid;
            }
        },
        
        player1Down : function()
        {
            var bid = parseInt(this.player1Bid.innerHTML) - 1;
            
            if (this.player1Bid.innerHTML == '-') bid = this.activeBid;
            bid = Math.min(bid, this.activeBid - 1);
            
            this.player1Bid.innerHTML = bid;
        },
        
        player1Set : function()
        {
            var bid = parseInt(this.player1Bid.innerHTML);
            if (bid < this.activeBid)
            {
                this.activeBidder = 1;
                this.activeBid = bid;
                this.getStartedButton.style.display = '';
                
                this.player2Bid.innerHTML = '-';
            }
        },
        
        player2Up : function()
        {
            var bid = parseInt(this.player2Bid.innerHTML) + 1;
            
            if (bid < this.activeBid)
            {
                this.player2Bid.innerHTML = bid;
            }
        },
        
        
        player2Down : function()
        {
            var bid = parseInt(this.player2Bid.innerHTML) - 1;
            
            if (this.player2Bid.innerHTML == '-') bid = this.activeBid;
            
            bid = Math.min(bid, this.activeBid - 1);
            
            this.player2Bid.innerHTML = bid;
        },
        
        player2Set : function()
        {
            var bid = parseInt(this.player2Bid.innerHTML);
            
            if (bid < this.activeBid)
            {
                this.activeBidder = 2;
                this.activeBid = bid;
                
                this.player1Bid.innerHTML = '-';
                this.getStartedButton.style.display = '';
            }
        },
        
        printStack : function(stack)
        {
            var log = '';
            for (var i = 0; i < stack.length; ++i)
            {
                log += '{ p: ' + stack[i].p + ', d: ' + stack[i].d + ' }, ';
            }
        },
        
        fakeRender : function()
        {
            clearTimeout(this.fr);
            
            var that = this;
            this.fr = setTimeout(function()
            {
                console.log('render');  
                that.render();
            }, 1);
        }
    });
    
    window['localModeGameboard'] = localModeGameboard;
})();