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

    demoModeGameboard = gameboard.extend
    ({        
        init : function(isActive, gameData, generateState, elapsedTime)
        {
            arguments.callee.$.init.call(this);

            this.maxTime = 120.0;

            var that = this;
            this.elapsedTime = 0;
            this.pastMoves = Array();

            setTimeout(function()
            {
                that.startGame();
            }, 100);
            
            return this.encodeBoard();
        },
        
        uninit : function()
        {
            arguments.callee.$.uninit.call(this);
            
            _('#demoModeContainer').innerHTML = '';
            _('#demoModeContainer').style.display = 'none';

            clearInterval(this.startInterval);
            clearInterval(this.confirmInterval);
        },
        
        encodeBoard : function()
        {
            var boardData = arguments.callee.$.encodeBoard.call(this);
            
            return boardData;
        },
        
        startRound : function()
        {
            var that = this;
        },
        
        endRound : function(success)
        {
            this.elapsedTime = 0;
            
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
            this.init();
        },

        showPossible : function()
        {
            return;
        },
        
        startGame : function()
        {
            var that = this;
            this.isActive = false;

            this.captureTileIndex = Math.floor(Math.random()*this.targets.length);
            this.activeTarget = this.targets[this.captureTileIndex];
            this.targets.splice(this.captureTileIndex, 1);

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
            this.solution = null;
            this.simulateMove();
            this.speed = 500;
        },

        simulateMove : function()
        {
            var that = this;

            if (!that.solution)
            {
                that.solution = that.solve();
            }

            var from = null;
            var to = null;
            var mover = null;

            if (that.solution)
            {
                if (that.solution.length == 0)
                {
                    return;
                }

                var move = that.solution.splice(0, 1)[0];
                from = that.tiles[move.f];
                to = that.tiles[move.t];
                mover = move.m;

                this.activeTile = from;
                that.showPossible();
                this.pastMoves.push(move);
                this.speed = 500;
            }
            else
            {
                // Move pieces at random...
                var pieceIndex = Math.floor(Math.random()*4);
                var moveOption = null;
                that.activeTile = that.tiles[that.movers[pieceIndex].tileIndex];
                that.showPossible();

                do
                {
                    var moveIndex = Math.floor(Math.random()*4);
                    moveOption = that.moveOptions[moveIndex];
                } while (!moveOption);

                from = that.activeTile;
                to = moveOption.endTile;
                mover = that.movers[pieceIndex];

                this.speed = 50;
            }

            this.render();

            if (from.piece != mover)
            {
                _alert('wtf');
                from.piece = mover;
                that.render();
                that.simulateMove();
                return;
            }

            this.moveMover(mover, from, to, this.speed, function() { that.simulateMove();} );
        }
    });
    
    window['demoModeGameboard'] = demoModeGameboard;
})();