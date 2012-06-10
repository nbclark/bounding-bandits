//Defines the top level Class
function Class() { }
Class.prototype.construct = function() {};
Class.extend = function(def) {
    var classDef = function() {
        if (arguments[0] !== Class) { this.construct.apply(this, arguments); }
    };
    
    var proto = new this(Class);
    var superClass = this.prototype;
    
    for (var n in def) {
        var item = def[n];                        
        if (item instanceof Function)
        {
            item.$ = superClass;
        }
        proto[n] = item;
    }

    classDef.prototype = proto;
    
    //Give this new class the same static extend method    
    classDef.extend = this.extend;        
    return classDef;
};

_ = function(name)
{
    return $(name).get(0);
};

Object.prototype.position = function()
{
    var node = this;
    var x = 0;
    var y = 0;
    
    while (node)
    {
        if (!isNaN(node.offsetLeft) && !isNaN(node.offsetLeft))
        {
            
            x += node.offsetLeft ? node.offsetLeft : 0;
            y += node.offsetTop ? node.offsetTop : 0;
            
            console.log(node.offsetLeft + ', ' + node.offsetTop);
        }
        
        node = node.parentNode;
    }
    
    return { x: x, y: y };
}