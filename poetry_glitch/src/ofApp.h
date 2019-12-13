#pragma once

#include "ofxiOS.h"
#include "ofxiOSCoreMotion.h"
#include "ofxARKit.h"
#define NUM_TEXT 23 // defining the array length of the text

class ofApp : public ofxiOSApp {
    
public:
    
    ofApp (ARSession * session);
    ofApp();
    ~ofApp ();
    
    void setup();
    void update();
    void draw();
    void exit();
    
    void touchDown(ofTouchEventArgs &touch);
    void touchMoved(ofTouchEventArgs &touch);
    void touchUp(ofTouchEventArgs &touch);
    void touchDoubleTap(ofTouchEventArgs &touch);
    void touchCancelled(ofTouchEventArgs &touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    
   void createAnchor();
    
    //===== MOTION stuff ======//
    
    ofxiOSCoreMotion coreMotion;
    ofVec3f accelerometerData;
    ofVec3f gyroscopeData;
    ofVec3f attitudeData;
    float pitchData;
    float rollData;
    float yawData;
    
    //====== AR stuff ========//
    ARSession * session;
    ARRef processor;
    ofTrueTypeFont font;
    ofCamera camera;
    vector <matrix_float4x4> mats;
    vector <ARAnchor*> anchors;
    
    //====== variables ======//
   // ofImage img[NUM_TEXT]; // image to try out
    ofTexture textText[NUM_TEXT]; // from font to texture
    int fSize; // font size
    
    ofTrueTypeFont myFont;
    int textIndex = 0;
    int click = 0;
    int maxtext = 24;
    
    bool finger = false;
    bool moved = false;
    
    //TRYOUT for the paths
    ofPath testChar, testCharContour;
};


