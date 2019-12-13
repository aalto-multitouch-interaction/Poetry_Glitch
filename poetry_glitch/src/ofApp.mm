#include "ofApp.h"


//--------------------------------------------------------------
ofApp :: ofApp (ARSession * session){
    this->session = session;
    cout << "creating ofApp" << endl;
}

ofApp::ofApp(){}

//--------------------------------------------------------------
ofApp :: ~ofApp () {
    cout << "destroying ofApp" << endl;
}

//--------------------------------------------------------------
void ofApp::setup() {
    ofSetFrameRate(24);
    
    coreMotion.setupAccelerometer();
    coreMotion.setupGyroscope();
    coreMotion.setupAttitude();
    
    fSize = 200;
    //font set up for the font in AR
    myFont.load("fonts/Arial Black.ttf",fSize);
    //img.load("dog_hello.jpg"); // for testing purposes to make sure AR is working
    
        // POEM "LADY LAZARUS" by Sylvia Plath
    
        textText[0] = myFont.getStringTexture("Dying");
        textText[1] = myFont.getStringTexture("is an");
        textText[2] = myFont.getStringTexture("art");
        textText[3] = myFont.getStringTexture("like");
        textText[4] = myFont.getStringTexture("everything");
        textText[5] = myFont.getStringTexture("else.");
        textText[6] = myFont.getStringTexture("I do");
        textText[7] = myFont.getStringTexture("it");
        textText[8] = myFont.getStringTexture("exceptionally");
        textText[9] = myFont.getStringTexture("well.");
        textText[10] = myFont.getStringTexture("I do");
        textText[11] = myFont.getStringTexture("it");
        textText[12] = myFont.getStringTexture("so");
        textText[13] = myFont.getStringTexture("it");
        textText[14] = myFont.getStringTexture("feels");
        textText[15] = myFont.getStringTexture("like");
        textText[16] = myFont.getStringTexture("hell.");
        textText[17] = myFont.getStringTexture("I do");
        textText[18] = myFont.getStringTexture("it");
        textText[19] = myFont.getStringTexture("so");
        textText[20] = myFont.getStringTexture("it");
        textText[21] = myFont.getStringTexture("feels");
        textText[22] = myFont.getStringTexture("real.");
    
    
    // TRYOUT FOR VECTORS
    
    bool vflip = true;
    bool filled = true;
    testChar = myFont.getCharacterAsPoints(vflip, filled);
    filled = false;
    testCharContour = myFont.getCharacterAsPoints(vflip, filled);
    
    // TRYOUT END
    
    //textText=myFont.getStringTexture("Hello"); // testing purposes that font works
    
    //------FONT setup-------//
    
    int fontSize = 8;
    if (ofxiOSGetOFWindow()->isRetinaSupportedOnDevice())
        fontSize *= 2;
    font.load("fonts/mono0755.ttf", fontSize);
    
    //------AR setup------//
    
    processor = ARProcessor::create(session);
    processor->setup();
}

//--------------------------------------------------------------
void ofApp::update(){
    processor->update();
    
    //====motion update===//
    coreMotion.update();
    accelerometerData = coreMotion.getAccelerometerData();
    gyroscopeData = coreMotion.getGyroscopeData();
    pitchData = coreMotion.getPitch();
    rollData = coreMotion.getRoll();
    yawData = coreMotion.getYaw();
    attitudeData = ofVec3f(pitchData, rollData, yawData);
    
}

//--------------------------------------------------------------
void ofApp::draw() {
    ofEnableAlphaBlending();
    
    ofDisableDepthTest();
    processor->draw();
    ofEnableDepthTest();
    
    processor->anchorController->loopAnchors([=](ARObject obj)->void {
       
        camera.begin();
        processor->setARCameraMatrices();
        
        ofPushMatrix();
        ofMultMatrix(obj.modelMatrix);
        
        ofRotate(90,0,0,1);
        if(finger){
            //createAnchor();
            cout << "DOUBLE TAP" << endl;
        }else{
            int myIndex = (processor->anchorController->anchorsIndex)%NUM_TEXT;
            // function for moving and tapping finger
            if(moved){
                ofSetColor(0, 0, 255);
                ofFill();// fills with colour
                ofSetLineWidth(3);
                textText[click].draw(-(0.2),-(0.2), 0.2, 0.2);
            }else{
                ofSetColor(255);
                ofFill(); // fills with colour
                ofSetLineWidth(3);
                textText[myIndex].draw(-(0.2),-(0.2), 0.2, 0.2);
            }
       }
        ofPopMatrix();
        camera.end();
    });
    ofDisableDepthTest();
    
    // ========== DEBUG STUFF ============= //
    processor->debugInfo.drawDebugInformation(font);
}

//--------------------------------------------------------------
void ofApp::exit() {
    //
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs &touch){
    click+=1;
    if (click>0 && click<maxtext) {
        ofLogNotice() << "clicks:" << click;
    processor->addAnchor(ofVec3f(touch.x,touch.y,-0.8));
}
    if (click==23) {
        click = 0;
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs &touch){
    moved=true;
    processor->addAnchor(ofVec3f(touch.x,touch.y,-0.8));
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs &touch){
    moved=false;
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs &touch){
 /*
    finger=!finger;*/
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    processor->deviceOrientationChanged(newOrientation);
}


//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs& args){
    
}


//--------------------------------------------------------------
void ofApp::createAnchor() {
    // ====== AR ANCHORS ====== //
    if (session.currentFrame){
        ARFrame *currentFrame = [session currentFrame];
        
        matrix_float4x4 translation = matrix_identity_float4x4;
        translation.columns[3].z = -0.2;
        matrix_float4x4 transform = matrix_multiply(currentFrame.camera.transform, translation);
        
        // Add a new anchor to the session
        ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];
        [session addAnchor:anchor];
        
        // Add a new geo to the anchor
        textText[3].draw(-(0.2),-(0.2), 0.2, 0.2);
//geoRenderer.createGeo(accelerometerData,gyroscopeData,attitudeData); try out from Robert's code
    }
}
