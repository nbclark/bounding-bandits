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
            this.container.innerHTML = '';
            this.container.style.display = 'block';
            this.container.innerHTML = this.template;

            /*
            var tbody = ce(ce(this.container, 'table', null, ''), 'tbody', null, '');
            
            var p2Data = ce(ce(ce(tbody, 'tr', null, null), 'td', null, null), 'div', null, 'player2Data', null);
            var p2Title = ce(p2Data, 'div', null, null, 'Player 2: ');
            var p2Buttons = ce(p2Data, 'div', null, 'playerButtons');
            this.player2UpButton = ce(p2Buttons, 'button', null, 'player2Up', 'Up');
            this.player2DownButton = ce(p2Buttons, 'button', null, 'player2Down', 'Down');
            this.player2Bid = ce(p2Buttons, 'div', null, 'player2Bid', '--');
            this.player2SetButton = ce(p2Buttons, 'button', null, 'player2Set', 'Set');
            this.player2Cache = ce(p2Data, 'div', null, 'player2Cache', '');
            
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
            */

            this.moveLogContainer = $(this.container).find('.moveLog')[0];
            this.moveCountContainer = $(this.container).find('.moveCount')[0];
            this.activeCache = $(this.container).find('.activeCache')[0];
            this.timeCountCont = $(this.container).find('.timeCount')[0];
            var clearMoves = $(this.container).find('.clearMoves')[0];

            this.player1UpButton = $(this.container).find('.player1Up')[0];
            this.player1DownButton = $(this.container).find('.player1Down')[0];
            this.player1Bid = $(this.container).find('.player1Bid')[0];
            this.player1SetButton = $(this.container).find('.player1Set')[0];
            this.player1Cache = $(this.container).find('.player1Cache')[0];
            this.player1Name = $(this.container).find('.player1Name')[0];

            this.player2UpButton = $(this.container).find('.player2Up')[0];
            this.player2DownButton = $(this.container).find('.player2Down')[0];
            this.player2Bid = $(this.container).find('.player2Bid')[0];
            this.player2SetButton = $(this.container).find('.player2Set')[0];
            this.player2Cache = $(this.container).find('.player2Cache')[0];
            this.player2Name = $(this.container).find('.player2Name')[0];

            this.getStartedButton = $(this.container).find('.getStarted')[0];
            
            this.wrapTouchEvent(this.player1UpButton, 'player1Up');
            this.wrapTouchEvent(this.player1DownButton, 'player1Down');
            this.wrapTouchEvent(this.player2UpButton, 'player2Up');
            this.wrapTouchEvent(this.player2DownButton, 'player2Down');
            this.wrapTouchEvent(this.player1SetButton, 'player1Set');
            this.wrapTouchEvent(this.player2SetButton, 'player2Set');
            this.wrapTouchEvent(this.getStartedButton, 'getStarted');
            
            this.getStartedButton.style.display = 'none';
            this.activeCache.style.display = '';
            this.activeCache.className = 'activeCache full';
            this.moveLogContainer.style.display = 'none';
            
            this.activeBidder = null;
            this.activeBid = 21;
            
            this.player1Cache.innerHTML = '';
            this.player2Cache.innerHTML = '';
            this.activeCache.innerHTML = '';
            
            this.player1Name.innerHTML = 'Player #1';
            this.player2Name.innerHTML = 'Player #2';
            
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

            this.seconds = 60;
            this.maxTime = 60;
            
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
            var moveLogItem = document.createElement('div');
            moveLogItem.className = 'moveLogItem';
            moveLogItem.onclick = this.wrapCallback('logClick');

            moveLogItem.innerHTML = this.moveLogTemplate;

            $(moveLogItem).find('.index')[0].innerHTML = this.moveLog.length + '.';
            var dir = $(moveLogItem).find('.direction')[0];

            dir.firstChild.style.backgroundColor = move.color;
            dir.firstChild.className = move.direction;
            
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
        
        endRound : function()
        {
            this.activeCache.className = 'activeCache full';
            this.getStartedButton.style.display = 'none';
            this.moveLogContainer.style.display = 'none';
            
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
            
            var that = this;
            var wait = 6;
            
            this.player1Bid.innerHTML = 20;
            this.player2Bid.innerHTML = 20;
            $(this.player1SetButton.parentNode).addClass('active');
            $(this.player2SetButton.parentNode).addClass('active');
            this.activeBid = 21;
            this.activeBidder = null;
            this.moveLogContainer.parentNode.style['vertical-align'] = 'middle';
            this.activeCache.style.display = '';
            
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
                    var animatedToken;
                    
                    that.targets.splice(index, 1);
                    
                    for (var i = 0; i < that.activeCache.childNodes.length;++i)
                    {
                        var node = that.activeCache.childNodes[i];
                        
                        if (node.id == t.id)
                        {
                            var moveContainer = document.createElement('div');
                            moveContainer.className = 'movingCache full';
                            moveContainer.style.position = 'absolute';
                            moveContainer.style.top = '50px';
                            moveContainer.style.left = '50px';
                            
                            var token = that.createToken('animatedToken', node.firstChild['data-color']);
                            
                            moveContainer.appendChild(token);
                            
                            document.body.appendChild(moveContainer);
                            var mc = _('.modeContainer');
                            var pos = mc.position();
                            
                            pos.y += mc.clientHeight / 2;
                            pos.x;
                            
                            moveContainer.style.left = pos.x + 'px';
                            moveContainer.style.top = pos.y + 'px';
                            
                            node.style.visibility = 'hidden';
                            
                            animatedToken = moveContainer;
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
                    
                    var w = animatedToken.firstChild.clientWidth;
                    var h = animatedToken.firstChild.clientHeight;
                            
                    var startX = that.context.boardLeft + that.context.tileSize * that.captureTile.col - (w - that.context.tileSize) / 2;
                    var startY = that.context.boardTop + that.context.tileSize * that.captureTile.row - (h - that.context.tileSize) / 2;
    
                    $("#animatedToken").animate({
                      marginLeft:-pos.x + startX + 10,
                      marginTop:-pos.y + startY + 10
                    }, 600, 'ease-out', function()
                    {
                        animatedToken.parentNode.removeChild(animatedToken);
                        
                        that.render();
                        
                        that.startInterval = setInterval(function()
                        {
                            var remaining = time - Math.floor((new Date().getTime() - start) / 100) / 10;
                            that.drawTime(remaining);
                            
                            if (remaining <= 0 || that.letsGo)
                            {
                                clearInterval(that.startInterval);
                                
                                if (that.activeBidder)
                                {
                                    that.flashMessage('Player ' + (that.activeBidder) + ' get ready...', 1500, function()
                                    {
                                        that.activeCache.style.display = 'none';
                                        that.getStartedButton.style.display = 'none';
                                        
                                        that.moveLogContainer.style.display = 'block';
                                        that.moveLogContainer.style['-webkit-transform'] = '';
                                            
                                        if (that.activeBidder == 2)
                                        {
                                            that.moveLogContainer.style['-webkit-transform'] = 'rotate(-180deg)';
                                            that.moveLogContainer.parentNode.style['vertical-align'] = 'top';
                                        }
                                        else
                                        {
                                            that.moveLogContainer.style['-webkit-transform'] = 'rotate(0deg)';
                                            that.moveLogContainer.parentNode.style['vertical-align'] = 'bottom';
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
                                }
                            }
                            
                        }, 250);
                    });
                }
            }, 250);
        },
        
        player1Up : function()
        {
            var bid = parseInt(this.player1Bid.innerHTML) + 1;
            
            if (bid < this.activeBid)
            {
                this.player1Bid.innerHTML = bid;
                $(this.player1SetButton.parentNode).addClass('active');
            }
        },
        
        player1Down : function()
        {
            var bid = parseInt(this.player1Bid.innerHTML) - 1;
            
            if (this.player1Bid.innerHTML == '-') bid = this.activeBid;
            bid = Math.min(bid, this.activeBid - 1);
            
            this.player1Bid.innerHTML = bid;
            $(this.player1SetButton.parentNode).addClass('active');
        },
        
        player1Set : function()
        {
            var bid = parseInt(this.player1Bid.innerHTML);
            if (bid < this.activeBid)
            {
                this.activeBidder = 1;
                this.activeBid = bid;
                this.getStartedButton.style.display = '';
                this.activeCache.className = 'activeCache';
                
                this.player2Bid.innerHTML = '-';
                
                $(this.player1SetButton.parentNode).removeClass('active');
                $(this.player2SetButton.parentNode).removeClass('active');
            }
        },
        
        player2Up : function()
        {
            var bid = parseInt(this.player2Bid.innerHTML) + 1;
            
            if (bid < this.activeBid)
            {
                this.player2Bid.innerHTML = bid;
                
                $(this.player2SetButton.parentNode).addClass('active');
            }
        },
        
        player2Down : function()
        {
            var bid = parseInt(this.player2Bid.innerHTML) - 1;
            
            if (this.player2Bid.innerHTML == '-') bid = this.activeBid;
            
            bid = Math.min(bid, this.activeBid - 1);
            
            this.player2Bid.innerHTML = bid;
                
            $(this.player2SetButton.parentNode).addClass('active');
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
                this.activeCache.className = 'activeCache';
                
                $(this.player1SetButton.parentNode).removeClass('active');
                $(this.player2SetButton.parentNode).removeClass('active');
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
        },

        moveLogTemplate: ' \
                        <div class="index">1</div> \
                        <div class="direction"><div class="left yellow"></div></div> \
                        <div class="undo"><div></div></div>',

        template: '\
        <table> \
            <tbody> \
            <tr> \
                <td class="playerData player2Data"> \
                        <table class="userInfo user2Info" cellpadding="0" cellspacing="0"> \
                            <tr class="profile"> \
                            <td> \
                                <div style="background-image:url(img/noface.png)"></div> \
                            </td> \
                            <td colspan="2" class="player2Name"> \
                                Nicholas \
                            </td> \
                            </tr> \
                            <tr class="moveCount playerButtons"> \
                                    <td class="bidButtons"> \
                                        <button class="player2Up"><img src="img/up.png" /></button> \
                                        <button class="player2Down"><img src="img/down.png" /></button> \
                                    </td> \
                                \
                                    <td class="bidText"> \
                                        <div class="player2Bid">20</div> \
                                        <div class="bidMoves">moves</div> \
                                    </td> \
                                    <td class="setButtons"> \
                                        <button class="player2Set"><img src="img/check.png" /></button> \
                                    </td> \
                            </tr> \
                            </table> \
                        <div colspan="3" class="playerCache player2Cache"> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); height: 30px; width: 30px; margin-top: 2px; margin-right: 2px; margin-bottom: 2px; margin-left: 2px; line-height: 30px; color: rgb(255, 255, 255); text-align: center; text-shadow: rgb(0, 0, 0) 0px 0px 3px; display: inline-block;"></div> \
                            </div> \
                        </div> \
                    </td> \
                </tr> \
                <tr> \
                    <td height="100%" valign="middle" class="localInfo"> \
                        <div style="overflow-x: hidden; padding:5px"> \
                            <button class="getStarted" style="display: block;">Start Game</button> \
                            <div class="activeCache full"> \
                            </div> \
                        </div> \
                        <div class="moveLog" style="display:none; border-radius: 5px;">\
                        </div> \
                    </td> \
                </tr> \
                <tr> \
                    <td class="playerData player1Data"> \
                        <div colspan="3" class="playerCache player1Cache"> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                            <div id="16"> \
                                <div style="background-color: rgb(176, 101, 185); "></div> \
                            </div> \
                        </div> \
                        <table class="userInfo" cellpadding="0" cellspacing="0"> \
                            <tr class="profile"> \
                            <td> \
                                <div style="background-image:url(img/noface.png)"></div> \
                            </td> \
                            </td> \
                            <td colspan="2" class="player1Name"> \
                                Nicholas \
                            </td> \
                            </tr> \
                            <tr class="moveCount playerButtons"> \
                                    <td class="bidButtons"> \
                                        <button class="player1Up"><img src="img/up.png" /></button> \
                                        <button class="player1Down"><img src="img/down.png" /></button> \
                                    </td> \
                                \
                                    <td class="bidText"> \
                                        <div class="player1Bid">20</div> \
                                        <div class="bidMoves">moves</div> \
                                    </td> \
                                    <td class="setButtons"> \
                                        <button class="player1Set"><img src="img/check.png" /></button> \
                                    </td> \
                            </tr> \
                            </table> \
                        </td> \
                    </tr> \
                </tbody> \
            </table>'
    });
    
    window['localModeGameboard'] = localModeGameboard;
})();