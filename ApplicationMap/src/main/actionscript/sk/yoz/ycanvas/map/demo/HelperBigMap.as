package sk.yoz.ycanvas.map.demo
{
    import flash.ui.Multitouch;
    
    import feathers.controls.Label;
    import feathers.core.PopUpManager;
    
    import sk.yoz.ycanvas.map.MapController;
    import sk.yoz.ycanvas.map.demo.routes.RouteNewYorkWashington;
    import sk.yoz.ycanvas.map.display.MarkerLayer;
    import sk.yoz.ycanvas.map.display.StrokeLayer;
    import sk.yoz.ycanvas.map.events.CanvasEvent;
    import sk.yoz.ycanvas.map.managers.AbstractTransformationManager;
    import sk.yoz.ycanvas.map.managers.MouseTransformationManager;
    import sk.yoz.ycanvas.map.managers.TouchTransformationManager;
    import sk.yoz.ycanvas.map.utils.GeoUtils;
    import sk.yoz.ycanvas.map.valueObjects.CanvasLimit;
    import sk.yoz.ycanvas.map.valueObjects.CanvasTransformation;
    
    import starling.display.Image;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class HelperBigMap
    {
        public var map:MapController;
        
        public var strokeLayer:StrokeLayer;
        public var transformationManager:AbstractTransformationManager;
        public var markerLayer:MarkerLayer;
        
        public function HelperBigMap()
        {
            var init:CanvasTransformation = new CanvasTransformation;
            init.centerX = GeoUtils.lon2x(7.75);
            init.centerY = GeoUtils.lat2y(45.53);
            init.rotation = 0;
            init.scale = 1 / 4096;
            
            var limit:CanvasLimit = new CanvasLimit;
            limit.minScale = 1;
            limit.maxScale = 1 / 65536;
            limit.minCenterX = 0;
            limit.maxCenterX = GeoUtils.lon2x(180);
            limit.minCenterY = GeoUtils.lat2y(85);
            limit.maxCenterY = GeoUtils.lat2y(-85);
            
            map = new MapController(Maps.MAP_CONFIG_ESRI, init);
            map.addEventListener(CanvasEvent.TRANSFORMATION_FINISHED, onMapTransformationFinished);
            
            transformationManager = Multitouch.supportsTouchEvents
                ? new TouchTransformationManager(map, limit)
                : new MouseTransformationManager(map, limit);
            
            strokeLayer = new StrokeLayer;
            strokeLayer.autoUpdateThickness = false;
            strokeLayer.addEventListener(TouchEvent.TOUCH, onStrokeLayerTouch);
            map.addMapLayer(strokeLayer);
            
            markerLayer = new MarkerLayer;
            markerLayer.addEventListener(TouchEvent.TOUCH, onMarkerLayerTouch);
            map.addMapLayer(markerLayer);
        }
        
        public function addMarkerAt(x:Number, y:Number):void
        {
            var marker:Image = new Image(Assets.MARKER_GREEN_TEXTURE);
            marker.x = x;
            marker.y = y;
            marker.pivotX = Assets.MARKER_GREEN_TEXTURE.width / 2;
            marker.pivotY = Assets.MARKER_GREEN_TEXTURE.height;
            markerLayer.add(marker);
        }
        
        private function showLabelPopup(message:String):void
        {
            var label:Label = new Label;
            label.text = message;
            PopUpManager.addPopUp(label);
            
            label.addEventListener(TouchEvent.TOUCH, function(event:TouchEvent):void
            {
                if(PopUpManager.isPopUp(label) && event.getTouch(label, TouchPhase.BEGAN))
                    PopUpManager.removePopUp(label);
            });
        }
        
        private function onMapTransformationFinished(event:CanvasEvent):void
        {
            if(!strokeLayer.autoUpdateThickness)
                strokeLayer.updateThickness();
        }
        
        private function onStrokeLayerTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(map.component, TouchPhase.BEGAN);
            if(touch)
                showLabelPopup("Stroke selected. Click here to close popup.");
        }
        
        private function onMarkerLayerTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(map.component, TouchPhase.BEGAN);
            if(touch)
                showLabelPopup("Marker selected. Click here to close popup");
        }
    }
}