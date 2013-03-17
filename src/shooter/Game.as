package shooter {
	import org.swiftsuspenders.Injector;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.errors.AbstractMethodError;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	public class Game extends Sprite implements IAnimatable {
		protected var injector:Injector;

		public function Game() {
			injector = new Injector();
			injector.map(Game).toValue(this);
			injector.map(Camera).asSingleton();
			injector.map(AssetManager).asSingleton();
			initialize();
			startup();
			enableUpdate();
		}

		protected function initialize():void {
		}

		protected function startup():void {
			throw new AbstractMethodError("'startup' needs to be implemented in subclass");
		}

		protected function enableUpdate():void {
			Starling.current.juggler.add(this);
		}

		protected function disableUpdate():void {
			Starling.current.juggler.remove(this);
		}

		protected function enableKeyboardHandlers():void {
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		protected function disableKeyboardHandlers():void {
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		protected function enableTouchHandler():void {
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		protected function disableTouchHandler():void {
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
		}

		private function keyDownHandler(e:KeyboardEvent):void {
			trace("keydown:", e);
			handleMessage("handleKeyDown", e);
		}

		private function keyUpHandler(e:KeyboardEvent):void {
			trace("keyup:", e);
			handleMessage("handleKeyUp", e);
		}

		private function touchHandler(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if (touch)
				handleMessage("handleTouch" + touch.phase.charAt(0).toUpperCase() + touch.phase.substr(1), e);

		}

		private function handleMessage(handler:String, ... params):void {
			for (var i:int = numChildren - 1; i >= 0; i--) {
				var screen:Screen = getChildAt(i) as Screen;
				if (screen.hasOwnProperty(handler))
					screen[handler].apply(screen, params);
				if (screen.blockMessage)
					break;
			}
		}

		public function replace(instanceOrClass:*):void {
			pop();
			push(instanceOrClass);
		}

		public function push(instanceOrClass:*):void {
			var instance:Screen = instanceOrClass is Class ? injector.getInstance(instanceOrClass) : instanceOrClass;
			addChild(instance);
			instance.enter();
		}

		public function pop():Boolean {
			if (numChildren > 0) {
				(removeChildAt(numChildren - 1) as Screen).exit();
				return true;
			}
			return false;
		}

		public function advanceTime(time:Number):void {
			handleMessage("update", time);
		}
	}
}
