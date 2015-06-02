import com.neurogami.leaphacking.*;
import com.leapmotion.leap.*;

PointerListener listener   = new PointerListener();
Controller      controller = new Controller(listener);
PGraphics       drawing;

//-------------------------------------------------------------------
void setup() {
  size(displayWidth, displayHeight, OPENGL);
  drawing = createGraphics(width, height);
  background(255);
}


//-------------------------------------------------------------------
void draw() {
  

  
  //  For some reason the app always starts off as if there is a pinch.
  //  For best results enter the interaction area with an open hand.
  if (listener.havePinch() ) {
    d("*****************************************************************************");

     // TODO:  The code needs to paint to an offscreen buffer, adding to the image
     // when the fingers are pinched.
     // On draw(), the iamge is blt'ed to the screen and whatever else
     // gets overlayed.
     // If the hand is fully extended, then the buffer image is wiped so
     // the user can start fresh.
     // https://processing.org/examples/creategraphics.html
     // https://processing.org/discourse/beta/num_1275325290.html
     // https://processing.org/reference/PGraphics.html
  
    addToDrawing(drawing);
  
  } else {
     lastDrawingX = NULL_DRAWING_VALUE;
     lastDrawingY = NULL_DRAWING_VALUE;
  }
  
//  bltImage(drawing);
  //writePosition();

}

//-------------------------------------------------------------------
// Track last postion as both normalized value and as raw value, and
// make note of the largests and smallest raw values so we can see 
// what range we get.
Vector lastPos() {

  Vector normlp = listener.normalizedAvgPos();
  Vector lp = listener.avgPos();

  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  println(normlp);

  return normlp;
}


