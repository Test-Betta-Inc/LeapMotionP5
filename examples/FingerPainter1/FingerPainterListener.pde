
class FingerPainterListener extends Listener {
  // Hmm.  These are also defined in the utils file.
  private Vector avgPos;
  private Vector normalizedAvgPos;
  private float ps;
  private boolean handSpread;
  private boolean handSpreadSwipe;
  private float currentConfidence; 
  private GestureList gestureList;  

  //------------------------------------------------------------
  void onInit(Controller controller) {
    // `d` is a helper method for printing debug stuff.
    d("Initialized");
    avgPos = Vector.zero();
    normalizedAvgPos = Vector.zero();
    currentConfidence = 0.0;
    controller.enableGesture(Gesture.Type.TYPE_SWIPE);
  }

  //------------------------------------------------------------
  void onConnect(Controller controller) {
    d("Connected");
  }

  //------------------------------------------------------------
  void onFocusGained(Controller controller) {
    d(" Focus gained");
  }

  //------------------------------------------------------------
  void onFocusLost(Controller controller) {
    d("Focus lost");
  }

  //------------------------------------------------------------
  void onDisconnect(Controller controller) {
    d("Disconnected");
  }

  //------------------------------------------------------------
  void onFrame(Controller controller) {
    Frame frame = controller.frame();
    InteractionBox box = frame.interactionBox();
    HandList hands = frame.hands();

    if (hands.count() > 0 ) {
      d("Hand!");
      Hand hand = hands.get(0);
      currentConfidence = hand.confidence(); 
      FingerList fingers = hand.fingers();
      if (fingers.count() > 0) {
        gestureList = frame.gestures();
        detectOpenHandSwipe(hand);
        d("Fingers!");
        avgPos = Vector.zero();
        ps = constrain(hand.pinchStrength(), 0.0, 1.0);
        d("pinch Strength = " + ps );

        for (Finger finger : fingers) {
          avgPos  = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        d("avgPos x: " + avgPos.getX() );
        normalizedAvgPos = box.normalizePoint(avgPos, true);

      } 
    } //  if hands 
  } 


  //------------------------------------------------------------
  com.leapmotion.leap.Vector avgPos(){
    return new com.leapmotion.leap.Vector(avgPos);
  }

  //------------------------------------------------------------
  boolean haveSpreadHand() {
    return handSpread;
  }

  //------------------------------------------------------------
  void detectHandSpread(Hand h) {

    handSpread = false;
    if (h.fingers().count() < 5 )  return;

    for (Finger finger : h.fingers()) {
      if ( !finger.isExtended() ) return ;
    }
    handSpread = true;
  }

  //------------------------------------------------------------
  float currentConfidence() {
    return currentConfidence;
  }

  //------------------------------------------------------------
  boolean haveOpenHandSwipe()  {
    return handSpreadSwipe;
  }


  //------------------------------------------------------------
  // FIXME Make this reobust. This versoin assumes an awful lot.
  void detectOpenHandSwipe(Hand h) {
    handSpreadSwipe = false;
    detectHandSpread(h);
    if (!haveSpreadHand() )  return;
    if ( gestureList.count() ==  0 ) return ;
    handSpreadSwipe = true;
  }

  //------------------------------------------------------------
  boolean havePinch() {
    if (ps > pinchThreshold ) return true; 
    return false;

  }
  //------------------------------------------------------------
  com.leapmotion.leap.Vector normalizedAvgPos(){
    return new com.leapmotion.leap.Vector(normalizedAvgPos);
  }
} 

