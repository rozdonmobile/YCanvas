package sk.yoz.ycanvas.map.display
{
import feathers.core.IFeathersDisplayObject;

import flash.geom.Rectangle;

import sk.yoz.ycanvas.map.YCanvasMap;

import starling.display.DisplayObject;

/**
* A map layer extension to be used as a marker container. Marker real/global
* size remains the same no matter the YCanvas transformation is. Marker
* global rotation is 0.
*/
public class MarkerLayer extends MapLayer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function MarkerLayer()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var markers:Vector.<IFeathersDisplayObject> = new Vector.<IFeathersDisplayObject>;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override public function set rotation(value:Number):void
    {
        if (rotation == value)
            return;

        super.rotation = value;

        for (var i:int = 0; i < markers.length; i++)
        {
            if (isMarkerHidden(markers[i]))
                continue;

            markers[i].rotation = -rotation;
        }
    }

    override public function set scale(value:Number):void
    {
        if (scale == value)
            return;

        super.scale = value;

        for (var i:int = 0; i < markers.length; i++)
        {
            if (isMarkerHidden(markers[i]))
                continue;

            markers[i].scaleX = markers[i].scaleY = 1 / scale;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Adds any Starling DisplayObject as a marker.
     */
    public function add(marker:IFeathersDisplayObject):void
    {
        markers[markers.length] = marker;
//        addChild(marker as DisplayObject);
    }

    /**
     * Removes previously added marker.
     */
    public function remove(marker:IFeathersDisplayObject):void
    {
        markers.removeAt(markers.indexOf(marker));

        removeChild(marker as DisplayObject);
    }

    public function isMarkerHidden(marker:IFeathersDisplayObject):Boolean
    {
        return !contains(marker as DisplayObject)
    }

    public function showMarker(marker:IFeathersDisplayObject):void
    {
        addChild(marker as DisplayObject);
        marker.scaleX = marker.scaleY = 1 / scale;
        marker.rotation = -rotation;
    }

    public function hideMarker(marker:IFeathersDisplayObject):void
    {
        removeChild(marker as DisplayObject);
    }

//    public function redraw(map:YCanvasMap):void
//    {
//        var sizeW:Number = width * (1 / scale);
//        var sizeH:Number = height * (1 / scale);
//
//        var b:Rectangle = new Rectangle(center.x - sizeW / 2, center.y - sizeH / 2, sizeW, sizeH);
//
//        for (var i:int = 0, n:int = markers ? markers.length : 0; i < n; i++)
//        {
//            var marker:DisplayObject = markers[i] as DisplayObject;
//            marker.visible = b.contains(marker.x, marker.y);
//        }
//    }
}
}