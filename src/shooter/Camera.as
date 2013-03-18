package shooter {
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;

	public class Camera {
		public var zoom:Number;
		public var rotation:Number;
		public var viewport:Rectangle;
		public var bounds:Rectangle;

		public function Camera() {
			zoom = 1.0;
			rotation = 0;
			viewport = Starling.current.viewPort.clone();
			bounds = viewport.clone();
		}

		public function get center():Point {
			return new Point(viewport.x + viewport.width / 2, viewport.y + viewport.height / 2);
		}

		public function move(offsetX:Number, offsetY:Number):void {
			viewport.x = testBounds(viewport.x, offsetX, viewport.width, bounds.left, bounds.right);
			viewport.y = testBounds(viewport.y, offsetY, viewport.height, bounds.top, bounds.bottom);
		}

		private function testBounds(origin:Number, offset:Number, viewSize:Number, boundsLeft:Number, boundsRight:Number):Number {
			var viewLeft:Number = origin + offset;
			var viewRight:Number = viewLeft + viewSize;
			if (viewLeft > boundsLeft && viewRight < boundsRight)
				return viewLeft;
			else if (viewLeft <= boundsLeft)
				return boundsLeft;
			else if (viewRight >= boundsRight)
				return boundsRight - viewSize;
			return origin;
		}
	}
}
