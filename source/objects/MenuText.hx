package objects;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;

class MenuText extends FlxText {
    public var lerpMenu:Bool = false;
	public var targetY:Int = 0;
	public var changeX:Bool = true;
	public var changeY:Bool = false;

	public var distancePerItem:FlxPoint = new FlxPoint(50, 0);
	public var startPosition:FlxPoint = new FlxPoint(0, 0); //for the calculations
	public function new(x:Float, y:Float, text:String) {
		super(x,y);

        this.text = text;
		this.startPosition.x = x;
		this.startPosition.y = y;
		setFormat("Alex Brush", 70, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		antialiasing = ClientPrefs.data.antialiasing;
	}

	override function update(elapsed:Float)
	{
		if (lerpMenu)
		{
			var lerpVal:Float = FlxMath.bound(elapsed * 9.6, 0, 1);
			if(changeX) x = FlxMath.lerp(x, (targetY * distancePerItem.x) + startPosition.x, lerpVal);
            if(changeY) screenCenter(Y);
		}
		super.update(elapsed);
	}

	public function snapToPosition()
	{
		if (lerpMenu) {
			if(changeX) x = (targetY * distancePerItem.x) + startPosition.x;
            if(changeY) screenCenter(Y);
		}
	}
}