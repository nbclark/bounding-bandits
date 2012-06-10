(function () {

    var GS_INTRO = 0;
    var GS_BLITZ = 1;

    var boardTiles = [
        {
            id : 0,
            data :
        [ { row: 0, col: 0, mask: 0, targetId: 0 }, { row: 0, col: 1, mask: 0, targetId: 0 }, { row: 0, col: 2, mask: 0, targetId: 0 }, { row: 0, col: 3, mask: 4, targetId: 0 }, { row: 0, col: 4, mask: 0, targetId: 0 }, { row: 0, col: 5, mask: 0, targetId: 0 }, { row: 0, col: 6, mask: 0, targetId: 0 }, { row: 0, col: 7, mask: 0, targetId: 0 }, { row: 1, col: 0, mask: 0, targetId: 0 }, { row: 1, col: 1, mask: 0, targetId: 0 }, { row: 1, col: 2, mask: 0, targetId: 0 }, { row: 1, col: 3, mask: 0, targetId: 0 }, { row: 1, col: 4, mask: 0, targetId: 0 }, { row: 1, col: 5, mask: 0, targetId: 0 }, { row: 1, col: 6, mask: 0, targetId: 0 }, { row: 1, col: 7, mask: 0, targetId: 0 }, { row: 2, col: 0, mask: 0, targetId: 0 }, { row: 2, col: 1, mask: 0, targetId: 0 }, { row: 2, col: 2, mask: 0, targetId: 0 }, { row: 2, col: 3, mask: 0, targetId: 0 }, { row: 2, col: 4, mask: 0, targetId: 0 }, { row: 2, col: 5, mask: 12, targetId: 1 }, { row: 2, col: 6, mask: 0, targetId: 0 }, { row: 2, col: 7, mask: 0, targetId: 0 }, { row: 3, col: 0, mask: 0, targetId: 0 }, { row: 3, col: 1, mask: 0, targetId: 0 }, { row: 3, col: 2, mask: 0, targetId: 0 }, { row: 3, col: 3, mask: 0, targetId: 0 }, { row: 3, col: 4, mask: 0, targetId: 0 }, { row: 3, col: 5, mask: 0, targetId: 0 }, { row: 3, col: 6, mask: 0, targetId: 0 }, { row: 3, col: 7, mask: 0, targetId: 0 }, { row: 4, col: 0, mask: 8, targetId: 0 }, { row: 4, col: 1, mask: 0, targetId: 0 }, { row: 4, col: 2, mask: 6, targetId: 3 }, { row: 4, col: 3, mask: 0, targetId: 0 }, { row: 4, col: 4, mask: 0, targetId: 0 }, { row: 4, col: 5, mask: 0, targetId: 0 }, { row: 4, col: 6, mask: 0, targetId: 0 }, { row: 4, col: 7, mask: 0, targetId: 0 }, { row: 5, col: 0, mask: 0, targetId: 0 }, { row: 5, col: 1, mask: 0, targetId: 0 }, { row: 5, col: 2, mask: 0, targetId: 0 }, { row: 5, col: 3, mask: 0, targetId: 0 }, { row: 5, col: 4, mask: 0, targetId: 0 }, { row: 5, col: 5, mask: 0, targetId: 0 }, { row: 5, col: 6, mask: 0, targetId: 0 }, { row: 5, col: 7, mask: 9, targetId: 5 }, { row: 6, col: 0, mask: 0, targetId: 0 }, { row: 6, col: 1, mask: 3, targetId: 6 }, { row: 6, col: 2, mask: 0, targetId: 0 }, { row: 6, col: 3, mask: 0, targetId: 0 }, { row: 6, col: 4, mask: 0, targetId: 0 }, { row: 6, col: 5, mask: 0, targetId: 0 }, { row: 6, col: 6, mask: 0, targetId: 0 }, { row: 6, col: 7, mask: 0, targetId: 0 }, { row: 7, col: 0, mask: 0, targetId: 0 }, { row: 7, col: 1, mask: 0, targetId: 0 }, { row: 7, col: 2, mask: 0, targetId: 0 }, { row: 7, col: 3, mask: 0, targetId: 0 }, { row: 7, col: 4, mask: 0, targetId: 0 }, { row: 7, col: 5, mask: 0, targetId: 0 }, { row: 7, col: 6, mask: 0, targetId: 0 }, { row: 7, col: 7, mask: 15, targetId: 0 },  ]
        },
        
        {
            id : 1,
            data :
        [ { row: 0, col: 0, mask: 0, targetId: 0 }, { row: 0, col: 1, mask: 0, targetId: 0 }, { row: 0, col: 2, mask: 0, targetId: 0 }, { row: 0, col: 3, mask: 0, targetId: 0 }, { row: 0, col: 4, mask: 0, targetId: 0 }, { row: 0, col: 5, mask: 1, targetId: 0 }, { row: 0, col: 6, mask: 0, targetId: 0 }, { row: 0, col: 7, mask: 0, targetId: 0 }, { row: 1, col: 0, mask: 0, targetId: 0 }, { row: 1, col: 1, mask: 0, targetId: 0 }, { row: 1, col: 2, mask: 12, targetId: 13 }, { row: 1, col: 3, mask: 0, targetId: 0 }, { row: 1, col: 4, mask: 0, targetId: 0 }, { row: 1, col: 5, mask: 0, targetId: 0 }, { row: 1, col: 6, mask: 0, targetId: 0 }, { row: 1, col: 7, mask: 0, targetId: 0 }, { row: 2, col: 0, mask: 0, targetId: 0 }, { row: 2, col: 1, mask: 0, targetId: 0 }, { row: 2, col: 2, mask: 0, targetId: 0 }, { row: 2, col: 3, mask: 0, targetId: 0 }, { row: 2, col: 4, mask: 0, targetId: 0 }, { row: 2, col: 5, mask: 0, targetId: 0 }, { row: 2, col: 6, mask: 0, targetId: 0 }, { row: 2, col: 7, mask: 0, targetId: 0 }, { row: 3, col: 0, mask: 0, targetId: 0 }, { row: 3, col: 1, mask: 9, targetId: 15 }, { row: 3, col: 2, mask: 0, targetId: 0 }, { row: 3, col: 3, mask: 0, targetId: 0 }, { row: 3, col: 4, mask: 0, targetId: 0 }, { row: 3, col: 5, mask: 0, targetId: 0 }, { row: 3, col: 6, mask: 0, targetId: 0 }, { row: 3, col: 7, mask: 0, targetId: 0 }, { row: 4, col: 0, mask: 8, targetId: 0 }, { row: 4, col: 1, mask: 0, targetId: 0 }, { row: 4, col: 2, mask: 0, targetId: 0 }, { row: 4, col: 3, mask: 0, targetId: 0 }, { row: 4, col: 4, mask: 0, targetId: 0 }, { row: 4, col: 5, mask: 0, targetId: 0 }, { row: 4, col: 6, mask: 3, targetId: 8 }, { row: 4, col: 7, mask: 0, targetId: 0 }, { row: 5, col: 0, mask: 0, targetId: 0 }, { row: 5, col: 1, mask: 0, targetId: 0 }, { row: 5, col: 2, mask: 0, targetId: 0 }, { row: 5, col: 3, mask: 0, targetId: 0 }, { row: 5, col: 4, mask: 0, targetId: 0 }, { row: 5, col: 5, mask: 0, targetId: 0 }, { row: 5, col: 6, mask: 0, targetId: 0 }, { row: 5, col: 7, mask: 0, targetId: 0 }, { row: 6, col: 0, mask: 0, targetId: 0 }, { row: 6, col: 1, mask: 0, targetId: 0 }, { row: 6, col: 2, mask: 0, targetId: 0 }, { row: 6, col: 3, mask: 0, targetId: 0 }, { row: 6, col: 4, mask: 0, targetId: 0 }, { row: 6, col: 5, mask: 6, targetId: 10 }, { row: 6, col: 6, mask: 0, targetId: 0 }, { row: 6, col: 7, mask: 0, targetId: 0 }, { row: 7, col: 0, mask: 0, targetId: 0 }, { row: 7, col: 1, mask: 0, targetId: 0 }, { row: 7, col: 2, mask: 0, targetId: 0 }, { row: 7, col: 3, mask: 12, targetId: 12 }, { row: 7, col: 4, mask: 0, targetId: 0 }, { row: 7, col: 5, mask: 0, targetId: 0 }, { row: 7, col: 6, mask: 0, targetId: 0 }, { row: 7, col: 7, mask: 15, targetId: 0 },  ]
        },
        
        {
            id : 2,
            data :
        [ { row: 0, col: 0, mask: 0, targetId: 0 }, { row: 0, col: 1, mask: 0, targetId: 0 }, { row: 0, col: 2, mask: 0, targetId: 0 }, { row: 0, col: 3, mask: 0, targetId: 0 }, { row: 0, col: 4, mask: 1, targetId: 0 }, { row: 0, col: 5, mask: 0, targetId: 0 }, { row: 0, col: 6, mask: 0, targetId: 0 }, { row: 0, col: 7, mask: 0, targetId: 0 }, { row: 1, col: 0, mask: 0, targetId: 0 }, { row: 1, col: 1, mask: 0, targetId: 0 }, { row: 1, col: 2, mask: 0, targetId: 0 }, { row: 1, col: 3, mask: 0, targetId: 0 }, { row: 1, col: 4, mask: 0, targetId: 0 }, { row: 1, col: 5, mask: 12, targetId: 16 }, { row: 1, col: 6, mask: 0, targetId: 0 }, { row: 1, col: 7, mask: 0, targetId: 0 }, { row: 2, col: 0, mask: 0, targetId: 0 }, { row: 2, col: 1, mask: 9, targetId: 14 }, { row: 2, col: 2, mask: 0, targetId: 0 }, { row: 2, col: 3, mask: 0, targetId: 0 }, { row: 2, col: 4, mask: 0, targetId: 0 }, { row: 2, col: 5, mask: 0, targetId: 0 }, { row: 2, col: 6, mask: 0, targetId: 0 }, { row: 2, col: 7, mask: 0, targetId: 0 }, { row: 3, col: 0, mask: 8, targetId: 0 }, { row: 3, col: 1, mask: 0, targetId: 0 }, { row: 3, col: 2, mask: 0, targetId: 0 }, { row: 3, col: 3, mask: 0, targetId: 0 }, { row: 3, col: 4, mask: 0, targetId: 0 }, { row: 3, col: 5, mask: 0, targetId: 0 }, { row: 3, col: 6, mask: 0, targetId: 0 }, { row: 3, col: 7, mask: 0, targetId: 0 }, { row: 4, col: 0, mask: 0, targetId: 0 }, { row: 4, col: 1, mask: 0, targetId: 0 }, { row: 4, col: 2, mask: 0, targetId: 0 }, { row: 4, col: 3, mask: 0, targetId: 0 }, { row: 4, col: 4, mask: 0, targetId: 0 }, { row: 4, col: 5, mask: 0, targetId: 0 }, { row: 4, col: 6, mask: 3, targetId: 11 }, { row: 4, col: 7, mask: 0, targetId: 0 }, { row: 5, col: 0, mask: 0, targetId: 0 }, { row: 5, col: 1, mask: 0, targetId: 0 }, { row: 5, col: 2, mask: 0, targetId: 0 }, { row: 5, col: 3, mask: 0, targetId: 0 }, { row: 5, col: 4, mask: 0, targetId: 0 }, { row: 5, col: 5, mask: 0, targetId: 0 }, { row: 5, col: 6, mask: 0, targetId: 0 }, { row: 5, col: 7, mask: 0, targetId: 0 }, { row: 6, col: 0, mask: 0, targetId: 0 }, { row: 6, col: 1, mask: 0, targetId: 0 }, { row: 6, col: 2, mask: 6, targetId: 9 }, { row: 6, col: 3, mask: 0, targetId: 0 }, { row: 6, col: 4, mask: 0, targetId: 0 }, { row: 6, col: 5, mask: 0, targetId: 0 }, { row: 6, col: 6, mask: 0, targetId: 0 }, { row: 6, col: 7, mask: 0, targetId: 0 }, { row: 7, col: 0, mask: 0, targetId: 0 }, { row: 7, col: 1, mask: 0, targetId: 0 }, { row: 7, col: 2, mask: 0, targetId: 0 }, { row: 7, col: 3, mask: 0, targetId: 0 }, { row: 7, col: 4, mask: 0, targetId: 0 }, { row: 7, col: 5, mask: 0, targetId: 0 }, { row: 7, col: 6, mask: 0, targetId: 0 }, { row: 7, col: 7, mask: 15, targetId: 0 },  ]
        },
        
        {
            id : 3,
            data :
        [ { row: 0, col: 0, mask: 0, targetId: 0 }, { row: 0, col: 1, mask: 4, targetId: 0 }, { row: 0, col: 2, mask: 0, targetId: 0 }, { row: 0, col: 3, mask: 0, targetId: 0 }, { row: 0, col: 4, mask: 0, targetId: 0 }, { row: 0, col: 5, mask: 0, targetId: 0 }, { row: 0, col: 6, mask: 0, targetId: 0 }, { row: 0, col: 7, mask: 0, targetId: 0 }, { row: 1, col: 0, mask: 0, targetId: 0 }, { row: 1, col: 1, mask: 0, targetId: 0 }, { row: 1, col: 2, mask: 0, targetId: 0 }, { row: 1, col: 3, mask: 0, targetId: 0 }, { row: 1, col: 4, mask: 3, targetId: 4 }, { row: 1, col: 5, mask: 0, targetId: 0 }, { row: 1, col: 6, mask: 0, targetId: 0 }, { row: 1, col: 7, mask: 0, targetId: 0 }, { row: 2, col: 0, mask: 0, targetId: 0 }, { row: 2, col: 1, mask: 6, targetId: 0 }, { row: 2, col: 2, mask: 0, targetId: 0 }, { row: 2, col: 3, mask: 0, targetId: 0 }, { row: 2, col: 4, mask: 0, targetId: 0 }, { row: 2, col: 5, mask: 0, targetId: 0 }, { row: 2, col: 6, mask: 0, targetId: 0 }, { row: 2, col: 7, mask: 0, targetId: 0 }, { row: 3, col: 0, mask: 0, targetId: 0 }, { row: 3, col: 1, mask: 0, targetId: 0 }, { row: 3, col: 2, mask: 0, targetId: 0 }, { row: 3, col: 3, mask: 0, targetId: 0 }, { row: 3, col: 4, mask: 0, targetId: 0 }, { row: 3, col: 5, mask: 0, targetId: 0 }, { row: 3, col: 6, mask: 12, targetId: 7 }, { row: 3, col: 7, mask: 0, targetId: 0 }, { row: 4, col: 0, mask: 0, targetId: 0 }, { row: 4, col: 1, mask: 0, targetId: 0 }, { row: 4, col: 2, mask: 0, targetId: 0 }, { row: 4, col: 3, mask: 0, targetId: 0 }, { row: 4, col: 4, mask: 0, targetId: 0 }, { row: 4, col: 5, mask: 0, targetId: 0 }, { row: 4, col: 6, mask: 0, targetId: 0 }, { row: 4, col: 7, mask: 0, targetId: 0 }, { row: 5, col: 0, mask: 8, targetId: 0 }, { row: 5, col: 1, mask: 0, targetId: 0 }, { row: 5, col: 2, mask: 0, targetId: 0 }, { row: 5, col: 3, mask: 0, targetId: 0 }, { row: 5, col: 4, mask: 0, targetId: 0 }, { row: 5, col: 5, mask: 0, targetId: 0 }, { row: 5, col: 6, mask: 0, targetId: 0 }, { row: 5, col: 7, mask: 0, targetId: 0 }, { row: 6, col: 0, mask: 0, targetId: 0 }, { row: 6, col: 1, mask: 0, targetId: 0 }, { row: 6, col: 2, mask: 0, targetId: 0 }, { row: 6, col: 3, mask: 6, targetId: 2 }, { row: 6, col: 4, mask: 0, targetId: 0 }, { row: 6, col: 5, mask: 0, targetId: 0 }, { row: 6, col: 6, mask: 0, targetId: 0 }, { row: 6, col: 7, mask: 0, targetId: 0 }, { row: 7, col: 0, mask: 0, targetId: 0 }, { row: 7, col: 1, mask: 0, targetId: 0 }, { row: 7, col: 2, mask: 0, targetId: 0 }, { row: 7, col: 3, mask: 0, targetId: 0 }, { row: 7, col: 4, mask: 0, targetId: 0 }, { row: 7, col: 5, mask: 0, targetId: 0 }, { row: 7, col: 6, mask: 0, targetId: 0 }, { row: 7, col: 7, mask: 15, targetId: 0 },  ]
        }
            
    ];
 
     var colors = [ 'rgb(176,101,185)', 'rgb(50,164,57)', 'rgb(216,136,56)', 'rgb(0,172,189)' ];
     var pieceImages = [ 'img/piece-purple.png', 'img/piece-green.png', 'img/piece-orange.png', 'img/piece-blue.png' ];
 //var pieceImagesHD = [ 'piece-purple@2x.png', 'piece-green@2x.png', 'piece-orange@2x.png', 'piece-blue@2x.png' ];
 var pieceImagesHD = {};
 
 for (var i = 0; i < colors.length; ++i)
 {
    pieceImagesHD[colors[i]] = new Image();
 }
 
 pieceImagesHD[colors[0]].src = 'img/piece-purple@2x.png';
 pieceImagesHD[colors[1]].src = 'img/piece-green@2x.png';
 pieceImagesHD[colors[2]].src = 'img/piece-orange@2x.png';
 pieceImagesHD[colors[3]].src = 'img/piece-blue@2x.png';
    
    Array.prototype.select = function(lambda)
    {
        var retArr = Array();
        
        for (var i = 0; i < this.length; ++i)
        {
            retArr.push(lambda(this[i]));
        }
        
        return retArr;
    };

    Board = function(array) { if (array) this.init(array); }
    Board.prototype = new Array();

    Board.prototype.init = function ( array )
    {
        var side = Math.floor(Math.sqrt(array.length));
        
        for (var i = 0; i < array.length; ++i)
        {
            var localRow = Math.floor(i / side);
            var localCol = i % side;
            
            var t = array[i];
            var ti = new tile(localRow, localCol, t.mask);
            ti.targetId = t.targetId;
            ti.index = i;

            this.push(ti);
        }
    }
    
    Board.prototype.stitchQuads = function ( a, b, c, d )
    {
        this.length = 0;
        
        var quadSide = Math.floor(Math.sqrt(a.length));
        var side = quadSide * 2;
        var pieces = [ a, b, c, d ];
        
        for (var i = 0; i < pieces.length; ++i)
        {
            for (var j = 0; j < pieces[i].length; ++j)
            {
                var localRow = Math.floor(j / quadSide);
                var localCol = j % quadSide;
                
                if (i % 2)
                {
                    localCol += quadSide;
                }
                if (i >= 2)
                {
                    localRow += quadSide;
                }
                
                var index = side * localRow + localCol;
                
                if (this[index])
                {
                    //alert('error');
                }
                
                var t = pieces[i][j];
                
                this[index] = new tile(localRow, localCol, t.wallMask);
                this[index].targetId = t.targetId;
                this[index].index = index;
                
                this.length = Math.max(index+1, this.length);
            }
        }
    }
    
    Board.prototype.rotate = function (amount)
    {        
        amount = (amount + 4) % 4;
        
        var side = Math.sqrt(this.length);
        
        for (var i = 0; i < amount; ++i)
        {
            var copy = Array();
            
            for (var x = 0; x < this.length; ++x)
            {
                copy.push(this[x]);
                this[x] = null;
            }
            
            var index = 0;
            
            for (var row = 0; row < side; ++row)
            {
                for (var col = 0; col < side; ++col)
                {
                    var newRow = col;
                    var newCol = side - 1 - row;
                    var newIndex = newRow * side + newCol;
                    
                    
                    if (!this[newIndex])
                    {
                        this[newIndex] = copy[index];
                        this[newIndex].row = newRow;
                        this[newIndex].col = newCol;
                        
                        var mask = copy[index].wallMask;
                        var newMask = 0;
                        
                        newMask |= (mask & 1) ? 2 : 0;
                        newMask |= (mask & 2) ? 4 : 0;
                        newMask |= (mask & 4) ? 8 : 0;
                        newMask |= (mask & 8) ? 1 : 0;

                        this[newIndex].wallMask = newMask;
                    }
                    
                    index++;
                }
            }
        }
    }
    
    Board.prototype.printQuad = function (quad)
    {
        var startRow = (quad < 2) ? 0 : 8;
        var startCol = (quad % 2 == 0) ? 0 : 8;
        
        var output = '[ ';
        
        for (var row = startRow; row < startRow + 8; ++row)
        {
            for (var col = startCol; col < startCol + 8; ++col)
            {
                var index = row * 16 + col;
                var o = this[index];
                
                output = output + '{ row: ' + o.row + ', col: ' + o.col + ', mask: ' + o.wallMask + ', targetId: ' + o.targetId + ' }, ';
            }
        }
        
        output += ' ]';
        
        return output;
    }

    function getTouchPoint(canvas, e) {
        if (!('ontouchstart' in window)) {
            return { pageX: e.pageX - canvas.offsetLeft, pageY: e.pageY - canvas.offsetTop };
        }
        
        var touches = e.touches ? e.touches : e.targetTouches;
        
        return { pageX: touches[0].pageX - canvas.offsetLeft, pageY: touches[0].pageY - canvas.offsetTop };
    }
    
    function context(ctx) {
    	this.ctx = ctx;
    	this.tileSize = 50;
    	this.boardLeft = 0;
    	this.boardTop = 0;
    	this.boardWidth = 0;
    	this.boardHeight = 0;
    	this.layerDepth = 0;
    	
    	this.registerLayerDepth = function ( layer )
    	{
    	    this.layerDepth = Math.max(layer, this.layerDepth);
    	}
    };
    
    function moveLogEntry(from, to, groupId, prevState) {
        this.color = colors[groupId];
        this.from = from;
        this.to = to;
        this.moverId = groupId;
        this.previousState = prevState;
        
        if (from.col == to.col)
        {
            this.dir = (from.row > to.row) ? 1 : 3;
            this.direction = (from.row > to.row) ? 'Up' : 'Down';
        }
        else
        {
            this.dir = (from.col > to.col) ? 0 : 2;
            this.direction = (from.col > to.col) ? 'Left' : 'Right';
        }
    }

    function streak(startRow, endRow, startCol, endCol, groupId) {
    	this.startRow = startRow;
    	this.endRow = endRow;
    	this.startCol = startCol;
    	this.endCol = endCol;
    	this.groupId = groupId;
    	this.color = colors[groupId];
    	
    	this.render = function (context, pass) {
    	
    	    if (pass > 0) return;
    		context.ctx.globalAlpha = 0.55;
    		
    		var startX = context.boardLeft + context.tileSize * this.startCol;
    		var endX = context.boardLeft + context.tileSize * this.endCol;
    		
    		var startY = context.boardTop + context.tileSize * this.startRow;
    		var endY = context.boardTop + context.tileSize * this.endRow;
    		
    		context.ctx.fillStyle = this.color;
    		
    		var barSize = context.tileSize / 8;
    		var hbarSize = barSize / 2;
    		
    		if (startX == endX)
    		{
    			context.ctx.fillRect( startX + context.tileSize / 2 - hbarSize, startY + context.tileSize / 2, barSize,  endY - startY );
    		}
    		else {
    			context.ctx.fillRect( startX + context.tileSize / 2, startY + context.tileSize / 2 - hbarSize, endX - startX, barSize );
    		}
    		
    		context.ctx.globalAlpha = 1;
    	}
    };
    
    function option(startTile, endTile, groupId)
    {
        this.isActive = true;
        this.streak = new streak(startTile.row, endTile.row, startTile.col, endTile.col, groupId);
        this.endTile = endTile;
        this.color = startTile.piece.color;
        
        this.render = function (context, pass) {
        
            if (pass > 0) return;
            
            if (this.isActive)
            {
                this.streak.render(context);
                this.endTile.renderDot(context, this.color);
            }
        }
    };
        
    function tile(row, col, wallMask) {
    	this.row = row;
    	this.col = col;
    	this.isActive = false;
    	this.wallMask = wallMask;
    	this.targetId = 0;
    	this.piece = null;
    	this.target = null;
    	this.highlight = null;

        this.renderDot = function (context, color)
        {
            context.ctx.globalAlpha = 1.0;
            context.ctx.fillStyle = color;

            var size = context.tileSize;
            var radius = size / 4.0;
 
            var left = context.boardLeft + context.tileSize * this.col ;
            var top = context.boardTop + context.tileSize * this.row ;

            context.ctx.beginPath();
            context.ctx.arc(context.boardLeft + context.tileSize * this.col + size / 2, context.boardTop + context.tileSize * this.row + size / 2, radius, 0, 2 * Math.PI, false);
            context.ctx.closePath();
            context.ctx.fill();

            context.ctx.drawImage(pieceImagesHD[color], left + size / 4, top + size / 4, size / 2, size / 2);

            //context.ctx.fillRect(context.boardLeft + context.tileSize * this.col, context.boardTop + context.tileSize * this.row, context.tileSize, context.tileSize);

            context.ctx.globalAlpha = 1;
        }

        this.renderHighlight = function (context, color)
        {
            context.ctx.globalAlpha = 0.9;

            context.ctx.fillStyle = color;
            context.ctx.fillRect(context.boardLeft + context.tileSize * this.col, context.boardTop + context.tileSize * this.row, context.tileSize, context.tileSize);

            context.ctx.globalAlpha = 1;
        }
    	
    	this.render = function (context, pass) {
    		
    		var left = context.boardLeft + context.tileSize * this.col;
    		var top = context.boardTop + context.tileSize * this.row;
    		
    		if (pass == 0)
    		{
        		var padding = 0;//0.5;
        		var hPadding = padding / 2;
        		
        		context.ctx.fillStyle = ((this.row % 2) != (this.col % 2)) ? 'rgb(222,227,233)' : '#fff';
        		context.ctx.fillRect(hPadding + left, hPadding + top, context.tileSize - padding, context.tileSize - padding);

        		var highlight = this.highlight;
        		
        		if (this.isActive)
        		{
        			//highlight = '#eee';
        		}
        		
        		if (highlight)
        		{
        			this.renderHighlight(context, highlight);
        		}
    		}
    		else if (pass == 1)
    		{
		    context.ctx.globalAlpha = 1;
		    context.ctx.fillStyle = '#333';
		    
		    var wallSize = 6;
		    var hwallSize = wallSize / 2;
		    
		    // 1 is left, 2 is top, 4 is right, 8 is bottom
		    if (this.wallMask != 15)
		    {
			var offsetA, offsetB;
			
			if (this.wallMask & 1)
			{
			    offsetA = (wallMask & 2) ? hwallSize : 0;
			    offsetB = (wallMask & 8) ? hwallSize : 0;
			    
			    context.ctx.fillRect(left - hwallSize, top - offsetA, wallSize, context.tileSize + (offsetA+offsetB));
			}
			if (this.wallMask & 2)
			{
			    offsetA = (wallMask & 1) ? hwallSize : 0;
			    offsetB = (wallMask & 4) ? hwallSize : 0;
			    
			    context.ctx.fillRect(left - offsetA, top - hwallSize, context.tileSize + (offsetA+offsetB), wallSize);
			}
			if (this.wallMask & 4)
			{
			    offsetA = (wallMask & 2) ? hwallSize : 0;
			    offsetB = (wallMask & 8) ? hwallSize : 0;
			    
			    context.ctx.fillRect(hwallSize + left+context.tileSize-wallSize, top - offsetA, wallSize, context.tileSize +  + (offsetA+offsetB));
			}
			if (this.wallMask & 8)
			{
			    offsetA = (wallMask & 1) ? hwallSize : 0;
			    offsetB = (wallMask & 4) ? hwallSize : 0;
			    
			    context.ctx.fillRect(left - offsetA, hwallSize + top + context.tileSize - wallSize, context.tileSize +  + (offsetA+offsetB), wallSize);
			}
		    }
        		
		    if (this.target)
		    {
			this.target.render(context, left, top, context.tileSize);
		    }
		    
		    if (this.piece)
		    {
			this.piece.render(context, left, top, context.tileSize);
		    }
    		}
    	}
    };
    
    function piece() {
    	this.render = function (context, pass) {
    	
    	    if (pass > 0) return;
    	};
    }
    
    function mover(groupId) {
        this.color = colors[groupId];
        this.image = pieceImagesHD[this.color];
    	this.groupId = groupId;
        this.tileIndex = -1;
    	
    	this.render = function (context, x, y, size) {
    	    var radius = (size / 2.0) - (size / 14.0);
    	    
    		context.ctx.beginPath();
    		context.ctx.arc(x + size / 2, y + size / 2, radius, 0, 2 * Math.PI, false);
    		context.ctx.closePath();
    		context.ctx.fillStyle = this.color;
    		context.ctx.fill();
		
		var newSize = radius*2;
		var pad = (size - newSize) / 2;
 
            context.ctx.drawImage(this.image, x+pad, y+pad, newSize, newSize);
    	};
    	
    	this.clone = function ( )
    	{
    	    return new mover(this.color);
    	}
    }
    
    function target(id, groupId) {
        this.id = id;
    	this.color = colors[groupId];
    	this.groupId = groupId;
    	
    	this.render = function (context, x, y, size) {
    	    var hSize = size / 4;
    	    
    		context.ctx.fillStyle = this.color;
    		context.ctx.fillRect(x + hSize, y + hSize, size - 2*hSize, size - 2*hSize);
    	};
    	
    	this.clone = function ( )
    	{
    	    return new target(this.id, this.groupId);
    	}
    };
    
    function player(name, color, isLocal, side) {
    	this.name = name;
    	this.color = color;
    	this.isLocal = isLocal;
    	this.side = side;
    	
    	this.render = function (context, pass) {
    	
    	    if (pass > 0) return;
    	
    		context.ctx.fillStyle = this.color;
    		
    		var rackSize = 400;
    		
    		if (this.side == 0)
    		{
    			context.ctx.fillRect( context.boardLeft + ( context.boardWidth - rackSize ) / 2, 0, rackSize, context.boardTop / 1.2);
    		}
    		else if (this.side == 1)
    		{
    			context.ctx.fillRect( context.boardLeft + ( context.boardWidth - rackSize ) / 2, context.boardHeight + 1.2 * context.boardTop, rackSize, context.boardTop / 1.2);
    		}
    		else if (this.side == 2)
    		{
    			context.ctx.fillRect( 0, context.boardTop + ( context.boardHeight - rackSize ) / 2, context.boardLeft / 1.2, rackSize);
    		}
    		else if (this.side == 3)
    		{
    			context.ctx.fillRect( context.boardWidth + 1.2 * context.boardLeft, context.boardTop + ( context.boardHeight - rackSize ) / 2, context.boardLeft / 1.2, rackSize);
    		}
    	}
    };
    
    var gameboard = Class.extend({});

    gameboard.prototype.construct = function gameboard(domImage, imageData) {
        this.context = 0;
        this.canvas = 0;
        this.int = 0;
        this.width = 1000;
        this.height = 1000;
        this.tileSize = 50;
        this.tiles = new Board();
        this.targets = Array();
        this.players = Array();
        this.movers = Array();
        this.streaks = Array();
        this.activeTile = null;
        
        this.conditions =
        [
        	{ condition: function (i) { return ( i % 16 < 15 ); }, increment: -1 },
        	{ condition: function (i) { return ( i >= 0 ); }, increment: -16 },
        	{ condition: function (i) { return ( i % 16 > 0 ); }, increment: 1 },
        	{ condition: function (i) { return ( i < 16*16 ); }, increment: 16 }        	
        ];
        
        this.moveOptions = Array();
        
        this.wrapCallback = function (callbackName) {
            var that = this;
            return function (e) {
                try {
                    return that[callbackName](e);
                }
                catch (ex)
                {
                    _alert(callbackName + ': ' + ex);
                }
            };
        };
        
        this.render = function ()
        {
	        this.context.ctx.fillStyle = '#444';
	        this.context.ctx.fillRect(0,0,this.width,this.height);
	        
	        for (var i = 0; i < this.renderSets.length; ++i)
	        {
	            var set = this.renderSets[i];
	            
	            for (var j = 0; j < set.length; ++j)
	            {
	                var obj = set[j];
	                
	                if (obj && obj.render)
	                {
	                    obj.render(this.context, 0);
	                }
	            }
	        }
	        
	        for (var i = 0; i < this.renderSets.length; ++i)
	        {
	            var set = this.renderSets[i];
	            
	            for (var j = 0; j < set.length; ++j)
	            {
	                var obj = set[j];
	                
	                if (obj && obj.render)
	                {
	                    obj.render(this.context, 1);
	                }
	            }
	        }

            this.drawTime();
        }
        
        this.downPos = null;
        this.downTile = null;
        this.moveTile = null;
        
        this.createToken = function(id, color)
        {
            var tokenCont = document.createElement('div');;
            tokenCont.id = id;
            var token = document.createElement('div');
 token.style['background-color'] = color;
 //token.style['background-image'] = 'url(' + pieceImagesHD[color] + ')';
 token.style['background-size'] = '100%';
 token.style['background-height'] = '100%';
            // token.innerHTML = id;

            tokenCont.appendChild(token);
            
            return tokenCont;
        }
        
        this.getTileByPosition = function (x, y)
        {
            if (x > this.context.boardLeft && y > this.context.boardTop)
            {
            	var row = Math.floor(( y - this.context.boardTop ) / this.context.tileSize);
            	var col = Math.floor(( x - this.context.boardLeft ) / this.context.tileSize);
            	
            	if (col >= 0 && col < 16 && row >= 0 && row < 16)
            	{
            		var index = 16*row + col;

            		return this.tiles[index];
            	}
            }
        }

        // moveIndex is the index of the move to revert to - 0 is the starting state
        this.goToMove = function(moveIndex)
        {
            debugger;
            clearInterval(this.moveInterval);

            if (moveIndex >= 0 && moveIndex < this.moveLog.length)
            {
                var prevState = this.moveLog[moveIndex].previousState;
                this.moveLog = this.moveLog.splice(0, moveIndex);

                for (var i = 0; i < prevState.m.length; ++i)
                {
                    this.tiles[this.movers[i].tileIndex].piece = null;
                }

                for (var i = 0; i < prevState.m.length; ++i)
                {
                    this.tiles[prevState.m[i]].piece = this.movers[i];
                    this.movers[i].tileIndex = prevState.m[i];
                }

                this.activeTile = this.tiles[prevState.a];
            }
        }
        
        this.moveMover = function (mover, from, to, duration, callback)
        {
            if (!mover)
            {
                return;
            }
            
            var move = new moveLogEntry(from, to, mover.groupId, { a: this.activeTile.index, m: this.movers.select(function(i) { return i.tileIndex; }) });
            
            if (!this.onBeforeUserMove(move))
            {
                return;
            }

            this.moveLog.push(move);
            this.onUserMove(move);
            
            var that = this;
            
            from.piece = null;
            to.piece = null;
            
            var delta = Math.abs(from.row - to.row) + Math.abs(from.col - to.col);
            
            var steps = (2 + Math.log(delta)*5.0) * 2;
            var step = steps;
            
            var startX = this.context.boardLeft + this.context.tileSize * from.col;
            var startY = this.context.boardTop + this.context.tileSize * from.row;
            
            var endX = this.context.boardLeft + this.context.tileSize * to.col;
            var endY = this.context.boardTop + this.context.tileSize * to.row;

            if (!duration)
            {
                duration = steps * 5;
            }
            else
            {
                steps = duration / 5;
            }

            clearInterval(this.moveInterval);
            this.moveInterval = setInterval(function()
            {
                var x = endX + (startX - endX) * step / steps;
                var y = endY + (startY - endY) * step / steps;
                    
                that.render();
                mover.render(that.context, x, y, that.context.tileSize);
                
                if (step-- <= 0)
                {
                    clearInterval(that.moveInterval);
                    that.moveInterval = 0;

                    that.activeTile = to;
                    that.activeTile.isActive = true;
                    that.activeTile.piece = mover;
                    mover.tileIndex = that.activeTile.index;
                    
                    if (to.target && to.target.groupId === mover.groupId)
                    {
                        that.endRound(true);
                        that.moveLog = Array();
                    }
                    else
                    {
                        that.showPossible();
                    }
                    
                    that.render();

                    if (callback)
                    {
                        callback();
                    }
                }
            }, 5);
        }

        this.mouseDown = function (e)
        {
            e.preventDefault();
            
            if (!this.isActive) return;
            
            this.downPos = getTouchPoint(this.canvas, e);
            
            var tile = this.getTileByPosition(this.downPos.pageX, this.downPos.pageY);
            
            if (tile && tile.piece)
            {
            	if (this.activeTile)
            	{
            		this.activeTile.isActive = false;
            	}
            	
            	this.downTile = tile;
            	this.activeTile = tile;
            	this.activeTile.isActive = true;
            	
            	this.showPossible();
            	
            	this.render();
            }
        }
        
        this.mouseUp = function (e)
        {
            e.preventDefault();
            
            if (!this.isActive) return;
            
            var moveTo = null;
        	var pos;
        	
        	try
        	{
        	    pos = getTouchPoint(this.canvas, e);
        	}
        	catch (ex)
        	{
        	    pos = this.downPos;
        	}
        	
        	var tile = this.getTileByPosition(pos.pageX, pos.pageY);
                    
            for (var i = 0; i < this.moveOptions.length; ++i)
            {
                var option = this.moveOptions[i];
                
                if (option && option.isActive)
                {
                    if (this.downTile)
                    {
                        if (moveTo)
                        {
                            moveTo = null;
                            break;
                        }
                          
                        moveTo = option.endTile;
                    }
                    else if (option.endTile === tile)
                    {
                        moveTo = tile;
                        break;
                    }
                }
            }
            
            this.downTile = null;
            
            if (moveTo)
            {
                this.moveMover(this.activeTile.piece, this.activeTile, moveTo);
                this.activeTile.piece = null;
                this.activeTile.isActive = false;
                
                return;
            }
            else
            {
                if (!tile || !tile.piece) return;
                
                this.moveOptions.length = 0;
            
            	if (tile && tile.piece)
            	{
        			if (this.activeTile)
        			{
        				this.activeTile.isActive = false;
        			}
        			
        			this.activeTile = tile;
        			this.activeTile.isActive = true;
        			
        			this.showPossible();
            	}
            }
        	
        	this.render();
        }
        
        this.mouseMove = function (e)
        {
            e.preventDefault();
            
            this.downPos = getTouchPoint(this.canvas, e);
            
            if (this.downTile)
            {
                var pos = getTouchPoint(this.canvas, e);
                var tile = this.getTileByPosition(pos.pageX, pos.pageY);
                
                for (var i = 0; i < 4; ++i)
                {
                    var option = this.moveOptions[i];
                    
                    if (option)
                    {
                        option.isActive = true;
                    }
                }
                
                if (tile && tile != this.downTile)
                {
                    if (!tile.piece && (tile.row == this.downTile.row || tile.col == this.downTile.col))
                    {
                        var direction = 0;
                        var deltaX = this.downTile.col - tile.col;
                        var deltaY = this.downTile.row - tile.row;
                        
                        if (tile.row == this.downTile.row)
                        {
                            if (this.downTile.col > tile.col)
                            {
                                // moving left
                                direction = 0;
                            }
                            else
                            {
                                // moving right
                                direction = 2; 
                            }
                        }
                        else
                        {
                            if (this.downTile.row > tile.row)
                            {
                                // moving down
                                direction = 1;
                            }
                            else
                            {
                                // moving up
                                direction = 3;
                            }
                        }
                        
                        for (var i = 0; i < 4; ++i)
                        {
                            var option = this.moveOptions[i];
                            
                            if (option)
                            {
                                option.isActive = (i == direction);
                            }
                        }
                    }
                }
                
                this.render();
            }
        }
        
        this.canMove = function (from, to)
        {
        	if (to.piece)
        	{
        		return false;
        	}
        
        	if (from.row != to.row && from.col != to.col)
        	{
        		return false;
        	}
        	
        	if (from.row != to.row)
        	{
        		var minRow = Math.min(from.row, to.row);
        		var maxRow = Math.max(from.row, to.row);
        		var offset = from.col;
        		
        		for (var i = minRow; i <= maxRow; ++i)
        		{
        			var index = offset + i * 16;
        			var tile = this.tiles[index];
        			
        			if (i > minRow && 0 != (tile.wallMask & 2))
        			{
        				return false;
        			}
       
        			if (i < maxRow && 0 != (tile.wallMask & 8))
        			{
        				return false;
        			}
        		}
        	}
        	else
        	{
    	 		var minCol = Math.min(from.col, to.col);
    	 		var maxCol = Math.max(from.col, to.col);
    	 		var offset = from.row * 16;
    	 		
    	 		for (var i = minCol; i <= maxCol; ++i)
    	 		{
    	 			var index = offset + i;
    	 			var tile = this.tiles[index];
    	 			
    	 			if (i > minCol && 0 != (tile.wallMask & 1))
    	 			{
    	 				return false;
    	 			}
    	
    	 			if (i < maxCol && 0 != (tile.wallMask & 4))
    	 			{
    	 				return false;
    	 			}
    	 		}
        	}
        	
        	return true;
        }
        
        this.showPossible = function ()
        {
			// Let us calculate all of the possible moves
			for (var i = 0; i < this.conditions.length; ++i)
			{
				var condition = this.conditions[i];
				
				var endTile = this.walkPath(this.activeTile, condition.condition, condition.increment);
				this.moveOptions[i] = null;

				if (endTile && endTile != this.activeTile)
				{
                    if (!this.activeTile.piece)
                    {
                        debugger;
                    }

					this.moveOptions[i] = new option(this.activeTile, endTile, this.activeTile.piece.groupId);
				}
			} 
         }
        
        this.walkPath = function (startTile, condition, increment)
        {
	        var endTile = null;
	        var index = startTile.row*16 + startTile.col;
	        var startIndex = index;
	        
        	while (index >= 0 && index < this.tiles.length && (index == startIndex || condition(index)))
        	{
        		var newTile = this.tiles[index];
        		
        		if (newTile == startTile || this.canMove(startTile, newTile))
        		{
        			if (startTile != newTile)
        			{
        				endTile = newTile;
        			}
        		}
        		else {
        			break;
        		}
        		
        		index += increment;
        	}
        	
        	return endTile;
        }
        
        this.keyDown = function (e) {

            if (!this.isActive) return;

            /*
              left, up, right, down
             if (from.col == to.col)
             {
             this.dir = (from.row > to.row) ? 1 : 3;
             this.direction = (from.row > to.row) ? 'Up' : 'Down';
             }
             else
             {
             this.dir = (from.col > to.col) ? 2 : 0;
             this.direction = (from.col > to.col) ? 'Left' : 'Right';
             }

             */
        	if (e.keyCode >= 37 && e.keyCode <= 40)
        	{
	        	if (this.activeTile)
	        	{
	        		var condition = function (i) { return false; }
	        		var increment = 1;
	        		
	        		this.activeTile.isActive = false;
	        		var index = this.activeTile.row*16 + this.activeTile.col;
	        		
	        		condition = this.conditions[e.keyCode - 37].condition;
	        		increment = this.conditions[e.keyCode - 37].increment;
	        				        	
		        	var startIndex = index;
		        	
		        	var endTile = this.walkPath(this.activeTile, condition, increment);
		        	
		        	if (endTile && endTile != this.activeTile)
		        	{
		        	    this.moveMover(this.activeTile.piece, this.activeTile, endTile);
		        	    return;
		        	}
	        	}
	        	else
	        	{
	        		return;
	        	}
	        	
	        	this.activeTile.isActive = true;
	        	this.render();
        	}
            else if (e.keyCode == 9) // tab
            {
                if (!this.moveInterval)
                {
                    var activeId = 0;
                    
                    if (this.activeTile && this.activeTile.isActive && this.activeTile.piece)
                    {
                        var dir = (e.shiftKey) ? -1 : 1;
                        activeId = (this.activeTile.piece.groupId + dir) % this.movers.length;
                        this.activeTile.isActive = false;
                    }
                    
                    this.activeTile = this.movers[activeId].tile;
                    this.activeTile.isActive = true;
                    
                    this.showPossible();
                    this.render();
                }
                
                e.preventDefault();
            }
        
        }
        
        this.renderSets = Array();
        
        this.isActive = false;
        this.confirmInterval = null;
        
        this.wrapTouchEvent = function(obj, name)
        {
            if (!('ontouchstart' in window))
            {
                obj.onclick = this.wrapCallback(name);
            }
            else
            {
                obj.ontouchstart = this.wrapCallback(name);
            }
        };
        
        this.wrapTouchEventFunc = function(obj, func)
        {
            if (!('ontouchstart' in window))
            {
                obj.onclick = func;
            }
            else
            {
                obj.ontouchstart = func;
            }
        };
        
        this.showMessage = function(message, click)
        {
            window._showMessage(message, click);
            return;
            var that = this;
            var flashBack = document.getElementById('flashMessageBack');
            var flashM = document.getElementById('flashMessage');
            
            flashBack.style.display = flashM.style.display = '';
            flashM.innerHTML = message;
            
            if (click)
            {
                flashBack.onclick = flashM.onclick = function() { click(); };
            }
            else {
                this.wrapTouchEvent(flashBack, 'hideMessage');
                this.wrapTouchEvent(flashM, 'hideMessage');
            }
        };
        
        this.hideMessage = function()
        {
            window._hideMessage();
            return;
            var flashBack = document.getElementById('flashMessageBack');
            var flashM = document.getElementById('flashMessage');
            
            flashBack.style.display = flashM.style.display = 'none';
        }
        
        this.flashMessage = function(message, time, oncomplete)
        {
            var that = this;
            this.showMessage(message, function(){});
            
            setTimeout(function()
            {
                that.hideMessage();
                
                if (oncomplete)
                {
                    oncomplete();
                }
            }, time);
        };
        
        this.moveLog = Array();
    };

    gameboard.prototype.drawTime = function(seconds)
    {
        seconds = (seconds == undefined) ? this.seconds : seconds;
        this.seconds = seconds;
        if (seconds == this.maxTime) seconds = 59.999;

        var left = this.context.boardLeft + this.context.tileSize * 7;
        var top = this.context.boardTop + this.context.tileSize * 7;

        this.context.ctx.fillStyle = '#3A3C41';
        this.context.ctx.fillRect(left, top, this.context.tileSize * 2, this.context.tileSize * 2);

        this.context.ctx.fillStyle ='rgb(222,227,233)';

        this.context.ctx.beginPath();
        this.context.ctx.moveTo(left+this.context.tileSize,top+this.context.tileSize);
        this.context.ctx.arc(left+this.context.tileSize,top+this.context.tileSize, this.context.tileSize * 0.8, 0, Math.PI*2*(1 - seconds / this.maxTime), true);

        this.context.ctx.closePath();
        this.context.ctx.fill();
    };

    gameboard.prototype.resize = function (e)
    {
        if (document.body.offsetHeight > document.body.offsetWidth)
        {
            //
        }

        // padding = 15
        var padding = 10;

        var size = Math.min(container.offsetWidth - padding*2, container.offsetHeight - padding*2);

        this.width = size;//container.offsetWidth;
        this.height = size;//container.offsetHeight;

        this.canvas.width = this.width;//-260;
        this.canvas.height = this.height;

        this.canvas.style.width = (this.width/*-260*/)+ 'px';
        this.canvas.style.height = this.height + 'px';

        this.context.tileSize = Math.min((this.height-this.context.boardTop*2) / 16, (this.width-this.context.boardLeft*2) / 16);

        this.context.boardWidth = 16 * this.context.tileSize;
        this.context.boardHeight = 16 * this.context.tileSize;

        this.render();
    }
    
    gameboard.prototype.onUserMove = function(move)
    {
        //
    }
    
    gameboard.prototype.onBeforeUserMove = function(move)
    {
        return true;
    }
    
    gameboard.prototype.endRound = function(success)
    {        
        this.render();
    }
    
    gameboard.prototype.uninit = function()
    {
        this.hideMessage();
        this.canvasContainer.parentNode.removeChild(this.canvasContainer);
    };
    
    gameboard.prototype.encodeBoard = function ()
    {
        var _movers = Array();
        
        for (var i = 0; i < this.tiles.length; ++i)
        {
            if (this.tiles[i].piece)
            {
                _movers.push({ groupId: this.tiles[i].piece.groupId, position: i });
            }
        }
        
        return {
            'boardPieces': this.activeBoardPieces,
            'movers': _movers,
            'targets': this.targets,
            'activeTarget': this.activeTarget
        };
    };
    
    gameboard.prototype.decodeBoard = function (gameState, generateNewState)
    {
        this.captureTileIndex = -1;
        
        var newTargets = Array();
        for (var i = 0; i < this.targets.length; ++i)
        {
            var found = false;
            
            for (var j = 0; j < gameState.targets.length; ++j)
            {
                if (this.targets[i].id == gameState.targets[j].id)
                {
                    found = true;
                    break;
                }
            }
            
            if (found)
            {
                newTargets.push(this.targets[i]);
            }
        }


        if (gameState.activeTarget && !generateNewState)
        {
            this.activeTarget = new target(gameState.activeTarget.id, gameState.activeTarget.groupId);

            for (var j = 0; j < this.tiles.length; ++j)
            {
                var ti = this.tiles[j];
                
                if (ti.targetId === this.activeTarget.id)
                {
                    ti.target = this.activeTarget;
                    this.captureTile = ti;
                }
                else {
                    ti.target = null;
                }
            }
        }

        this.targets = newTargets;

        if (!generateNewState)
        {
            this.activeBoardPieces = gameState.boardPieces;
            var bTiles = Array();

            for (var j = 0; j < this.activeBoardPieces.length; ++j)
            {
                for (var i = 0; i < boardTiles.length; ++i)
                {
                    if (this.activeBoardPieces[j] == boardTiles[i].id)
                    {
                        console.log(this.activeBoardPieces[j]  + ' - ' + boardTiles[i].id);
                        var boardPiece = new Board(boardTiles[i].data);
                        bTiles.push(boardPiece);

                        boardPiece.rotate(bTiles.length - 1);
                        break;
                    }
                }
            }

            this.tiles = new Board();
            this.tiles.stitchQuads(bTiles[0], bTiles[1], bTiles[3], bTiles[2]);
            this.renderSets[0] = this.tiles;

            for (var i = 0; i < gameState.movers.length; ++i)
            {
                var savedMover = gameState.movers[i];

                for (var j = 0; j < this.movers.length; ++j)
                {
                    var activeMover = this.movers[j];

                    if (savedMover.groupId == activeMover.groupId)
                    {
                        this.tiles[savedMover.position].piece = activeMover;
                        //activeMover.tile = this.tiles[savedMover.position];
                        activeMover.tileIndex = savedMover.position;

                        break;
                    }
                }
            }
        }

        this.render();
    };
    
    gameboard.prototype.getResult = function()
    {
        return {};
    }
        
    gameboard.prototype.init = function()
    {
        if (!this.canvas) {
            this.canvasContainer = document.createElement('div');
            this.canvasContainer.id = 'canvasContainer';
            this.canvas = document.createElement('canvas');
            this.canvas.id = 'canvas';

            this.container = document.getElementById('container');
            
			if (!('ontouchstart' in window)) {
			    this.canvas.onmousedown = this.wrapCallback('mouseDown');
			    this.canvas.onmousemove = this.wrapCallback('mouseMove');
			    this.canvas.onmouseup = this.wrapCallback('mouseUp');
			    this.canvas.onmouseout = this.wrapCallback('mouseUp');
			}
			else {
			    this.canvas.ontouchstart = this.wrapCallback('mouseDown');
			    this.canvas.ontouchmove = this.wrapCallback('mouseMove');
			    this.canvas.ontouchend = this.wrapCallback('mouseUp');
			}
			
			window.onresize = this.wrapCallback('resize');
			
			document.body.onkeydown = this.wrapCallback('keyDown');
			this.canvas.onkeydown = this.wrapCallback('keyDown');

            this.canvasContainer.appendChild(this.canvas);
            this.container.appendChild(this.canvasContainer);
            this.context = new context(this.canvas.getContext("2d"));
            this.context.boardLeft = 0;//15;
            this.context.boardTop = 0;//15;
            
            this.resize();
        }
        else {
            //return;
        }

        this.seconds = 90;
        this.maxTime = 90;
        
        var btCopy = Array();
        for (var i = 0; i < boardTiles.length; ++i)
        {
            btCopy.push(boardTiles[i]);
        }
        
        this.activeBoardPieces = Array();
        
        var bTiles = Array();
        while (bTiles.length < 4)
        {
            var random = Math.floor(Math.random()*btCopy.length);
            var boardPiece = new Board(btCopy[random].data);
            this.activeBoardPieces.push(btCopy[random].id);
            
            //boardPiece.rotate(bTiles.length);
            boardPiece.rotate(bTiles.length);
            
            btCopy.splice(random, 1);
            bTiles.push(boardPiece);
        }
        
        this.tiles.stitchQuads(bTiles[0], bTiles[1], bTiles[3], bTiles[2]);

        this.players = Array();
        this.players.push(new player("Nicholas", '#00f', true, this.players.length));
        this.players.push(new player("Nicholas", '#0f0', true, this.players.length));

        this.movers = Array();
        this.movers.push(new mover(0));
        this.movers.push(new mover(1));
        this.movers.push(new mover(2));
        this.movers.push(new mover(3));

        this.renderSets = Array();
        this.renderSets.push(this.tiles);
        this.renderSets.push(this.movers);
        this.renderSets.push(this.streaks);
        this.renderSets.push(this.moveOptions);
        
        this.targets = Array();
        
        for (var i = 0; i < 17; ++i)
        {
            var t = new target(i, i % 4);
            this.targets.push(t);
        }

        for (var i = 0; i < this.tiles.length; ++i)
        {
            this.tiles.piece = null;
        }
        
        for (var i = 0; i < this.movers.length; ++i)
        {
            var index = Math.floor(Math.random() * this.tiles.length);
            
            while (this.tiles[index].piece || this.tiles[index].wallMask == 15)
            {
                index = Math.floor(Math.random() * this.tiles.length);
            }
            
            this.tiles[index].piece = this.movers[i];
            this.movers[i].tileIndex = index;
        }
        
        this.render();
    }

    gameboard.prototype.solve = function(depth)
    {
        // 16 possible state changes per round
        var maxDepth = 6;
        var piecePlaces = Array();

        for (var i = 0; i < this.tiles.length; ++i)
        {
            for (var p = 0; p < this.movers.length; ++p)
            {
                if (this.tiles[i].piece == this.movers[p])
                {
                    piecePlaces[p] = i;
                    break;
                }
            }
        }

        this.bestSolution = null;
        for (var i = 0; i < maxDepth; ++ i)
        {
            var start = new Date().getTime();
            this.solve2(this.movers.length, i, 0, -1, -1);
            var elapsed = Math.floor(new Date().getTime() - start);
            
            console.log('[' + i + '] elasped = ' + elapsed + ' - ' + (elapsed / this.iterCount));
            
            if (this.bestSolution)
            {
                break;
            }
        }

        for (var p = 0; p < this.movers.length; ++p)
        {
            this.tiles[piecePlaces[p]].piece = this.movers[p];
            this.movers[p].tileIndex = piecePlaces[p];
        }

        console.log('solve: ' + JSON.stringify(piecePlaces));

        return this.bestSolution;

        for (var i = maxDepth; i < 15; ++ i)
        {
            var start = new Date().getTime();
            this.solve2(1, i, 0, -1, -1);
            var elapsed = Math.floor(new Date().getTime() - start);
            
            console.log('[' + i + '] elasped = ' + elapsed + ' - ' + (elapsed / this.iterCount));
            
            if (this.bestSolution)
            {
                return this.bestSolution.length;
            }
        }
        
        return -1;
    };
    
    gameboard.prototype.solve2 = function(maxMoverAbs, maxDepth, depth, prevDir, prevPiece)
    {
        if (!depth)
        {
            console.log(maxDepth);
            this.bestSolution = null;
            this.stack = Array();
            this.iterCount = 0;
            this.evalMovers = Array();
            
            this.evalMovers.push(this.movers[this.captureTile.target.groupId]);
            
            for (var i = 0; i < this.movers.length; ++i)
            {
                if (i != this.captureTile.target.groupId)
                {
                    this.evalMovers.push(this.movers[i]);
                }
            }
            
            depth = 0;
        }
        
        if (depth > maxDepth || this.bestSolution) return false;
        
        var maxMover = (depth == maxDepth) ? 1 : maxMoverAbs;
        
        for (var piece = 0; piece < maxMover; ++piece)
        {
            var mover = this.evalMovers[piece];
            
            for (var dir = 0; dir < 4; ++dir)
            {
                // Can't move same piece in the same direction twice
                if (piece == prevPiece && dir == prevDir) continue;
                
                var condition = this.conditions[dir];
                var from = this.tiles[mover.tileIndex];
                var to = this.walkPath(from, condition.condition, condition.increment);
                
                if (to && to != from)
                {
                    // recurse
                    this.stack.push({ p: piece, d: dir, m: mover, f: from.index, t: to.index });
                
                    to.piece = from.piece;
                    from.piece = null;
                    to.piece.tileIndex = to.index;
                    
                    this.iterCount++;
                    var hasSolution = false;
                    
                    if (to.target && to.target.groupId === mover.groupId)
                    {
                        var solution = '[' + maxDepth + '] ' + '[' + this.stack.length + '] - ';
                        
                        for (var i = 0; i < this.stack.length; ++i)
                        {
                            solution = solution + '{ p: ' + this.stack[i].p + ', d: ' + this.stack[i].d + ' }, ';
                        }
                        
                        console.log(JSON.stringify(this.stack));
                        
                        if (!this.bestSolution || this.stack.length < this.bestSolution.length)
                        {
                            this.bestSolution = this.stack.slice(0);
                        }
                        
                        hasSolution = true;
                    }
                                            
                    if (hasSolution || !this.bestSolution || depth+1 < this.bestSolution.length)
                    {
                        this.solve2(maxMoverAbs, maxDepth, depth + 1, piece, dir);
                    }
                    
                    from.piece = to.piece;
                    to.piece = null;
                    from.piece.tileIndex = from.index;
                    
                    this.stack.pop();
                    
                    if (hasSolution)
                    {
                        return;
                    }
                }
            }
        }
        
        if (!depth)
        {
            console.log('iter: ' + this.iterCount);
            console.log('best: ' + (this.bestSolution ? this.bestSolution.length : -1));
            //_alert('done');
        }
    };

    window['gameboard'] = gameboard;
    
})();